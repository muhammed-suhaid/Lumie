//************************* UserProfileScreen *************************//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/services/likes_service.dart';
import 'package:lumie/services/matches_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/custom_snakbar.dart';

class UserProfileScreen extends StatefulWidget {
  final UserModel user;
  final bool showActionButtons;

  const UserProfileScreen({
    super.key,
    required this.user,
    this.showActionButtons = true,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final LikesService _likesService = LikesService();
  final MatchesService _matchesService = MatchesService();
  bool isMatched = false;
  int _mainPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkIfMatched();
  }

  Future<void> _checkIfMatched() async {
    final currentUserId = getCurrentUserId();
    final matched = await MatchesService().isMatched(
      currentUserId,
      widget.user.uid,
    );
    setState(() {
      isMatched = matched;
    });
  }

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? "";
  }

  Future<void> _handleLike(String likedUserId, String userName) async {
    try {
      final currentUserId = getCurrentUserId();

      await _likesService.addLike(currentUserId, likedUserId);

      final isReciprocal = await _likesService.isUserLiked(
        likedUserId,
        currentUserId,
      );

      if (isReciprocal && mounted) {
        CustomSnackbar.show(
          context,
          "You matched with $userName",
          isError: false,
        );
        await _matchesService.checkAndCreateMatch(currentUserId, likedUserId);
      }
    } catch (e) {
      debugPrint("Error liking user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.kPaddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.photos.isNotEmpty)
                _buildHeaderCard(context, colorScheme, user),
              const SizedBox(height: 12),
              if (user.photos.length > 1) _buildPhotoStrip(context, user),
              const SizedBox(height: 12),
              _buildBasicInfo(colorScheme, user),
              _buildPersonality(colorScheme, user),
              _buildPreferences(colorScheme, user),
              _buildInterests(colorScheme, user),

              const SizedBox(height: 20),
              if (widget.showActionButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text("Dislike"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withAlpha(200),
                      ),
                      onPressed: isMatched
                          ? null
                          : () => Navigator.pop(context),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.favorite),
                      label: const Text("Like"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.withAlpha(200),
                      ),
                      onPressed: isMatched
                          ? null
                          : () async {
                              await _handleLike(
                                widget.user.uid,
                                widget.user.name,
                              );
                              if (context.mounted) Navigator.pop(context);
                            },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Header with main image and gradient overlay text
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
      } catch (_) {}
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

  Widget _buildPreferences(ColorScheme colorScheme, UserModel user) {
    List<Widget> preferenceWidgets = [];

    if (user.goalMain.isNotEmpty) {
      final text = user.goalSub.isNotEmpty
          ? "${user.goalMain} : ${user.goalSub}"
          : user.goalMain;
      preferenceWidgets.add(Text(text, style: const TextStyle(fontSize: 16)));
    }

    if (user.whoToMeet.isNotEmpty) {
      preferenceWidgets.add(Text("Looking For: ${user.whoToMeet}"));
    }

    if (user.relationshipStatus.isNotEmpty) {
      preferenceWidgets.add(
        Text("Relationship Status: ${user.relationshipStatus}"),
      );
    }

    if (user.relationshipType.isNotEmpty) {
      preferenceWidgets.add(
        Text("Relationship Type: ${user.relationshipType}"),
      );
    }

    if (preferenceWidgets.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Preferences",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...preferenceWidgets,
        ],
      ),
    );
  }

  Widget _buildInterests(ColorScheme colorScheme, UserModel user) {
    if (user.interests.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppConstants.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Interests",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (var interest in user.interests) Chip(label: Text(interest)),
            ],
          ),
        ],
      ),
    );
  }
}
