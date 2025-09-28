import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_constants.dart';

class UserProfileCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final photos = (user["photos"] as List<String>?) ?? [];
    //************************* Body *************************//
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // ===== Scrollable content =====
            Padding(
              padding: const EdgeInsets.all(AppConstants.kPaddingL),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (photos.isNotEmpty) _buildPhoto(context, photos[0]),
                    _buildBasicInfo(colorScheme),
                    _buildPersonality(colorScheme),
                    _buildBio(colorScheme),

                    if (photos.length > 1) _buildPhoto(context, photos[1]),
                    _buildPreferences(colorScheme),

                    if (photos.length > 2) _buildPhoto(context, photos[2]),
                    _buildDesire(colorScheme),

                    if (photos.length > 3) _buildPhoto(context, photos[3]),
                    _buildInterests(colorScheme),

                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),

            //************************* Floating action buttons with background *************************//
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
                      RawMaterialButton(
                        onPressed: () => debugPrint("❌ Disliked"),
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
                      RawMaterialButton(
                        onPressed: () => debugPrint("❤️ Liked"),
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

  //************************* _buildPhoto method *************************//
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

  //************************* _buildBasicInfo method *************************//
  Widget _buildBasicInfo(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Text(
        "${user['name'] ?? ''}, ${user['age'] ?? ''} • ${user['gender'] ?? ''}",
        style: GoogleFonts.poppins(
          fontSize: AppConstants.kFontSizeL,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
      ),
    );
  }

  //************************* _buildPersonality method *************************//
  Widget _buildPersonality(ColorScheme colorScheme) {
    if ((user["personality"] ?? "").isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Text(
        "Personality: ${user["personality"]}",
        style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
      ),
    );
  }

  //************************* _buildBio method *************************//
  Widget _buildBio(ColorScheme colorScheme) {
    if ((user["bio"] ?? "").isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Text(
        user["bio"],
        style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
      ),
    );
  }

  //************************* _buildPreferences method *************************//
  Widget _buildPreferences(ColorScheme colorScheme) {
    final prefs = (user["preferences"] as List<String>?) ?? [];
    if (prefs.isEmpty) return const SizedBox.shrink();

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
          Wrap(
            spacing: 8,
            children: prefs
                .map(
                  (pref) => Chip(
                    label: Text(pref),
                    backgroundColor: colorScheme.surface,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  //************************* _buildDesire method *************************//
  Widget _buildDesire(ColorScheme colorScheme) {
    if ((user["desire"] ?? "").isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Text(
        "Desire: ${user["desire"]}",
        style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
      ),
    );
  }

  //************************* _buildInterests method *************************//
  Widget _buildInterests(ColorScheme colorScheme) {
    final interests = (user["interests"] as List<String>?) ?? [];
    if (interests.isEmpty) return const SizedBox.shrink();

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
            children: interests
                .map(
                  (interest) => Chip(
                    label: Text(interest),
                    backgroundColor: colorScheme.surface,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
