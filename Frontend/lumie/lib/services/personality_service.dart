import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalityService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save the personality result (MBTI) for the current user
  static Future<void> savePersonality(String mbti) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final userDoc = _firestore.collection("users").doc(user.uid);

    await userDoc.update({
      "personality": mbti,
      "personalityUpdatedAt": FieldValue.serverTimestamp(),
    });
  }
}
