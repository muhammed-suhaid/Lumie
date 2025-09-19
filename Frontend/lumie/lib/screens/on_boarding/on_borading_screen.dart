import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumie/screens/on_boarding/build_profile_screen.dart';
import 'package:lumie/screens/on_boarding/identify_yourself_screen.dart';
import 'package:lumie/screens/on_boarding/widgets/custom_step_indicator.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
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

  //************************* Pick photo from camera/gallery *************************//
  Future<void> _pickPhoto(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
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
  void _validateProfile() {
    if (_selectedImage == null) {
      // TODO:show custom snackbar
      debugPrint("Please Select an image");
    } else {
      debugPrint("Image Selected, Going to next page");
      _goToNextPage();
    }
  }

  //************************* _validateIdentifyYourself method *************************//
  void _validateIdentifyYourself() {
    // Gender check
    if (_selectedGender == null) {
      debugPrint("Please select a gender");
      // TODO:show custom snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a gender")));
      return;
    }

    // Birthday check
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day == null || month == null || year == null) {
      debugPrint("Birthday fields must be numbers");
      // TODO:show custom snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid birthday")),
      );
      return;
    }

    if (day < 1 || day > 31 || month < 1 || month > 12) {
      debugPrint("Invalid day or month");
      // TODO:show custom snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid day or month")));
      return;
    }

    final currentYear = DateTime.now().year;
    if (year < currentYear - 100 || year > currentYear) {
      debugPrint("Year not in valid range");
      // TODO:show custom snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid year")),
      );
      return;
    }

    // Optional: check if the date is actually valid (e.g., no Feb 30)
    try {
      final birthDate = DateTime(year, month, day);
      if (birthDate.day != day ||
          birthDate.month != month ||
          birthDate.year != year) {
        throw Exception();
      }
    } catch (_) {
      debugPrint("Invalid date");
      // TODO:show custom snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid date")),
      );
      return;
    }

    // Name check
    final name = _nameController.text.trim();
    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (name.isEmpty || name.length < 3 || !nameRegex.hasMatch(name)) {
      debugPrint("Please enter a valid name with at least 3 characters");
      // TODO:show custom snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid name")),
      );
      return;
    }

    debugPrint(
      "All fields valid: Gender=$_selectedGender, Name=$name, Birthday=$day/$month/$year",
    );
    _goToNextPage();
  }

  //************************* _handleContinue method *************************//
  void _handleContinue() {
    switch (_currentStep) {
      case 0:
        _validateProfile();
        break;
      case 1:
        _validateIdentifyYourself();
        break;
      default:
        _goToNextPage();
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
              child: PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  BuildProfileScreen(
                    selectedImage: _selectedImage,
                    onPickPhoto: () => _showImageSourceActionSheet(context),
                  ),
                  IdentifyYourselfScreen(
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
                  ),
                  SizedBox(
                    child: Center(child: Text("Add Recovery Email Screen")),
                  ),
                  SizedBox(
                    child: Center(child: Text("Secure Your Account Screen")),
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
          text: AppTexts.continueText,
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
