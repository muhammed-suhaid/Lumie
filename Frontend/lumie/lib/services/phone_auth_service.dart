import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PhoneAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //************************* Variables *************************//
  static String? _verificationId;

  //************************* Send OTP *************************//
  static Future<void> sendOTP({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) onFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint("Error sending OTP: $e");
      rethrow;
    }
  }

  //************************* Verify OTP *************************//
  static Future<UserCredential?> verifyOTP(String otpCode) async {
    try {
      if (_verificationId == null) throw Exception("No verificationId found");

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );

      // Sign in first
      final userCredential = await _auth.signInWithCredential(credential);

      // Ensure user is signed in before writing
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = _firestore.collection("users").doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            "uid": user.uid,
            "phone": user.phoneNumber,
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } catch (e) {
      debugPrint("Error verifying OTP: $e");
      rethrow;
    }
  }

  //************************* Sign Out *************************//
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  //************************* Current User *************************//
  static User? get currentUser => _auth.currentUser;
}
