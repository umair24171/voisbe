import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
// import 'package:social_notes/screens/chat_screen.dart/model/chat_model.dart';
import 'package:social_notes/screens/chat_screen.dart/model/recent_chat_model.dart';
import 'package:voice_message_package/voice_message_package.dart';

class SingleChatUser extends StatelessWidget {
  const SingleChatUser({super.key, required this.chatModel});
  final RecentChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    var currentUSer = Provider.of<UserProvider>(context, listen: false).user;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  chatModel.senderId! == currentUSer!.uid
                      ? chatModel.receiverImage!
                      : chatModel.senderImage!),
              radius: 17,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chatModel.senderId == currentUSer.uid
                          ? chatModel.receiverName!
                          : chatModel.senderName!,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    Text(
                      '${chatModel.time!.hour.round()}:${chatModel.time!.minute}',
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]),
                    ),
                  ],
                ),
                VoiceMessageView(
                  backgroundColor: primaryColor,
                  circlesColor: primaryColor,
                  cornerRadius: 50,
                  activeSliderColor: whiteColor,
                  innerPadding: 2,
                  controller: VoiceController(
                    audioSrc: chatModel.message!,
                    maxDuration: const Duration(seconds: 500),
                    isFile: false,
                    onComplete: () {},
                    onPause: () {},
                    onPlaying: () {},
                    onError: (err) {},
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, right: 4),
                child: Icon(Icons.check),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
