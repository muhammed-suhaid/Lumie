import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferencesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves preferences for the current logged-in user
  static Future<void> savePreferences(Map<String, dynamic> preferences) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final userDoc = _firestore.collection("users").doc(user.uid);

    // Update only the "preferences" field and "updatedAt"
    await userDoc.update({
      "preferences": preferences,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
