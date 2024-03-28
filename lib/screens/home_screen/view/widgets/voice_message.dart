import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:social_notes/screens/home_screen/model/comment_modal.dart';

class CircleVoiceNotes extends StatefulWidget {
  const CircleVoiceNotes(
      {Key? key, required this.commentModel, required this.index})
      : super(key: key);

  final CommentModel commentModel;
  final int index;

  @override
  State<CircleVoiceNotes> createState() => _CircleVoiceNotesState();
}

class _CircleVoiceNotesState extends State<CircleVoiceNotes> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration? duration;
  Duration? position;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSourceUrl(widget.commentModel.comment);

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
    await Future.delayed(Duration(seconds: 2));

    // Reset the like animation after 2 seconds
    setState(() {
      _isLiked = isAlreadyLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    double percent = position != null && duration != null
        ? position!.inSeconds / duration!.inSeconds
        : 0.0;

    return GestureDetector(
      onTap: playPause,
      onDoubleTap: _toggleLike,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 5.0,
              percent: percent,
              center: Container(
                width: 70,
                height: 71,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.commentModel.userImage),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: _isLiked
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 35,
                      )
                    : IconButton(
                        onPressed: playPause,
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.blue,
                          size: 35,
                        ),
                      ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: widget.index == 0
                  ? const Color(0xff50a87e)
                  : widget.index == 1
                      ? const Color(0xff6cbfd9)
                      : Colors.white,
              progressColor: Colors.green,
              animation: _isPlaying,
              animationDuration: duration == null ? 0 : duration!.inSeconds,
            ),
            Text(
              widget.commentModel.username,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
