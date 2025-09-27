import 'package:flutter/material.dart';
import 'package:lumie/screens/personality/personality_quiz_screen.dart';
import 'package:lumie/screens/preferences/pages/preference_goal_screen.dart';
import 'package:lumie/screens/preferences/pages/preference_interests_screen.dart';
import 'package:lumie/screens/preferences/pages/preference_meet_screen.dart';
import 'package:lumie/screens/preferences/pages/preference_status_screen.dart';
import 'package:lumie/screens/preferences/pages/preference_type_screen.dart';
import 'package:lumie/services/preferences_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_loading_screen.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:lumie/screens/on_boarding/widgets/custom_step_indicator.dart';
import 'package:lumie/widgets/transition_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Preference state
  String? _goalMain;
  String? _goalSub;
  String? _whoToMeet;
  String? _relationshipStatus;
  String? _relationshipType;
  List<String> _interests = [];

  //************************* _validateCurrentStep Method *************************//
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Goal Page
        if (_goalMain == null) {
          CustomSnackbar.show(context, "Please choose Dating or Friends");
          return false;
        }
        if (_goalMain == "Dating" && _goalSub == null) {
          CustomSnackbar.show(context, "Please choose a dating preference");
          return false;
        }
        break;

      case 1: // Meet Page
        if (_whoToMeet == null) {
          CustomSnackbar.show(context, "Please choose who you want to meet");
          return false;
        }
        break;

      case 2: // Status Page
        if (_relationshipStatus == null) {
          CustomSnackbar.show(
            context,
            "Please choose your relationship status",
          );
          return false;
        }
        break;

      case 3: // Type Page
        if (_relationshipType == null) {
          CustomSnackbar.show(context, "Please choose a relationship type");
          return false;
        }
        break;

      case 4: // Interests Page
        if (_interests.length < 5) {
          CustomSnackbar.show(context, "Please select at least 5 interests");
          return false;
        }
        break;
    }
    return true;
  }

  //************************* _validateAllSteps Method *************************//
  bool _validateAllSteps() {
    if (_goalMain == null) {
      CustomSnackbar.show(context, "Please choose Dating or Friends");
      return false;
    }
    if (_goalMain == "Dating" && _goalSub == null) {
      CustomSnackbar.show(context, "Please choose a dating preference");
      return false;
    }
    if (_whoToMeet == null) {
      CustomSnackbar.show(context, "Please choose who you want to meet");
      return false;
    }
    if (_relationshipStatus == null) {
      CustomSnackbar.show(context, "Please choose your relationship status");
      return false;
    }
    if (_relationshipType == null) {
      CustomSnackbar.show(context, "Please choose a relationship type");
      return false;
    }
    if (_interests.length < 5) {
      CustomSnackbar.show(context, "Please select at least 5 interests");
      return false;
    }
    return true;
  }

  //************************* _onNextPressed Method *************************//
  void _onNextPressed() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < 4) {
      _goToNextPage();
    } else {
      // Validate all pages at once before finishing
      if (_validateAllSteps()) {
        final data = _collectPreferencesData();
        debugPrint("===== Preferences Collected =====");
        data.forEach((key, value) => debugPrint("$key: $value"));
        debugPrint("=================================");
        _finishPreferences();
      }
    }
  }

  //************************* _goToNextPage method *************************//
  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  //************************* _collectPreferencesData Method *************************//
  Map<String, dynamic> _collectPreferencesData() {
    return {
      "goalMain": _goalMain,
      "goalSub": _goalSub,
      "whoToMeet": _whoToMeet,
      "relationshipStatus": _relationshipStatus,
      "relationshipType": _relationshipType,
      "interests": _interests,
    };
  }

  //************************* _finishPreferences Method *************************//
  Future<void> _finishPreferences() async {
    final data = _collectPreferencesData();

    try {
      setState(() => _isLoading = true);
      await PreferencesService.savePreferences(data);
      if (mounted) {
        CustomSnackbar.show(context, "Preferences saved!", isError: false);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransitionScreen(
              subtitle: AppTexts.transitonPreferencsSubtitle,
              buttonText: AppTexts.startPersonalityQuiz,
              onContinue: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalityQuizScreen(),
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(context, "Error saving preferences: $e");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  //************************* Dispose Method *************************//
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //************************* Body *************************//
  //************************* Body *************************//
  //************************* Body *************************//

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return _isLoading
        ? LoadingScreen()
        : Scaffold(
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
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) =>
                          setState(() => _currentStep = index),
                      children: [
                        PreferenceGoalPage(
                          selectedMain: _goalMain,
                          selectedSub: _goalSub,
                          onMainSelected: (main) =>
                              setState(() => _goalMain = main),
                          onSubSelected: (sub) =>
                              setState(() => _goalSub = sub),
                        ),
                        PreferenceMeetPage(
                          selected: _whoToMeet,
                          onSelected: (selected) =>
                              setState(() => _whoToMeet = selected),
                        ),
                        PreferenceStatusPage(
                          selected: _relationshipStatus,
                          onSelected: (s) =>
                              setState(() => _relationshipStatus = s),
                        ),
                        PreferenceTypePage(
                          selected: _relationshipType,
                          onSelected: (s) =>
                              setState(() => _relationshipType = s),
                        ),
                        PreferenceInterestsPage(
                          selectedInterests: _interests,
                          onChanged: (list) =>
                              setState(() => _interests = list),
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
                onPressed: _onNextPressed,
              ),
            ),
          );
  }
}
