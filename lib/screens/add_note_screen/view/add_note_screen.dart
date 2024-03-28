import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
// import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/add_note_screen/view/select_topic_screen.dart';
import 'package:social_notes/screens/add_note_screen/view/widgets/tag_users_modal_sheet.dart';
import 'package:social_notes/screens/upload_sounds/provider/sound_provider.dart';
import 'package:social_notes/screens/upload_sounds/view/add_sound.dart';
// import 'package:social_notes/screens/upload_sounds/view/upload_sound.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final TextEditingController titleController = TextEditingController();
    var noteProvider = Provider.of<NoteProvider>(context);
    var soundPro = Provider.of<SoundProvider>(context);
    noteProvider.initRecorder();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffee856d), Color(0xffed6a5a)])),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      label: Text(
                        'Add a title',
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: primaryColor),
                      ),
                      fillColor: whiteColor,
                      constraints: BoxConstraints(
                          maxWidth: size.width * 0.89,
                          maxHeight: size.width * 0.15),
                      filled: true,
                      contentPadding: const EdgeInsets.only(left: 20),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 13, right: 15),
                        child: Text(
                          'Mamimum 8 letters',
                          style: TextStyle(
                              fontFamily: fontFamily, color: Colors.grey),
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none)),
                ),
              ),
              Column(
                children: [
                  if (noteProvider.voiceNote != null)
                    Container(
                      alignment: Alignment.center,
                      child: VoiceMessageView(
                        activeSliderColor: primaryColor,
                        // notActiveSliderColor: whiteColor,
                        innerPadding: 18,
                        cornerRadius: 50,
                        backgroundColor: whiteColor,
                        controller: VoiceController(
                          audioSrc:
                              noteProvider.voiceNote!.path, // audio source path
                          maxDuration: const Duration(seconds: 500),
                          isFile: true,
                          onComplete: () {},
                          onPause: () {},
                          onPlaying: () {},
                          onError: (err) {},
                        ),
                      ),
                    ),
                  if (soundPro.voiceUrl != null)
                    Container(
                      alignment: Alignment.center,
                      child: VoiceMessageView(
                        activeSliderColor: primaryColor,
                        // notActiveSliderColor: whiteColor,
                        innerPadding: 18,
                        cornerRadius: 50,
                        backgroundColor: whiteColor,
                        controller: VoiceController(
                          audioSrc: soundPro.voiceUrl!, // audio source path
                          maxDuration: const Duration(seconds: 500),
                          isFile: false,
                          onComplete: () {},
                          onPause: () {},
                          onPlaying: () {},
                          onError: (err) {},
                        ),
                      ),
                    ),
                  if (noteProvider.voiceNote != null)
                    Text(
                      '-05:36 MIN',
                      style:
                          TextStyle(fontFamily: fontFamily, color: whiteColor),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(
                            Size(125, 8),
                          ),
                        ),
                        onPressed: () {},
                        label: Text(
                          'Optimize',
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        icon: Icon(
                          Icons.check,
                          color: blackColor,
                          // size: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            fixedSize:
                                const MaterialStatePropertyAll(Size(140, 8)),
                            backgroundColor:
                                MaterialStatePropertyAll(blackColor)),
                        onPressed: () {
                          showBottomSheet(
                            context: context,
                            builder: (context) {
                              return const AddSound();
                            },
                          );
                        },
                        label: Text(
                          'Add sounds',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                              fontFamily: fontFamily,
                              fontSize: 12),
                        ),
                        icon: Icon(
                          Icons.volume_up_sharp,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (soundPro.voiceUrl == null)
                GestureDetector(
                  onTap: () {
                    if (noteProvider.recoder.isRecording) {
                      noteProvider.stop();
                    } else {
                      noteProvider.record();
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: noteProvider.isRecording
                          ? Icon(
                              Icons.stop,
                              color: primaryColor,
                            )
                          : Image.asset(
                              'assets/images/recording_inprogress.png',
                              height: 50,
                              width: 50,
                            )),
                ),
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
                      onPressed: () {
                        noteProvider.removeVoiceNote();
                        soundPro.removeVoiceUrl();
                      },
                      label: Text(
                        'Retake',
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: fontFamily,
                            fontSize: 12),
                      ),
                      icon: Image.asset(
                        'assets/images/retake.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          fixedSize:
                              const MaterialStatePropertyAll(Size(120, 10)),
                          backgroundColor:
                              MaterialStatePropertyAll(blackColor)),
                      onPressed: () {
                        showBottomSheet(
                          context: context,
                          builder: (context) {
                            return TagUsersModalSheet();
                          },
                        );
                      },
                      label: Text(
                        'Tag people',
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: fontFamily,
                            fontSize: 12),
                      ),
                      icon: Image.asset(
                        'assets/images/tagpeople_white.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          fixedSize:
                              const MaterialStatePropertyAll(Size(110, 10)),
                          backgroundColor:
                              MaterialStatePropertyAll(whiteColor)),
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            (noteProvider.voiceNote != null ||
                                soundPro.voiceUrl != null)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectTopicScreen(
                                  title: titleController.text,
                                  taggedPeople: [],
                                ),
                              ));
                        }
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
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
