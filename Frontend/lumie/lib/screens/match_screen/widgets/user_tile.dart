//*************************  UserTile Widget  *************************//
import 'package:flutter/material.dart';
import 'package:lumie/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final VoidCallback? onMessageTap;
  final bool showChatButton;
  final bool showPersonality;

  const UserTile({
    super.key,
    required this.user,
    this.onTap,
    this.onMessageTap,
    this.showChatButton = true,
    this.showPersonality = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  user.profileImage,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, size: 64, color: Colors.grey),
                ),
              ),

              const SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (showPersonality) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.personality,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),

              // Chat Button
              if (showChatButton)
                IconButton(
                  onPressed: onMessageTap,
                  icon: const Icon(Icons.chat_bubble_outline),
                  color: Colors.pinkAccent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
