// import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:simple_waveform_progressbar/simple_waveform_progressbar.dart';
import 'package:social_notes/resources/colors.dart';

import 'package:social_notes/screens/home_screen/provider/filter_provider.dart';

class CommentsPlayer extends StatefulWidget {
  CommentsPlayer(
      {Key? key,
      required this.noteUrl,
      required this.height,
      required this.width,
      required this.mainWidth,
      required this.mainHeight,
      this.backgroundColor = Colors.white,
      required this.changeIndex,
      required this.playPause,
      this.size = 35,
      this.isComment = false,
      this.isMainPlayer = false,
      this.commentId,
      this.postId,
      required this.player,
      required this.isPlaying,
      required this.position,
      // this.stopOtherPlayer,
      this.playedCounter,
      required this.currentIndex,
      this.waveColor})
      : super(key: key);

  final String noteUrl;
  final double height;
  final double width;
  final double mainWidth;
  final double mainHeight;
  final Color backgroundColor;
  double size;
  int? playedCounter;
  Color? waveColor;
  bool isComment;
  String? commentId;
  String? postId;
  bool isMainPlayer;
  // final Function(AudioPlayer)? stopOtherPlayer;
  int currentIndex;
  AudioPlayer player;
  final VoidCallback playPause;
  int changeIndex;
  bool isPlaying;
  Duration position;
  @override
  State<CommentsPlayer> createState() => _CommentsPlayerState();
}

class _CommentsPlayerState extends State<CommentsPlayer> {
  String? _cachedFilePath;
  // int? _currentIndex;
  // var _player = AudioPlayer();
  // bool isPlaying = false;
  bool isBuffering = false;
  double _playbackSpeed = 1.0;
  Duration duration = Duration.zero;
  // Duration position = Duration.zero;
  initPlayer() async {
    widget.player = AudioPlayer();
    widget.player.setReleaseMode(ReleaseMode.stop);
    widget.player.setSourceUrl(widget.noteUrl).then((value) {
      // widget.player.getDuration().then(
      //       (value) => setState(() {
      //         duration = value!;
      //         // playPause();
      //       }),
      //     );
    });
    widget.player.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    // widget.player.setReleaseMode(ReleaseMode.stop);

    // Check if the file is already cached
    DefaultCacheManager().getFileFromCache(widget.noteUrl).then((file) {
      if (file != null && file.file.existsSync()) {
        _cachedFilePath = file.file.path;
      }
    });
    // widget.player.getCurrentPosition().then(
    //       (value) => setState(() {
    //         position = value!;
    //       }),
    //     );
    widget.player.onPlayerComplete.listen((state) {
      setState(() {
        widget.isPlaying = false;
        widget.changeIndex = -1;
      });
    });

    widget.player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          widget.isPlaying = true;
          // widget.isPlaying = widget.isPlaying;
        });
      } else {
        setState(() {
          widget.isPlaying = false;
          // widget.isPlaying = widget.isPlaying;
        }); // Notify parent widget
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
    // _player = AudioPlayer();
    //  widget.player.setReleaseMode(ReleaseMode.stop);

    // _init();
    // widget.player.onPlayerStateChanged.listen((event) {
    //   if (event.processingState == ProcessingState.completed) {
    //     setState(() {
    //       isPlaying = false;
    //     });
    //   }
    // });
    // widget.player.playingStream.listen((event) {
    //   if (event == true) {
    //     setState(() {
    //       isPlaying = true;
    //     });
    //   } else {
    //     setState(() {
    //       isPlaying = false;
    //     });
    //   }
    // });
  }

  // Future<void> _init() async {
  //   widget.player.playbackEventStream.listen((event) {},
  //       onError: (Object e, StackTrace stackTrace) {
  //     print('A stream error occurred: $e');
  //   });
  //   // Try to load audio from a source and catch any errors.
  //   try {
  //     // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
  //     await widget.player
  //         .setAudioSource(AudioSource.uri(Uri.parse(widget.noteUrl)))
  //         .then((value) {
  //       setState(() {
  //         duration = value!;
  //       });
  //     }); // Load a remote audio file and play.
  //     widget.player.durationStream.listen((value) {
  //       setState(() {
  //         duration = value!;
  //       });
  //     });
  //     widget.player.positionStream.listen((event) {
  //       setState(() {
  //         position = event;
  //       });
  //     });
  //     widget.player.processingStateStream.listen((event) {
  //       if (event == ProcessingState.loading) {
  //         setState(() {
  //           isBuffering = true;
  //         });
  //       } else {
  //         setState(() {
  //           isBuffering = false;
  //         });
  //       }
  //     });
  //   } on PlayerException catch (e) {
  //     log("Error loading audio source: $e");
  //   }
  // }

  // playAudio() async {
  //   try {
  //     setState(() {
  //       isPlaying = true;
  //     });
  //     log("playing");
  //     final audioSource = LockCachingAudioSource(Uri.parse(widget.noteUrl));
  //     var da = await widget.player.setAudioSource(audioSource);

  //     await widget.player.play();
  //     _updatePlayedComment();
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // void _playAudio() async {
  //   if (isPlaying && _currentIndex != widget.currentIndex) {
  //     await widget.player.stop();
  //   }

  //   if (_currentIndex == widget.currentIndex && isPlaying) {
  //     widget.player.pause();
  //     setState(() {
  //       isPlaying = false;
  //     });
  //   } else {
  //     await widget.player.play();
  //     setState(() {
  //       _currentIndex = widget.currentIndex;
  //       isPlaying = true;
  //     });
  //   }
  // }

  // stopAudio() async {
  //   setState(() {
  //     isPlaying = false;
  //   });
  //   await widget.player.stop();
  // }

  // @override
  // void dispose() {
  //   widget.player.dispose();
  //   duration = Duration.zero;
  //   // position = Duration.zero;

  //   super.dispose();
  // }

  String getReverseDuration(Duration position, Duration totalDuration) {
    int remainingSeconds = totalDuration.inSeconds - position.inSeconds;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getInitialDurationnText(Duration totalDuration) {
    int remainingSeconds = totalDuration.inSeconds;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _updatePlayedComment() {
    if (widget.isComment) {
      int updateCommentCounter = widget.playedCounter ?? 0;
      updateCommentCounter++;
      FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.postId)
          .collection('comments')
          .doc(widget.commentId)
          .update({'playedComment': updateCommentCounter});
    }
  }

  @override
  Widget build(BuildContext context) {
    // log('Waveform: $doubleWaveformData');
    // checkAutoPlay();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Container(
          height: widget.mainHeight,
          width: widget.mainWidth,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(55),
          ),
          child: Row(
            children: [
              if (widget.isMainPlayer)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: widget.playPause,
                    child: Consumer<FilterProvider>(
                        builder: (context, filterPro, _) {
                      return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: filterPro.selectedFilter
                                    .contains('Close Friends')
                                ? greenColor
                                : widget.waveColor ?? primaryColor,
                            // border: Border.all(
                            //   color: widget.waveColor ?? primaryColor,
                            //   width: 2,
                            // ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          // onPressed: playPause,
                          child: widget.isPlaying
                              ? Icon(
                                  Icons.pause_outlined,
                                  color: whiteColor,
                                  size: 20,
                                )
                              // : _playerState == PlayerState.paused
                              //     ?
                              //  Icon(
                              //     Icons.pause_outlined,
                              //     color: whiteColor,
                              //     size: 20,
                              //   )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_arrow,
                                      color: whiteColor,
                                      size: 20,
                                    ),
                                  ],
                                ));
                    }),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: widget.playPause,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      // onPressed: playPause,
                      child: widget.changeIndex == widget.currentIndex &&
                              widget.isPlaying
                          ? Icon(
                              Icons.pause,
                              color: widget.backgroundColor,
                              size: widget.size,
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: widget.backgroundColor,
                                  size: widget.size,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child: Consumer<FilterProvider>(
                      builder: (context, filterPro, _) {
                    return WaveformProgressbar(
                      color: filterPro.selectedFilter.contains('Close Friends')
                          ? whiteColor.withOpacity(0.5)
                          : widget.isMainPlayer
                              ? primaryColor.withOpacity(0.5)
                              : widget.waveColor!.withOpacity(0.5),
                      // widget.waveColor == null
                      //     ? primaryColor
                      //     : widget.waveColor!,
                      progressColor:
                          filterPro.selectedFilter.contains('Close Friends')
                              ? whiteColor
                              : widget.isMainPlayer
                                  ? primaryColor
                                  : widget.waveColor ?? primaryColor,
                      // widget.waveColor == null
                      //     ? greenColor
                      //     : widget.waveColor!,
                      progress: widget.changeIndex == widget.currentIndex &&
                              widget.isPlaying
                          ? widget.position.inSeconds / duration.inSeconds
                          : 0.0,
                      onTap: (progress) {
                        Duration seekPosition = Duration(
                            seconds: (progress * duration.inSeconds).round());
                        // Duration seekPosition =
                        //     Duration(seconds: progress.toInt());
                        widget.player.seek(seekPosition);
                      },
                    );
                  })),
              const SizedBox(
                width: 10,
              ),
              Consumer<FilterProvider>(builder: (context, filterPro, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.position.inSeconds == 0
                        ? Text(
                            getInitialDurationnText(duration),
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 12,
                              color: filterPro.selectedFilter
                                      .contains('Close Friends')
                                  ? greenColor
                                  : widget.waveColor ?? primaryColor,
                            ),
                          )
                        : Text(
                            widget.changeIndex == widget.currentIndex &&
                                    widget.isPlaying
                                ? getReverseDuration(widget.position, duration)
                                : getInitialDurationnText(duration),
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 12,
                              color: filterPro.selectedFilter
                                      .contains('Close Friends')
                                  ? greenColor
                                  : widget.waveColor ?? primaryColor,
                            ),
                          ),
                    if (widget.waveColor == null)
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_playbackSpeed == 1.0) {
                              _playbackSpeed = 1.5;
                            } else if (_playbackSpeed == 1.5) {
                              _playbackSpeed = 2.0;
                            } else {
                              _playbackSpeed = 1.0;
                            }
                            // Set playback speed if audio is already playing
                            if (widget.isPlaying) {
                              widget.player.setPlaybackRate(_playbackSpeed);
                            }
                          });
                        },
                        child: Consumer<FilterProvider>(
                            builder: (context, filterPro, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                                color: filterPro.selectedFilter
                                        .contains('Close Friends')
                                    ? greenColor
                                    : primaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              '${_playbackSpeed}X',
                              style: TextStyle(
                                color: whiteColor,
                                fontFamily: fontFamily,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
