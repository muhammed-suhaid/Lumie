import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_colors.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //************************* Get Started Screen *************************//
    return Scaffold(
      //************************* Body *************************//
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // Background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryLavender, AppColors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        //************************* Column *************************//
        child: Column(
          children: [
            Spacer(flex: 2),
            //************************* App Name + Tagline *************************//
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AppName
                Text(
                  AppTexts.appName,
                  style: GoogleFonts.dancingScript(
                    fontSize: AppConstants.kFontSizeTextLogo,
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                // TagLine
                Text(
                  AppTexts.tagline,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeM,
                    color: AppColors.lilacBackground.withAlpha(
                      (0.9 * 255).round(),
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),

            //************************* Custom Button *************************//
            CustomButton(
              text: AppTexts.letsGetStarted,
              type: ButtonType.primary,
              width: screenWidth * 0.8,
              height: 50,
              backgroundColor: AppColors.lilacBackground,
              textColor: AppColors.deepPurple,
              borderRadius: AppConstants.kRadiusM,
              fontSize: AppConstants.kFontSizeM,
              onPressed: () {
                // Navigate to Auth Screen
                // TODO: Navigate to Auth Screen
              },
            ),
            SizedBox(height: screenHeight * 0.08),
          ],
        ),
      ),
    );
  }
}
