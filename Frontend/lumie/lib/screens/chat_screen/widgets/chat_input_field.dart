//************************* Chat Input Widget *************************//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;
  final VoidCallback? onMicStart;
  final VoidCallback? onMicEnd;
  final VoidCallback? onMicCancel;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
    this.onMicStart,
    this.onMicEnd,
    this.onMicCancel,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _isRecording = false;
  bool _willCancel = false;
  Offset? _dragStart;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails d) {
    if (!widget.enabled) return;
    setState(() {
      _isRecording = true;
      _willCancel = false;
    });
    _dragStart = d.globalPosition;
    widget.onMicStart?.call();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails d) {
    if (!_isRecording) return;
    // Cancel if user swipes RIGHT (requested). Also allow significant UP as cancel.
    final dx = d.offsetFromOrigin.dx;
    final dy = d.offsetFromOrigin.dy;
    final cancel = (dx > 30) || (dy < -60);
    if (cancel != _willCancel) {
      setState(() => _willCancel = cancel);
    }
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (!_isRecording || _dragStart == null) return;
    final dx = d.globalPosition.dx - _dragStart!.dx;
    final dy = d.globalPosition.dy - _dragStart!.dy;
    final cancel = (dx > 30) || (dy < -60);
    if (cancel != _willCancel) {
      setState(() => _willCancel = cancel);
    }
  }

  void _onPanEnd(DragEndDetails d) {
    if (!_isRecording) return;
    // Treat lift as end of recording (will also get longPressEnd on most platforms).
    _onLongPressEnd(
      LongPressEndDetails(velocity: d.velocity, globalPosition: Offset.zero),
    );
  }

  void _onLongPressEnd(LongPressEndDetails d) {
    if (!_isRecording) return;
    setState(() => _isRecording = false);
    if (_willCancel) {
      widget.onMicCancel?.call();
    } else {
      widget.onMicEnd?.call();
    }
    _willCancel = false;
  }

  void _onLongPressCancel() {
    if (!_isRecording) return;
    setState(() => _isRecording = false);
    widget.onMicCancel?.call();
    _willCancel = false;
  }

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
          // Mic (press and hold)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPressStart: _onLongPressStart,
            onLongPressMoveUpdate: _onLongPressMoveUpdate,
            onLongPressEnd: _onLongPressEnd,
            onLongPressCancel: _onLongPressCancel,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.enabled
                    ? (_isRecording
                          ? colorScheme.secondary
                          : colorScheme.primary)
                    : Colors.grey,
                shape: BoxShape.circle,
                boxShadow: _isRecording
                    ? [
                        BoxShadow(
                          color: colorScheme.secondary,
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                _isRecording ? Icons.mic_rounded : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              enabled: widget.enabled,
              style: GoogleFonts.poppins(fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.enabled
                    ? (_isRecording
                          ? 'Swipe right to cancel'
                          : 'Type a message...')
                    : "You can't message this user",
                hintStyle: GoogleFonts.poppins(color: colorScheme.onSurface),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (!_isRecording) ...[
            GestureDetector(
              onTap: widget.enabled ? widget.onSend : null,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.enabled ? colorScheme.secondary : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ] else ...[
            // While recording: show dynamic cancel button when swiping up
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _willCancel ? Colors.red : colorScheme.secondary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: InkWell(
                onTap: _onLongPressCancel,
                borderRadius: BorderRadius.circular(24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _willCancel ? Icons.delete_forever : Icons.mic,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _willCancel ? 'Cancel' : 'Recording...',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
