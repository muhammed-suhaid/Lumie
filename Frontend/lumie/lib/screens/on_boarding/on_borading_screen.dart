import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumie/screens/on_boarding/add_recovery_email_screen.dart';
import 'package:lumie/screens/on_boarding/build_profile_screen.dart';
import 'package:lumie/screens/on_boarding/identify_yourself_screen.dart';
import 'package:lumie/screens/on_boarding/secure_account_screen.dart';
import 'package:lumie/screens/on_boarding/widgets/custom_step_indicator.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';

//************************* Main Onboarding Screen *************************//
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // For Build Profile Screen
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // For Identify Yourself Screen
  String? _selectedGender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // For Add Recovery Email Screen
  final TextEditingController _emailController = TextEditingController();

  // For Secure Account Screen
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //************************* Pick photo from camera/gallery *************************//
  Future<void> _pickPhoto(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  //************************* Show bottom sheet *************************//
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.kPaddingM),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(AppTexts.takeAPhoto),
                  onTap: () {
                    Navigator.pop(context);
                    _pickPhoto(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text(AppTexts.chooseFromGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickPhoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //************************* _validateProfile method *************************//
  bool _validateProfile({bool showSnackbar = true}) {
    if (_selectedImage == null) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Please select a profile photo");
      }
      return false;
    }
    return true;
  }

  //************************* _validateIdentifyYourself method *************************//
  bool _validateIdentifyYourself({bool showSnackbar = true}) {
    // Gender check
    if (_selectedGender == null) {
      if (showSnackbar) CustomSnackbar.show(context, "Please select a gender");
      return false;
    }

    // Birthday check
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day == null || month == null || year == null) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Please enter a valid birthday");
      }
      return false;
    }

    if (day < 1 || day > 31 || month < 1 || month > 12) {
      if (showSnackbar) CustomSnackbar.show(context, "Invalid day or month");
      return false;
    }

    final currentYear = DateTime.now().year;
    if (year < currentYear - 100 || year > currentYear) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Please enter a valid year");
      }
      return false;
    }

    // check if the date is actually valid (e.g., no Feb 30)
    try {
      final birthDate = DateTime(year, month, day);
      if (birthDate.day != day ||
          birthDate.month != month ||
          birthDate.year != year) {
        throw Exception();
      }
    } catch (_) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Please enter a valid date");
      }
      return false;
    }

    // Name check
    final name = _nameController.text.trim();
    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (name.isEmpty || name.length < 3 || !nameRegex.hasMatch(name)) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Please enter a valid name");
      }
      return false;
    }

    return true;
  }

  //************************* _validateRecoveryEmail method *************************//
  bool _validateRecoveryEmail({bool showSnackbar = true}) {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Please enter a valid email address");
      }
      return false;
    }

    return true;
  }

  //************************* _validateSecureAccount method *************************//
  bool _validateSecureAccount({bool showSnackbar = true}) {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.length < 3) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Username must be at least 3 characters");
      }
      return false;
    }

    if (password.length < 6) {
      if (showSnackbar) {
        CustomSnackbar.show(context, "Password must be at least 6 characters");
      }
      return false;
    }

    return true;
  }

  //************************* Full Validation *************************//
  bool _validateAllSteps() {
    return _validateProfile(showSnackbar: true) &&
        _validateIdentifyYourself(showSnackbar: true) &&
        _validateRecoveryEmail(showSnackbar: true) &&
        _validateSecureAccount(showSnackbar: true);
  }

  //************************* Collect all onboarding data *************************//
  Map<String, dynamic> _collectOnboardingData() {
    return {
      "profileImage": _selectedImage?.path ?? "No image selected",
      "gender": _selectedGender,
      "name": _nameController.text.trim(),
      "birthday":
          "${_dayController.text}/${_monthController.text}/${_yearController.text}",
      "email": _emailController.text.trim(),
      "username": _usernameController.text.trim(),
      "password": _passwordController.text.trim(),
    };
  }

  //************************* Continue / Done Handler *************************//
  void _handleContinue() {
    if (_currentStep < 3) {
      switch (_currentStep) {
        case 0:
          if (_validateProfile()) _goToNextPage();
          break;
        case 1:
          if (_validateIdentifyYourself()) _goToNextPage();
          break;
        case 2:
          if (_validateRecoveryEmail()) _goToNextPage();
          break;
      }
    } else {
      // Done pressed, validate all steps
      if (_validateAllSteps()) {
        final data = _collectOnboardingData();
        debugPrint("===== Final Onboarding Data =====");
        data.forEach((key, value) => debugPrint("$key: $value"));
        debugPrint("=================================");
        // TODO: API call
      }
    }
  }

  //************************* _goToNextPage method *************************//
  void _goToNextPage() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  //************************* Dispose Method *************************//
  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //************************* Body *************************//
  //************************* Body *************************//
  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            // Custom Step Indicator Widget
            CustomStepIndicator(currentStep: _currentStep, totalSteps: 4),
            SizedBox(height: screenHeight * 0.05),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 4,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return BuildProfileScreen(
                        selectedImage: _selectedImage,
                        onPickPhoto: () => _showImageSourceActionSheet(context),
                      );
                    case 1:
                      return IdentifyYourselfScreen(
                        nameController: _nameController,
                        dayController: _dayController,
                        monthController: _monthController,
                        yearController: _yearController,
                        selectedGender: _selectedGender,
                        onGenderSelected: (gender) {
                          setState(() {
                            _selectedGender = gender;
                          });
                        },
                      );
                    case 2:
                      return AddRecoveryEmailScreen(
                        emailController: _emailController,
                      );
                    case 3:
                      return SecureAccountScreen(
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                      );
                    default:
                      return const SizedBox();
                  }
                },
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
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
          text: _currentStep == 3 ? AppTexts.done : AppTexts.continueText,
          type: ButtonType.primary,
          isFullWidth: true,
          backgroundColor: colorScheme.secondary,
          textColor: colorScheme.onPrimary,
          borderRadius: AppConstants.kRadiusM,
          fontSize: AppConstants.kFontSizeM,
          onPressed: _handleContinue,
        ),
      ),
    );
  }
}
