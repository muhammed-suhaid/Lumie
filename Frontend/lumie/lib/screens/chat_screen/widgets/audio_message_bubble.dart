//************************* Audio Message Bubble *************************//
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lumie/utils/custom_snakbar.dart';

class AudioMessageBubble extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final int? durationMs;

  const AudioMessageBubble({
    super.key,
    required this.audioUrl,
    required this.isMe,
    this.durationMs,
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (widget.audioUrl.isEmpty) {
      if (mounted) {
        CustomSnackbar.show(context, 'Audio not available.');
      }
      return;
    }

    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      try {
        await _player.play(UrlSource(widget.audioUrl));
        setState(() => _isPlaying = true);
      } catch (e) {
        if (mounted) {
          CustomSnackbar.show(context, 'Failed to play audio.');
        }
      }
    }
  }

  String _format(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fg = widget.isMe ? colorScheme.onSecondary : colorScheme.onSurface;

    final total = _duration.inMilliseconds > 0
        ? _duration
        : Duration(milliseconds: widget.durationMs ?? 0);

    final bubbleBg = widget.isMe ? colorScheme.secondary : colorScheme.primary;

    return Container(
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bubbleBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Play/Pause button
          InkWell(
            onTap: _togglePlay,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: (widget.isMe ? colorScheme.onSecondary : colorScheme.onPrimary).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: fg,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Wave/progress + times
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Slider themed like WhatsApp
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    activeTrackColor: fg,
                    inactiveTrackColor: fg.withOpacity(0.25),
                    thumbColor: fg,
                    overlayColor: fg.withOpacity(0.1),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                  ),
                  child: Slider(
                    value: total.inMilliseconds == 0
                        ? 0
                        : (_position.inMilliseconds.clamp(0, total.inMilliseconds)).toDouble(),
                    min: 0,
                    max: (total.inMilliseconds == 0 ? 1 : total.inMilliseconds).toDouble(),
                    onChanged: (v) async {
                      final newPos = Duration(milliseconds: v.toInt());
                      await _player.seek(newPos);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_format(_position), style: TextStyle(color: fg.withOpacity(0.9), fontSize: 11)),
                    Row(
                      children: [
                        const Icon(Icons.mic_rounded, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          total == Duration.zero ? '' : _format(total),
                          style: TextStyle(color: fg.withOpacity(0.9), fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
