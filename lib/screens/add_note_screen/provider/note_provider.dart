import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_notes/screens/add_note_screen/model/saved_note_model.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';

class NoteProvider with ChangeNotifier {
  File? voiceNote;
  bool isRecorderReady = false;
  final recoder = FlutterSoundRecorder();
  bool isRecording = false;

  List<UserModel> tags = [];

  addTag(UserModel user) {
    tags.add(user);
    notifyListeners();
  }

  removeTag(UserModel user) {
    tags.remove(user);
    notifyListeners();
  }

  setVoiceNote(File file) {
    voiceNote = file;
    notifyListeners();
  }

  removeVoiceNote() {
    voiceNote = null;
    notifyListeners();
  }

  setRecording(bool value) {
    isRecording = value;
    notifyListeners();
  }

  initRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await recoder.openRecorder();
      isRecorderReady = true;
      recoder.setSubscriptionDuration(const Duration(milliseconds: 500));
    }
  }

  initializedRecorder() {
    initRecorder();
    notifyListeners();
  }

  closeRecorder() {
    recoder.closeRecorder();
    notifyListeners();
  }

  Future record() async {
    if (!isRecorderReady) return;
    setRecording(true);
    await recoder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    setRecording(false);
    final path = await recoder.stopRecorder();

    setVoiceNote(File(path!));
  }
}
