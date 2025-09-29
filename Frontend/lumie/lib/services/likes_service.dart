//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'matches_service.dart';

class LikesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MatchesService _matchesService = MatchesService();

  // Add a like from current user to another user
  Future<void> addLike(String fromUserId, String toUserId) async {
    try {
      await _firestore.collection("likes").add({
        "from": fromUserId,
        "to": toUserId,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // Check if it's a match
      await _matchesService.checkAndCreateMatch(fromUserId, toUserId);
    } catch (e) {
      rethrow;
    }
  }

  // Remove a like
  Future<void> removeLike(String fromUserId, String toUserId) async {
    final query = await _firestore
        .collection("likes")
        .where("from", isEqualTo: fromUserId)
        .where("to", isEqualTo: toUserId)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  // Users I liked
  Stream<List<String>> getLikedUsers(String userId) {
    return _firestore
        .collection("likes")
        .where("from", isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc["to"] as String).toList(),
        );
  }

  // Users who liked me
  Stream<List<String>> getUsersWhoLikedMe(String userId) {
    return _firestore
        .collection("likes")
        .where("to", isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc["from"] as String).toList(),
        );
  }

  // Check if a specific user is liked
  Future<bool> isUserLiked(String fromUserId, String toUserId) async {
    final query = await _firestore
        .collection("likes")
        .where("from", isEqualTo: fromUserId)
        .where("to", isEqualTo: toUserId)
        .get();

    return query.docs.isNotEmpty;
  }
}
