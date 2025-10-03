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
          .where('id', whereIn: userIds.toList())
          .get();

      return userDocs.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint("Error fetching chat users: $e");
      return [];
    }
  }
}
