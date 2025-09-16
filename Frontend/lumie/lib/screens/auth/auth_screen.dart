import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kPaddingL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //************************* App Name *************************//
              const Spacer(flex: 2),
              Text(
                AppTexts.appName,
                style: GoogleFonts.dancingScript(
                  fontSize: AppConstants.kFontSizeTextLogo,
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.kPaddingM),

              //************************* Subheading *************************//
              Text(
                AppTexts.signIn,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(flex: 2),

              //************************* Google Sign In *************************//
              CustomButton(
                text: AppTexts.continueWithGoogle,
                type: ButtonType.primary,
                isFullWidth: true,
                backgroundColor: colorScheme.onSurface,
                textColor: colorScheme.surface,
                borderRadius: AppConstants.kRadiusL,
                fontSize: AppConstants.kFontSizeM,
                icon: Icons.g_mobiledata,
                isIconRight: false,
                onPressed: () {
                  debugPrint("Google Sign In Pressed");
                  // TODO: Implement Google Sign In
                },
              ),
              const SizedBox(height: AppConstants.kPaddingM),

              //************************* Phone Sign In *************************//
              CustomButton(
                text: AppTexts.continueWithPhone,
                type: ButtonType.outline,
                isFullWidth: true,
                backgroundColor: colorScheme.secondary,
                textColor: colorScheme.secondary,
                borderRadius: AppConstants.kRadiusL,
                fontSize: AppConstants.kFontSizeM,
                icon: Icons.phone,
                isIconRight: false,
                onPressed: () {
                  debugPrint("Phone Sign In Pressed");
                  // TODO: Navigate to Phone OTP Screen
                },
              ),

              //************************* Footer *************************//
              const Spacer(flex: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "By continuing, you agree to our ",
                    style: GoogleFonts.poppins(
                      fontSize: AppConstants.kFontSizeXS,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),

                  // Terms of Service button
                  CustomButton(
                    text: "Terms of Service",
                    type: ButtonType.text,
                    textColor: colorScheme.secondary,
                    fontSize: AppConstants.kFontSizeXS,
                    onPressed: () {
                      debugPrint("Navigate to Terms of Service");
                      // TODO: Navigate to Terms Screen
                    },
                  ),

                  Text(
                    " and ",
                    style: GoogleFonts.poppins(
                      fontSize: AppConstants.kFontSizeXS,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),

                  // Privacy Policy button
                  CustomButton(
                    text: "Privacy Policy",
                    type: ButtonType.text,
                    textColor: colorScheme.secondary,
                    fontSize: AppConstants.kFontSizeXS,
                    onPressed: () {
                      debugPrint("Navigate to Privacy Policy");
                      // TODO: Navigate to Privacy Screen
                    },
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
