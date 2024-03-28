import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/controllers/add_note_controller.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:uuid/uuid.dart';

class CircleComments extends StatefulWidget {
  const CircleComments({super.key, required this.postId});
  final String postId;

  @override
  State<CircleComments> createState() => _CircleCommentsState();
}

class _CircleCommentsState extends State<CircleComments> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(
  //     const Duration(seconds: 1),
  //     () {
  //       Provider.of<DisplayNotesProvider>(context, listen: false)
  //           .displayAllComments(widget.postId);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var commentProvider =
        Provider.of<DisplayNotesProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    // var noteProvider = Provider.of<NoteProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5).copyWith(top: 0),
                child: Consumer<NoteProvider>(
                    builder: (context, noteProvider, child) {
                  return GestureDetector(
                    onTap: () async {
                      if (noteProvider.recoder.isRecording) {
                        noteProvider.stop().then((value) async {
                          String commentId = const Uuid().v4();
                          String comment = await AddNoteController().uploadFile(
                              'comments', noteProvider.voiceNote!, context);
                          CommentModel commentModel = CommentModel(
                            commentid: commentId,
                            comment: comment,
                            username: userProvider!.username,
                            time: DateTime.now(),
                            userId: userProvider.uid,
                            postId: widget.postId,
                            likes: [],
                            userImage: userProvider.photoUrl,
                          );

                          commentProvider
                              .addComment(
                                  widget.postId, commentId, commentModel)
                              .then((value) {
                            commentProvider.addOneComment(commentModel);
                            noteProvider.removeVoiceNote();
                          });
                        });
                      } else {
                        noteProvider.record();
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(40)),
                          child: noteProvider.isRecording
                              ? Icon(
                                  Icons.stop,
                                  color: primaryColor,
                                  size: 24,
                                )
                              : Image.asset(
                                  'assets/images/microphone_recordbutton.png',
                                  height: 24,
                                  width: 24,
                                ),
                        ),
                        Text(
                          'Reply',
                          style: TextStyle(
                              fontFamily: fontFamily, color: whiteColor),
                        )
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 110,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('notes')
                        .doc(widget.postId)
                        .collection('comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Container();
                      }
                      List<CommentModel> list = snapshot.data!.docs
                          .map((e) => CommentModel.fromMap(e.data()))
                          .toList();
                      List<CommentModel> mostEngagedComment = [];
                      List<CommentModel> commentContainsSubscriber = [];
                      List<CommentModel> remainingComments = [];

                      for (int i = 0; i < list.length; i++) {
                        if (list[i].likes.length > 5) {
                          mostEngagedComment.add(list[i]);
                        } else if (userProvider!.subscribedUsers
                            .contains(list[i].userId)) {
                          commentContainsSubscriber.add(list[i]);
                        } else {
                          remainingComments.add(list[i]);
                        }
                      }

                      list = [
                        ...mostEngagedComment,
                        ...commentContainsSubscriber,
                        ...remainingComments
                      ];

                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length >= 3 ? 3 : list.length,
                          itemBuilder: (context, index) {
                            var comment = list[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 10, left: 0),
                              child: CircleVoiceNotes(
                                index: index,
                                commentModel: comment,
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Container();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length >= 3
                        ? snapshot.data!.docs.length - 3
                        : 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      CommentModel comment = CommentModel.fromMap(
                          snapshot.data!.docs[index + 3].data());
                      return CircleVoiceNotes(
                        commentModel: comment,
                        index: index,
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }),
        )
      ],
    );
  }
}
