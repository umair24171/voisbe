import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:social_notes/screens/home_screen/model/sub_comment_model.dart';
import 'package:social_notes/screens/home_screen/view/widgets/comments_player.dart';

import 'package:social_notes/screens/user_profile/other_user_profile.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_player.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleCommentNote extends StatelessWidget {
  const SingleCommentNote(
      {super.key,
      required this.commentModel,
      required this.index,
      required this.closeFriendIndexs,
      required this.commentsList,
      required this.playPause,
      required this.player,
      required this.position,
      required this.isPlaying,
      required this.changeIndex,
      required this.subscriberCommentIndex});
  final CommentModel commentModel;
  final int index;
  final List<int> subscriberCommentIndex;
  final List<int> closeFriendIndexs;
  final List<CommentModel> commentsList;
  final AudioPlayer player;
  final VoidCallback playPause;
  final int changeIndex;
  final bool isPlaying;
  final Duration position;

  @override
  Widget build(BuildContext context) {
    // var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    // var subCommentProvider =
    // Provider.of<DisplayNotesProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherUserProfile(
                                userId: commentModel.userId,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(commentModel.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.data();
                          UserModel imageUser = UserModel.fromMap(data!);
                          return CircleAvatar(
                            backgroundImage: NetworkImage(
                              imageUser.photoUrl,
                            ),
                            radius: 17,
                          );
                        } else {
                          return const Text('');
                        }
                      }),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(commentModel.userId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data!.data();
                                UserModel userModel = UserModel.fromMap(data!);
                                return Text(
                                  '@${userModel.name}',
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w600),
                                );
                              } else {
                                return const Text('');
                              }
                            }),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          timeago.format(commentModel.time),
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    CommentsPlayer(
                        isPlaying: isPlaying,
                        player: player,
                        isComment: true,
                        commentId: commentModel.commentid,
                        postId: commentModel.postId,
                        changeIndex: changeIndex,
                        currentIndex: index,
                        playedCounter: commentModel.playedComment,
                        playPause: playPause,
                        position: position,
                        size: 10,
                        waveColor: whiteColor,
                        backgroundColor: index == 0
                            ? const Color(0xff6cbfd9)
                            : closeFriendIndexs.contains(index)
                                ? const Color(0xff50a87e)
                                : subscriberCommentIndex.contains(index)
                                    ? const Color(0xffa562cb)
                                    : primaryColor,
                        noteUrl: commentModel.comment,
                        height: 20,
                        width: 150,
                        mainWidth: 250,
                        mainHeight: 42),
                    Consumer<NoteProvider>(builder: (context, noteProvider, _) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Provider.of<NoteProvider>(context, listen: false)
                              .setCommentModel(commentModel);
                          if (noteProvider.recoder.isRecording) {
                            noteProvider.commentStop();
                          } else {
                            noteProvider.commentRecord();
                          }
                          // Set cancel reply to false
                        },
                        child: Text(
                          'Reply',
                          style: TextStyle(
                              color: Colors.black38,
                              fontFamily: fontFamily,
                              fontSize: 14),
                        ),
                      );
                    })
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 34, right: 0),
                      child: GestureDetector(
                          onTap: () async {
                            List likes = commentModel.likes;
                            if (likes.contains(
                                FirebaseAuth.instance.currentUser!.uid)) {
                              likes.remove(
                                  FirebaseAuth.instance.currentUser!.uid);
                            } else {
                              likes.add(FirebaseAuth.instance.currentUser!.uid);
                            }
                            await FirebaseFirestore.instance
                                .collection('notes')
                                .doc(commentModel.postId)
                                .collection('comments')
                                .doc(commentModel.commentid)
                                .update({
                              'likes': likes,
                            });
                          },
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('notes')
                                  .doc(commentModel.postId)
                                  .collection('comments')
                                  .doc(commentModel.commentid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  CommentModel commentModel1 =
                                      CommentModel.fromMap(
                                          snapshot.data!.data()!);
                                  return Icon(
                                    commentModel1.likes.contains(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: commentModel1.likes.contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? Colors.red
                                        : Colors.black,
                                  );
                                } else {
                                  return Text('');
                                }
                              }))))
            ],
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notes')
              .doc(commentModel.postId)
              .collection('comments')
              .doc(commentModel.commentid)
              .collection('subComments')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  SubCommentModel subCommentModel = SubCommentModel.fromMap(
                      snapshot.data!.docs[index].data());
                  return Padding(
                    padding: const EdgeInsets.only(left: 60, bottom: 10),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherUserProfile(
                                          userId: subCommentModel.userId,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                subCommentModel.userImage,
                              ),
                              radius: 17,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 5,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '@${subCommentModel.userName}',
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    timeago.format(subCommentModel.createdAt),
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              CustomProgressPlayer(
                                  isComment: true,
                                  commentId: subCommentModel.subCommentId,
                                  postId: subCommentModel.postId,
                                  playedCounter: commentModel.playedComment,
                                  size: 10,
                                  waveColor: whiteColor,
                                  backgroundColor: primaryColor,
                                  noteUrl: subCommentModel.comment,
                                  height: 20,
                                  width: 130,
                                  mainWidth: 230,
                                  mainHeight: 42),
                              // VoiceMessageView(
                              //   backgroundColor: index == 0
                              //       ? greenColor
                              //       : index == 1
                              //           ? const Color(0xff6cbfd9)
                              //           : primaryColor,
                              //   activeSliderColor: whiteColor,
                              //   cornerRadius: 50,
                              //   innerPadding: 3,
                              //   size: 30,
                              //   controller: VoiceController(
                              //     audioSrc: commentModel.comment,
                              //     maxDuration: const Duration(seconds: 500),
                              //     isFile: false,
                              //     onComplete: () {
                              //       debugPrint('completed');
                              //     },
                              //     onPause: () {
                              //       debugPrint('paused');
                              //     },
                              //     onPlaying: () {
                              //       debugPrint('playing');
                              //     },
                              //     onError: (err) {
                              //       debugPrint('voice error ${err.toString()}');
                              //     },
                              //   ),
                              // ),
                              // Consumer<NoteProvider>(
                              //     builder: (context, noteProvider, _) {
                              //   return InkWell(
                              //     splashColor: Colors.transparent,
                              //     onTap: () {
                              //       if (noteProvider.recoder.isRecording) {
                              //         noteProvider.stop().then((value) async {
                              //           String commentId = const Uuid().v4();
                              //           String comment =
                              //               await AddNoteController()
                              //                   .uploadFile(
                              //                       'comments',
                              //                       noteProvider.voiceNote!,
                              //                       context);
                              //           SubCommentModel subCommentModel =
                              //               SubCommentModel(
                              //                   comment: comment,
                              //                   subCommentId: commentId,
                              //                   commentId:
                              //                       commentModel.commentid,
                              //                   userId: userProvider!.uid,
                              //                   userName: userProvider.username,
                              //                   userImage:
                              //                       userProvider.photoUrl,
                              //                   postId: commentModel.postId,
                              //                   createdAt: DateTime.now());

                              //           subCommentProvider
                              //               .addSubComment(subCommentModel)
                              //               .then((value) {
                              //             noteProvider.removeVoiceNote();
                              //           });
                              //         });
                              //       } else {
                              //         noteProvider.record();
                              //       }
                              //     },
                              //     child: Text(
                              //       noteProvider.recoder.isRecording
                              //           ? 'Stop recording'
                              //           : 'Reply',
                              //       style: TextStyle(
                              //           color: Colors.black38,
                              //           fontFamily: fontFamily,
                              //           fontSize: 14),
                              //     ),
                              //   );
                              // })
                            ],
                          ),
                        ),
                        // Expanded(
                        //     child: Padding(
                        //   padding: const EdgeInsets.only(top: 34, right: 0),
                        //   child: StreamBuilder(
                        //       stream: FirebaseFirestore.instance
                        //           .collection('notes')
                        //           .doc(commentModel.postId)
                        //           .collection('comments')
                        //           .doc(commentModel.commentid)
                        //           .snapshots(),
                        //       builder: (context, snapshot) {
                        //         if (snapshot.connectionState ==
                        //             ConnectionState.waiting) {
                        //           return const Text('');
                        //         }
                        //         CommentModel commentModel1 =
                        //             CommentModel.fromMap(
                        //                 snapshot.data!.data()!);
                        //         return GestureDetector(
                        //             onTap: () async {
                        //               if (commentModel1.likes.contains(
                        //                   FirebaseAuth
                        //                       .instance.currentUser!.uid)) {
                        //                 commentModel1.likes.remove(FirebaseAuth
                        //                     .instance.currentUser!.uid);
                        //               } else {
                        //                 commentModel1.likes.add(FirebaseAuth
                        //                     .instance.currentUser!.uid);
                        //               }
                        //               await FirebaseFirestore.instance
                        //                   .collection('notes')
                        //                   .doc(commentModel.postId)
                        //                   .collection('comments')
                        //                   .doc(commentModel.commentid)
                        //                   .update({
                        //                 'likes': commentModel1.likes,
                        //               });
                        //             },
                        //             child: Icon(
                        //               commentModel1.likes.contains(FirebaseAuth
                        //                       .instance.currentUser!.uid)
                        //                   ? Icons.favorite
                        //                   : Icons.favorite_border,
                        //               color: commentModel1.likes.contains(
                        //                       FirebaseAuth
                        //                           .instance.currentUser!.uid)
                        //                   ? Colors.red
                        //                   : Colors.black,
                        //             ));
                        //       }),
                        // ))
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Text('');
            }
          },
        ),
      ],
    );
  }
}
