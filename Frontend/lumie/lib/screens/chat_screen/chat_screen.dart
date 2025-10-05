//************************* Imports *************************//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/screens/match_screen/widgets/user_profile_screen.dart';
import 'package:lumie/screens/chat_screen/widgets/chat_input_field.dart';
import 'package:lumie/services/block_report_service.dart';
import 'package:lumie/utils/custom_snakbar.dart';

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

  final BlockReportService _blockReportService = BlockReportService();

  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _checkBlockedStatus();
  }

  //************************* Check if either user blocked *************************//
  Future<void> _checkBlockedStatus() async {
    bool blocked = await _blockReportService.isBlocked(
      widget.currentUserId,
      widget.otherUser.uid,
    );

    setState(() => _isBlocked = blocked);
  }

  //************************* Send Message method *************************//
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (_isBlocked) return; // restrict sending if blocked

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

  //************************* Block User *************************//
  void _blockUser() async {
    await _blockReportService.blockUser(
      widget.currentUserId,
      widget.otherUser.uid,
    );
    if (mounted) {
      CustomSnackbar.show(context, "User blocked", isError: false);
      setState(() => _isBlocked = true);
    }
  }

  //************************* Block User *************************//
  void _onBlockPressed() {
    _showConfirmationDialog(
      title: "Block User",
      content: "Are you sure you want to block this user?",
      onConfirm: _blockUser,
    );
  }

  //************************* Unblock User *************************//
  void _unblockUser() async {
    await _blockReportService.unblockUser(
      widget.currentUserId,
      widget.otherUser.uid,
    );
    if (mounted) {
      CustomSnackbar.show(context, "User unblocked", isError: false);
      setState(() => _isBlocked = false);
    }
  }

  //************************* Unblock User *************************//
  void _onUnblockPressed() {
    _showConfirmationDialog(
      title: "Unblock User",
      content: "Are you sure you want to unblock this user?",
      onConfirm: _unblockUser,
    );
  }

  //************************* Report User with Reason *************************//
  void _reportUserWithReason(String reason, String otherText) async {
    String finalReason = reason == "Other" ? otherText : reason;

    if (finalReason.isEmpty) {
      if (mounted) {
        CustomSnackbar.show(context, "Please provide a reason", isError: true);
      }
      return;
    }

    await _blockReportService.reportUser(
      widget.currentUserId,
      widget.otherUser.uid,
      finalReason,
    );

    if (mounted) {
      CustomSnackbar.show(context, "User reported", isError: false);
    }
  }

  //************************* Report User Trigger *************************//
  void _onReportPressed() {
    _showReportDialog();
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      //************************* Appbar *************************//
      appBar: AppBar(
        title: Text(widget.otherUser.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'view_profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(user: widget.otherUser),
                  ),
                );
              }
              if (value == 'block') _onBlockPressed();
              if (value == 'unblock') _onUnblockPressed();
              if (value == 'report') _onReportPressed();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view_profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text("View Profile"),
                  ],
                ),
              ),
              if (!_isBlocked)
                const PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      Icon(Icons.block, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text("Block"),
                    ],
                  ),
                ),
              if (_isBlocked)
                const PopupMenuItem(
                  value: 'unblock',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text("Unblock"),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Report"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
              enabled: !_isBlocked,
            ),
          ),
          if (_isBlocked)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "You can't send messages to this user.",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  //************************* Confirmation Dialog *************************//
  void _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  //************************* Report User *************************//
  void _showReportDialog() {
    final List<String> reasons = [
      "Inappropriate content",
      "Spam",
      "Fake profile",
      "Harassment",
      "Other",
    ];
    String selectedReason = reasons[0];
    TextEditingController otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Report User"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var reason in reasons)
                    RadioListTile<String>(
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() => selectedReason = value!);
                      },
                    ),
                  if (selectedReason == "Other")
                    TextField(
                      controller: otherReasonController,
                      decoration: const InputDecoration(
                        labelText: "Type reason",
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _reportUserWithReason(
                      selectedReason,
                      otherReasonController.text,
                    );
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
