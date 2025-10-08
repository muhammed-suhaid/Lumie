//************************* Imports *************************//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/services/likes_service.dart';
import 'package:lumie/services/matches_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/custom_snakbar.dart';

//************************* UserProfileCard Widget *************************//
class UserProfileCard extends StatefulWidget {
  final List<UserModel> users;

  const UserProfileCard({super.key, required this.users});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  int currentIndex = 0;
  int _mainPhotoIndex = 0;

  final LikesService _likesService = LikesService();
  final MatchesService _matchesService = MatchesService();

  //************************* Show Next User *************************//
  void _showNextUser() {
    setState(() {
      if (currentIndex < widget.users.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      _mainPhotoIndex = 0;
    });
  }

  //************************* Get Current User *************************//
  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return "";
  }

  //************************* Handle Like Action *************************//
  Future<void> _handleLike(String likedUserId, String userName) async {
    try {
      final currentUserId = getCurrentUserId();

      // Add like
      await _likesService.addLike(currentUserId, likedUserId);

      // Check if liked user liked me → match
      final isReciprocal = await _likesService.isUserLiked(
        likedUserId,
        currentUserId,
      );

      if (isReciprocal) {
        debugPrint("🎉 You matched with $userName!");
        if (mounted) {
          CustomSnackbar.show(
            context,
            "You matched with $userName",
            isError: false,
          );
        }
        await _matchesService.checkAndCreateMatch(currentUserId, likedUserId);
      }

      // Remove liked user from list and refresh
      setState(() {
        widget.users.removeAt(currentIndex);
        if (currentIndex >= widget.users.length && widget.users.isNotEmpty) {
          currentIndex = widget.users.length - 1;
        }
      });

      // Move to next profile
      _showNextUser();
    } catch (e) {
      debugPrint("Error liking user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = widget.users[currentIndex];

    return SafeArea(
      child: Stack(
        children: [
          //************************* PROFILE SCROLL CONTENT *************************//
          Padding(
            padding: const EdgeInsets.all(AppConstants.kPaddingL),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header photo with overlayed name and quick facts
                  if (user.photos.isNotEmpty)
                    _buildHeaderCard(context, colorScheme, user),
                  const SizedBox(height: 12),
                  // Extra photos strip
                  if (user.photos.length > 1) _buildPhotoStrip(context, user),
                  const SizedBox(height: 12),
                  // Details
                  _buildBasicInfo(colorScheme, user),
                  _buildPersonality(colorScheme, user),
                  _buildPreferences(colorScheme, user),
                  _buildInterests(colorScheme, user),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),

          //************************* LIKE & DISLIKE BUTTONS *************************//
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(217),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(31),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //❌ Dislike Button
                    _CircleActionButton(
                      icon: Icons.close,
                      color: Colors.redAccent,
                      onTap: () {
                        debugPrint("❌ Disliked ${user.name}");
                        _showNextUser();
                      },
                    ),
                    const SizedBox(width: 18),
                    //❤️ Like Button
                    _CircleActionButton(
                      icon: Icons.favorite,
                      color: Colors.pinkAccent,
                      onTap: () {
                        debugPrint("❤️ Liked ${user.name}");
                        CustomSnackbar.show(
                          context,
                          "Liked ${user.name}",
                          isError: false,
                        );
                        _handleLike(user.uid, user.name);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //************************* Header with main image and gradient overlay text *************************//
  Widget _buildHeaderCard(
    BuildContext context,
    ColorScheme colorScheme,
    UserModel user,
  ) {
    final cover = user.photos[_mainPhotoIndex.clamp(0, user.photos.length - 1)];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                cover,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 60)),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(13),
                      Colors.black.withAlpha(89),
                      Colors.black.withAlpha(179),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameAndAge(user, colorScheme),
                  const SizedBox(height: 4),
                  if (user.personality.isNotEmpty)
                    Text(
                      "${user.gender} • ${user.personality}",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withAlpha(242),
                        fontSize: AppConstants.kFontSizeM,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndAge(UserModel user, ColorScheme colorScheme) {
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
      } catch (_) {}
    }
    return Text(
      "${user.name}, $age",
      style: GoogleFonts.poppins(
        fontSize: AppConstants.kFontSizeXXL,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.1,
      ),
    );
  }

  // Thumbnails that switch the main image
  Widget _buildPhotoStrip(BuildContext context, UserModel user) {
    final thumbs = user.photos;
    if (thumbs.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) {
          final url = thumbs[i];
          final isSelected = i == _mainPhotoIndex;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _mainPhotoIndex = i;
              });
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: thumbs.length,
      ),
    );
  }

  //************************* Basic Info Widget *************************//
  Widget _buildBasicInfo(ColorScheme colorScheme, UserModel user) {
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
          fontSize: AppConstants.kFontSizeXXL,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
      ),
    );
  }

  //************************* Personality Widget *************************//
  Widget _buildPersonality(ColorScheme colorScheme, UserModel user) {
    if (user.personality.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Text(
        "${user.gender} • ${user.personality}",
        style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
      ),
    );
  }

  //************************* Preferences Widget *************************//
  Widget _buildPreferences(ColorScheme colorScheme, UserModel user) {
    List<Widget> preferenceWidgets = [];

    if (user.goalMain.isNotEmpty) {
      final text = user.goalSub.isNotEmpty
          ? "${user.goalMain} : ${user.goalSub}"
          : user.goalMain;
      preferenceWidgets.add(
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    if (user.whoToMeet.isNotEmpty) {
      preferenceWidgets.add(
        Text(
          "Looking For : ${user.whoToMeet}",
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    if (user.relationshipStatus.isNotEmpty) {
      preferenceWidgets.add(
        Text(
          "Relationship Status : ${user.relationshipStatus}",
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    if (user.relationshipType.isNotEmpty) {
      preferenceWidgets.add(
        Text(
          "Relationship Type : ${user.relationshipType}",
          style: GoogleFonts.poppins(fontSize: AppConstants.kFontSizeM),
        ),
      );
    }

    if (preferenceWidgets.isEmpty) return const SizedBox.shrink();

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

  //************************* Interests Widget *************************//
  Widget _buildInterests(ColorScheme colorScheme, UserModel user) {
    if (user.interests.isEmpty) return const SizedBox.shrink();

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
            runSpacing: 8,
            children: [
              for (var interest in user.interests)
                Chip(
                  label: Text(interest),
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  backgroundColor: colorScheme.surface,
                  side: BorderSide(color: colorScheme.secondary.withAlpha(100)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

//************************* Small round action button *************************//
class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
