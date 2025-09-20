import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLength;
  final TextAlign textAlign;
  final bool obscureText;
  final String? prefixText;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.prefixText,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFilled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkFilled);
  }

  void _checkFilled() {
    setState(() {
      _isFilled = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkFilled);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final borderColor = _isFilled
        ? colorScheme.secondary
        : colorScheme.onSurface.withAlpha(150);

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      cursorColor: colorScheme.secondary,
      style: GoogleFonts.poppins(
        fontSize: AppConstants.kFontSizeM,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        counterText: "",
        prefixText: widget.prefixText,
        prefixStyle: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          borderSide: BorderSide(color: colorScheme.secondary, width: 2),
        ),
      ),
    );
  }
}
