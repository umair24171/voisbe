import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/chat_screen.dart/model/chat_model.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/view/widgets/chat_player.dart';
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
                child: ChatPlayer(
                    noteUrl: chatModel.message,
                    height: 40,
                    width: 180,
                    size: 35,
                    mainWidth: 300,
                    waveColor: isShare
                        ? whiteColor
                        : isMe
                            ? primaryColor
                            : whiteColor,
                    backgroundColor: isShare
                        ? Colors.grey.withOpacity(0.7)
                        : isMe
                            ? whiteColor
                            : primaryColor,
                    mainHeight: 95)
                // VoiceMessageView(
                //   // notActiveSliderColor: red,
                //   // circlesColor: isMe ? primaryColor : whiteColor,
                //   counterTextStyle:
                //       TextStyle(color: isMe ? primaryColor : whiteColor),
                //   // circlesTextStyle: TextStyle(
                //   //     color: isMe
                //   //         ? whiteColor
                //   //         : isShare
                //   //             ? Colors.grey
                //   //             : primaryColor),
                //   activeSliderColor: isShare
                //       ? whiteColor
                //       : isMe
                //           ? primaryColor
                //           : whiteColor,
                //   // notActiveSliderColor: whiteColor,
                //   innerPadding: 16,
                //   cornerRadius: 50,
                // backgroundColor: isShare
                //     ? Colors.grey.withOpacity(0.7)
                //     : isMe
                //         ? whiteColor
                //         : primaryColor,
                //   controller: VoiceController(
                //     audioSrc: chatModel.message,
                //     maxDuration: const Duration(seconds: 500),
                //     isFile: false,
                //     onComplete: () {},
                //     onPause: () {},
                //     onPlaying: () {},
                //     onError: (err) {},
                //   ),
                // ),
                ),
            !isMe || isShare
                ? Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isShare
                              ? Colors.grey.withOpacity(0.7)
                              : whiteColor,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundImage: NetworkImage(chatModel.avatarUrl),
                      ),
                    ),
                  )
                : Positioned(
                    left: MediaQuery.of(context).size.width * 0.74,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundImage: NetworkImage(chatModel.avatarUrl),
                      ),
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
