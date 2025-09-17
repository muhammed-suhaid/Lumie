import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_button.dart';

class BuildProfileScreen extends StatefulWidget {
  const BuildProfileScreen({super.key});

  @override
  State<BuildProfileScreen> createState() => _BuildProfileScreenState();
}

class _BuildProfileScreenState extends State<BuildProfileScreen> {
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

  //************************* Navigate to Identify Yourself Screen *************************//
  void _goToNextPage() {
    debugPrint("Navigate to Identify Yourself Screen");
    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),

              //************************* Profile Placeholder / Image *************************//
              CircleAvatar(
                radius: 80,
                backgroundColor: colorScheme.secondary.withAlpha(30),
                backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                child: _selectedImage == null
                    ? Icon(Icons.person, size: 120, color: colorScheme.secondary)
                    : null,
              ),
              SizedBox(height: screenHeight * 0.05),

              //************************* Title *************************//
              Text(
                AppTexts.buildProfileTitle,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeXXXL,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: AppConstants.kPaddingS),

              //************************* Subtitle *************************//
              Text(
                AppTexts.buildProfileSubtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  color: colorScheme.onSurface.withAlpha(160),
                ),
              ),
              const Spacer(),

              //************************* Add / Change Photo Button *************************//
              CustomButton(
                text: _selectedImage == null ? AppTexts.addYourPhoto : AppTexts.changePhoto,
                type: ButtonType.primary,
                isFullWidth: true,
                backgroundColor: colorScheme.secondary,
                textColor: colorScheme.onPrimary,
                borderRadius: AppConstants.kRadiusM,
                fontSize: AppConstants.kFontSizeM,
                onPressed: () => _showImageSourceActionSheet(context),
              ),

              const SizedBox(height: AppConstants.kPaddingM),

              //************************* Continue Button (only if photo is selected) *************************//
              if (_selectedImage != null)
                CustomButton(
                  text: AppTexts.continueText,
                  type: ButtonType.secondary,
                  isFullWidth: true,
                  backgroundColor: colorScheme.secondary,
                  textColor: colorScheme.onPrimary,
                  borderRadius: AppConstants.kRadiusM,
                  fontSize: AppConstants.kFontSizeM,
                  onPressed: _goToNextPage,
                ),

              SizedBox(height: screenHeight * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
