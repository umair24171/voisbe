import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/controllers/add_note_controller.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/widgets/single_comment_note.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_message_package/voice_message_package.dart';

class CommentModalSheet extends StatefulWidget {
  // final List<String> comments;

  const CommentModalSheet({super.key, required this.postId});
  final String postId;

  @override
  State<CommentModalSheet> createState() => _CommentModalSheetState();
}

class _CommentModalSheetState extends State<CommentModalSheet> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(
  //     const Duration(seconds: 0),
  //     () {
  //       Provider.of<DisplayNotesProvider>(context, listen: false)
  //           .displayAllComments(widget.postId);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // var noteProvider = Provider.of<NoteProvider>(context);

    var commentProvider =
        Provider.of<DisplayNotesProvider>(context, listen: false);
    // commentProvider.displayAllComments(widget.postId);
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;

    return Container(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('notes')
                      .doc(widget.postId)
                      .collection('comments')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var comment = CommentModel.fromMap(
                              snapshot.data!.docs[index].data());
                          return SingleCommentNote(
                            index: index,
                            commentModel: comment,
                          );
                        },
                      );
                    } else {
                      return Text('');
                    }
                  }),
            ),
            Consumer<NoteProvider>(builder: (context, noteProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    if (noteProvider.voiceNote == null)
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(
                            noteProvider.voiceNote == null ? 8.0 : 0),
                        child: noteProvider.voiceNote != null
                            ? Row(
                                children: [
                                  VoiceMessageView(
                                    size: 25,
                                    circlesColor: primaryColor,
                                    cornerRadius: 50,
                                    controller: VoiceController(
                                      audioSrc: noteProvider.voiceNote!.path,
                                      maxDuration: const Duration(seconds: 500),
                                      isFile: true,
                                      onComplete: () {},
                                      onPause: () {},
                                      onPlaying: () {},
                                      onError: (err) {},
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                        onPressed: () async {
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
                                            username: userProvider!.username,
                                            time: DateTime.now(),
                                            userId: userProvider.uid,
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
                                        },
                                        icon: const Icon(Icons.send)),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        noteProvider.removeVoiceNote();
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
                                      if (noteProvider.recoder.isRecording) {
                                        noteProvider.stop();
                                      } else {
                                        noteProvider.record();
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
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(19)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(19)),
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
          ],
        ),
      ),
    );
  }
}
