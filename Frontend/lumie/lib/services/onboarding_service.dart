//************************* Imports *************************//
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/custom_snakbar.dart';
import 'cloudinary_service.dart';

//************************* Onboarding Service *************************//
class OnboardingService {
  static Future<void> uploadOnboardingData({
    required BuildContext context,
    required File profileImage,
    required List<File> photos,
    required File video,
    required String gender,
    required String name,
    required String birthday,
    required String email,
    required String password,
  }) async {
    try {
      //************************* Upload Media to Cloudinary *************************//
      final profileImageUrl = await CloudinaryService.uploadFile(
        context,
        profileImage,
        "users/profile",
      );
      if (!context.mounted) return;

      final photoUrls = await CloudinaryService.uploadFiles(
        context,
        photos,
        "users/photos",
      );
      if (!context.mounted) return;

      final videoUrl = await CloudinaryService.uploadFile(
        context,
        video,
        "users/videos",
      );
      if (!context.mounted) return;

      if (profileImageUrl == null || videoUrl == null) {
        CustomSnackbar.show(context, "File upload failed");
        return;
      }

      //************************* Get Current User *************************//
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        CustomSnackbar.show(context, "User not authenticated");
        return;
      }

      //************************* Save Profile in Firestore *************************//
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "profile": {
          "name": name,
          "email": email,
          "phone": user.phoneNumber ?? "",
          "birthday": birthday,
          "gender": gender,
          "profileImage": profileImageUrl,
          "photos": photoUrls,
          "video": videoUrl,
        },
        "onboardingComplete": true,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.show(context, "Error uploading onboarding data");
    }
  }
}
