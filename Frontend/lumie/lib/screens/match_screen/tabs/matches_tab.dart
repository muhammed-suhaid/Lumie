import 'package:flutter/material.dart';
import 'package:lumie/screens/match_screen/widgets/user_profile_screen.dart';
import 'package:lumie/screens/match_screen/widgets/user_tile.dart';
import 'package:lumie/services/matches_service.dart';
import 'package:lumie/models/user_model.dart';

class MatchesTab extends StatelessWidget {
  final MatchesService matchesService;
  final String userId;

  const MatchesTab({
    super.key,
    required this.matchesService,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: matchesService.getMatchedUsersFull(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No matches yet."));
        }

        final matchedUsers = snapshot.data!;

        return ListView.builder(
          itemCount: matchedUsers.length,
          itemBuilder: (context, index) {
            final user = matchedUsers[index];
            return UserTile(
              user: user,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(user: user, showActionButtons: false),
                  ),
                );
              },
              showChatButton: true,
              onMessageTap: () {
                debugPrint("Chat Button Pressed");
              },
            );
          },
        );
      },
    );
  }
}
