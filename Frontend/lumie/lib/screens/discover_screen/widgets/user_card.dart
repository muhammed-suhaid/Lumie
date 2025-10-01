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
                  if (user.photos.isNotEmpty)
                    _buildPhoto(context, user.photos[0]),
                  _buildBasicInfo(colorScheme, user),
                  _buildPersonality(colorScheme, user),
                  if (user.photos.length > 1)
                    _buildPhoto(context, user.photos[1]),
                  _buildPreferences(colorScheme, user),
                  if (user.photos.length > 2)
                    _buildPhoto(context, user.photos[2]),
                  if (user.photos.length > 3)
                    _buildPhoto(context, user.photos[3]),
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
                    //❌ Dislike Button
                    RawMaterialButton(
                      onPressed: () {
                        debugPrint("❌ Disliked ${user.name}");
                        _showNextUser();
                      },
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

                    //❤️ Like Button
                    RawMaterialButton(
                      onPressed: () {
                        debugPrint("❤️ Liked ${user.name}");
                        CustomSnackbar.show(
                          context,
                          "Liked ${user.name}",
                          isError: false,
                        );
                        _handleLike(user.uid, user.name);
                      },
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
            children: [
              for (var interest in user.interests)
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
