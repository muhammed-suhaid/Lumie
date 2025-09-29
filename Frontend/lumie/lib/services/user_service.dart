//************************* Imports *************************//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

//************************* UserService *************************//
class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //************************* Fetch Current User *************************//
  static Future<UserModel?> fetchCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      debugPrint("Error fetching user: $e");
      return null;
    }
  }

  //************************* Fetch Multiple Users *************************//
  static Future<List<UserModel>> fetchUsers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final querySnapshot = await _firestore
          .collection("users")
          .where(
            FieldPath.documentId,
            isNotEqualTo: currentUser.uid,
          ) // Exclude current user
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error fetching users: $e");
      return [];
    }
  }

  //************************* Fetch Matching Users *************************//
  static Future<List<UserModel>> fetchMatchingUsers(
    String personality,
    String whoToMeet,
    DateTime userBirthday,
  ) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final matches = personalityMatches[personality] ?? [];
      if (matches.isEmpty) return [];

      String mapWhoToMeetToGender(String whoToMeet) {
        if (whoToMeet == "Men") return "Male";
        if (whoToMeet == "Women") return "Female";
        return ""; // Everyone
      }

      // String formatDate(DateTime date) {
      //   return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      // }

      Query query = _firestore
          .collection("users")
          .where("personality", whereIn: matches);

      // Filter based on whoToMeet
      if (whoToMeet != "Everyone") {
        query = query.where(
          "gender",
          isEqualTo: mapWhoToMeetToGender(whoToMeet),
        );
      }

      // Age filter ±2 years
      // DateTime minBirthday = DateTime(
      //   userBirthday.year - 2,
      //   userBirthday.month,
      //   userBirthday.day,
      // );
      // DateTime maxBirthday = DateTime(
      //   userBirthday.year + 2,
      //   userBirthday.month,
      //   userBirthday.day,
      // );
      // query = query
      //     .where("birthday", isGreaterThanOrEqualTo: formatDate(minBirthday))
      //     .where("birthday", isLessThanOrEqualTo: formatDate(maxBirthday));

      // Exclude current user
      query = query.where(FieldPath.documentId, isNotEqualTo: currentUser.uid);

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint("Error fetching matching users: $e");
      return [];
    }
  }

  //************************* Personality Match Map *************************//
  static Map<String, List<String>> personalityMatches = {
    "INTJ": ["ENTP", "ENFP", "INFJ", "ENTJ"],
    "ENTP": ["INFJ", "INTJ", "ENFP", "ENTJ"],
    "INFJ": ["ENFP", "ENTP", "INTJ", "INFP"],
    "ENFP": ["INFJ", "INTJ", "ENTP", "ENFJ"],
    "ISTJ": ["ESFP", "ESTP", "ISFJ", "ESTJ"],
    "ISFJ": ["ESTP", "ESFP", "ISTJ", "ESFJ"],
    "ESTJ": ["ISFP", "ISTJ", "ESFJ", "ENTJ"],
    "ESFJ": ["ISFP", "ISTJ", "ENFP", "ESTJ"],
    "ISTP": ["ESFJ", "ESTJ", "ISFP", "INTP"],
    "ISFP": ["ESTJ", "ESFJ", "ISTP", "INFP"],
    "ESTP": ["ISFJ", "ISTJ", "ESFP", "ENTP"],
    "ESFP": ["ISTJ", "ISFJ", "ESTP", "ENFP"],
    "INFP": ["ENFJ", "INFJ", "ISFP", "ENFP"],
    "ENFJ": ["INFP", "ENFP", "INFJ", "ENTP"],
    "ENTJ": ["INTJ", "ENTP", "ENFJ", "ESTJ"],
    "INTP": ["ENTP", "INFJ", "ISTP", "INFP"],
  };
}
