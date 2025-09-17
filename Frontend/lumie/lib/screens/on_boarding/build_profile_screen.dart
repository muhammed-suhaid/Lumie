import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';

class BuildProfileScreen extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickPhoto;
  const BuildProfileScreen({
    super.key,
    required this.selectedImage,
    required this.onPickPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.08),
          //************************* Profile Placeholder / Image *************************//
          CircleAvatar(
            radius: 80,
            backgroundColor: colorScheme.secondary.withAlpha(30),
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!)
                : null,
            child: selectedImage == null
                ? Icon(Icons.person, size: 120, color: colorScheme.secondary)
                : null,
          ),
          SizedBox(height: screenHeight * 0.05),

          //************************* Title *************************//
          Text(
            AppTexts.buildProfileTitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeXXXL,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),

          //************************* Subtitle *************************//
          Text(
            AppTexts.buildProfileSubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              color: colorScheme.onSurface.withAlpha(160),
            ),
          ),
          const Spacer(),

          //************************* Add / Change Photo Button *************************//
          CustomButton(
            text: selectedImage == null
                ? AppTexts.addYourPhoto
                : AppTexts.changePhoto,
            type: ButtonType.primary,
            isFullWidth: true,
            backgroundColor: colorScheme.secondary,
            textColor: colorScheme.onPrimary,
            borderRadius: AppConstants.kRadiusM,
            fontSize: AppConstants.kFontSizeM,
            onPressed: onPickPhoto,
          ),
          SizedBox(height: screenHeight * 0.08),
        ],
      ),
    );
  }
}
