//************************* Imports *************************//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumie/models/user_model.dart';
import 'package:lumie/screens/match_screen/widgets/user_profile_screen.dart';
import 'package:lumie/screens/chat_screen/widgets/chat_input_field.dart';
import 'package:lumie/services/block_report_service.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/services/voice_message_service.dart';
import 'package:lumie/screens/chat_screen/widgets/audio_message_bubble.dart';
import 'package:lumie/services/encryption_service.dart';

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
  final VoiceMessageService _voiceService = VoiceMessageService();
  final EncryptionService _encryptionService = EncryptionService();

  bool _isBlocked = false;
  bool _isBlockedByMe = false;
  bool _isBlockedByOther = false;
  String? _chatSaltB64;

  @override
  void initState() {
    super.initState();
    _checkBlockedStatus();
    _initEncryptionSalt();
  }

  //************************* Check if either user blocked *************************//
  void _checkBlockedStatus() async {
    final blockStatus = await _blockReportService.isBlocked(
      widget.currentUserId,
      widget.otherUser.uid,
    );

    setState(() {
      _isBlocked = blockStatus["isBlocked"]!;
      _isBlockedByMe = blockStatus["isBlockedByMe"]!;
      _isBlockedByOther = blockStatus["isBlockedByOther"]!;
    });
  }

  //************************* Init per-chat encryption salt *************************//
  Future<void> _initEncryptionSalt() async {
    try {
      final salt = await _encryptionService.ensureChatSalt(widget.chatId);
      if (mounted) {
        setState(() {
          _chatSaltB64 = salt;
        });
      }
    } catch (e) {
      // Even if salt init fails, allow UI; messages will be plain
      debugPrint('Salt init failed: $e');
    }
  }

  //************************* Send Message method *************************//
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (_isBlocked) return; // restrict sending if blocked

    final message = _messageController.text.trim();

    Map<String, dynamic> payload;
    try {
      // If we have a salt, encrypt; else store plaintext as fallback
      String salt = _chatSaltB64 ??
          await _encryptionService.ensureChatSalt(widget.chatId);
      _chatSaltB64 = salt;

      final enc = await _encryptionService.encryptText(
        chatId: widget.chatId,
        currentUserId: widget.currentUserId,
        otherUserId: widget.otherUser.uid,
        plaintext: message,
        saltB64: salt,
      );
      payload = {
        "senderId": widget.currentUserId,
        "cipherText": enc['cipherText'],
        "nonce": enc['nonce'],
        "mac": enc['mac'],
        "enc": true,
        "type": 'text',
        "timestamp": FieldValue.serverTimestamp(),
      };
    } catch (e) {
      // On any failure, fallback to plaintext to avoid message loss
      payload = {
        "senderId": widget.currentUserId,
        "text": message,
        "type": 'text',
        "timestamp": FieldValue.serverTimestamp(),
      };
    }

    await _firestore
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .add(payload);

    // update last message without revealing content
    await _firestore.collection("chats").doc(widget.chatId).update({
      "lastMessage": "New message",
      "updatedAt": FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  //************************* Voice Recording Handlers *************************//
  Future<void> _startRecording() async {
    if (_isBlocked || _isBlockedByOther || _isBlockedByMe) return;
    try {
      await _voiceService.startRecording();
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(context, e.toString(), isError: true);
      }
    }
  }

  Future<void> _stopAndSendRecording() async {
    try {
      await _voiceService.stopRecording();
      if (mounted) {
        await _voiceService.sendVoiceMessage(
          context: context,
          chatId: widget.chatId,
          senderId: widget.currentUserId,
          receiverId: widget.otherUser.uid,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(context, e.toString(), isError: true);
      }
    }
  }

  Future<void> _cancelRecording() async {
    await _voiceService.cancelRecording();
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
              if (!_isBlockedByMe && !_isBlockedByOther)
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
              if (_isBlockedByMe)
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
                    final type = data["type"] ?? 'text';
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
                        child: type == 'audio'
                            ? AudioMessageBubble(
                                audioUrl: data['audioUrl'] ?? '',
                                isMe: isMe,
                                durationMs: data['audioDurationMs'],
                              )
                            : FutureBuilder<String>(
                                future: _resolveMessageText(data),
                                builder: (context, snap) {
                                  final displayText = snap.data ?? '';
                                  return Text(
                                    displayText,
                                    style: TextStyle(
                                      color: isMe
                                          ? colorScheme.onSecondary
                                          : colorScheme.onSurface,
                                    ),
                                  );
                                },
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
              enabled: !_isBlockedByOther && !_isBlockedByMe,
              onMicStart: _startRecording,
              onMicEnd: _stopAndSendRecording,
              onMicCancel: _cancelRecording,
            ),
          ),

          //************************* Blocked Message *************************//
          if (_isBlockedByOther)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This user has blocked you. You can't send messages.",
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (_isBlockedByMe)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "You have blocked this user.",
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

  //************************* Resolve Message Text (decrypt or fallback) *************************//
  Future<String> _resolveMessageText(Map<String, dynamic> data) async {
    try {
      final bool isEncrypted = (data['enc'] == true) ||
          (data.containsKey('cipherText') && data.containsKey('nonce') && data.containsKey('mac'));
      if (!isEncrypted) {
        // plaintext or legacy messages
        return (data['text'] ?? '').toString();
      }

      // Ensure salt availability
      String salt = _chatSaltB64 ?? await _encryptionService.ensureChatSalt(widget.chatId);
      _chatSaltB64 = salt;

      final cipherText = (data['cipherText'] ?? '').toString();
      final nonce = (data['nonce'] ?? '').toString();
      final mac = (data['mac'] ?? '').toString();
      if (cipherText.isEmpty || nonce.isEmpty || mac.isEmpty) {
        return '⚠️ Unable to decrypt';
      }

      final plain = await _encryptionService.decryptText(
        chatId: widget.chatId,
        currentUserId: widget.currentUserId,
        otherUserId: widget.otherUser.uid,
        cipherTextB64: cipherText,
        nonceB64: nonce,
        macB64: mac,
        saltB64: salt,
      );
      return plain;
    } catch (_) {
      return '⚠️ Unable to decrypt';
    }
  }
}
