import 'dart:async';
import 'dart:developer';
// import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/controllers/add_note_controller.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:uuid/uuid.dart';

class CircleComments extends StatefulWidget {
  const CircleComments(
      {super.key,
      required this.postId,
      required this.userId,
      required this.commentsLength,
      this.newlyComment});
  final String postId;
  final String userId;
  final CommentModel? newlyComment;
  final int commentsLength;
  @override
  State<CircleComments> createState() => _CircleCommentsState();
}

class _CircleCommentsState extends State<CircleComments> {
  List<CommentModel> firstListViewComments = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration position = Duration.zero;
  int? indexNewComment;
  late StreamSubscription<QuerySnapshot> _subscription;
  late StreamSubscription<DocumentSnapshot> _userSubscription;
  List<int> subscriberCommentsIndexes = [];

  List<int> closeFriendIndexes = [];
  List<int> remainingCommentsIndex = [];
  List<CommentModel> commentsList = [];
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    getStreamComments();
  }

  getStreamComments() async {
    UserModel? currentNoteUser;
    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(widget.userId)
    //     .get()
    //     .then((value) {
    //   currentNoteUser = UserModel.fromMap(value.data() ?? {});
    // });
    _userSubscription = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .snapshots()
        .listen((snapshot) {
      currentNoteUser = UserModel.fromMap(snapshot.data() ?? {});
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

        List<int> subcomments = [];
        List<int> closeComm = [];
        List<int> remainCom = [];

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
        // if (list.isNotEmpty) {
        //   indexOfNewComent = list.indexWhere(
        //       (element) => element.commentid == widget.newlyComment!.commentid);
        //   log('New Index Comment $indexOfNewComent');
        //   list.removeWhere(
        //       (element) => element.commentid == widget.newlyComment!.commentid);
        // }

        // log('index of subscriber comments: $subscriberCommentsIndexes');
        // // log('MostLikedComment: $mostEngagedComment');
        // // log('CommentContainsSubscriber: $commentContainsSubscriber');
        // log('RemainingComments: $remainCom');
        // // log('CloseFriendsComments: $closeFriendsComments');
        // log('CloseFriednIndexes: $closeFriendIndexes');
        setState(() {
          // Update the local list with the sorted list

          commentsList = list;
          subcomments = subscriberCommentsIndexes;
          closeComm = closeFriendIndexes;
          remainCom = remainingCommentsIndex;
          indexNewComment = indexOfNewComent;
        });
      }
    });
  }

  void _updatePlayedComment(String commentId, int playedComment) async {
    int updateCommentCounter = playedComment + 1;
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .update({'playedComment': updateCommentCounter});
  }

  void _playAudio(
      String url, int index, String commentId, int playedComment) async {
    if (_isPlaying && _currentIndex != index) {
      await _audioPlayer.stop();
    }

    if (_currentIndex == index && _isPlaying) {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.pause();
        setState(() {
          _currentIndex = -1;
          _isPlaying = false;
        });
      } else {
        _audioPlayer.resume();
        setState(() {
          _currentIndex = index;
          _isPlaying = true;
        });
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
      // _updatePlayedComment(commentId, playedComment);
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

  // @override
  // void didUpdateWidget(covariant CircleComments oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Update commentsList when the widget is updated
  //   updateCommentsList();
  // }

  // void updateCommentsList() {
  //   // Reset commentsList
  //   commentsList = [];

  //   // Fetch comments from Firestore
  //   FirebaseFirestore.instance
  //       .collection('notes')
  //       .doc(widget.postId)
  //       .collection('comments')
  //       .snapshots()
  //       .listen((snapshot) {
  //     setState(() {
  //       commentsList = snapshot.docs
  //           .map((doc) => CommentModel.fromMap(doc.data()))
  //           .toList();

  //       // Remove newlyComment if it exists
  //       commentsList.removeWhere(
  //           (comment) => comment.commentid == widget.newlyComment?.commentid);
  //     });
  //   });
  // }

  // @override
  // void didUpdateWidget(covariant CircleComments oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Update commentsList when the widget is updated
  //   updateCommentsList();
  // }

  // void updateCommentsList() {
  //   List<CommentModel> updatedList = List.from(commentsList);

  //   // Remove the newly added comment from the list
  //   updatedList.removeWhere(
  //     (element) => element.commentid == widget.newlyComment?.commentid,
  //   );

  //   // Limit the number of items to show to 3 after removing the new comment
  //   firstListViewComments = updatedList.length > 3
  //       ? updatedList.sublist(0, 3)
  //       : List.from(updatedList);

  //   setState(() {});
  // }
  int indexOfNewComent = -1;

  @override
  Widget build(BuildContext context) {
    var commentProvider =
        Provider.of<DisplayNotesProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    var size = MediaQuery.of(context).size;
    commentsList.removeWhere(
        (element) => element.commentid == widget.newlyComment!.commentid);

    log('new comment index: $indexOfNewComent ');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            children: [
              Expanded(
                // height: size.height * 0.15,
                child: Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5)
                          .copyWith(top: 12),
                      child: Consumer<NoteProvider>(
                        builder: (context, noteProvider, child) {
                          return GestureDetector(
                            onLongPress: () {
                              Timer(const Duration(seconds: 2), () {
                                _audioPlayer.stop();
                                if (noteProvider.isCancellingReply) {
                                  noteProvider.setCancellingReply(false);
                                } else {
                                  noteProvider.setCancellingReply(true);
                                }
                              });
                            },
                            onTap: () async {
                              _audioPlayer.stop();
                              setState(() {
                                _currentIndex = -1;
                              });
                              if (noteProvider.isCancellingReply) {
                                noteProvider.cancelReply();
                              } else if (noteProvider.recoder.isRecording) {
                                noteProvider.setIsSending(true);
                                noteProvider.stop();
                              } else if (noteProvider.isSending) {
                                Provider.of<NoteProvider>(context,
                                        listen: false)
                                    .setIsLoading(true);
                                String commentId = const Uuid().v4();
                                String comment = await AddNoteController()
                                    .uploadFile('comments',
                                        noteProvider.voiceNote!, context);
                                CommentModel commentModel = CommentModel(
                                  commentid: commentId,
                                  comment: comment,
                                  username: userProvider!.name,
                                  time: DateTime.now(),
                                  userId: userProvider.uid,
                                  postId: widget.postId,
                                  likes: [],
                                  playedComment: 0,
                                  userImage: userProvider.photoUrl,
                                );

                                commentProvider
                                    .addComment(
                                        widget.postId, commentId, commentModel)
                                    .then((value) {
                                  noteProvider.removeVoiceNote();
                                  noteProvider.setIsSending(false);
                                  Provider.of<NoteProvider>(context,
                                          listen: false)
                                      .setIsLoading(false);
                                });
                              } else {
                                noteProvider.record();
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: noteProvider.isLoading
                                      ? SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        )
                                      : noteProvider.isSending
                                          ? SvgPicture.asset(
                                              'assets/icons/Send comment.svg',
                                              height: 40,
                                              width: 40,
                                            )
                                          : noteProvider.isCancellingReply
                                              ? SvgPicture.asset(
                                                  'assets/icons/Refresh.svg',
                                                  height: 40,
                                                  width: 40,
                                                )
                                              : noteProvider.isRecording
                                                  ? Icon(
                                                      Icons.stop,
                                                      color: primaryColor,
                                                      size: 40,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/microphone_recordbutton.png',
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                ),
                                Text(
                                  noteProvider.isRecording
                                      ? 'Stop'
                                      : noteProvider.isSending
                                          ? 'Send'
                                          : noteProvider.isCancellingReply
                                              ? 'Cancel'
                                              : 'Reply',
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 13,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (widget.commentsLength >= 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 0),
                        child: CircleVoiceNotes(
                          audioPlayer: _audioPlayer,
                          changeIndex: _currentIndex,
                          onPlayPause: () {
                            _playAudio(
                                widget.newlyComment!.comment,
                                indexOfNewComent,
                                widget.newlyComment!.commentid,
                                widget.newlyComment!.playedComment);
                          },
                          isPlaying: _isPlaying,
                          position: position,
                          index: indexOfNewComent,
                          commentModel: widget.newlyComment!,
                          subscriberCommentIndex: subscriberCommentsIndexes,
                          closeFriendIndexs: closeFriendIndexes,
                          onPlayStateChanged: (isPlaying) {},
                        ),
                      ),
                    ...commentsList.take(2).map((comment) {
                      final key =
                          ValueKey<String>('comment_${comment.commentid}');
                      return KeyedSubtree(
                        key: key,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 0),
                          child: CircleVoiceNotes(
                            audioPlayer: _audioPlayer,
                            changeIndex: _currentIndex,
                            onPlayPause: () {
                              _playAudio(
                                  comment.comment,
                                  commentsList.indexOf(comment),
                                  comment.commentid,
                                  comment.playedComment);
                            },
                            isPlaying: _isPlaying,
                            position: position,
                            index: commentsList.indexOf(comment),
                            commentModel: comment,
                            subscriberCommentIndex: subscriberCommentsIndexes,
                            closeFriendIndexs: closeFriendIndexes,
                            onPlayStateChanged: (isPlaying) {},
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                    ...commentsList.skip(2).take(4).map((comment) {
                      final key =
                          ValueKey<String>('comment_${comment.commentid}');
                      return KeyedSubtree(
                        key: key,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 1),
                          child: CircleVoiceNotes(
                            audioPlayer: _audioPlayer,
                            changeIndex: _currentIndex,
                            onPlayPause: () {
                              _playAudio(
                                  comment.comment,
                                  commentsList.indexOf(comment),
                                  comment.commentid,
                                  comment.playedComment);
                            },
                            isPlaying: _isPlaying,
                            position: position,
                            index: commentsList.indexOf(comment),
                            commentModel: comment,
                            subscriberCommentIndex: subscriberCommentsIndexes,
                            closeFriendIndexs: closeFriendIndexes,
                            onPlayStateChanged: (isPlaying) {},
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
