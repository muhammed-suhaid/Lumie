//************************* Chat Input Widget *************************//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: GoogleFonts.poppins(fontSize: 16),
              decoration: InputDecoration(
                hintText: enabled
                    ? "Type a message..."
                    : "You can't message this user",
                hintStyle: GoogleFonts.poppins(color: colorScheme.onSurface),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: enabled ? onSend : null,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: enabled ? colorScheme.secondary : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
