//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//************************* Personality Service *************************//
class PersonalityService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> savePersonality(String mbti) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final userDoc = _firestore.collection("users").doc(user.uid);

    await userDoc.update({
      "personality": mbti,
      "personalityComplete": true,
      "personalityUpdatedAt": FieldValue.serverTimestamp(),
    });
  }
}
