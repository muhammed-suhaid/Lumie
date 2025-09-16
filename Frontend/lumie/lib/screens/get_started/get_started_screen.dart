import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/auth/auth_screen.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  //************************* Navigate to SignIn Method *************************//
  void _goToSignIn(BuildContext context) {
    debugPrint("Navigate to SignIn Screen");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;

    // Colors from theme
    final colorScheme = Theme.of(context).colorScheme;

    //************************* Get Started Screen *************************//
    return Scaffold(
      //************************* Body *************************//
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // Background gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
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
                    color: colorScheme.onPrimary,
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
                    color: colorScheme.onPrimary.withAlpha(150),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),

            //************************* Custom Button *************************//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.kPaddingL,
              ),
              child: CustomButton(
                text: AppTexts.letsGetStarted,
                type: ButtonType.primary,
                isFullWidth: true,
                backgroundColor: colorScheme.surface,
                textColor: colorScheme.onSurface,
                borderRadius: AppConstants.kRadiusM,
                fontSize: AppConstants.kFontSizeM,
                onPressed: () => _goToSignIn(context),
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
          ],
        ),
      ),
    );
  }
}
