//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';

class BlockReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //************************* Block User *************************//
  Future<void> blockUser(String blockerId, String blockedId) async {
    await _firestore
        .collection('users')
        .doc(blockerId)
        .collection('blockedUsers')
        .doc(blockedId)
        .set({"blockedAt": FieldValue.serverTimestamp()});
  }

  //************************* Unblock User *************************//
  Future<void> unblockUser(String blockerId, String blockedId) async {
    await _firestore
        .collection('users')
        .doc(blockerId)
        .collection('blockedUsers')
        .doc(blockedId)
        .delete();
  }

  //************************* Check Block Status *************************//
  Future<Map<String, bool>> isBlocked(
    String currentUserId,
    String otherUserId,
  ) async {
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

    return {
      "isBlockedByMe": currentUserBlockDoc.exists,
      "isBlockedByOther": otherUserBlockDoc.exists,
      "isBlocked": currentUserBlockDoc.exists || otherUserBlockDoc.exists,
    };
  }

  //************************* Report User *************************//
  Future<void> reportUser(
    String currentUserId,
    String otherUserId,
    String reason,
  ) async {
    await _firestore.collection('reports').add({
      "reportedBy": currentUserId,
      "reportedUser": otherUserId,
      "reportReason": reason,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
