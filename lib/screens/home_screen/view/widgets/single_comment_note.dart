import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleCommentNote extends StatelessWidget {
  const SingleCommentNote(
      {super.key, required this.commentModel, required this.index});
  final CommentModel commentModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
              radius: 17,
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
                    Text(
                      commentModel.username,
                      style: TextStyle(
                          fontFamily: fontFamily, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      timeago.format(commentModel.time),
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]),
                    ),
                  ],
                ),
                VoiceMessageView(
                  backgroundColor: index == 0
                      ? greenColor
                      : index == 1
                          ? const Color(0xff6cbfd9)
                          : primaryColor,
                  activeSliderColor: whiteColor,
                  cornerRadius: 50,
                  innerPadding: 2,
                  size: 25,
                  controller: VoiceController(
                    audioSrc: commentModel.comment,
                    maxDuration: const Duration(seconds: 500),
                    isFile: false,
                    onComplete: () {
                      debugPrint('completed');
                    },
                    onPause: () {
                      debugPrint('paused');
                    },
                    onPlaying: () {
                      debugPrint('playing');
                    },
                    onError: (err) {
                      debugPrint('voice error ${err.toString()}');
                    },
                  ),
                ),
                Text(
                  'Reply',
                  style: TextStyle(
                      color: Colors.black38,
                      fontFamily: fontFamily,
                      fontSize: 14),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 27),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('notes')
                    .doc(commentModel.postId)
                    .collection('comments')
                    .doc(commentModel.commentid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('');
                  }
                  CommentModel commentModel1 =
                      CommentModel.fromMap(snapshot.data!.data()!);
                  return IconButton(
                      onPressed: () async {
                        if (commentModel1.likes
                            .contains(FirebaseAuth.instance.currentUser!.uid)) {
                          commentModel1.likes
                              .remove(FirebaseAuth.instance.currentUser!.uid);
                        } else {
                          commentModel1.likes
                              .add(FirebaseAuth.instance.currentUser!.uid);
                        }
                        await FirebaseFirestore.instance
                            .collection('notes')
                            .doc(commentModel.postId)
                            .collection('comments')
                            .doc(commentModel.commentid)
                            .update({
                          'likes': commentModel1.likes,
                        });
                      },
                      icon: Icon(
                        commentModel1.likes.contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: commentModel1.likes.contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? Colors.red
                            : Colors.black,
                      ));
                }),
          ))
        ],
      ),
    );
  }
}
