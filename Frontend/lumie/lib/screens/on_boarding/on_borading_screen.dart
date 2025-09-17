import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumie/screens/on_boarding/build_profile_screen.dart';
import 'package:lumie/screens/on_boarding/widgets/custom_step_indicator.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';

//************************* Main Onboarding Screen *************************//

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            // Custom Step Indicator Widget
            CustomStepIndicator(currentStep: _currentStep, totalSteps: 4),
            SizedBox(height: screenHeight * 0.03),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  BuildProfileScreen(
                    selectedImage: _selectedImage,
                    onPickPhoto: () {
                      _showImageSourceActionSheet(context);
                    },
                  ),
                  SizedBox(
                    child: Center(child: Text("Identify Yourself Screen")),
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
    );
  }
}
