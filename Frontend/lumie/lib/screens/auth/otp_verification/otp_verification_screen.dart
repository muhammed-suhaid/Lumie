import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/auth/otp_verification/widgets/custom_otp_field.dart';
import 'package:lumie/screens/on_boarding/on_borading_screen.dart';
import 'package:lumie/services/phone_auth_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  const OtpVerificationScreen({
    super.key,
    required this.phone,
    required this.verificationId,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _otpCode = "";

  //************************* onContinue method *************************//
  void _onContinue() async {
    if (_otpCode.isEmpty || _otpCode.length < 6) {
      CustomSnackbar.show(context, "Please enter the 6-digit OTP");
      return;
    }

    debugPrint("Entered Phone Number: ${widget.phone}");
    debugPrint("Entered OTP: $_otpCode");
    try {
      final userCredential = await PhoneAuthService.verifyOTP(_otpCode);

      if (!mounted) return;

      if (userCredential != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(context, "Invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    //************************* OTP Screen *************************//
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.08),

              //************************* Title *************************//
              Text(
                AppTexts.otpTitle1,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeXXXL,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                AppTexts.otpTitle2,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeXXXL,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppConstants.kPaddingS),

              //************************* Subtitle *************************//
              Text(
                AppTexts.otpSubtitle,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  color: colorScheme.onSurface.withAlpha(160),
                ),
              ),
              Text(
                "+91 ${widget.phone}",
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  color: colorScheme.onSurface.withAlpha(160),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              //************************* OTP Input *************************//
              CustomOtpField(
                onChanged: (value) {
                  setState(() => _otpCode = value);
                },
                onCompleted: (value) {
                  setState(() => _otpCode = value);
                },
              ),

              const Spacer(flex: 3),

              //************************* Continue Button *************************//
              CustomButton(
                text: AppTexts.continueText,
                type: ButtonType.primary,
                isFullWidth: true,
                backgroundColor: colorScheme.secondary,
                textColor: colorScheme.onPrimary,
                borderRadius: AppConstants.kRadiusM,
                fontSize: AppConstants.kFontSizeM,
                onPressed: _onContinue,
              ),
              SizedBox(height: screenHeight * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
