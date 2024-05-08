import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';

class NoteProvider with ChangeNotifier {
  bool isSearchingUser = false;
  List<UserModel> searchedUsers = [];
  bool isLoading = false;
  bool isSending = false;

  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setIsSending(bool value) {
    isSending = value;
    notifyListeners();
  }

  File? voiceNote;
  File? commentNoteFile;
  CommentModel? commentModel;
  bool isRecorderReady = false;
  final recoder = FlutterSoundRecorder();
  bool isRecording = false;
  bool isCancellingReply = false; // New property to track cancel reply state

  List<UserModel> tags = [];

  addTag(UserModel user) {
    tags.add(user);
    notifyListeners();
  }

  setCommentNoteFile(File file) {
    commentNoteFile = file;
    notifyListeners();
  }

  setCommentModel(CommentModel model) {
    commentModel = model;
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

  setCancellingReply(bool value) {
    isCancellingReply = value;
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

  commentRecord() {
    if (!isRecorderReady) return;
    setRecording(true);
    recoder.startRecorder(toFile: 'comment');
  }

  commentStop() async {
    setRecording(false);
    final path = await recoder.stopRecorder();
    setCommentNoteFile(File(path!));
  }

  removeCommentNote() {
    commentNoteFile = null;
    notifyListeners();
  }

  removeCommentModel() {
    commentModel = null;
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

  cancelReply() {
    // Remove the voice note and set cancelling reply to false
    removeVoiceNote();
    setCancellingReply(false);
  }

  setSearching(bool value) {
    isSearchingUser = value;
    notifyListeners();
  }
}
