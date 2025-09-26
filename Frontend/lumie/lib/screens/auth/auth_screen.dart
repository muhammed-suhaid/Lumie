import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/auth/phone_number_screen.dart';
import 'package:lumie/screens/get_started/terms_conditions_screen.dart';
import 'package:lumie/screens/legal/privacy_policy_screen.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    //************************* Navigate to SignIn Method *************************//
    void goToPhoneNumberScreen(BuildContext context) {
      debugPrint("Navigate to Phone Number Screen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
      );
    }

    //************************* Google Sign-In Method *************************//
    // Future<void> handleGoogleSignIn() async {
    //   try {
    //     final userCredential = await GoogleSignInService.signInWithGoogle();

    //     if (userCredential != null &&
    //         userCredential.user != null &&
    //         context.mounted) {
    //       // Sign-in successful, go to OnBoardingScreen
    //       debugPrint("Sign-in successful, go to OnBoardingScreen");
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    //       );
    //     }
    //   } catch (e) {
    //     debugPrint("Google Sign-In error: $e");
    //     if (context.mounted) {
    //       CustomSnackbar.show(context, "Google Sign-In failed");
    //     }
    //   }
    // }

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
              // CustomButton(
              //   text: AppTexts.continueWithGoogle,
              //   type: ButtonType.primary,
              //   isFullWidth: true,
              //   backgroundColor: colorScheme.onSurface,
              //   textColor: colorScheme.surface,
              //   borderRadius: AppConstants.kRadiusL,
              //   fontSize: AppConstants.kFontSizeM,
              //   icon: Icons.g_mobiledata,
              //   isIconRight: false,
              //   onPressed: handleGoogleSignIn,
              // ),
              // const SizedBox(height: AppConstants.kPaddingM),

              //************************* Phone Sign In *************************//
              CustomButton(
                text: AppTexts.continueWithPhone,
                type: ButtonType.outline,
                isFullWidth: true,
                borderColor: colorScheme.secondary,
                textColor: colorScheme.secondary,
                borderRadius: AppConstants.kRadiusL,
                fontSize: AppConstants.kFontSizeM,
                icon: Icons.phone,
                isIconRight: false,
                onPressed: () {
                  goToPhoneNumberScreen(context);
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

                  // Terms & Conditions button
                  CustomButton(
                    text: AppTexts.termsAndConditions,
                    type: ButtonType.text,
                    textColor: colorScheme.secondary,
                    fontSize: AppConstants.kFontSizeXS,
                    onPressed: () {
                      debugPrint("Navigate to Terms & Conditions");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsConditionsScreen(),
                        ),
                      );
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
                    text: AppTexts.privacyPolicy,
                    type: ButtonType.text,
                    textColor: colorScheme.secondary,
                    fontSize: AppConstants.kFontSizeXS,
                    onPressed: () {
                      debugPrint("Navigate to Privacy Policy");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicyScreen(),
                        ),
                      );
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
