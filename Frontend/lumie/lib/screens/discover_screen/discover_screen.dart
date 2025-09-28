import 'package:flutter/material.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/screens/discover_screen/widgets/user_card.dart';
import 'package:lumie/services/user_service.dart';

/// Screen to display the current user's profile card
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser(); // Load user data when screen initializes
  }

  /// Fetches user data from Firestore using UserService
  Future<void> _loadUser() async {
    final fetchedUser = await UserService.fetchCurrentUser();
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No user data found")));
    }

    return SafeArea(
      child: UserProfileCard(user: user!),
    );
  }
}
