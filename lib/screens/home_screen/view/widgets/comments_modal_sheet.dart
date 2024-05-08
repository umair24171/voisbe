import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/controllers/add_note_controller.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:social_notes/screens/home_screen/model/sub_comment_model.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/widgets/single_comment_note.dart';
// import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_message_package/voice_message_package.dart';

class CommentModalSheet extends StatefulWidget {
  // final List<String> comments;

  const CommentModalSheet(
      {super.key,
      required this.postId,
      required this.userId,
      required this.noteData});
  final String postId;
  final String userId;
  final NoteModel noteData;

  @override
  State<CommentModalSheet> createState() => _CommentModalSheetState();
}

class _CommentModalSheetState extends State<CommentModalSheet> {
  AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  bool _isPlaying = false;
  late StreamSubscription<QuerySnapshot> _subscription;
  List<CommentModel> commentsList = [];
  List<int> subscriberComments = [];
  List<int> remainingComments = [];
  List<int> closeCOmments = [];

  final _player = AudioPlayer();
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _player.onPlayerComplete.listen((state) {
      setState(() {
        _isPlaying = false;
      });
    });
    _player.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    // Subscribe to the Firestore collection
    UserModel? currentNoteUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.noteData.userUid)
        .get()
        .then((value) {
      currentNoteUser = UserModel.fromMap(value.data() ?? {});
    });

    _subscription = FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.postId)
        .collection('comments')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        List<CommentModel> list =
            snapshot.docs.map((e) => CommentModel.fromMap(e.data())).toList();
        list.sort((a, b) => b.playedComment.compareTo(a.playedComment));

        List<int> subscriberCommentsIndexes = [];
        List<int> closeFriendIndexes = [];
        List<int> remainingCommentsIndex = [];

        for (var index = 0; index < list.length; index++) {
          var comment = list[index];
          if (currentNoteUser!.closeFriends.contains(comment.userId)) {
            closeFriendIndexes.add(index);
            log('Close Friends Comments: $closeFriendIndexes');
          } else if (currentNoteUser!.subscribedUsers
              .contains(comment.userId)) {
            subscriberCommentsIndexes.add(index);
            log('Subscriber Comments: $subscriberCommentsIndexes');
          } else {
            remainingCommentsIndex.add(index);
            log('Remaining Comments: $remainingCommentsIndex');
          }
        }

        log('index of subscriber comments: $subscriberCommentsIndexes');
        // log('MostLikedComment: $mostEngagedComment');
        // log('CommentContainsSubscriber: $commentContainsSubscriber');
        log('RemainingComments: $remainingComments');
        // log('CloseFriendsComments: $closeFriendsComments');
        log('CloseFriednIndexes: $closeFriendIndexes');
        setState(() {
          // Update the local list with the sorted list
          commentsList = list;
          subscriberComments = subscriberCommentsIndexes;
          closeCOmments = closeFriendIndexes;
          remainingComments = remainingComments;
        });
      }
    });
  }

  void _updatePlayedComment(String commentId, int playedComment) {
    int updateCommentCounter = playedComment + 1;
    FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .update({'playedComment': updateCommentCounter});
  }

  void _playAudio(String url, int index, String commentId) async {
    if (_isPlaying && _currentIndex != index) {
      await _audioPlayer.stop();
    }

    if (_currentIndex == index && _isPlaying) {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.resume();
      }
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentIndex = index;
        _isPlaying = true;
      });
    }
    _audioPlayer.onPositionChanged.listen((event) {
      if (_currentIndex == index) {
        setState(() {
          position = event;
        });
      }
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      _updatePlayedComment(commentId, commentsList[index].playedComment);
      setState(() {
        _isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _audioPlayer.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var noteProvider = Provider.of<NoteProvider>(context);

    var commentProvider =
        Provider.of<DisplayNotesProvider>(context, listen: false);
    // commentProvider.displayAllComments(widget.postId);
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    // log('All Users: ${commentProvider.allUsers}');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 6,
            width: 55,
            decoration: BoxDecoration(
                color: const Color(0xffdcdcdc),
                borderRadius: BorderRadius.circular(30)),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              'Replies',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily),
            ),
          ),
          Divider(
            color: Colors.grey[300],
          ),
          Expanded(
              child: commentsList.isNotEmpty
                  ? ListView.builder(
                      itemCount: commentsList.length,
                      itemBuilder: (context, index) {
                        final key = ValueKey<String>(
                            'comment_${commentsList[index].commentid}');
                        return KeyedSubtree(
                          key: key,
                          child: SingleCommentNote(
                            isPlaying: _isPlaying,
                            player: _player,
                            position: position,
                            index: index,
                            commentModel: commentsList[index],
                            subscriberCommentIndex: subscriberComments,
                            closeFriendIndexs: closeCOmments,
                            commentsList: commentsList,
                            playPause: () {
                              _playAudio(commentsList[index].comment, index,
                                  commentsList[index].commentid);
                            },
                            changeIndex: _currentIndex,

                            // comment: comment
                          ),
                        );
                      },
                    )
                  : const Text('')

              // }),
              ),
          Consumer<NoteProvider>(builder: (context, noteProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  if (noteProvider.voiceNote == null &&
                      noteProvider.commentNoteFile == null)
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        userProvider!.photoUrl,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          noteProvider.voiceNote == null ? 8.0 : 0),
                      child: noteProvider.voiceNote != null
                          ? Row(
                              children: [
                                VoiceMessageView(
                                  size: 40,
                                  circlesColor: primaryColor,
                                  cornerRadius: 50,
                                  innerPadding: 2,
                                  controller: VoiceController(
                                    audioSrc: noteProvider.commentNoteFile ==
                                            null
                                        ? noteProvider.voiceNote!.path
                                        : noteProvider.commentNoteFile!.path,
                                    maxDuration: const Duration(seconds: 500),
                                    isFile: true,
                                    onComplete: () {},
                                    onPause: () {},
                                    onPlaying: () {},
                                    onError: (err) {},
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                      onTap: () async {
                                        if (noteProvider.voiceNote != null) {
                                          String commentId = const Uuid().v4();
                                          String comment =
                                              await AddNoteController()
                                                  .uploadFile(
                                                      'comments',
                                                      noteProvider.voiceNote!,
                                                      context);
                                          CommentModel commentModel =
                                              CommentModel(
                                            commentid: commentId,
                                            comment: comment,
                                            username: userProvider!.name,
                                            time: DateTime.now(),
                                            userId: userProvider.uid,
                                            playedComment: 0,
                                            postId: widget.postId,
                                            likes: [],
                                            userImage: userProvider.photoUrl,
                                          );

                                          commentProvider
                                              .addComment(widget.postId,
                                                  commentId, commentModel)
                                              .then((value) {
                                            // commentProvider
                                            //     .addOneComment(commentModel);
                                            noteProvider.removeVoiceNote();
                                          });
                                        } else if (noteProvider
                                                .commentNoteFile !=
                                            null) {
                                          String commentId = const Uuid().v4();
                                          String comment =
                                              await AddNoteController()
                                                  .uploadFile(
                                                      'comments',
                                                      noteProvider
                                                          .commentNoteFile!,
                                                      context);
                                          SubCommentModel commentModel =
                                              SubCommentModel(
                                            subCommentId: commentId,
                                            commentId: noteProvider
                                                .commentModel!.commentid,
                                            comment: comment,
                                            userName: userProvider!.name,
                                            createdAt: DateTime.now(),
                                            userId: userProvider.uid,
                                            // playedComment: 0,
                                            postId: widget.postId,
                                            // likes: [],
                                            userImage: userProvider.photoUrl,
                                          );

                                          commentProvider
                                              .addSubComment(commentModel)
                                              .then((value) {
                                            noteProvider.removeCommentModel();
                                            noteProvider.removeCommentNote();
                                          });
                                        }
                                      },
                                      child: const Icon(Icons.send)),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      noteProvider.removeVoiceNote();
                                      noteProvider.removeCommentNote();
                                    },
                                    child: const Icon(Icons.close),
                                  ),
                                )
                              ],
                            )
                          : noteProvider.commentNoteFile != null
                              ? Row(
                                  children: [
                                    VoiceMessageView(
                                      size: 40,
                                      circlesColor: primaryColor,
                                      cornerRadius: 50,
                                      innerPadding: 2,
                                      controller: VoiceController(
                                        audioSrc:
                                            noteProvider.commentNoteFile == null
                                                ? noteProvider.voiceNote!.path
                                                : noteProvider
                                                    .commentNoteFile!.path,
                                        maxDuration:
                                            const Duration(seconds: 500),
                                        isFile: true,
                                        onComplete: () {},
                                        onPause: () {},
                                        onPlaying: () {},
                                        onError: (err) {},
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () async {
                                            if (noteProvider.voiceNote !=
                                                null) {
                                              String commentId =
                                                  const Uuid().v4();
                                              String comment =
                                                  await AddNoteController()
                                                      .uploadFile(
                                                          'comments',
                                                          noteProvider
                                                              .voiceNote!,
                                                          context);
                                              CommentModel commentModel =
                                                  CommentModel(
                                                commentid: commentId,
                                                comment: comment,
                                                username: userProvider!.name,
                                                time: DateTime.now(),
                                                userId: userProvider.uid,
                                                playedComment: 0,
                                                postId: widget.postId,
                                                likes: [],
                                                userImage:
                                                    userProvider.photoUrl,
                                              );

                                              commentProvider
                                                  .addComment(widget.postId,
                                                      commentId, commentModel)
                                                  .then((value) {
                                                // commentProvider
                                                //     .addOneComment(commentModel);
                                                noteProvider.removeVoiceNote();
                                              });
                                            } else if (noteProvider
                                                    .commentNoteFile !=
                                                null) {
                                              String commentId =
                                                  const Uuid().v4();
                                              String comment =
                                                  await AddNoteController()
                                                      .uploadFile(
                                                          'comments',
                                                          noteProvider
                                                              .commentNoteFile!,
                                                          context);
                                              SubCommentModel commentModel =
                                                  SubCommentModel(
                                                subCommentId: commentId,
                                                commentId: noteProvider
                                                    .commentModel!.commentid,
                                                comment: comment,
                                                userName: userProvider!.name,
                                                createdAt: DateTime.now(),
                                                userId: userProvider.uid,
                                                // playedComment: 0,
                                                postId: widget.postId,
                                                // likes: [],
                                                userImage:
                                                    userProvider.photoUrl,
                                              );

                                              commentProvider
                                                  .addSubComment(commentModel)
                                                  .then((value) {
                                                noteProvider
                                                    .removeCommentModel();
                                                noteProvider
                                                    .removeCommentNote();
                                              });
                                            }
                                          },
                                          child: const Icon(Icons.send)),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          noteProvider.removeVoiceNote();
                                          noteProvider.removeCommentNote();
                                          noteProvider.removeCommentModel();
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    )
                                  ],
                                )
                              : TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Add a reply',
                                    hintStyle: TextStyle(
                                        fontFamily: fontFamily,
                                        color: Colors.grey,
                                        fontSize: 13),
                                    // label: Text(
                                    //   'Add a reply',
                                    //   style: TextStyle(
                                    //       fontFamily: fontFamily,
                                    //       color: Colors.grey,
                                    //       fontSize: 13),
                                    // ),

                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        if (noteProvider.voiceNote == null) {
                                          if (noteProvider
                                              .recoder.isRecording) {
                                            noteProvider.stop();
                                          } else {
                                            noteProvider.record();
                                          }
                                        } else if (noteProvider
                                                .commentNoteFile ==
                                            null) {
                                          if (noteProvider
                                              .recoder.isRecording) {
                                            noteProvider.commentStop();
                                          } else {
                                            noteProvider.commentRecord();
                                          }
                                        }
                                      },
                                      child: Icon(
                                        noteProvider.isRecording
                                            ? Icons.stop
                                            : Icons.mic,
                                        color: blackColor,
                                        size: 30,
                                      ),
                                    ),
                                    constraints:
                                        const BoxConstraints(maxHeight: 45),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(19),
                                    ),
                                  ),
                                ),
                    ),
                  )
                ],
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 6,
            width: 150,
            decoration: BoxDecoration(
                color: blackColor, borderRadius: BorderRadius.circular(50)),
          ),
        ],
      ),
    );
  }
}
