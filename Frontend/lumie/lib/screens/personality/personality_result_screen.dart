import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/dummyData/personality_results_data.dart';
import 'package:lumie/models/personality_result_model.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:lumie/widgets/custom_selectable_tile.dart';

class PersonalityResultScreen extends StatelessWidget {
  final String mbti;

  const PersonalityResultScreen({super.key, required this.mbti});

  //************************* Get Result *************************//
  PersonalityResult _getResult() {
    return PersonalityResultsData.getByType(mbti);
  }

  //************************* _chip Widget *************************//
  Widget _chip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: CustomSelectableTile(
        label: label,
        selected: false,
        onTap: () {},
        height: 36,
        isFullWidth: false,
      ),
    );
  }

  //************************* _chipList Widget *************************//
  Widget _chipList(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((e) => _chip(e)).toList(),
    );
  }

  //************************* Navigate to Home *************************//
  void _onButtonClicked(BuildContext context) {
    debugPrint("Navigating to Home Screen");
    // Navigating to Home Screen
    // TODO: Navigating to Home Screen
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final result = _getResult();
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.kPaddingL),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),

                //************************* Title *************************//
                Text(
                  AppTexts.personalityResultTitle,
                  style: TextStyle(
                    fontSize: AppConstants.kFontSizeXXL,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: AppConstants.kPaddingM),

                //************************* MBTI Type *************************//
                Text(
                  "${result.type} – ${result.fullForm}",
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeL,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                //************************* Subtitle *************************//
                Text(
                  result.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeM,
                    fontStyle: FontStyle.italic,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                //************************* Description *************************//
                Text(
                  result.description,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeM,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                //************************* Strengths *************************//
                Text(
                  AppTexts.strengths,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeL,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                _chipList(result.strengths),
                SizedBox(height: screenHeight * 0.03),

                //************************* Weaknesses *************************//
                Text(
                  AppTexts.weaknesses,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeL,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                _chipList(result.weaknesses),
                SizedBox(height: screenHeight * 0.03),

                //************************* Ideal Matches *************************//
                Text(
                  AppTexts.idealMatches,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeL,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                _chipList(result.idealMatches),
                SizedBox(height: screenHeight * 0.05),

                //************************* Button *************************//
                CustomButton(
                  text: AppTexts.continueText,
                  type: ButtonType.secondary,
                  isFullWidth: true,
                  onPressed: () => _onButtonClicked(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
