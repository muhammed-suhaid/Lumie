//************************* EncryptionService *************************//
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptography/cryptography.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Hkdf _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
  final AesGcm _aesGcm = AesGcm.with256bits();

  // Ensure a random per-chat salt exists and return it (base64)
  Future<String> ensureChatSalt(String chatId) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final doc = await chatRef.get();
    String? saltB64 = doc.data()?['salt'] as String?;
    if (saltB64 != null && saltB64.isNotEmpty) return saltB64;

    // Generate 16-byte random salt
    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    saltB64 = base64Encode(salt);
    await chatRef.set({'salt': saltB64}, SetOptions(merge: true));
    return saltB64;
  }

  // Derive a shared key for the chat using HKDF-SHA256.
  // Uses chatId and both userIds to bind the key to this chat and participants.
  Future<SecretKey> _deriveChatKey({
    required String chatId,
    required String currentUserId,
    required String otherUserId,
    required List<int> salt,
  }) async {
    // Sort IDs to be order-independent
    final ids = [currentUserId, otherUserId]..sort();
    final ikm = utf8.encode('$chatId|${ids[0]}|${ids[1]}');
    final secretKey = await _hkdf.deriveKey(
      secretKey: SecretKey(ikm),
      nonce: salt,
      info: utf8.encode('lumie-chat-hkdf'),
    );
    return secretKey;
  }

  // Encrypt plain text; returns a map with cipherText, nonce and mac (all base64 strings)
  Future<Map<String, String>> encryptText({
    required String chatId,
    required String currentUserId,
    required String otherUserId,
    required String plaintext,
    required String saltB64,
  }) async {
    final salt = base64Decode(saltB64);
    final key = await _deriveChatKey(
      chatId: chatId,
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      salt: salt,
    );

    final nonce = List<int>.generate(12, (_) => Random.secure().nextInt(256));
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(plaintext),
      secretKey: key,
      nonce: nonce,
    );

    return {
      'cipherText': base64Encode(secretBox.cipherText),
      'nonce': base64Encode(secretBox.nonce),
      'mac': base64Encode(secretBox.mac.bytes),
    };
  }

  // Decrypt previously encrypted text
  Future<String> decryptText({
    required String chatId,
    required String currentUserId,
    required String otherUserId,
    required String cipherTextB64,
    required String nonceB64,
    required String macB64,
    required String saltB64,
  }) async {
    try {
      final salt = base64Decode(saltB64);
      final key = await _deriveChatKey(
        chatId: chatId,
        currentUserId: currentUserId,
        otherUserId: otherUserId,
        salt: salt,
      );

      final box = SecretBox(
        base64Decode(cipherTextB64),
        nonce: base64Decode(nonceB64),
        mac: Mac(base64Decode(macB64)),
      );

      final clearBytes = await _aesGcm.decrypt(
        box,
        secretKey: key,
      );
      return utf8.decode(clearBytes);
    } catch (e) {
      // If anything goes wrong, return a placeholder instead of crashing UI
      return '⚠️ Unable to decrypt';
    }
  }
}
