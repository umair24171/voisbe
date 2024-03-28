import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
// import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
// import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/widgets/animated_text.dart';
import 'package:social_notes/screens/home_screen/view/widgets/circle_comments.dart';
import 'package:social_notes/screens/home_screen/view/widgets/comments_modal_sheet.dart';
import 'package:social_notes/screens/home_screen/view/widgets/share_post_sheet.dart';
import 'package:social_notes/screens/home_screen/view/widgets/show_tagged_users.dart';
import 'package:social_notes/screens/user_profile/other_user_profile.dart';
// import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
// import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:timeago/timeago.dart' as timeago;

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({
    super.key,
    required this.size,
    required this.note,
  });

  final Size size;
  final NoteModel note;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<DisplayNotesProvider>(context, listen: false)
            .displayAllComments(widget.note.noteId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var commentProvider =
        Provider.of<DisplayNotesProvider>(context, listen: false).allComments;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15).copyWith(top: 5),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    // alignment: Alignment.center,
                    width: widget.size.width * 0.85,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.note.userUid !=
                                  FirebaseAuth.instance.currentUser!.uid) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return OtherUserProfile(
                                      userId: widget.note.userUid,
                                    );
                                  }),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(22)),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        NetworkImage(widget.note.photoUrl),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.note.username,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Image.network(
                                    'https://media.istockphoto.com/id/1396933001/vector/vector-blue-verified-badge.jpg?s=612x612&w=0&k=20&c=aBJ2JAzbOfQpv2OCSr0k8kYe0XHutOGBAJuVjvWvPrQ=',
                                    height: 20,
                                    width: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            left: widget.size.width * 0.43,
                            top: 4,
                            child: Container(
                              width: widget.size.width * 0.42,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 15),
                              decoration: BoxDecoration(
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //       color: Color(0xffcf4836),
                                  //       blurRadius: 4,
                                  //       spreadRadius: 1)
                                  // ],
                                  color: const Color(0xffCF4737),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Text(
                                widget.note.topic,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: fontFamily,
                                    color: whiteColor),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              const AnimatedText(),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: VoiceMessageView(
                  circlesColor: primaryColor,
                  cornerRadius: 50,
                  controller: VoiceController(
                    audioSrc: widget.note.noteUrl,
                    maxDuration: const Duration(seconds: 500),
                    isFile: false,
                    onComplete: () {},
                    onPause: () {},
                    onPlaying: () {},
                    onError: (err) {},
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeago.format(widget.note.publishedDate),
                      style: TextStyle(
                          color: whiteColor,
                          fontFamily: fontFamily,
                          fontSize: 11),
                    ),
                    Text(
                      ' |  ',
                      style: TextStyle(color: whiteColor, fontSize: 11),
                    ),
                    Icon(
                      Icons.play_arrow,
                      size: 10,
                      color: whiteColor,
                    ),
                    Text(
                      ' ${widget.note.title}',
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: whiteColor,
                          fontSize: 11),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5).copyWith(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                          onTap: () {
                            Provider.of<DisplayNotesProvider>(context,
                                    listen: false)
                                .likePost(
                                    widget.note.likes, widget.note.noteId);
                            //     .then((value) {
                            //   Provider.of<DisplayNotesProvider>(context,
                            //           listen: false)
                            //       .addLikeInProvider(widget.note.noteId);
                            // });
                          },
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('notes')
                                  .doc(widget.note.noteId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('');
                                }
                                if (snapshot.data!
                                        .data()!
                                        .containsKey('likes') &&
                                    snapshot.data!.data()!['likes'].contains(
                                        FirebaseAuth
                                            .instance.currentUser!.uid)) {
                                  return const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 30,
                                  );
                                } else {
                                  return Image.asset(
                                    'assets/images/likes.png',
                                    height: 25,
                                    width: 25,
                                  );
                                }
                              })),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () async {
                          await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SharePostSheet(
                                  note: widget.note,
                                );
                              });
                        },
                        child: Image.asset(
                          'assets/images/send_message.png',
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        'assets/images/bookmark_white.png',
                        height: 25,
                        width: 25,
                      ),
                    ),
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.image_outlined,
                    //       color: whiteColor,
                    //       size: 30,
                    //     )),
                    InkWell(
                      onTap: () {
                        showBottomSheet(
                          context: context,
                          builder: (context) {
                            return ShowTaggedUsers(noteModel: widget.note);
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          'assets/images/tags.png',
                          height: 30,
                          width: 25,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_horiz,
                          color: whiteColor,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15)
                    .copyWith(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('notes')
                            .doc(widget.note.noteId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('');
                          }
                          NoteModel likes =
                              NoteModel.fromMap(snapshot.data!.data()!);
                          return Text(
                            '${likes.likes.length} likes',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: whiteColor,
                                fontWeight: FontWeight.w600),
                          );
                        }),
                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                            context: context,
                            builder: (context) => CommentModalSheet(
                                  postId: widget.note.noteId,
                                ));
                      },
                      child: Text(
                        'View all ${commentProvider.length} replies',
                        style: TextStyle(
                            fontFamily: fontFamily,
                            color: whiteColor,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              CircleComments(
                postId: widget.note.noteId,
              )
              // Row(
              //   children: [
              //     Container(decoration: Boxde,)
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
