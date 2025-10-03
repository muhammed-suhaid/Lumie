import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.termsAndConditions,
          style: GoogleFonts.poppins(
            fontSize: AppConstants.kFontSizeL,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.kPaddingL),
        child: SingleChildScrollView(
          child: Text(
            AppTexts.termsAndConditionsContent,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              color: colorScheme.onSurface.withAlpha(200),
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
