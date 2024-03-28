import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';

class UserProfileProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NoteModel> userPosts = [];
  List<NoteModel> otherUserPosts = [];
  UserModel? otherUser;

  Future<void> getUserPosts(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> userPostsSnapshot =
        await _firestore
            .collection('notes')
            .where('userUid', isEqualTo: userId)
            .orderBy('publishedDate', descending: true)
            .get();
    userPosts = userPostsSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
            NoteModel.fromMap(e.data()))
        .toList();
    notifyListeners();
  }

  deletePost(String postId) async {
    await _firestore.collection('notes').doc(postId).delete();
    userPosts.removeWhere((element) => element.noteId == postId);
    notifyListeners();
  }

  followUser(
    UserModel currentUser,
    UserModel followUser,
  ) {
    if (followUser.followers.contains(currentUser.uid)) {
      _firestore.collection('users').doc(followUser.uid).update({
        'followers': FieldValue.arrayRemove([currentUser.uid])
      });
      // otherUser!.followers.remove(FirebaseAuth.instance.currentUser!.uid);
    } else {
      _firestore.collection('users').doc(followUser.uid).update({
        'followers': FieldValue.arrayUnion([currentUser.uid])
      });
      // otherUser!.followers.remove(currentUser.uid);
    }
    if (currentUser.following.contains(followUser.uid)) {
      _firestore.collection('users').doc(currentUser.uid).update({
        'following': FieldValue.arrayRemove([followUser.uid])
      });
    } else {
      _firestore.collection('users').doc(currentUser.uid).update({
        'following': FieldValue.arrayUnion([followUser.uid])
      });
    }

    notifyListeners();
  }

  Future<void> getOtherUserPosts(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> userPostsSnapshot =
        await _firestore
            .collection('notes')
            .where('userUid', isEqualTo: userId)
            .get();
    otherUserPosts = userPostsSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
            NoteModel.fromMap(e.data()))
        .toList();
    notifyListeners();
  }

  otherUserProfile(String userUid) async {
    final DocumentSnapshot<Map<String, dynamic>> userPostsSnapshot =
        await _firestore.collection('users').doc(userUid).get();
    otherUser = UserModel.fromMap(userPostsSnapshot.data()!);
    notifyListeners();
  }

  pinPost(String noteId, bool isPinned) async {
    List<NoteModel> pinnedPosts = [];
    for (var note in userPosts) {
      if (note.isPinned) {
        pinnedPosts.add(note);
      }
    }

    log(pinnedPosts.length.toString());
    if (pinnedPosts.length <= 1 || isPinned == false) {
      await _firestore
          .collection('notes')
          .doc(noteId)
          .update({'isPinned': isPinned});
      for (var element in userPosts) {
        if (element.noteId == noteId) {
          element.isPinned = isPinned;
          if (isPinned) {
            userPosts.insert(1, element);
          }
        }
      }
      notifyListeners();
    }
  }
}
