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
              if (user.photos.isNotEmpty) _buildPhoto(context, user.photos[0]),
              _buildBasicInfo(colorScheme, user),
              _buildPersonality(colorScheme, user),
              for (int i = 1; i < user.photos.length; i++)
                _buildPhoto(context, user.photos[i]),
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
