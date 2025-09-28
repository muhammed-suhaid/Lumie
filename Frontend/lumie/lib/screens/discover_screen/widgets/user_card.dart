import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/utils/app_constants.dart';

/// Displays a user's profile in a card format
class UserProfileCard extends StatelessWidget {
  final UserModel user;

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // ================= PROFILE SCROLL CONTENT =================
            Padding(
              padding: const EdgeInsets.all(AppConstants.kPaddingL),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.photos.isNotEmpty)
                      _buildPhoto(context, user.photos[0]),
                    _buildBasicInfo(colorScheme),
                    _buildPersonality(colorScheme),

                    if (user.photos.length > 1)
                      _buildPhoto(context, user.photos[1]),
                    _buildPreferences(colorScheme),

                    if (user.photos.length > 2)
                      _buildPhoto(context, user.photos[2]),
                    if (user.photos.length > 3)
                      _buildPhoto(context, user.photos[3]),
                    _buildInterests(colorScheme),

                    const SizedBox(height: 200), // leave space for buttons
                  ],
                ),
              ),
            ),

            // ================= LIKE & DISLIKE BUTTONS =================
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(150),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ❌ Dislike Button
                      RawMaterialButton(
                        onPressed: () => debugPrint("❌ Disliked ${user.name}"),
                        constraints: const BoxConstraints(
                          minWidth: 56,
                          minHeight: 56,
                        ),
                        shape: const CircleBorder(),
                        elevation: 0,
                        fillColor: Colors.transparent,
                        child: const Icon(
                          Icons.close,
                          size: 32,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // ❤️ Like Button
                      RawMaterialButton(
                        onPressed: () => debugPrint("❤️ Liked ${user.name}"),
                        constraints: const BoxConstraints(
                          minWidth: 56,
                          minHeight: 56,
                        ),
                        shape: const CircleBorder(),
                        elevation: 0,
                        fillColor: Colors.transparent,
                        child: const Icon(
                          Icons.favorite,
                          size: 32,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //************************* Photo Widget *************************//
  Widget _buildPhoto(BuildContext context, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Center(child: Icon(Icons.broken_image, size: 60)),
          ),
        ),
      ),
    );
  }

  //************************* Basic Info Widget *************************//
  Widget _buildBasicInfo(ColorScheme colorScheme) {
    int age = 0;

    if (user.birthday.isNotEmpty) {
      try {
        final dobParts = user.birthday.split('/');
        final dob = DateTime(
          int.parse(dobParts[2]),
          int.parse(dobParts[1]),
          int.parse(dobParts[0]),
        );

        final today = DateTime.now();
        age = today.year - dob.year;
        if (today.month < dob.month ||
            (today.month == dob.month && today.day < dob.day)) {
          age--;
        }
      } catch (e) {
        debugPrint("Error calculating age: $e");
      }
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Text(
        "${user.name}, $age",
        style: GoogleFonts.poppins(
          fontSize: AppConstants.kFontSizeL,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
      ),
    );
  }

  //************************* Personality Widget *************************//
  Widget _buildPersonality(ColorScheme colorScheme) {
    if (user.personality.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingS),
      child: Text(
        "${user.gender} • ${user.personality}",
        style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
      ),
    );
  }

  //************************* Bio Widget *************************//
  // Widget _buildBio(ColorScheme colorScheme) {
  //   if (user.bio.isEmpty) return const SizedBox.shrink();
  //   return Padding(
  //     padding: const EdgeInsets.all(AppConstants.kPaddingS),
  //     child: Text(
  //       user.bio,
  //       style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
  //     ),
  //   );
  // }

  //************************* Preferences Widget *************************//
  Widget _buildPreferences(ColorScheme colorScheme) {
    if (user.preferences.isEmpty) return const SizedBox.shrink();

    List<Widget> preferenceWidgets = [];

    // Goal
    if (user.preferences.containsKey("goalMain")) {
      final goalMain = user.preferences["goalMain"] ?? "";
      final goalSub = user.preferences["goalSub"] ?? "";

      preferenceWidgets.add(
        Text(
          goalSub.isNotEmpty ? "$goalMain : $goalSub" : goalMain,
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    // Looking For (whoToMeet)
    if (user.preferences.containsKey("whoToMeet")) {
      preferenceWidgets.add(
        Text(
          "Looking For : ${user.preferences["whoToMeet"]}",
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    // Relationship Status
    if (user.preferences.containsKey("relationshipStatus")) {
      preferenceWidgets.add(
        Text(
          "Relationship Status : ${user.preferences["relationshipStatus"]}",
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    // Relationship Type
    if (user.preferences.containsKey("relationshipType")) {
      preferenceWidgets.add(
        Text(
          "Relationship Type : ${user.preferences["relationshipType"]}",
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Preferences",
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeL,
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: preferenceWidgets,
          ),
        ],
      ),
    );
  }

  // //************************* Desire Widget *************************//
  // Widget _buildDesire(ColorScheme colorScheme) {
  //   if (user.whoToMeet.isEmpty) return const SizedBox.shrink();
  //   return Padding(
  //     padding: const EdgeInsets.all(AppConstants.kPaddingS),
  //     child: Text(
  //       "Desire: ${user.whoToMeet}",
  //       style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
  //     ),
  //   );
  // }

  //************************* Interests Widget *************************//
  Widget _buildInterests(ColorScheme colorScheme) {
    if (user.preferences["interests"] == null ||
        (user.preferences["interests"] as List).isEmpty) {
      return const SizedBox.shrink();
    }

    final interests = user.preferences["interests"] as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Interests",
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeL,
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (var interest in interests)
                Chip(
                  label: Text(interest),
                  backgroundColor: colorScheme.surface,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
