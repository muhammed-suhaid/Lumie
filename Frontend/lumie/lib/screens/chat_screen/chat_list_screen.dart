//************************* Imports *************************//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/screens/match_screen/widgets/user_tile.dart';
import 'package:lumie/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumie/utils/app_constants.dart';

//************************* Chats List Screen *************************//
class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final ChatService _chatService = ChatService();
  List<UserModel> chatUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatUsers();
  }

  //************************* _loadChatUsers method *************************//
  // Future<void> _loadChatUsers() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;

  //   final users = await _chatService.getChatUsers(currentUser.uid);
  //   setState(() {
  //     chatUsers = users;
  //     isLoading = false;
  //   });
  // }
  //************************* _loadChatUsers method *************************//
  Future<void> _loadChatUsers() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    setState(() {
      chatUsers = [
        UserModel(
          uid: "1",
          name: "Alice Johnson",
          birthday: "1998-05-21",
          gender: "Female",
          phone: "+911234567890",
          personality: "ENFP",
          profileImage: "https://randomuser.me/api/portraits/women/65.jpg",
          photos: [],
          video: "",
          email: '',
          createdAt: DateTime(DateTime.april),
          updatedAt: DateTime(DateTime.april),
          personalityUpdatedAt: DateTime(DateTime.april),
          preferencesUpdatedAt: DateTime(DateTime.april),
          onboardingComplete: true,
          personalityComplete: true,
          preferencesComplete: true,
          goalMain: '',
          goalSub: '',
          relationshipStatus: '',
          relationshipType: '',
          whoToMeet: '',
          interests: [],
        ),
        UserModel(
          uid: "2",
          name: "Michael Smith",
          birthday: "1995-11-10",
          gender: "Male",
          phone: "+919876543210",
          personality: "INTJ",
          profileImage: "https://randomuser.me/api/portraits/men/72.jpg",
          photos: [],
          video: "",
          email: '',
          createdAt: DateTime(DateTime.april),
          updatedAt: DateTime(DateTime.april),
          personalityUpdatedAt: DateTime(DateTime.april),
          preferencesUpdatedAt: DateTime(DateTime.april),
          onboardingComplete: true,
          personalityComplete: true,
          preferencesComplete: true,
          goalMain: '',
          goalSub: '',
          relationshipStatus: '',
          relationshipType: '',
          whoToMeet: '',
          interests: [],
        ),
        UserModel(
          uid: "3",
          name: "Sophia Williams",
          birthday: "2000-02-14",
          gender: "Female",
          phone: "+911112223334",
          personality: "INFJ",
          profileImage: "https://randomuser.me/api/portraits/women/44.jpg",
          photos: [],
          video: "",
          email: '',
          createdAt: DateTime(DateTime.april),
          updatedAt: DateTime(DateTime.april),
          personalityUpdatedAt: DateTime(DateTime.april),
          preferencesUpdatedAt: DateTime(DateTime.april),
          onboardingComplete: true,
          personalityComplete: true,
          preferencesComplete: true,
          goalMain: '',
          goalSub: '',
          relationshipStatus: '',
          relationshipType: '',
          whoToMeet: '',
          interests: [],
        ),
      ];
      isLoading = false;
    });
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //************************* Appbar *************************//
      appBar: AppBar(
        title: Text(
          "Chats",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.kFontSizeL,
          ),
        ),
      ),
      //************************* Body *************************//
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatUsers.isEmpty
          ? const Center(
              child: Text(
                "No chats yet 👋",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                final user = chatUsers[index];
                return UserTile(
                  user: user,
                  onTap: () {
                    //  TODO: Go to chat screen
                    debugPrint("Chat of ${user.name} pressed");
                  },
                );
              },
            ),
    );
  }
}
