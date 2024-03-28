import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/search_screen/view/note_details_screen.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
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

    return Column(
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('notes')
                .where('userUid',
                    isEqualTo:
                        Provider.of<UserProfileProvider>(context, listen: false)
                            .otherUser!
                            .uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      // crossAxisSpacing: 3,
                      crossAxisCount: 4,
                      mainAxisExtent: 90,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    NoteModel noteModel =
                        NoteModel.fromMap(snapshot.data!.docs[index].data());
                    return GestureDetector(
                      onTap: () {
                        showMenu(
                            context: context,
                            position: RelativeRect.fromDirectional(
                                textDirection: TextDirection.ltr,
                                start: 0,
                                top: 0,
                                end: 0,
                                bottom: 0),
                            items: [
                              PopupMenuItem(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NoteDetailsScreen(
                                        size: MediaQuery.of(context).size,
                                        note: noteModel),
                                  ));
                                },
                                child: const Text('View Post'),
                              ),
                            ]);
                        // if (userPosts[index].userUid ==
                        //     FirebaseAuth.instance.currentUser!.uid) {
                        //   var isPinned = userPosts[index].isPinned;

                        //   Provider.of<UserProfileProvider>(context, listen: false)
                        //       .pinPost(userPosts[index].noteId, !isPinned);
                        // }
                      },
                      child: SinglePostNote(
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
