import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class to represent a User document in Firestore
class UserModel {
  // Profile
  final String birthday;
  final String email;
  final String gender;
  final String name;
  final String phone;
  final String profileImage;
  final String video;
  final List<String> photos;

  // Root-level
  final String uid;
  final String personality;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime personalityUpdatedAt;
  final DateTime preferencesUpdatedAt;

  // Flags
  final bool onboardingComplete;
  final bool personalityComplete;
  final bool preferencesComplete;
  final bool isAdFree;

  // Preferences
  final String goalMain;
  final String goalSub;
  final String relationshipStatus;
  final String relationshipType;
  final String whoToMeet;
  final List<String> interests;

  // Payment History — now a list
  final List<Map<String, dynamic>> paymentHistory;

  UserModel({
    required this.birthday,
    required this.email,
    required this.gender,
    required this.name,
    required this.phone,
    required this.profileImage,
    required this.video,
    required this.photos,
    required this.uid,
    required this.personality,
    required this.createdAt,
    required this.updatedAt,
    required this.personalityUpdatedAt,
    required this.preferencesUpdatedAt,
    required this.onboardingComplete,
    required this.personalityComplete,
    required this.preferencesComplete,
    required this.isAdFree,
    required this.goalMain,
    required this.goalSub,
    required this.relationshipStatus,
    required this.relationshipType,
    required this.whoToMeet,
    required this.interests,
    required this.paymentHistory,
  });

  /// Factory constructor to convert Firestore document data into UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final profile = Map<String, dynamic>.from(map['profile'] ?? {});
    final preferences = Map<String, dynamic>.from(map['preferences'] ?? {});

    return UserModel(
      // Profile
      birthday: profile['birthday'] ?? "",
      email: profile['email'] ?? "",
      gender: profile['gender'] ?? "",
      name: profile['name'] ?? "",
      phone: profile['phone'] ?? "",
      profileImage: profile['profileImage'] ?? "",
      video: profile['video'] ?? "",
      photos: List<String>.from(profile['photos'] ?? []),

      // Root
      uid: map['uid'] ?? "",
      personality: map['personality'] ?? "",
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      personalityUpdatedAt: (map['personalityUpdatedAt'] as Timestamp).toDate(),
      preferencesUpdatedAt: (map['preferencesUpdatedAt'] as Timestamp).toDate(),

      // Flags
      onboardingComplete: map['onboardingComplete'] ?? false,
      personalityComplete: map['personalityComplete'] ?? false,
      preferencesComplete: map['preferencesComplete'] ?? false,
      isAdFree: map['isAdFree'] ?? false,

      // Preferences
      goalMain: preferences['goalMain'] ?? "",
      goalSub: preferences['goalSub'] ?? "",
      relationshipStatus: preferences['relationshipStatus'] ?? "",
      relationshipType: preferences['relationshipType'] ?? "",
      whoToMeet: preferences['whoToMeet'] ?? "",
      interests: List<String>.from(preferences['interests'] ?? []),

      // Payment History as list
      paymentHistory: List<Map<String, dynamic>>.from(
        map['paymentHistory'] ?? [],
      ),
    );
  }
}
