import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:voice_message_package/voice_message_package.dart';

class CustomMessageNote extends StatelessWidget {
  const CustomMessageNote(
      {super.key, required this.isMe, required this.isShare});
  final bool isMe;
  final bool isShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isShare
          ? Alignment.centerLeft
          : isMe
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: VoiceMessageView(
                activeSliderColor: isShare
                    ? whiteColor
                    : isMe
                        ? primaryColor
                        : whiteColor,
                // notActiveSliderColor: whiteColor,
                innerPadding: 18,
                cornerRadius: 50,
                backgroundColor: isShare
                    ? Colors.grey
                    : isMe
                        ? whiteColor
                        : primaryColor,
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
            const Positioned(
                child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
            ))
          ],
        ),
      ),
    );
  }
}
