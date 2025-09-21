import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:lumie/screens/on_boarding/widgets/custom_step_indicator.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  //************************* Dispose Method *************************//
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //************************* _goToNextPage method *************************//
  void _goToNextPage() {
    if (_currentStep < 4) {
      debugPrint("Continue button pressed");
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  //************************* Body *************************//
  //************************* Body *************************//
  //************************* Body *************************//

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            // step indicator
            CustomStepIndicator(currentStep: _currentStep, totalSteps: 5),
            SizedBox(height: screenHeight * 0.04),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  SizedBox(child: Center(child: Text("Preference Goal Page"))),
                  SizedBox(child: Center(child: Text("Preference Meet Page"))),
                  SizedBox(
                    child: Center(child: Text("Preference Status Page")),
                  ),
                  SizedBox(child: Center(child: Text("Preference Type Page"))),
                  SizedBox(
                    child: Center(child: Text("Preference Interest Page")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //************************* Continue Button at Bottom *************************//
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          top: AppConstants.kPaddingM,
          bottom: AppConstants.kPaddingL,
          left: AppConstants.kPaddingL,
          right: AppConstants.kPaddingL,
        ),
        child: CustomButton(
          text: _currentStep == 4 ? AppTexts.done : AppTexts.continueText,
          type: ButtonType.primary,
          isFullWidth: true,
          backgroundColor: colorScheme.secondary,
          textColor: colorScheme.onPrimary,
          borderRadius: AppConstants.kRadiusM,
          fontSize: AppConstants.kFontSizeM,
          onPressed: _goToNextPage,
        ),
      ),
    );
  }
}
