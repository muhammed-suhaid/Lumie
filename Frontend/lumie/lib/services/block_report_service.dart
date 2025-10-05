//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';

class BlockReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //************************* Block User *************************//
  Future<void> blockUser(String currentUserId, String otherUserId) async {
    final batch = _firestore.batch();

    batch.set(
      _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('blockedUsers')
          .doc(otherUserId),
      {"blockedAt": FieldValue.serverTimestamp()},
    );

    batch.set(
      _firestore
          .collection('users')
          .doc(otherUserId)
          .collection('blockedUsers')
          .doc(currentUserId),
      {"blockedAt": FieldValue.serverTimestamp()},
    );

    await batch.commit();
  }

  //************************* Unblock User *************************//
  Future<void> unblockUser(String currentUserId, String otherUserId) async {
    final batch = _firestore.batch();

    batch.delete(
      _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('blockedUsers')
          .doc(otherUserId),
    );

    batch.delete(
      _firestore
          .collection('users')
          .doc(otherUserId)
          .collection('blockedUsers')
          .doc(currentUserId),
    );

    await batch.commit();
  }

  //************************* Check Block Status *************************//
  Future<bool> isBlocked(String currentUserId, String otherUserId) async {
    final currentUserBlockDoc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('blockedUsers')
        .doc(otherUserId)
        .get();

    final otherUserBlockDoc = await _firestore
        .collection('users')
        .doc(otherUserId)
        .collection('blockedUsers')
        .doc(currentUserId)
        .get();

    return currentUserBlockDoc.exists || otherUserBlockDoc.exists;
  }

  //************************* Report User *************************//
  Future<void> reportUser(String currentUserId, String otherUserId,String reason) async {
    await _firestore.collection('reports').add({
      "reportedBy": currentUserId,
      "reportedUser": otherUserId,
      "reason": reason,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
