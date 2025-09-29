//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if two users liked each other → Create a match
  Future<void> checkAndCreateMatch(String userId, String likedUserId) async {
    try {
      // Check if likedUserId liked userId
      final query = await _firestore
          .collection("likes")
          .where("from", isEqualTo: likedUserId)
          .where("to", isEqualTo: userId)
          .get();

      if (query.docs.isNotEmpty) {
        // It's a match → Add to matches collection
        await _firestore.collection("matches").add({
          "users": [userId, likedUserId],
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get matches for a specific user
  Stream<List<String>> getMatches(String userId) {
    return _firestore.collection("matches").snapshots().map((snapshot) {
      List<String> matchedUserIds = [];

      for (var doc in snapshot.docs) {
        List<dynamic> users = doc["users"];
        if (users.contains(userId)) {
          matchedUserIds.addAll(
            users.where((id) => id != userId).cast<String>(),
          );
        }
      }

      return matchedUserIds.toSet().toList(); // Remove duplicates
    });
  }

  // Check if two users are matched
  Future<bool> isMatched(String userId, String otherUserId) async {
    final query = await _firestore
        .collection("matches")
        .where("users", arrayContainsAny: [userId, otherUserId])
        .get();

    for (var doc in query.docs) {
      List<dynamic> users = doc["users"];
      if (users.contains(userId) && users.contains(otherUserId)) {
        return true;
      }
    }
    return false;
  }
}
