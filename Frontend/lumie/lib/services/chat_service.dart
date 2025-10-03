//************************* ChatService *************************//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumie/models/user_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all chat users for the current user
  Future<List<UserModel>> getChatUsers(String currentUserId) async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      // Collect unique userIds
      final Set<String> userIds = {};
      for (var doc in snapshot.docs) {
        final participants = List<String>.from(doc['participants']);
        userIds.addAll(participants.where((id) => id != currentUserId));
      }

      if (userIds.isEmpty) return [];

      // Fetch user profiles
      final userDocs = await _firestore
          .collection('users')
          .where('uid', whereIn: userIds.toList())
          .get();

      return userDocs.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint("Error fetching chat users: $e");
      return [];
    }
  }

  /// Create or get chat between two users
  Future<String> createOrGetChat(
    String currentUserId,
    String otherUserId,
  ) async {
    final chatId = _generateChatId(currentUserId, otherUserId);

    final chatRef = _firestore.collection("chats").doc(chatId);

    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        "participants": [currentUserId, otherUserId],
        "lastMessage": "",
        "updatedAt": FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

  /// Generate a unique chatId
  String _generateChatId(String user1, String user2) {
    // Always sort IDs to prevent duplicates
    return (user1.compareTo(user2) < 0) ? "${user1}_$user2" : "${user2}_$user1";
  }
}
