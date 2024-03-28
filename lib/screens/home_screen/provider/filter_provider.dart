import 'package:flutter/material.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';

class FilterProvider with ChangeNotifier {
  String selectedFilter = 'For you';
  bool isSearch = false;
  String searchValue = '';
  List<NoteModel> searcheNote = [];

  addSearchNote(NoteModel noteModel) {
    searcheNote.add(noteModel);
    notifyListeners();
  }

  // List followers = [];
  List<NoteModel> closeFriendsPosts = [];
  // getUserFollowers(List followersList) {
  //   followers = followersList;
  //   notifyListeners();
  // }

  addCloseFriendsPosts(NoteModel closeFriends) {
    closeFriendsPosts.add(closeFriends);
    notifyListeners();
  }

  getSearchEdNotes(List<NoteModel> allNotes) {
    searcheNote = allNotes
        .where((element) =>
            element.topic.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    notifyListeners();
  }

  setSearchingValue(String value) {
    searchValue = value;
    notifyListeners();
  }

  setSearching(bool value) {
    isSearch = value;
    notifyListeners();
  }

  setSelectedFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
