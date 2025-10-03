import 'package:flutter/material.dart';
import 'package:lumie/screens/chat_screen/chat_screen.dart';
import 'package:lumie/screens/match_screen/widgets/user_profile_screen.dart';
import 'package:lumie/screens/match_screen/widgets/user_tile.dart';
import 'package:lumie/services/chat_service.dart';
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

  //************************* onMessageTap Function *************************//
  Future<void> _onMessageTap(
    BuildContext context,
    String currentUserId,
    UserModel otherUser,
  ) async {
    final chatService = ChatService();

    // Create or get chatId from service
    final chatId = await chatService.createOrGetChat(
      currentUserId,
      otherUser.uid,
    );

    // Navigate to ChatScreen
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: chatId,
            currentUserId: currentUserId,
            otherUser: otherUser,
          ),
        ),
      );
    }
  }

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
                _onMessageTap(context, userId, user);
              },
            );
          },
        );
      },
    );
  }
}
