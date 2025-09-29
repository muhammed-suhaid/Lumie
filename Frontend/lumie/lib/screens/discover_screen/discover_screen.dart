//************************* Imports *************************//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/screens/discover_screen/widgets/user_card.dart';
import 'package:lumie/services/user_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';

//************************* DiscoverScreen *************************//
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<UserModel> userList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatchingUsers();
  }

  //************************* Load Matching Users from Firestore *************************//
  Future<void> _loadMatchingUsers() async {
    final currentUser = await UserService.fetchCurrentUser();
    if (currentUser == null) return;
    final matches = await UserService.fetchMatchingUsers(
      currentUser.personality,
      currentUser.whoToMeet,
      DateTime.parse(_convertBirthdayToDate(currentUser.birthday)),
    );
    setState(() {
      userList = matches;
      isLoading = false;
    });
  }

  //************************* _convertBirthdayToDate method *************************//
  String _convertBirthdayToDate(String birthday) {
    final parts = birthday.split('/');
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userList.isEmpty) {
      return const Scaffold(body: Center(child: Text("No users found")));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 35,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            AppTexts.appName,
            style: GoogleFonts.dancingScript(
              fontSize: AppConstants.kFontSizeAppBar,
              color: colorScheme.secondary,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                debugPrint("Notification Button Pressed");
              },
              icon: Icon(Icons.notifications, size: 30),
            ),
          ),
        ],
      ),
      body: UserProfileCard(users: userList),
    );
  }
}
