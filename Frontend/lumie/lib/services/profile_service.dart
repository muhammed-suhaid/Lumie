//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumie/models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current logged-in user ID
  String? get currentUserId => _auth.currentUser?.uid;

  //************************* Get User Profile *************************//
  Future<UserModel?> getUserProfile() async {
    if (currentUserId == null) return null;

    final doc = await _firestore.collection("users").doc(currentUserId).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!..["uid"] = doc.id);
    }
    return null;
  }

  //************************* Update User Profile *************************//
  Future<void> updateUserProfile({
    String? whoToMeet,
    String? relationshipStatus,
    String? relationshipType,
    String? goalMain,
    String? goalSub,
    List<String>? interests,
  }) async {
    if (currentUserId == null) return;

    final Map<String, dynamic> updates = {};

    if (goalMain != null) updates["preferences.goalMain"] = goalMain;
    if (goalSub != null) updates["preferences.goalSub"] = goalSub;
    if (goalMain == "Friends") updates["preferences.goalSub"] = goalSub;
    if (whoToMeet != null) updates["preferences.whoToMeet"] = whoToMeet;
    if (relationshipStatus != null) {
      updates["preferences.relationshipStatus"] = relationshipStatus;
    }
    if (relationshipType != null) {
      updates["preferences.relationshipType"] = relationshipType;
    }
    if (interests != null) updates["preferences.interests"] = interests;

    updates["updatedAt"] = FieldValue.serverTimestamp();

    await _firestore.collection("users").doc(currentUserId).update(updates);
  }
}
