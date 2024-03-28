// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/show_snack.dart';
import 'package:social_notes/screens/auth_screens/controller/notifications_methods.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/custom_bottom_bar.dart';
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
      var userPro = Provider.of<UserProvider>(context, listen: false);
      userPro.setUserLoading(true);
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        NotificationMethods notificationMethods = NotificationMethods();
        String token = await notificationMethods.getFirebaseMessagingToken();

        UserModel userModel = UserModel(
            token: token,
            name: '',
            uid: credential.user!.uid,
            subscribedSoundPacks: [],
            username: username,
            email: email,
            photoUrl: '',
            following: [],
            pushToken: '',
            followers: [],
            subscribedUsers: [],
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
        userPro.setUserLoading(false);
        showSnackBar(context, 'Registeration Successful');
        Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
        // navPush(ProfileScreen.routeName, context);
      }
    } catch (e) {
      Provider.of<UserProvider>(context, listen: false).setUserLoading(false);
      showSnackBar(context, e.toString());
      log(e.toString());
    }
  }

  userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      var userPro = Provider.of<UserProvider>(context, listen: false);
      userPro.setUserLoading(true);
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        userPro.setUserLoading(false);
        showSnackBar(context, 'Login Successful');
        // navPush(BottomBar.routeName, context);
        Navigator.pushReplacementNamed(context, BottomBar.routeName);
      }
    } catch (e) {
      Provider.of<UserProvider>(context, listen: false).setUserLoading(false);
      showSnackBar(context, e.toString());
      // log(e.toString());
    }
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credentials = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final UserCredential userCredential =
          await auth.signInWithCredential(credentials);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'username': user.displayName,
            'profilePhoto': user.photoURL
          });
        }
        res = true;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      res = false;
    }
    return res;
  }
}
