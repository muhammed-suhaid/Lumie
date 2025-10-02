//************************* Imports *************************//
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/services/profile_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();

  UserModel? currentUser;
  bool isEditing = false;

  File? newProfileImage;
  List<File> newGalleryPhotos = [];

  String? goalMain;
  String? goalSub;
  String? whoToMeet;
  String? status;
  String? type;
  List<String> interests = [];

  final List<String> goalMainOptions = ["Dating", "Friends"];
  final List<String> goalSubOptions = [
    "Long-Term",
    "Short-Term",
    "Open",
    "Short-Term Open to Long",
  ];
  final List<String> whoToMeetOptions = ["Men", "Women", "Everyone"];
  final List<String> statusOptions = [
    "Single",
    "Divorced",
    "Separated",
    "Widowed",
    "It's complicated",
  ];
  final List<String> typeOptions = [
    "Monogamous",
    "Open",
    "Polyamorous",
    "Casual",
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  //************************* Loading profile method *************************//
  Future<void> _loadProfile() async {
    final user = await _profileService.getUserProfile();
    if (user != null) {
      setState(() {
        currentUser = user;

        goalMain = goalMainOptions.contains(user.goalMain)
            ? user.goalMain
            : null;
        goalSub = goalSubOptions.contains(user.goalSub) ? user.goalSub : null;
        whoToMeet = whoToMeetOptions.contains(user.whoToMeet)
            ? user.whoToMeet
            : null;
        status = statusOptions.contains(user.relationshipStatus)
            ? user.relationshipStatus
            : null;
        type = typeOptions.contains(user.relationshipType)
            ? user.relationshipType
            : null;
        interests = List<String>.from(user.interests);
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        newProfileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickGalleryPhotos() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 50);

    setState(() {
      newGalleryPhotos = pickedFiles.map((x) => File(x.path)).toList();
    });
  }

  //************************* Save profile Method *************************//
  Future<void> _saveProfile() async {
    await _profileService.updateUserProfile(
      goalMain: goalMain,
      goalSub: goalSub,
      whoToMeet: whoToMeet,
      relationshipStatus: status,
      relationshipType: type,
      interests: interests,
    );

    if (newProfileImage != null && mounted) {
      await _profileService.updateProfileImage(context, newProfileImage!);
    }
    if (newGalleryPhotos.isNotEmpty && mounted) {
      await _profileService.updateGalleryPhotos(context, newGalleryPhotos);
    }

    if (mounted) {
      CustomSnackbar.show(context, "Profile Updated!", isError: false);
    }
    setState(() => isEditing = false);
    _loadProfile();
  }

  //************************* Custom TextField *************************//
  Widget _field({
    required String label,
    required TextEditingController controller,
    bool enabled = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: GoogleFonts.poppins(
          fontSize: AppConstants.kFontSizeM,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: AppConstants.kFontSizeM,
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
      ),
    );
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      //************************* Appbar *************************//
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.kFontSizeL,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      //************************* Body *************************//
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.kPaddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  //************************* Profile Image *************************//
                  Center(
                    child: GestureDetector(
                      onTap: isEditing ? _pickProfileImage : null,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: newProfileImage != null
                            ? FileImage(newProfileImage!)
                            : (currentUser!.profileImage.isNotEmpty
                                  ? NetworkImage(currentUser!.profileImage)
                                  : const AssetImage(
                                          "assets/default_profile.png",
                                        )
                                        as ImageProvider),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  //************************* Personal Info Section *************************//
                  Text(
                    "Personal Info",
                    style: GoogleFonts.poppins(
                      fontSize: AppConstants.kFontSizeL,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.kPaddingM),
                  // Name
                  _field(
                    label: "Name",
                    controller: TextEditingController(
                      text: currentUser?.name ?? "",
                    ),
                    enabled: false,
                  ),
                  // Birthday
                  _field(
                    label: "Birthday",
                    controller: TextEditingController(
                      text: currentUser?.birthday ?? "",
                    ),
                    enabled: false,
                  ),
                  // Gender
                  _field(
                    label: "Gender",
                    controller: TextEditingController(
                      text: currentUser?.gender ?? "",
                    ),
                    enabled: false,
                  ),
                  // Phone Number
                  _field(
                    label: "Phone",
                    controller: TextEditingController(
                      text: currentUser?.phone ?? "",
                    ),
                    enabled: false,
                  ),
                  // Personality
                  _field(
                    label: "Personality",
                    controller: TextEditingController(
                      text: currentUser?.personality ?? "",
                    ),
                    enabled: false,
                  ),

                  const SizedBox(height: AppConstants.kPaddingXXL),

                  //************************* Gallery Images *************************//
                  Text(
                    "Gallery Photos",
                    style: GoogleFonts.poppins(
                      fontSize: AppConstants.kFontSizeL,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.kPaddingM),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          (newGalleryPhotos.isNotEmpty
                              ? newGalleryPhotos.length
                              : currentUser!.photos.length) +
                          1,
                      itemBuilder: (context, index) {
                        if (index ==
                            (newGalleryPhotos.isNotEmpty
                                ? newGalleryPhotos.length
                                : currentUser!.photos.length)) {
                          return GestureDetector(
                            onTap: isEditing ? _pickGalleryPhotos : null,
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(
                                  AppConstants.kRadiusM,
                                ),
                              ),
                              child: const Icon(Icons.add_a_photo, size: 40),
                            ),
                          );
                        } else {
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppConstants.kRadiusM,
                              ),
                              image: DecorationImage(
                                image: newGalleryPhotos.isNotEmpty
                                    ? FileImage(newGalleryPhotos[index])
                                    : NetworkImage(currentUser!.photos[index])
                                          as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppConstants.kPaddingXXL),

                  //************************* Preferences Section *************************//
                  Text(
                    "Preferences",
                    style: GoogleFonts.poppins(
                      fontSize: AppConstants.kFontSizeL,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.kPaddingM),

                  //************************* Looking For Dropdown *************************//
                  DropdownButtonFormField<String>(
                    value: goalMain,
                    items: goalMainOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: isEditing
                        ? (val) {
                            setState(() {
                              goalMain = val;
                              if (goalMain == "Friends") {
                                goalSub = null;
                              }
                            });
                          }
                        : null,
                    decoration: const InputDecoration(labelText: "Looking For"),
                  ),

                  const SizedBox(height: AppConstants.kPaddingM),

                  //************************* SubGoal Dropdown *************************//
                  DropdownButtonFormField<String>(
                    value: goalMain == "Friends" ? null : goalSub,
                    items: goalSubOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: isEditing && goalMain != "Friends"
                        ? (val) => setState(() => goalSub = val)
                        : null,
                    decoration: InputDecoration(
                      labelText: "Sub Goal",
                      enabled: goalMain != "Friends",
                    ),
                  ),

                  const SizedBox(height: AppConstants.kPaddingM),

                  //************************* Who To Meet Dropdown *************************//
                  DropdownButtonFormField<String>(
                    value: whoToMeet,
                    items: whoToMeetOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: isEditing
                        ? (val) => setState(() => whoToMeet = val)
                        : null,
                    decoration: const InputDecoration(labelText: "Who to meet"),
                  ),

                  const SizedBox(height: AppConstants.kPaddingM),

                  //************************* relationShip Status Dropdown *************************//
                  DropdownButtonFormField<String>(
                    value: status,
                    items: statusOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: isEditing
                        ? (val) => setState(() => status = val)
                        : null,
                    decoration: const InputDecoration(
                      labelText: "Relationship Status",
                    ),
                  ),

                  const SizedBox(height: AppConstants.kPaddingM),

                  //************************* relationShip Type Dropdown *************************//
                  DropdownButtonFormField<String>(
                    value: type,
                    items: typeOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: isEditing
                        ? (val) => setState(() => type = val)
                        : null,
                    decoration: const InputDecoration(
                      labelText: "Relationship Type",
                    ),
                  ),

                  const SizedBox(height: AppConstants.kPaddingXXL),

                  //************************* Interest Section *************************//
                  Text(
                    "Interests",
                    style: GoogleFonts.poppins(
                      fontSize: AppConstants.kFontSizeL,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                  //************************* Chips *************************//
                  Wrap(
                    spacing: 6,
                    children: interests
                        .map(
                          (i) => Chip(
                            label: Text(i),
                            onDeleted: isEditing
                                ? () => setState(() => interests.remove(i))
                                : null,
                          ),
                        )
                        .toList(),
                  ),
                  //************************* Textfield for add interest *************************//
                  if (isEditing)
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Add Interest",
                      ),
                      onSubmitted: (val) {
                        if (val.isNotEmpty) setState(() => interests.add(val));
                      },
                    ),

                  const SizedBox(height: 30),

                  //************************* Custom button *************************//
                  if (isEditing)
                    CustomButton(
                      text: "Save Changes",
                      type: ButtonType.secondary,
                      isFullWidth: true,
                      onPressed: _saveProfile,
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}
