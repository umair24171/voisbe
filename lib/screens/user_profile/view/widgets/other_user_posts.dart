import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/search_screen/view/note_details_screen.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_player.dart';
// import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:social_notes/screens/user_profile/view/widgets/single_post_note.dart';

class OtherUserPosts extends StatefulWidget {
  const OtherUserPosts({super.key});

  @override
  State<OtherUserPosts> createState() => _OtherUserPostsState();
}

class _OtherUserPostsState extends State<OtherUserPosts> {
  // @override
  // void initState() {
  //   Provider.of<UserProfileProvider>(context, listen: false).getUserPosts(
  //       Provider.of<UserProfileProvider>(context, listen: false)
  //           .otherUser!
  //           .uid);
  //   super.initState();
  // }

  // List<NoteModel> pinnedPosts = [];
  @override
  Widget build(BuildContext context) {
    var otherUser = Provider.of<UserProfileProvider>(
      context,
    ).otherUser;
    var currentUser = Provider.of<UserProvider>(context, listen: false).user;
    // var userPosts = Provider.of<UserProfileProvider>(
    //   context,
    // ).userPosts;

    // for (int i = 0; i < userPosts.length; i++) {
    //   if (userPosts[i].isPinned) {
    //     pinnedPosts.add(userPosts[i]);
    //   } else {
    //     nonPinnedPosts.add(userPosts[i]);
    //   }
    // }
    // userPosts = [...pinnedPosts, ...nonPinnedPosts];

    // Offset _tapPosition = Offset.zero;
    return otherUser!.isPrivate
        ? !otherUser.followers.contains(currentUser!.uid)
            ? Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/private lock.svg',
                    height: 94,
                    width: 94,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'This account is private',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 14,
                        color: whiteColor,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('notes')
                            .where('userUid',
                                isEqualTo: Provider.of<UserProfileProvider>(
                                        context,
                                        listen: false)
                                    .otherUser!
                                    .uid)
                            .orderBy('publishedDate', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return SizedBox(
                                height: 110,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/No posts.svg',
                                      height: 94,
                                      width: 94,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'No posts yet',
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length >= 3
                                  ? 3
                                  : snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                NoteModel not = NoteModel.fromMap(
                                    snapshot.data!.docs[index].data());
                                return index == 0
                                    ? CustomProgressPlayer(
                                        mainWidth: 180,
                                        mainHeight: 100,
                                        height: 50,
                                        width: 55,
                                        isMainPlayer: true,
                                        waveColor: primaryColor,
                                        noteUrl: not.noteUrl)
                                    : GestureDetector(
                                        // key: _popupKey,
                                        // onTapDown: (TapDownDetails details) {
                                        //   _tapPosition = details.globalPosition;
                                        // },
                                        onLongPress: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                NoteDetailsScreen(
                                                    size: MediaQuery.of(context)
                                                        .size,
                                                    note: not),
                                          ));
                                        },

                                        child: SinglePostNote(
                                          isGridViewPost: false,
                                          note: not,
                                          isPinned: not.isPinned,
                                        ),
                                      );
                              },
                            );
                          } else {
                            return Center(
                                child: SpinKitThreeBounce(
                              color: whiteColor,
                              size: 12,
                            ));
                          }
                        }),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('notes')
                          .where('userUid',
                              isEqualTo: Provider.of<UserProfileProvider>(
                                      context,
                                      listen: false)
                                  .otherUser!
                                  .uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.builder(
                            itemCount: snapshot.data!.docs.length >= 3
                                ? snapshot.data!.docs.length - 3
                                : 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    // crossAxisSpacing: 3,
                                    crossAxisCount: 4,
                                    mainAxisExtent: 120,
                                    mainAxisSpacing: 2),
                            itemBuilder: (context, index) {
                              NoteModel noteModel = NoteModel.fromMap(
                                  snapshot.data!.docs[index + 3].data());
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NoteDetailsScreen(
                                        size: MediaQuery.of(context).size,
                                        note: noteModel),
                                  ));
                                  // if (userPosts[index].userUid ==
                                  //     FirebaseAuth.instance.currentUser!.uid) {
                                  //   var isPinned = userPosts[index].isPinned;

                                  //   Provider.of<UserProfileProvider>(context, listen: false)
                                  //       .pinPost(userPosts[index].noteId, !isPinned);
                                  // }
                                },
                                child: SinglePostNote(
                                  isGridViewPost: true,
                                  note: noteModel,
                                  isPinned: noteModel.isPinned,
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: SpinKitThreeBounce(
                            color: whiteColor,
                            size: 12,
                          ));
                        }
                      })
                ],
              )
        : Column(
            children: [
              SizedBox(
                height: 110,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('notes')
                        .where('userUid',
                            isEqualTo: Provider.of<UserProfileProvider>(context,
                                    listen: false)
                                .otherUser!
                                .uid)
                        .orderBy('publishedDate', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return SizedBox(
                            height: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/No posts.svg',
                                  height: 94,
                                  width: 94,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'No posts yet',
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: 14,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length >= 3
                              ? 3
                              : snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            NoteModel not = NoteModel.fromMap(
                                snapshot.data!.docs[index].data());
                            return index == 0
                                ? CustomProgressPlayer(
                                    mainWidth: 180,
                                    mainHeight: 100,
                                    height: 50,
                                    width: 55,
                                    isMainPlayer: true,
                                    waveColor: primaryColor,
                                    noteUrl: not.noteUrl)
                                : GestureDetector(
                                    // key: _popupKey,
                                    // onTapDown: (TapDownDetails details) {
                                    //   _tapPosition = details.globalPosition;
                                    // },
                                    onLongPress: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NoteDetailsScreen(
                                                  size: MediaQuery.of(context)
                                                      .size,
                                                  note: not),
                                        ),
                                      );
                                    },

                                    child: SinglePostNote(
                                      isGridViewPost: false,
                                      note: not,
                                      isPinned: not.isPinned,
                                    ),
                                  );
                          },
                        );
                      } else {
                        return Center(
                            child: SpinKitThreeBounce(
                          color: whiteColor,
                          size: 12,
                        ));
                      }
                    }),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('notes')
                      .where('userUid',
                          isEqualTo: Provider.of<UserProfileProvider>(context,
                                  listen: false)
                              .otherUser!
                              .uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length >= 3
                            ? snapshot.data!.docs.length - 3
                            : 0,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                // crossAxisSpacing: 3,
                                crossAxisCount: 4,
                                mainAxisExtent: 90,
                                mainAxisSpacing: 2),
                        itemBuilder: (context, index) {
                          NoteModel noteModel = NoteModel.fromMap(
                              snapshot.data!.docs[index + 3].data());
                          return GestureDetector(
                            onLongPress: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NoteDetailsScreen(
                                      size: MediaQuery.of(context).size,
                                      note: noteModel),
                                ),
                              );
                            },
                            child: SinglePostNote(
                              isGridViewPost: true,
                              note: noteModel,
                              isPinned: noteModel.isPinned,
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                          child: SpinKitThreeBounce(
                        color: whiteColor,
                        size: 12,
                      ));
                    }
                  })
            ],
          );
  }
}
