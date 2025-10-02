import 'package:flutter/material.dart';
import 'package:lumie/screens/match_screen/widgets/user_tile.dart';
import 'package:lumie/services/likes_service.dart';
import 'package:lumie/models/user_model.dart';

class LikesTab extends StatelessWidget {
  final LikesService likesService;
  final String userId;

  const LikesTab({super.key, required this.likesService, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: likesService.getLikedUsersFull(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No likes yet."));
        }

        final likedUsers = snapshot.data!;

        return ListView.builder(
          itemCount: likedUsers.length,
          itemBuilder: (context, index) {
            final user = likedUsers[index];
            return UserTile(
              user: user,
              onTap: () {
                // TODO: navigate to user profile screen
              },
              showChatButton: false,
            );
          },
        );
      },
    );
  }
}
