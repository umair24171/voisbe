// import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:simple_waveform_progressbar/simple_waveform_progressbar.dart';
import 'package:social_notes/resources/colors.dart';

class CustomProgressPlayer extends StatefulWidget {
  const CustomProgressPlayer({
    Key? key,
    required this.noteUrl,
    required this.height,
    required this.width,
    required this.mainWidth,
    required this.mainHeight,
    this.backgroundColor = Colors.white,
  }) : super(key: key);
  final String noteUrl;
  final double height;
  final double width;
  final double mainWidth;
  final double mainHeight;
  final Color backgroundColor;
  @override
  State<CustomProgressPlayer> createState() => _CustomProgressPlayerState();
}

class _CustomProgressPlayerState extends State<CustomProgressPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  PlayerState? _playerState;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.setSourceUrl(widget.noteUrl);
    _playerState = _audioPlayer.state;

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

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void playPause() async {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                onPressed: playPause,
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.red,
                  size: 35,
                ),
              ),
              SizedBox(
                height: widget.height,
                width: widget.width,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: duration,
                  builder: (context, progress, child) {
                    final color = duration.inSeconds > 0
                        ? Color.lerp(primaryColor, Colors.black,
                            position.inSeconds / duration.inSeconds)!
                        : primaryColor;
                    return WaveformProgressbar(
                      color: primaryColor,
                      progressColor: color,
                      progress: duration.inSeconds / position.inSeconds,
                      onTap: (progress) {
                        var tt = progress;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '${position.inSeconds}:${duration.inSeconds}',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 14,
                  color: primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForProgress(double progress) {
    if (progress == 1.0) {
      return Colors.black;
    } else {
      return primaryColor;
    }
  }
}
