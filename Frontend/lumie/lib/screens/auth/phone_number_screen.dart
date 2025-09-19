import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/auth/otp_verification/otp_verification_screen.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:lumie/widgets/custom_textfield.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();

  //************************* onContinue method *************************//
  void _onContinue() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      CustomSnackbar.show(context, "Please enter a valid phone number");
      return;
    }

    debugPrint("Phone entered: $phone");
    // TODO: Trigger Firebase Phone Auth (send OTP)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OtpVerificationScreen(phone: phone)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    //************************* Phone Number Screen *************************//
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kPaddingL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //************************* Title *************************//
              SizedBox(height: screenHeight * 0.08),
              Text(
                AppTexts.phoneTitle1,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeXXXL,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                AppTexts.phoneTitle2,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeXXXL,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              //************************* Subtitle *************************//
              Text(
                AppTexts.phoneSubtitle,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  color: colorScheme.onSurface.withAlpha(160),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              //************************* Phone Input *************************//
              CustomTextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                hintText: AppTexts.enterPhoneNumber,
                prefixText: "+91  ",
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
