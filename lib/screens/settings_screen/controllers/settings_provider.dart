import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';

class SettingsProvider with ChangeNotifier {
  List<UserModel> userSubscriptions = [];
  List<UserModel> closeFriends = [];
  List<UserModel> blockedUsers = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  setIsloading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // fetchUserCloseFriends() {}

  getBlockedUsers(String userId) async {
    try {
      await _firestore
          .collection('users')
          .where('blockedByUsers', arrayContains: userId)
          .get()
          .then((value) {
        blockedUsers =
            value.docs.map((e) => UserModel.fromMap(e.data())).toList();
        notifyListeners();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  unblockUser(String currentId, String blockId, context) async {
    try {
      blockedUsers.removeWhere((element) => element.uid == blockId);
      notifyListeners();

      await _firestore.collection('users').doc(currentId).update({
        'blockedUsers': FieldValue.arrayRemove([blockId])
      });
      await _firestore.collection('users').doc(blockId).update({
        'blockedByUsers': FieldValue.arrayRemove([currentId])
      });
    } catch (e) {
      log(e.toString());
    }
  }

  getUserSubscriptions(String userId) async {
    try {
      await _firestore
          .collection('users')
          .where('subscribedUsers', arrayContains: userId)
          .get()
          .then((value) {
        userSubscriptions =
            value.docs.map((e) => UserModel.fromMap(e.data())).toList();
        notifyListeners();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  removeSubscription(String userId, String currentUserId) async {
    try {
      setIsloading(true);
      userSubscriptions.removeWhere((element) => element.uid == userId);
      notifyListeners();
      await _firestore.collection('users').doc(userId).update({
        'subscribedUsers': FieldValue.arrayRemove([currentUserId])
      });
      await _firestore.collection('users').doc(currentUserId).update({
        'subscribedSoundPacks': FieldValue.arrayRemove([userId])
      });

      setIsloading(false);
    } catch (e) {
      setIsloading(false);
      log(e.toString());
    }
  }
}
