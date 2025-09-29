//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//************************* Preferences Service *************************//
class PreferencesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> savePreferences(Map<String, dynamic> preferences) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final userDoc = _firestore.collection("users").doc(user.uid);

    await userDoc.update({
      "preferences": preferences,
      "preferencesComplete": true,
      "preferencesUpdatedAt": FieldValue.serverTimestamp(),
    });
  }
}
