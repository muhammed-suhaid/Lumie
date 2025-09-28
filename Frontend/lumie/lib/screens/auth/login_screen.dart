import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/auth/auth_screen.dart';
import 'package:lumie/screens/get_started/terms_conditions_screen.dart';
import 'package:lumie/screens/legal/privacy_policy_screen.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:lumie/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

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
              const Spacer(flex: 2),

              //************************* App Name *************************//
              Text(
                AppTexts.appName,
                style: GoogleFonts.dancingScript(
                  fontSize: AppConstants.kFontSizeTextLogo,
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.kPaddingM),

              //************************* Subtitle *************************//
              Text(
                AppTexts.signIn,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(flex: 1),

              //************************* Email Field  *************************//
              CustomTextField(
                controller: emailController,
                hintText: AppTexts.emailHint,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppConstants.kPaddingM),

              //************************* Password Field *************************//
              CustomTextField(
                controller: passwordController,
                hintText: AppTexts.passwordHint,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppConstants.kPaddingM),

              //************************* Login Button *************************//
              CustomButton(
                text: AppTexts.login,
                type: ButtonType.primary,
                isFullWidth: true,
                backgroundColor: colorScheme.onSurface,
                textColor: colorScheme.surface,
                borderRadius: AppConstants.kRadiusL,
                fontSize: AppConstants.kFontSizeM,
                icon: Icons.phone,
                isIconRight: false,
                onPressed: () {
                  debugPrint(
                    "Logging in with ${emailController.text} / ${passwordController.text}",
                  );
                },
              ),
              const SizedBox(height: AppConstants.kPaddingM),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.poppins(
                      fontSize: AppConstants.kFontSizeS,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                  CustomButton(
                    text: "Sign in",
                    type: ButtonType.text,
                    textColor: colorScheme.secondary,
                    fontSize: AppConstants.kFontSizeS,
                    onPressed: () {
                      debugPrint("Navigate to Auth Screen");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(flex: 3),
              //************************* Privacy Policy And Terms & Conditions *************************//
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
