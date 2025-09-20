import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:lumie/widgets/custom_textfield.dart';

class IdentifyYourselfScreen extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final String? selectedGender;
  final ValueChanged<String> onGenderSelected;

  const IdentifyYourselfScreen({
    super.key,
    required this.nameController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  //************************* _genderButton Widget *************************//
  Widget _genderButton(String gender, ColorScheme colorScheme) {
    final isSelected = selectedGender == gender;

    return Expanded(
      child: CustomButton(
        text: gender,
        type: ButtonType.outline,
        onPressed: () => onGenderSelected(gender),
        backgroundColor: isSelected
            ? colorScheme.secondary
            : Colors.transparent,
        textColor: isSelected ? colorScheme.onSecondary : colorScheme.onSurface,
        borderColor: isSelected ? colorScheme.secondary : colorScheme.onSurface,
        isFullWidth: true,
      ),
    );
  }

  //************************* _birthdayField Widget *************************//
  Widget _birthdayField(
    TextEditingController controller,
    String hintText,
    int maxLength,
  ) {
    return Expanded(
      child: CustomTextField(
        controller: controller,
        hintText: hintText,
        maxLength: maxLength,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
      ),
    );
  }

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
            AppTexts.identifyYourselfTitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeXXXL,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),
          Text(
            AppTexts.identifyYourselfSubtitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              color: colorScheme.onSurface.withAlpha(160),
            ),
          ),
          SizedBox(height: screenHeight * 0.04),

          //************************* Gender *************************//
          Text(
            AppTexts.iAmA,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              fontWeight: FontWeight.w500,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),
          Row(
            children: [
              _genderButton(AppTexts.maleGender, colorScheme),
              const SizedBox(width: AppConstants.kPaddingM),
              _genderButton(AppTexts.femaleGender, colorScheme),
            ],
          ),

          SizedBox(height: screenHeight * 0.03),

          //************************* Other Options *************************//
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       AppTexts.otherOptions,
          //       style: GoogleFonts.poppins(
          //         fontSize: AppConstants.kFontSizeM,
          //         fontWeight: FontWeight.w500,
          //         color: colorScheme.secondary,
          //       ),
          //     ),
          //     Icon(
          //       Icons.arrow_forward_ios,
          //       size: AppConstants.kIconSizeS,
          //       color: colorScheme.secondary,
          //     ),
          //   ],
          // ),
          // SizedBox(height: screenHeight * 0.03),

          //************************* Birthday *************************//
          Text(
            AppTexts.birthday,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              fontWeight: FontWeight.w500,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),
          Row(
            children: [
              _birthdayField(dayController, AppTexts.dd, 2),
              const SizedBox(width: 8),
              _birthdayField(monthController, AppTexts.mm, 2),
              const SizedBox(width: 8),
              _birthdayField(yearController, AppTexts.yyyy, 4),
            ],
          ),

          SizedBox(height: screenHeight * 0.03),

          //************************* Name *************************//
          Text(
            AppTexts.name,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              fontWeight: FontWeight.w500,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),
          // Name field
          CustomTextField(
            controller: nameController,
            hintText: AppTexts.addYourNameHere,
          ),
        ],
      ),
    );
  }
}
