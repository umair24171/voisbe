import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/provider/filter_provider.dart';
import 'package:social_notes/screens/user_profile/other_user_profile.dart';

// int? currentPlayingIndex;

class CircleVoiceNotes extends StatefulWidget {
  CircleVoiceNotes({
    Key? key,
    required this.commentModel,
    required this.index,
    required this.subscriberCommentIndex,
    required this.closeFriendIndexs,
    required this.onPlayStateChanged,
    required this.audioPlayer,
    required this.isPlaying,
    required this.position,
    required this.onPlayPause,
    required this.changeIndex,
  }) : super(key: key);
  // int playedComment;
  final CommentModel commentModel;
  final int index;
  final List<int> subscriberCommentIndex;
  final List<int> closeFriendIndexs;
  final Function(bool) onPlayStateChanged;
  AudioPlayer audioPlayer;
  bool isPlaying;
  Duration position;
  VoidCallback onPlayPause;
  int changeIndex;

  @override
  State<CircleVoiceNotes> createState() => _CircleVoiceNotesState();
}

class _CircleVoiceNotesState extends State<CircleVoiceNotes> {
  // late AudioPlayer _audioPlayer;
  String? _cachedFilePath;
  // bool _isPlaying = false;
  double _playbackSpeed = 1.0; // Default playback speed
  PlayerState? _playerState;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  initPlayer() async {
    widget.audioPlayer = AudioPlayer();
    widget.audioPlayer.setReleaseMode(ReleaseMode.stop);
    widget.audioPlayer.setSourceUrl(widget.commentModel.comment);
    _playerState = widget.audioPlayer.state;

    // Check if the file is already cached
    DefaultCacheManager()
        .getFileFromCache(widget.commentModel.comment)
        .then((file) {
      if (file != null && file.file.existsSync()) {
        _cachedFilePath = file.file.path;
      }
    });
    widget.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    // widget.audioPlayer.onPositionChanged.listen((event) {
    //   setState(() {
    //     position = event;
    //   });
    // });

    // widget.audioPlayer.onPlayerComplete.listen((state) {
    //   setState(() {
    //     _isPlaying = false;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    widget.audioPlayer.dispose();
    widget.audioPlayer.stop();
  }

  updatePlayedComment() async {
    int updateCommentCounter = widget.commentModel.playedComment;
    updateCommentCounter++;
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.commentModel.postId)
        .collection('comments')
        .doc(widget.commentModel.commentid)
        .update({'playedComment': updateCommentCounter});
  }

  // void playPause() async {
  //   if (_isPlaying) {
  //     await _audioPlayer.pause();
  //   } else {
  //     if (_cachedFilePath != null) {
  //       _audioPlayer.setReleaseMode(ReleaseMode.stop);
  //       await _audioPlayer
  //           .setPlaybackRate(_playbackSpeed); // Set playback speed
  //       await _audioPlayer.play(UrlSource(_cachedFilePath!));

  //       updatePlayedComment();
  //     } else {
  //       // Cache the file if not already cached
  //       _audioPlayer.setReleaseMode(ReleaseMode.stop);
  //       DefaultCacheManager()
  //           .downloadFile(widget.commentModel.comment)
  //           .then((fileInfo) {
  //         if (fileInfo != null && fileInfo.file.existsSync()) {
  //           _cachedFilePath = fileInfo.file.path;
  //           _audioPlayer.setPlaybackRate(_playbackSpeed); // Set playback speed
  //           _audioPlayer.play(
  //             UrlSource(_cachedFilePath!),
  //           );
  //         }
  //       });
  //     }
  //   }
  //   setState(() {
  //     _isPlaying = !_isPlaying;
  //   });
  //   // Start playing if not already playing
  //   // Pause if already playing
  //   // Your play/pause logic here
  // }

  bool _isLiked = false;
  Duration duration = Duration.zero;
  // Duration position = Duration.zero;

  void _toggleLike() async {
    bool isAlreadyLiked = widget.commentModel.likes
        .contains(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      _isLiked = !isAlreadyLiked;
    });

    if (_isLiked) {
      widget.commentModel.likes.add(FirebaseAuth.instance.currentUser!.uid);
    } else {
      widget.commentModel.likes.remove(FirebaseAuth.instance.currentUser!.uid);
    }

    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.commentModel.postId)
        .collection('comments')
        .doc(widget.commentModel.commentid)
        .update({
      'likes': widget.commentModel.likes,
    });

    // Wait for 2 seconds for the animation
    await Future.delayed(const Duration(seconds: 2));

    // Reset the like animation after 2 seconds
    setState(() {
      _isLiked = isAlreadyLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // double percent = position != null && duration != null
    //     ? position!.inSeconds / duration!.inSeconds
    //     : 0.0;

    return GestureDetector(
      onTap: widget.onPlayPause,
      onDoubleTap: _toggleLike,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            CircularPercentIndicator(
              // radius: 40.0,
              radius: size.width * 0.112,
              lineWidth: 5.0,
              percent: widget.isPlaying && widget.changeIndex == widget.index
                  ? widget.position.inSeconds / duration.inSeconds
                  : 0.0,
              center: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.commentModel.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.data();
                      UserModel userModel = UserModel.fromMap(data!);
                      return Container(
                          // width: 70,
                          // height: 71,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(userModel.photoUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: _isLiked
                              ? Consumer<FilterProvider>(
                                  builder: (context, filterPro, _) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.favorite,
                                      color: filterPro.selectedFilter
                                              .contains('Close Friends')
                                          ? greenColor
                                          : Colors.red,
                                      size: 20,
                                    ),
                                  );
                                })
                              : InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: widget.onPlayPause,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: widget.index == 0
                                            ? const Color.fromARGB(
                                                255, 111, 160, 175)
                                            : widget.subscriberCommentIndex
                                                    .contains(widget.index)
                                                ? const Color(0xffa562cb)
                                                : widget.closeFriendIndexs
                                                        .contains(widget.index)
                                                    ? const Color(0xff50a87e)
                                                    : whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      widget.isPlaying &&
                                              widget.changeIndex == widget.index
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: widget.index == 0
                                          ? whiteColor
                                          : widget.subscriberCommentIndex
                                                  .contains(widget.index)
                                              ? whiteColor
                                              : widget.closeFriendIndexs
                                                      .contains(widget.index)
                                                  ? whiteColor
                                                  : primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ));
                    } else {
                      return const Text('');
                    }
                  }),
              circularStrokeCap: CircularStrokeCap.round,
              // backgroundColor: widget.index == 0
              //     ? const Color(0xff50a87e)
              //     : widget.index == 1
              //         ? const Color(0xff6cbfd9)
              //         : Colors.white,
              backgroundColor:
                  widget.isPlaying && widget.changeIndex == widget.index
                      ? const Color(0xFFB8C7CB)
                      : widget.index == 0
                          ? const Color(0xff6cbfd9)
                          : widget.subscriberCommentIndex.contains(widget.index)
                              ? const Color(0xffa562cb)
                              : widget.closeFriendIndexs.contains(widget.index)
                                  ? const Color(0xff50a87e)
                                  : Colors.white,
              progressColor: widget.index == 0
                  ? const Color(0xff6cbfd9)
                  : widget.subscriberCommentIndex.contains(widget.index)
                      ? const Color(0xffa562cb)
                      : widget.closeFriendIndexs.contains(widget.index)
                          ? const Color(0xff50a87e)
                          : Colors.white,
              animation: widget.isPlaying && widget.changeIndex == widget.index,
              animationDuration: duration.inSeconds,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OtherUserProfile(userId: widget.commentModel.userId),
                    ));
              },
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.commentModel.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.data();
                      UserModel userModel = UserModel.fromMap(data!);
                      return Text(
                        '@${userModel.name}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return const Text('');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
