import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_textfield.dart';

class AddRecoveryEmailScreen extends StatelessWidget {
  final TextEditingController emailController;

  const AddRecoveryEmailScreen({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //************************* Title *************************//
          Text(
            AppTexts.addRecoveryEmailTitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeXXXL,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),

          //************************* Subtitle *************************//
          Text(
            AppTexts.addRecoveryEmailSubtitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              color: colorScheme.onSurface.withAlpha(160),
            ),
          ),

          SizedBox(height: screenHeight * 0.04),

          //************************* Email Label *************************//
          Text(
            AppTexts.email,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              fontWeight: FontWeight.w500,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),

          //************************* Email Input *************************//
          CustomTextField(
            controller: emailController,
            hintText: AppTexts.emailHint,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
