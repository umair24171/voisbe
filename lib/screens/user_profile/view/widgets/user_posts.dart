// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:just_waveform/just_waveform.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/search_screen/view/note_details_screen.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_player.dart';
// import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:social_notes/screens/user_profile/view/widgets/single_post_note.dart';
// import 'package:voice_message_package/voice_message_package.dart';

class UserPosts extends StatelessWidget {
  UserPosts({super.key});

  List<NoteModel> pinnedPosts = [];
  List<NoteModel> nonPinnedPosts = [];
  // final GlobalKey _popupKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  final double _autoplayThreshold = 200.0;

  @override
  Widget build(BuildContext context) {
    var userPosts = Provider.of<UserProfileProvider>(
      context,
    ).userPosts;

    // void _showPopupMenu(int index) {
    //   final RenderBox popupRenderBox =
    //       _popupKey.currentContext!.findRenderObject() as RenderBox;
    //   final RenderBox overlay =
    //       Overlay.of(context).context.findRenderObject() as RenderBox;
    //   final RelativeRect position = RelativeRect.fromRect(
    //     Rect.fromPoints(
    //       popupRenderBox.localToGlobal(Offset.zero, ancestor: overlay),
    //       popupRenderBox.localToGlobal(
    //           popupRenderBox.size.bottomRight(Offset.zero),
    //           ancestor: overlay),
    //     ),
    //     Offset.zero & overlay.size,
    //   );

    //   showMenu(
    //     context: context,
    //     position: position,
    //     color: whiteColor,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(7),
    //     ),
    //     constraints: const BoxConstraints(maxWidth: double.infinity),
    //     items: [
    //       PopupMenuItem(
    //           value: 'pinn',
    //           child: Text(
    //             'Pinn Post',
    //             style: TextStyle(fontFamily: fontFamily),
    //           )),
    //       PopupMenuItem(
    //           value: 'view',
    //           child: Text(
    //             'View Post',
    //             style: TextStyle(fontFamily: fontFamily),
    //           )),
    //       PopupMenuItem(
    //           value: 'delete',
    //           child: Text(
    //             'Delete Post',
    //             style: TextStyle(fontFamily: fontFamily),
    //           )),
    //     ],
    //   ).then((value) {
    //     if (value == 'pinn') {
    //       var isPinned = userPosts[index].isPinned;

    //       Provider.of<UserProfileProvider>(context, listen: false)
    //           .pinPost(userPosts[index].noteId, !isPinned);

    //       // Perform actions based on selected value if needed
    //       debugPrint('Selected: $value');
    //     } else if (value == 'view') {
    //       Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => NoteDetailsScreen(
    //             size: MediaQuery.of(context).size, note: userPosts[index]),
    //       ));
    //     } else {
    //       Provider.of<UserProfileProvider>(context, listen: false)
    //           .deletePost(userPosts[index].noteId);
    //     }
    //   });
    // }

    pinnedPosts.clear();
    nonPinnedPosts.clear();

    for (int i = 0; i < userPosts.length; i++) {
      if (userPosts[i].isPinned) {
        pinnedPosts.add(userPosts[i]);
      } else {
        nonPinnedPosts.add(userPosts[i]);
      }
      // if (userPosts[i].publishedDate.compareTo(DateTime.now()) == 0) {
      //   newlyNote = userPosts[i];
      // }
      // if (userPosts[i].isNewlyCreated) {
      //   userPosts.insert(0, userPosts[i]);
      // }
    }
    userPosts = [...pinnedPosts, ...nonPinnedPosts];
    // if (pinnedPosts.isNotEmpty) {
    //   userPosts.insert(0, pinnedPosts[0]);
    // }
    Offset _tapPosition = Offset.zero;

    return Column(
      children: [
        if (userPosts.isEmpty)
          SizedBox(
            height: 130,
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
                  // width: 94,
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
          ),
        if (userPosts.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userPosts.length >= 3 ? 3 : userPosts.length,
              itemBuilder: (context, index) {
                return index == 0
                    ? CustomProgressPlayer(
                        mainWidth: 180,
                        mainHeight: 100,
                        height: 50,
                        width: 55,
                        isMainPlayer: true,
                        waveColor: primaryColor,
                        noteUrl: userPosts[index].noteUrl)
                    : GestureDetector(
                        // key: _popupKey,
                        // onTapDown: (TapDownDetails details) {
                        //   _tapPosition = details.globalPosition;
                        // },
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NoteDetailsScreen(
                                  size: MediaQuery.of(context).size,
                                  note: userPosts[index]),
                            ),
                          );
                        },
                        onTap: () {
                          if (userPosts[index].userUid ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            var isPinned = userPosts[index].isPinned;

                            Provider.of<UserProfileProvider>(context,
                                    listen: false)
                                .pinPost(userPosts[index].noteId, !isPinned);
                          }
                        },
                        // onTap: () {

                        child: SinglePostNote(
                          isGridViewPost: false,
                          note: userPosts[index],
                          isPinned: userPosts[index].isPinned,
                        ),
                      );
              },
            ),
          ),
        if (userPosts.isNotEmpty)
          GridView.builder(
            itemCount: userPosts.length >= 3 ? userPosts.length - 3 : 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // crossAxisSpacing: 3,
                crossAxisCount: 4,
                mainAxisExtent: 120,
                mainAxisSpacing: 2),
            itemBuilder: (context, index) {
              return
                  // index == 0
                  //     ? CustomWaveformPlayer(audioUrl: userPosts[index].noteUrl)
                  //     :
                  GestureDetector(
                onLongPress: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NoteDetailsScreen(
                          size: MediaQuery.of(context).size,
                          note: userPosts[index + 3]),
                    ),
                  );
                },
                onTap: () {
                  if (userPosts[index + 3].userUid ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    var isPinned = userPosts[index + 3].isPinned;

                    Provider.of<UserProfileProvider>(context, listen: false)
                        .pinPost(userPosts[index + 3].noteId, !isPinned);
                  }
                },
                child: SinglePostNote(
                  isGridViewPost: true,
                  note: userPosts[index + 3],
                  isPinned: userPosts[index + 3].isPinned,
                ),
              );
            },
          )
      ],
    );
  }
}

// class CustomPlayer extends StatefulWidget {
//   const CustomPlayer({super.key, required this.audioSrc});
//   final String audioSrc;

//   @override
//   State<CustomPlayer> createState() => _CustomPlayerState();
// }

// class _CustomPlayerState extends State<CustomPlayer> {
//   @override
//   Widget build(BuildContext context) {
//     return VoiceMessageView(
//         innerPadding: 4,
//         controller: VoiceController(
//             audioSrc: widget.audioSrc,
//             maxDuration: const Duration(seconds: 1000),
//             isFile: false,
//             onComplete: () {},
//             onPause: () {},
//             onPlaying: () {}));
//   }
// }

// class CustomPlayer extends StatefulWidget {
//   CustomPlayer({Key? key, required this.note}) : super(key: key);

//   final NoteModel note;

//   @override
//   State<CustomPlayer> createState() => _CustomPlayerState();
// }

// class _CustomPlayerState extends State<CustomPlayer> {
//   late StreamSubscription<PlayerState> playerStateSubscription;
//   late final PlayerController playerController;

//   @override
//   void initState() {
//     super.initState();
//     _initialiseController();
//     preparePlayer();
//     playerStateSubscription =
//         playerController.onPlayerStateChanged.listen((event) {
//       setState(() {});
//     }, onError: (error) {
//       print('Player error: $error');
//     }, onDone: () {
//       print('Player finished playing');
//     });
//   }

//   void _initialiseController() {
//     playerController = PlayerController();
//   }

//   preparePlayer() async {
//     try {
//       playerController.preparePlayer(
//         path: widget.note.noteUrl,
//         shouldExtractWaveform: true,
//         noOfSamples: 100,
//       );
//     } catch (e) {
//       log('Error preparing player: $e');
//     }
//   }

//   @override
//   void dispose() {
//     playerController.dispose();
//     playerStateSubscription.cancel();
//     super.dispose();
//   }

//   void _playandPause() async {
//     if (playerController.playerState == PlayerState.playing) {
//       await playerController.pausePlayer();
//     } else {
//       await playerController.startPlayer(finishMode: FinishMode.loop);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.grey[300],
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: _playandPause,
//             icon: Icon(playerController.playerState == PlayerState.playing
//                 ? Icons.pause
//                 : Icons.play_arrow),
//           ),
//           AudioFileWaveforms(
//             enableSeekGesture: true,
//             animationDuration: const Duration(seconds: 100),
//             waveformType: WaveformType.fitWidth,
//             playerController: playerController,
//             playerWaveStyle: PlayerWaveStyle(fixedWaveColor: primaryColor),
//             backgroundColor: Colors.grey[300],
//             size: const Size(54, 20),
//           ),
//         ],
//       ),
//     );
//   }
// }
