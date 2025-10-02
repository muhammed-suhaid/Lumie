//************************* Imports *************************//
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/match_screen/tabs/liked_tab.dart';
import 'package:lumie/screens/match_screen/tabs/likes_tab.dart';
import 'package:lumie/screens/match_screen/tabs/matches_tab.dart';
import 'package:lumie/services/likes_service.dart';
import 'package:lumie/services/matches_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';

//************************* MatchesScreen Widget *************************//
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _likesService = LikesService();
  final _matchesService = MatchesService();

  String currentUserId = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Likes"),
            Tab(text: "Liked"),
            Tab(text: "Matches"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LikesTab(likesService: _likesService, userId: currentUserId),
          LikedTab(likesService: _likesService, userId: currentUserId),
          MatchesTab(matchesService: _matchesService, userId: currentUserId),
        ],
      ),
    );
  }
}
