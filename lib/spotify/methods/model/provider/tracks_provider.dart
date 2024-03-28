import 'package:flutter/foundation.dart';
import 'package:social_notes/spotify/methods/model/track_model.dart';

class TracksProvider with ChangeNotifier {
  List<Track> allTracks = [];

  List<Track> searchedTracks = [];
  bool isSearching = false;
  setSearchTrack(bool value) {
    isSearching = value;
    notifyListeners();
  }

  addTracks(Track track) {
    allTracks.add(track);
    notifyListeners();
  }
}
