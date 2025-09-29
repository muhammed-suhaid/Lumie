import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class to represent a User document in Firestore
class UserModel {
  final String birthday;
  final DateTime createdAt;
  final String email;
  final String gender;
  final String name;
  final String bio;
  final String password;
  final String personality;
  final DateTime personalityUpdatedAt;
  final String phone;
  final List<String> photos;
  final Map<String, dynamic> preferences;
  final List<String> interests;
  final String relationshipStatus;
  final String relationshipType;
  final String whoToMeet;
  final String profileImage;
  final String uid;
  final DateTime updatedAt;
  final String video;

  UserModel({
    required this.birthday,
    required this.createdAt,
    required this.email,
    required this.gender,
    required this.name,
    required this.bio,
    required this.password,
    required this.personality,
    required this.personalityUpdatedAt,
    required this.phone,
    required this.photos,
    required this.preferences,
    required this.interests,
    required this.relationshipStatus,
    required this.relationshipType,
    required this.whoToMeet,
    required this.profileImage,
    required this.uid,
    required this.updatedAt,
    required this.video,
  });

  /// Factory constructor to convert Firestore document data into UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      birthday: map['birthday'] ?? "",
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      email: map['email'] ?? "",
      gender: map['gender'] ?? "",
      name: map['name'] ?? "",
      bio: map['bio'] ?? "",
      password: map['password'] ?? "",
      personality: map['personality'] ?? "",
      personalityUpdatedAt: (map['personalityUpdatedAt'] as Timestamp).toDate(),
      phone: map['phone'] ?? "",
      photos: List<String>.from(map['photos'] ?? []),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      interests: List<String>.from(map['interests'] ?? []),
      relationshipStatus: map['relationshipStatus'] ?? "",
      relationshipType: map['relationshipType'] ?? "",
      whoToMeet: map['preferences']['whoToMeet'] ?? "",
      profileImage: map['profileImage'] ?? "",
      uid: map['uid'] ?? "",
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      video: map['video'] ?? "",
    );
  }
}
