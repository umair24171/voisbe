import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/chat_screen.dart/model/chat_model.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
import 'package:voice_message_package/voice_message_package.dart';

class CustomMessageNote extends StatelessWidget {
  const CustomMessageNote(
      {super.key,
      required this.isMe,
      required this.isShare,
      required this.conversationId,
      required this.chatModel});
  final bool isMe;
  final bool isShare;
  final ChatModel chatModel;
  final String conversationId;

  @override
  Widget build(BuildContext context) {
    !isMe
        ? Provider.of<ChatProvider>(
            context,
          ).updateMessageRead(conversationId, chatModel.chatId)
        : '';
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
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: VoiceMessageView(
                // notActiveSliderColor: red,
                // circlesColor: isMe ? primaryColor : whiteColor,
                counterTextStyle:
                    TextStyle(color: isMe ? primaryColor : whiteColor),
                // circlesTextStyle: TextStyle(
                //     color: isMe
                //         ? whiteColor
                //         : isShare
                //             ? Colors.grey
                //             : primaryColor),
                activeSliderColor: isShare
                    ? whiteColor
                    : isMe
                        ? primaryColor
                        : whiteColor,
                // notActiveSliderColor: whiteColor,
                innerPadding: 16,
                cornerRadius: 50,
                backgroundColor: isShare
                    ? Colors.grey.withOpacity(0.7)
                    : isMe
                        ? whiteColor
                        : primaryColor,
                controller: VoiceController(
                  audioSrc: chatModel.message,
                  maxDuration: const Duration(seconds: 500),
                  isFile: false,
                  onComplete: () {},
                  onPause: () {},
                  onPlaying: () {},
                  onError: (err) {},
                ),
              ),
            ),
            !isMe
                ? Positioned(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(chatModel.avatarUrl),
                    ),
                  )
                : Positioned(
                    left: MediaQuery.of(context).size.width * 0.76,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(chatModel.avatarUrl),
                    ),
                  ),
            if (isShare)
              Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sent ',
                      style:
                          TextStyle(fontFamily: fontFamily, color: whiteColor),
                    ),
                    Text(
                      '@${chatModel.postOwner}',
                      style:
                          TextStyle(fontFamily: fontFamily, color: blackColor),
                    ),
                    Text(
                      '\'s thought',
                      style:
                          TextStyle(fontFamily: fontFamily, color: whiteColor),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
