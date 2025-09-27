import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ******** Logo / App Name ********
              Text(
                AppTexts.appName,
                style: GoogleFonts.dancingScript(
                  fontSize: AppConstants.kFontSizeTextLogo,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // ******** Animated Loader ********
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation(colorScheme.secondary),
                ),
              ),
              const SizedBox(height: AppConstants.kPaddingL),

              // ******** Subtitle ********
              Text(
                "Please wait while we set things up...",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  color: colorScheme.onSurface.withAlpha(100),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
