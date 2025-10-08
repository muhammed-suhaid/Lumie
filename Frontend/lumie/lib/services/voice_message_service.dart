//************************* Voice Message Service *************************//
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'cloudinary_service.dart';

class VoiceMessageService {
  final AudioRecorder _recorder = AudioRecorder();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _currentFilePath;
  int _currentDurationMs = 0;

  Future<bool> hasMicPermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    if (!await hasMicPermission()) {
      throw Exception('Microphone permission denied');
    }

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    _currentFilePath = filePath;
    _currentDurationMs = 0;

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );
  }

  Future<({String filePath, int durationMs})> stopRecording() async {
    final path = await _recorder.stop();
    if (path == null) {
      throw Exception('No recording in progress');
    }

    // Duration retrieval is not handled here; keep 0 for now (client can update during playback)
    _currentDurationMs = _currentDurationMs == 0 ? 0 : _currentDurationMs;

    return (filePath: path, durationMs: _currentDurationMs);
  }

  Future<void> cancelRecording() async {
    try {
      await _recorder.stop();
    } catch (_) {}
    if (_currentFilePath != null) {
      final f = File(_currentFilePath!);
      if (await f.exists()) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
    _currentFilePath = null;
    _currentDurationMs = 0;
  }

  

  Future<void> sendVoiceMessage({
    required BuildContext context,
    required String chatId,
    required String senderId,
    required String receiverId,
  }) async {
    if (_currentFilePath == null) {
      throw Exception('No recorded file');
    }

    final file = File(_currentFilePath!);
    final fileName = file.path.split('/').last;
    final folder = 'chats/$chatId/voice/$senderId';
    final audioUrl = await CloudinaryService.uploadAudio(
      context,
      file,
      folder,
      publicId: fileName,
    );

    if (audioUrl == null || audioUrl.isEmpty) {
      throw Exception('Upload failed. Please try again.');
    }

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': null,
      'type': 'audio',
      'audioUrl': audioUrl,
      'audioDurationMs': _currentDurationMs,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': 'Voice message',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _currentFilePath = null;
    _currentDurationMs = 0;
  }
}
