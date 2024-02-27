import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/profile_screen/profile_screen.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  userSignup({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        UserModel userModel = UserModel(
            uid: credential.user!.uid,
            username: username,
            email: email,
            photoUrl: '',
            following: [],
            pushToken: '',
            followers: [],
            bio: '',
            contact: '',
            isSubscriptionEnable: false,
            link: '',
            price: 0,
            soundPacks: []);
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toMap());
        navPush(ProfileScreen.routeName, context);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        navPush(ProfileScreen.routeName, context);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
