import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/search_screen/view/note_details_screen.dart';
import 'package:social_notes/screens/user_profile/other_user_profile.dart';

class SingleSearchItem extends StatefulWidget {
  const SingleSearchItem(
      {super.key, required this.noteModel, required this.index});
  final NoteModel noteModel;
  final int index;

  @override
  State<SingleSearchItem> createState() => _SingleSearchItemState();
}

class _SingleSearchItemState extends State<SingleSearchItem> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSourceUrl(widget.noteModel.noteUrl);
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {});
    });
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {});
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

  void playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      // _audioPlayer.seek(Duration.zero);
      _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Duration? duration;
  // getDuration() async {
  //   duration = await _audioPlayer.getDuration();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.2,
      width: size.width * 0.5,
      child: Stack(
        children: [
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherUserProfile(
                        userId: widget.noteModel.userUid,
                      ),
                    ));
              },
              child: Image.network(
                widget.noteModel.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 54,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: IconButton(
                onPressed: playPause,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_arrow,
                  color: widget.index == 0
                      ? Colors.red
                      : widget.index == 1
                          ? greenColor
                          : color7,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                              color: widget.index == 0
                                  ? primaryColor
                                  : widget.index == 1
                                      ? greenColor
                                      : color7,
                              borderRadius: BorderRadius.circular(18)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          child: Text(
                            widget.noteModel.topic,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: a,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 11,
                                color: whiteColor),
                          )),
                    ),
                    Positioned(
                        left: size.width * 0.28,
                        top: 8,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteDetailsScreen(
                                      size: size, note: widget.noteModel),
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            decoration: BoxDecoration(
                                // boxShadow: const [
                                //   BoxShadow(
                                //       color: Color(0xffcf4836),
                                //       blurRadius: 4,
                                //       spreadRadius: 1)
                                // ],
                                color: whiteColor.withOpacity(1),
                                borderRadius: BorderRadius.circular(18)),
                            child: Text(
                              'View Post',
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 11,
                                  color: widget.index == 0
                                      ? primaryColor
                                      : widget.index == 1
                                          ? greenColor
                                          : color7),
                            ),
                          ),
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
