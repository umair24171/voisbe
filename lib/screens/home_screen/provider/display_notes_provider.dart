import 'dart:developer';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_notes/resources/show_snack.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/home_screen/model/book_mark_model.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';

class DisplayNotesProvider with ChangeNotifier {
  List<NoteModel> notes = [];
  List<NoteModel> currentUserPosts = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getCurrentUserPosts() {
    currentUserPosts = notes
        .where((element) =>
            element.userUid == FirebaseAuth.instance.currentUser!.uid)
        .toList();
    notifyListeners();
  }

  addLikeInProvider(String postId) async {
    for (var element in notes) {
      if (element.noteId == postId) {
        element.likes.add(FirebaseAuth.instance.currentUser!.uid);
      } else {
        element.likes.remove(FirebaseAuth.instance.currentUser!.uid);
      }
    }
    notifyListeners();
  }

  getAllNotes() async {
    await _firestore.collection('notes').get().then((value) {
      notes = value.docs.map((e) => NoteModel.fromMap(e.data())).toList();
      notifyListeners();
    });
  }

  addComment(String postId, String commentId, CommentModel commentModel) async {
    try {
      await _firestore
          .collection('notes')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(commentModel.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  List<CommentModel> allComments = [];

  addOneComment(CommentModel commentModel) {
    allComments.add(commentModel);
    notifyListeners();
  }

  displayAllComments(String postId) async {
    allComments.clear();
    await _firestore
        .collection('notes')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      allComments =
          value.docs.map((e) => CommentModel.fromMap(e.data())).toList();
      notifyListeners();
    });
  }

  likePost(List likes, String postId) async {
    if (likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
      likes.remove(FirebaseAuth.instance.currentUser!.uid);
    } else {
      likes.add(FirebaseAuth.instance.currentUser!.uid);
    }
    await _firestore.collection('notes').doc(postId).update({
      'likes': likes,
    });
  }

  List<BookmarkModel> bookMarkPosts = [];

  getBookMarkPosts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('bookmarks')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    bookMarkPosts =
        snapshot.docs.map((e) => BookmarkModel.fromMap(e.data())).toList();
    notifyListeners();
  }

  addPostToSaved(BookmarkModel bookmarkModel, context) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('bookmarks')
        .where('userId', isEqualTo: bookmarkModel.userId)
        .get();
    bool isSaved = false;
    BookmarkModel? book;
    for (var doc in snapshot.docs) {
      BookmarkModel bookmark = BookmarkModel.fromMap(doc.data());
      if (bookmark.postId == bookmarkModel.postId) {
        // savedNoteModel = savedNote;
        book = bookmark;
        isSaved = true;

        break;
      }
    }
    if (isSaved) {
      await _firestore.collection('bookmarks').doc(book!.bookmarkId).delete();
      bookMarkPosts
          .removeWhere((element) => element.postId == bookmarkModel.postId);
      notifyListeners();
      showSnackBar(context, 'Post removed from saved');
      log('deleted');
    } else {
      await _firestore
          .collection('bookmarks')
          .doc(bookmarkModel.bookmarkId)
          .set(bookmarkModel.toMap());
      bookMarkPosts.add(bookmarkModel);
      notifyListeners();
      showSnackBar(context, 'Post saved');
      log('saved');
    }
  }
}
