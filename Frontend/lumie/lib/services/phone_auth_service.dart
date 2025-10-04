import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Enum to decide the next screen after OTP verification
enum AuthNextStep { onboarding, preferences, personality, discover }

class PhoneAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //************************* Variables *************************//
  static String? _verificationId;

  //************************* Send OTP *************************//
  static Future<void> sendOTP({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) onFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint("Error sending OTP: $e");
      rethrow;
    }
  }

  //************************* Verify OTP *************************//
  static Future<AuthNextStep?> verifyOTP(String otpCode) async {
    try {
      if (_verificationId == null) throw Exception("No verificationId found");

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );

      // Step 1: Sign in user with credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user; // ✅ Use directly, avoids warning

      // Step 2: Check Firestore for user document
      if (user != null) {
        final userDoc = _firestore.collection("users").doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // First time registration → create a new user document
          await userDoc.set({
            "uid": user.uid,
            "phone": user.phoneNumber,
            "onboardingComplete": false,
            "preferencesComplete": false,
            "personalityComplete": false,
            'isAdFree': false,
            "createdAt": FieldValue.serverTimestamp(),
          });
          debugPrint("First Time Registering");
          return AuthNextStep.onboarding; // Go to onboarding
        } else {
          // Existing user → check progress flags
          bool onboardingComplete =
              (docSnapshot.data()?["onboardingComplete"] ?? false);
          bool preferencesComplete =
              (docSnapshot.data()?["preferencesComplete"] ?? false);
          bool personalityComplete =
              (docSnapshot.data()?["personalityComplete"] ?? false);

          if (!onboardingComplete) {
            return AuthNextStep.onboarding;
          } else if (!preferencesComplete) {
            return AuthNextStep.preferences;
          } else if (!personalityComplete) {
            return AuthNextStep.personality;
          } else {
            return AuthNextStep.discover;
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error verifying OTP: $e");
      rethrow;
    }
  }

  //************************* Sign Out *************************//
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  //************************* Current User *************************//
  static User? get currentUser => _auth.currentUser;
}
