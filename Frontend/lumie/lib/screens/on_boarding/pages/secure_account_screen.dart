import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_textfield.dart';

class SecureAccountScreen extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SecureAccountScreen({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SecureAccountScreen> createState() => _SecureAccountScreenState();
}

class _SecureAccountScreenState extends State<SecureAccountScreen> {
  bool _obscurePassword = true;

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
            AppTexts.secureYourAccountTitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeXXXL,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),

          //************************* Subtitle *************************//
          Text(
            AppTexts.secureYourAccountSubtitle,
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
            controller: widget.emailController,
            hintText: AppTexts.emailHint,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: screenHeight * 0.03),

          //************************* Password *************************//
          Text(
            AppTexts.password,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              fontWeight: FontWeight.w500,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),
          //************************* Password Input *************************//
          CustomTextField(
            controller: widget.passwordController,
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
        ],
      ),
    );
  }
}
