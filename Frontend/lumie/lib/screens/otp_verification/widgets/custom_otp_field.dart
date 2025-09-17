import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lumie/utils/app_constants.dart';

class CustomOtpField extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const CustomOtpField({
    super.key,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PinCodeTextField(
      appContext: context,
      length: length,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      textStyle: GoogleFonts.poppins(
        fontSize: AppConstants.kFontSizeXL,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
        fieldHeight: 60,
        fieldWidth: 55,
        activeFillColor: colorScheme.primary.withAlpha(40),
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveColor: colorScheme.primary,
        selectedColor: colorScheme.primary,
        activeColor: colorScheme.primary,
      ),
      enableActiveFill: true,
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
