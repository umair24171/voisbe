// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:social_notes/screens/auth_screens/model/user_model.dart';

class NoteModel {
  String noteId;
  String username;
  String photoUrl;
  String userToken;
  String title;
  String userUid;
  List<UserModel> tagPeople;
  String noteUrl;
  DateTime publishedDate;
  bool isPinned;
  List likes;
  List comments;
  String topic;
  List<String> hashtags;
  NoteModel({
    required this.noteId,
    required this.username,
    required this.photoUrl,
    required this.title,
    required this.userUid,
    required this.tagPeople,
    required this.likes,
    required this.userToken,
    required this.noteUrl,
    required this.publishedDate,
    required this.comments,
    required this.topic,
    required this.isPinned,
    required this.hashtags,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noteId': noteId,
      'username': username,
      'photoUrl': photoUrl,
      'title': title,
      'userUid': userUid,
      'tagPeople': tagPeople.map((user) => user.toMap()).toList(),
      'noteUrl': noteUrl,
      'publishedDate': publishedDate,
      'userToken': userToken,
      'comments': comments,
      'isPinned': isPinned,
      'likes': likes,
      'topic': topic,
      'hashtags': hashtags,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      noteId: map['noteId'] as String,
      username: map['username'] as String,
      photoUrl: map['photoUrl'] as String,
      title: map['title'] as String,
      userUid: map['userUid'] as String,
      tagPeople: List.from(map['tagPeople'] as List)
          .map((userMap) => UserModel.fromMap(userMap))
          .toList(),
      comments: List.from(map['comments'] as List),
      likes: List.from(map['likes'] as List),
      userToken: map['userToken'] as String,
      isPinned: map['isPinned'] as bool,
      noteUrl: map['noteUrl'] as String,
      publishedDate: map['publishedDate'].toDate() as DateTime,
      topic: map['topic'] as String,
      hashtags: List<String>.from(map['hashtags'] as List),
    );
  }
}
