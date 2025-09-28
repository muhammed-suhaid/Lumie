import 'package:flutter/material.dart';
import 'package:lumie/screens/discover_screen/widgets/user_card.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data (replace with Firestore data)
    final user = {
      "name": "Sophia",
      "age": 23,
      "location": "Kochi, India",
      "bio": "Dreamer 🌸 | Coffee lover ☕ | Traveler ✈️",
      "preferences": ["Music", "Books", "Hiking", "Dogs"],
      "personality": "INFJ - The Advocate",
      "photos": [
        "https://picsum.photos/500/700?1",
        "https://picsum.photos/500/700?2",
        "https://picsum.photos/500/700?3",
      ],
    };

    return SafeArea(child: UserProfileCard(user: user));
  }
}
