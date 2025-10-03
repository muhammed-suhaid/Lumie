import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/screens/chat_screen/widgets/chat_input_field.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final UserModel otherUser;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //************************* Send Message method *************************//
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();

    await _firestore
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .add({
          "senderId": widget.currentUserId,
          "text": message,
          "timestamp": FieldValue.serverTimestamp(),
        });

    // update last message
    await _firestore.collection("chats").doc(widget.chatId).update({
      "lastMessage": message,
      "updatedAt": FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      //************************* Appbar *************************//
      appBar: AppBar(title: Text(widget.otherUser.name)),
      body: Column(
        children: [
          //************************* Chats *************************//
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                //************************* Chat Chips *************************//
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data["senderId"] == widget.currentUserId;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? colorScheme.secondary
                              : colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data["text"] ?? "",
                          style: TextStyle(
                            color: isMe
                                ? colorScheme.onSecondary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          //************************* Text field *************************//
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChatInputField(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
