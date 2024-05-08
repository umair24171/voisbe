import 'dart:io';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';

class UserProvider with ChangeNotifier {
  bool userLoading = false;
  bool isLogin = false;
  File? imageFile;
  bool isSubscription = false;
  UserModel? user;
  bool isNotificationEnabled = false;
  updateUserField(bool value) {
    user!.toMap()['isPrivate'] = value;
    notifyListeners();
  }

  updateUserFieldForCloseFriends(String value) {
    user!.toMap()['closeFriends'].add(value);
    notifyListeners();
  }

  removeUSerFieldForCloseFriends(String value) {
    user!.toMap()['closeFriends'].remove(value);
    notifyListeners();
  }

  unblockField(String value) {
    user!.toMap()['blockedUsers'].remove(value);
    notifyListeners();
  }

  setUserNull() {
    user = null;
    notifyListeners();
  }

  setIsNotificationEnabled() {
    isNotificationEnabled = !isNotificationEnabled;
    notifyListeners();
  }

  removeImage() {
    imageFile = null;
    notifyListeners();
  }

  setUserLoading(bool value) {
    userLoading = value;
    notifyListeners();
  }

  getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      user = UserModel.fromMap(value.data()!);
      notifyListeners();
    });
  }

  setIsSubscription() {
    isSubscription = !isSubscription;
    notifyListeners();
  }

  setIslogin(bool value) {
    isLogin = value;
    notifyListeners();
  }

  pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        notifyListeners();
      }
    });
  }
}
