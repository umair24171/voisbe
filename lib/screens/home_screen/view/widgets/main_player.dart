// import 'dart:developer';

import 'dart:async';
// import 'dart:developer';

// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:simple_waveform_progressbar/simple_waveform_progressbar.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/home_screen/provider/filter_provider.dart';

class MainPlayer extends StatefulWidget {
  MainPlayer(
      {Key? key,
      required this.noteUrl,
      required this.height,
      required this.width,
      required this.mainWidth,
      required this.mainHeight,
      this.backgroundColor = Colors.white,
      this.size = 35,
      this.isComment = false,
      this.isMainPlayer = false,
      this.commentId,
      this.postId,
      this.playedCounter,
      this.onPlayStateChanged,
      this.pageController,
      required this.isPlaying,
      this.currentIndex,
      this.waveColor,
      required this.postIndex})
      : super(key: key);

  final String noteUrl;
  final double height;
  final double width;
  final double mainWidth;
  final double mainHeight;
  final Color backgroundColor;
  final int postIndex;

  double size;
  int? playedCounter;
  Color? waveColor;
  bool isComment;
  String? commentId;
  String? postId;
  bool isMainPlayer;
  PageController? pageController;
  final Function(bool)? onPlayStateChanged;
  bool isPlaying;

  int? currentIndex;
  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer> {
//   final _player = AudioPlayer();
//   bool isPlaying = false;
//   bool isBuffering = false;
//   double _playbackSpeed = 1.0;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();

//     // ambiguate(WidgetsBinding.instance)!
//     //     .addObserver(this as WidgetsBindingObserver);
//     // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     //   statusBarColor: Colors.black,
//     // ));
//     _init();
//     // _player.playingStream.listen((event) {
//     //   if (event == true) {
//     //     setState(() {
//     //       isPlaying = true;
//     //     });
//     //   }
//     // });

//     _player.playerStateStream.listen((event) {
//       if (event.processingState == ProcessingState.completed) {
//         setState(() {
//           isPlaying = false;
//           // duration = Duration.zero;
//           // position = Duration.zero;
//         });
//       }
//     });
//     _player.playingStream.listen((event) {
//       if (event == true) {
//         setState(() {
//           isPlaying = true;
//         });
//       } else {
//         setState(() {
//           isPlaying = false;
//         });
//       }
//     });
//     if (widget.isMainPlayer) {
//       widget.pageController!.addListener(() {
//         if (widget.currentIndex == widget.pageController!.page!.round()) {
//           _player.play();
//           // setState(() {
//           //   _isPlaying = true;
//           // });
//         } else {
//           _player.pause();
//           // setState(() {
//           //   _isPlaying = false;
//           // });
//         }
//       });
//     }
//     // _player?.duration
//   }

//   Future<void> _init() async {
//     // Inform the operating system of our app's audio attributes etc.
//     // We pick a reasonable default for an app that plays speech.
//     // final session = await AudioSession.instance;
//     // await session.configure(const AudioSessionConfiguration.speech());
//     // Listen to errors during playback.
//     _player.playbackEventStream.listen((event) {},
//         onError: (Object e, StackTrace stackTrace) {
//       print('A stream error occurred: $e');
//     });
//     // Try to load audio from a source and catch any errors.
//     try {
//       // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
//       final audioSource = LockCachingAudioSource(Uri.parse(widget.noteUrl));
//       if (audioSource.duration != null) {
//         await _player.setAudioSource(audioSource).then((value) {
//           setState(() {
//             duration = value!;
//           });
//         });
//       } else {
//         await _player
//             .setAudioSource(AudioSource.uri(Uri.parse(widget.noteUrl)))
//             .then((value) {
//           setState(() {
//             duration = value!;
//           });
//         });
//       } // Load a remote audio file and play.
//       _player.durationStream.listen((value) {
//         setState(() {
//           duration = value!;
//         });
//       });
//       _player.positionStream.listen((event) {
//         setState(() {
//           position = event;
//         });
//       });
//       _player.processingStateStream.listen((event) {
//         if (event == ProcessingState.loading) {
//           setState(() {
//             isBuffering = true;
//           });
//         } else {
//           setState(() {
//             isBuffering = false;
//           });
//         }
//       });
//     } on PlayerException catch (e) {
//       print("Error loading audio source: $e");
//     }
//   }

//   playAudio() async {
//     try {
//       setState(() {
//         isPlaying = true;
//       });
//       log("playing");
// final audioSource = LockCachingAudioSource(Uri.parse(widget.noteUrl));
//       var da = await _player.setAudioSource(audioSource);
//       await _player.play();
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   stopAudio() async {
//     setState(() {
//       isPlaying = false;
//     });
//     await _player.stop();
//   }
  late AudioPlayer _audioPlayer;
  String? _cachedFilePath;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  PlayerState? _playerState;
  bool _isMounted = false;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    initPlayer();
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      autoPlayFunction();
    });
    super.initState();
  }

  autoPlayFunction() {
    debugPrint("hello current index ${widget.currentIndex}");
    debugPrint("hello mic test ${widget.postIndex}");
    int index = widget.currentIndex! - 1;
    if (index == widget.postIndex) {
      if (_cachedFilePath != null) {
        _audioPlayer.setPlaybackRate(_playbackSpeed);
        _audioPlayer.play(UrlSource(_cachedFilePath!));
        // _updatePlayedComment();
      } else {
        DefaultCacheManager().downloadFile(widget.noteUrl).then((fileInfo) {
          if (fileInfo != null && fileInfo.file.existsSync()) {
            _cachedFilePath = fileInfo.file.path;
            _audioPlayer.setPlaybackRate(_playbackSpeed);
            _audioPlayer.play(
              UrlSource(_cachedFilePath!),
            );
          }
        });
      }
      widget.isPlaying = true;
      _isPlaying = true;
      // setState(() {
      //   _isPlaying = true;
      // });
    } else {
      _audioPlayer.pause();
      widget.isPlaying = false;
      _isPlaying = false;

      // setState(() {
      //   _isPlaying = false;
      // });
    }
    // _audioPlayer.onPlayerComplete.listen((state) {
    //   _isPlaying = false;
    //   widget.isPlaying = _isPlaying;
    // });
  }

  initPlayer() async {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.setSourceUrl(widget.noteUrl).then((value) {
      _audioPlayer.getDuration().then(
            (value) => setState(() {
              duration = value!;
              if (widget.currentIndex == widget.postIndex) {
                playPause();
              }
            }),
          );
    });

    // _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // Check if the file is already cached
    DefaultCacheManager().getFileFromCache(widget.noteUrl).then((file) {
      if (file != null && file.file.existsSync()) {
        _cachedFilePath = file.file.path;
      }
    });
    // _audioPlayer.getCurrentPosition().then(
    //       (value) => setState(() {
    //         position = value!;
    //       }),
    //     );
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    _audioPlayer.onPlayerComplete.listen((state) {
      setState(() {
        _isPlaying = false;
        widget.isPlaying = _isPlaying;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          _isPlaying = true;
          widget.isPlaying = _isPlaying;
        });
      } else {
        setState(() {
          _isPlaying = false;
          // widget.isPlaying = _isPlaying;
        }); // Notify parent widget
      }
    });
  }

  void _initStreams() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => duration = duration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen(
      (p) => setState(() => position = p),
    );

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        position = Duration.zero;
        widget.isPlaying = false;
        _isPlaying = false;
      });
    });

    _playerStateChangeSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
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
  void dispose() {
    _isMounted = false; // Update flag
    _audioPlayer.dispose();
    _playerStateChangeSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();

    super.dispose();
  }

  void playPause() async {
    if (!mounted) return;

    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      if (_cachedFilePath != null) {
        await _audioPlayer.setPlaybackRate(_playbackSpeed);
        await _audioPlayer.play(UrlSource(_cachedFilePath!));
        // _updatePlayedComment();
      } else {
        DefaultCacheManager().downloadFile(widget.noteUrl).then((fileInfo) {
          if (fileInfo != null && fileInfo.file.existsSync()) {
            _cachedFilePath = fileInfo.file.path;
            _audioPlayer.setPlaybackRate(_playbackSpeed);
            _audioPlayer.play(
              UrlSource(_cachedFilePath!),
            );
          }
        });
      }
    }

    if (!mounted) return;

    setState(() {
      _isPlaying = !_isPlaying;
      _playerState = _isPlaying ? PlayerState.playing : PlayerState.paused;
      widget.isPlaying = _isPlaying;
    });
  }

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

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Release the player's resources when not in use. We use "stop" so that
  //     // if the app resumes later, it will still remember what position to
  //     // resume from.
  //     _player.stop();
  //   }
  // }

  // @override
  // void dispose() {
  //   _audioPlayer.dispose();
  //   super.dispose();
  // }

  // Stream<PositionData> get _positionDataStream =>
  //     Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //         _player.positionStream,
  //         _player.bufferedPositionStream,
  //         _player.durationStream,
  //         (position, bufferedPosition, duration) => PositionData(
  //             position, bufferedPosition, duration ?? Duration.zero));

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
                    onTap: playPause,
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
                          child: _isPlaying
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
                    onTap: playPause,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      // onPressed: playPause,
                      child:
                          // ? Icon(
                          //     Icons.pause,
                          //     color: widget.backgroundColor,
                          //     size: widget.size,
                          //   )
                          // :
                          Stack(
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
                  child:
                      //  TweenAnimationBuilder<double>(
                      //   tween: Tween<double>(begin: 0.0, end: 1.0),
                      //   duration: duration,
                      //   builder: (context, tweenProgress, child) {
                      //     double progress = position.inSeconds / duration.inSeconds;
                      //     final color = duration.inSeconds > 0
                      //         ? Color.lerp(primaryColor, Colors.black, progress)!
                      //         : primaryColor;
                      //     return
                      Consumer<FilterProvider>(
                          builder: (context, filterPro, _) {
                    return WaveformProgressbar(
                      color: filterPro.selectedFilter.contains('Close Friends')
                          ? greenColor.withOpacity(0.5)
                          : widget.isMainPlayer
                              ? primaryColor.withOpacity(0.5)
                              : widget.waveColor!.withOpacity(0.5),
                      // widget.waveColor == null
                      //     ? primaryColor
                      //     : widget.waveColor!,
                      progressColor:
                          filterPro.selectedFilter.contains('Close Friends')
                              ? greenColor
                              : widget.isMainPlayer
                                  ? primaryColor
                                  : widget.waveColor ?? primaryColor,
                      // widget.waveColor == null
                      //     ? greenColor
                      //     : widget.waveColor!,
                      progress: position.inSeconds / duration.inSeconds,
                      onTap: (progress) {
                        // if (_cachedFilePath != null) {
                        Duration seekPosition = Duration(
                            seconds: (progress * duration.inSeconds).round());
                        // Duration seekPosition =
                        //     Duration(seconds: progress.toInt());
                        _audioPlayer.seek(seekPosition);
                        // }
                      },
                    );
                  })
                  //     CustomPaint(
                  //   painter: PlayerWavePainter(
                  //     waveformData: doubleWaveformData.map((e) => e / 1).toList(),
                  //     showTop: true,
                  //     showBottom: true,
                  //     animValue: 1,
                  //     scaleFactor: 2,
                  //     waveColor: widget.waveColor ?? primaryColor,
                  //     waveCap: StrokeCap.round,
                  //     waveThickness: 2,
                  //     dragOffset: const Offset(-30, 6),
                  //     totalBackDistance: Offset.zero,
                  //     spacing: 4,
                  //     audioProgress: position.inSeconds /
                  //         duration.inSeconds /
                  //         duration.inSeconds,
                  //     liveWaveColor: greenColor,
                  //     pushBack: () {},
                  //     callPushback: false,
                  //     scrollScale: 1,
                  //     seekLineThickness: 2.0,
                  //     seekLineColor: primaryColor,
                  //     showSeekLine: false,
                  //     waveformType: audi.WaveformType.fitWidth,
                  //     cachedAudioProgress:
                  //         position.inSeconds / duration.inSeconds,
                  //     liveWaveGradient: null,
                  //     fixedWaveGradient: null,
                  //   ),
                  // ),

                  //   },
                  // ),
                  ),
              const SizedBox(
                width: 10,
              ),
              Consumer<FilterProvider>(builder: (context, filterPro, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    position.inSeconds == 0
                        ? Text(
                            // '${duration.inSeconds ~/ 60}:${duration.inSeconds % 60}',
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
                            getReverseDuration(position, duration),
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 12,
                              color: filterPro.selectedFilter
                                      .contains('Close Friends')
                                  ? greenColor
                                  : widget.waveColor ?? primaryColor,
                            ),
                          ),
                    const SizedBox(height: 5),
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
                            if (_isPlaying) {
                              _audioPlayer.setPlaybackRate(_playbackSpeed);
                            }
                          });
                        },
                        child: Consumer<FilterProvider>(
                            builder: (context, filterPro, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            decoration: BoxDecoration(
                                color: filterPro.selectedFilter
                                        .contains('Close Friends')
                                    ? greenColor
                                    : primaryColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: Text(
                              '${_playbackSpeed.toDouble()}X',
                              // '',
                              style: TextStyle(
                                color: whiteColor,
                                fontFamily: fontFamily,
                                // fontWeight: FontWeight.w600,

                                fontSize: 10,
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
