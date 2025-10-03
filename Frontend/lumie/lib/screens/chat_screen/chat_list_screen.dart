//************************* Imports *************************//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/screens/chat_screen/chat_screen.dart';
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
  Future<void> _loadChatUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final users = await _chatService.getChatUsers(currentUser.uid);
    setState(() {
      chatUsers = users;
      isLoading = false;
    });
  }

  //************************* onTap Function *************************//
  Future<void> _onTap(BuildContext context, UserModel otherUser) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    final chatService = ChatService();
    final currentUserId = currentUser.uid;

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
                    _onTap(context, user);
                    debugPrint("Chat of ${user.name} pressed");
                  },
                );
              },
            ),
    );
  }
}
