import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLength;
  final TextAlign textAlign;
  final bool obscureText;
  final String? prefixText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      textAlign: textAlign,
      obscureText: obscureText,
      cursorColor: colorScheme.primary,
      style: GoogleFonts.poppins(
        fontSize: AppConstants.kFontSizeM,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: "",
        prefixText: prefixText,
        prefixStyle: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          borderSide: BorderSide(color: colorScheme.onSurface.withAlpha(150)),
        ),
        // When not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          borderSide: BorderSide(color: colorScheme.onSurface.withAlpha(150)),
        ),
        // When focused (same as gender button highlight)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          borderSide: BorderSide(color: colorScheme.secondary, width: 2),
        ),
      ),
    );
  }
}
