import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/add_note_screen.dart/view/select_topic_screen.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          Container(
            alignment: Alignment.center,
            child: VoiceMessageView(
              activeSliderColor: primaryColor,
              // notActiveSliderColor: whiteColor,
              innerPadding: 18,
              cornerRadius: 50,
              backgroundColor: whiteColor,
              controller: VoiceController(
                audioSrc: 'https://dl.musichi.ir/1401/06/21/Ghors%202.mp3',
                maxDuration: const Duration(seconds: 0),
                isFile: false,
                onComplete: () {},
                onPause: () {},
                onPlaying: () {},
                onError: (err) {},
              ),
            ),
          ),
          Text(
            '-05:36 MIN',
            style: TextStyle(fontFamily: fontFamily, color: whiteColor),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size(115, 10),
                  ),
                ),
                onPressed: () {},
                label: Text(
                  'Optimize',
                  style: TextStyle(
                      color: blackColor, fontFamily: fontFamily, fontSize: 12),
                ),
                icon: Icon(
                  Icons.check,
                  color: blackColor,
                  size: 15,
                ),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(120, 10)),
                    backgroundColor: MaterialStatePropertyAll(blackColor)),
                onPressed: () {},
                label: Text(
                  'Add sounds',
                  style: TextStyle(
                      color: whiteColor, fontFamily: fontFamily, fontSize: 12),
                ),
                icon: Icon(
                  Icons.volume_up_sharp,
                  color: whiteColor,
                  size: 15,
                ),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(110, 10)),
                    backgroundColor: MaterialStatePropertyAll(blackColor)),
                onPressed: () {},
                label: Text(
                  'Add music',
                  style: TextStyle(
                      color: whiteColor, fontFamily: fontFamily, fontSize: 12),
                ),
                icon: Icon(
                  Icons.music_note_outlined,
                  color: whiteColor,
                  size: 15,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.mic_none_rounded,
                    color: primaryColor,
                    size: 40,
                  ))),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(blackColor),
                    fixedSize: const MaterialStatePropertyAll(
                      Size(115, 10),
                    ),
                  ),
                  onPressed: () {},
                  label: Text(
                    'Retake',
                    style: TextStyle(
                        color: whiteColor,
                        fontFamily: fontFamily,
                        fontSize: 12),
                  ),
                  icon: Icon(
                    Icons.restart_alt_rounded,
                    color: whiteColor,
                    size: 15,
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      fixedSize: const MaterialStatePropertyAll(Size(120, 10)),
                      backgroundColor: MaterialStatePropertyAll(blackColor)),
                  onPressed: () {},
                  label: Text(
                    'Tag people',
                    style: TextStyle(
                        color: whiteColor,
                        fontFamily: fontFamily,
                        fontSize: 12),
                  ),
                  icon: Icon(
                    Icons.people_sharp,
                    color: whiteColor,
                    size: 15,
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      fixedSize: const MaterialStatePropertyAll(Size(110, 10)),
                      backgroundColor: MaterialStatePropertyAll(whiteColor)),
                  onPressed: () {
                    navPush(SelectTopicScreen.routeName, context);
                  },
                  label: Text(
                    'Next',
                    style: TextStyle(
                        color: blackColor,
                        fontFamily: fontFamily,
                        fontSize: 12),
                  ),
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: blackColor,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
