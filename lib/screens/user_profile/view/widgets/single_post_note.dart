// import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';

class SinglePostNote extends StatefulWidget {
  const SinglePostNote({super.key, required this.note, required this.isPinned});
  final NoteModel note;
  final bool isPinned;
  @override
  State<SinglePostNote> createState() => _SinglePostNoteState();
}

class _SinglePostNoteState extends State<SinglePostNote> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  PlayerState? _playerState;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.setSourceUrl(widget.note.noteUrl);
    _playerState = _audioPlayer.state;
    // _audioPlayer.getDuration().then(
    //       (value) => setState(() {
    //         duration = value;
    //       }),
    //     );
    // _audioPlayer.getCurrentPosition().then(
    //       (value) => setState(() {
    //         position = value;
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

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   getDuration();
  //   super.didChangeDependencies();
  // }

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
    setState(() async {
      _isPlaying = !_isPlaying;
      // duration = await _audioPlayer.getDuration();
    });
  }

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  getDuration() async {
    duration = (await _audioPlayer.getDuration())!;
    position = (await _audioPlayer.getCurrentPosition())!;
    setState(() {});
  }

  getPosition() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // getDuration();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircularPercentIndicator(
        radius: 44.0,
        lineWidth: 5.0,
        percent: position.inSeconds / duration.inSeconds,
        center: Container(
          width: 79,
          height: 79,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!widget.isPinned)
                const SizedBox(
                  height: 10,
                ),
              if (widget.isPinned)
                Icon(
                  Icons.push_pin,
                  color: primaryColor,
                  size: 12,
                ),
              IconButton(
                onPressed: playPause,
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: primaryColor,
                  size: 35,
                ),
              ),
              Text(
                '${position.inSeconds}:${duration.inSeconds}',
                style: TextStyle(
                    fontFamily: fontFamily, fontSize: 8, color: primaryColor),
              ),
            ],
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: whiteColor,
        progressColor: primaryColor,
        animation: _isPlaying,
        animationDuration: duration.inSeconds,
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 5),
    //   child: Stack(
    //     children: [
    //       Container(
    //         height: 140,
    //         width: 100,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(55),
    //           // border: Border.all(width: 3, color: primaryColor),
    //         ),
    //         child: CircleAvatar(
    //           radius: 35,
    //           backgroundColor: whiteColor,
    //         ),
    //       ),
    //       Positioned(
    //         top: 11,
    //         left: 15,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             // IconButton(
    //             //     onPressed: playPause,
    //             //     icon: Icon(
    //             //       _isPlaying
    //             //           ? Icons.pause_circle_filled
    //             //           : Icons.play_circle_fill,
    //             //       color: primaryColor,
    //             //       size: 35,
    //             //     )),
    //             Text(
    //               duration != null ? '${duration!.inSeconds}s' : '0s',
    //               style: TextStyle(
    //                   fontFamily: fontFamily, fontSize: 8, color: primaryColor),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Positioned(
    //         top: 0,
    //         left: 0,
    //         child: CircularPercentIndicator(
    //           radius: 50.0,
    //           lineWidth: 5.0,
    //           percent: position != null
    //               ? position!.inSeconds / duration!.inSeconds
    //               : 0.0,
    //           center: IconButton(
    //             onPressed: playPause,
    //             icon: Icon(
    //               _isPlaying
    //                   ? Icons.pause_circle_filled
    //                   : Icons.play_circle_fill,
    //               color: primaryColor,
    //               size: 35,
    //             ),
    //           ),
    //           circularStrokeCap: CircularStrokeCap.round,
    //           backgroundColor: Colors.grey,
    //           progressColor: Colors.blue,
    //           animation: _isPlaying,
    //           animationDuration: duration!.inSeconds,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
