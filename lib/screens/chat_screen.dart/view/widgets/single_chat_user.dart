import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
// import 'package:social_notes/screens/chat_screen.dart/model/chat_model.dart';
import 'package:social_notes/screens/chat_screen.dart/model/recent_chat_model.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_player.dart';
import 'package:intl/intl.dart';

class SingleChatUser extends StatelessWidget {
  const SingleChatUser(
      {super.key,
      required this.chatModel,
      required this.color,
      required this.index,
      required this.allMessgaesIndex,
      required this.messageReqIndex,
      required this.isSearching,
      required this.isSeen});
  final RecentChatModel chatModel;
  final Color color;
  final bool isSeen;
  final int index;
  final List<int> allMessgaesIndex;
  final List<int> messageReqIndex;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    var currentUSer = Provider.of<UserProvider>(context, listen: false).user;
    String formattedTime = DateFormat('hh:mm').format(chatModel.time!);
    // if (formattedTime.startsWith('0')) {
    //   formattedTime = formattedTime.replaceFirst('0', '12');
    // }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(width: 3, color: color)),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    chatModel.senderId! == currentUSer!.uid
                        ? chatModel.receiverImage!
                        : chatModel.senderImage!),
                radius: 17,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      chatModel.senderId == currentUSer.uid
                          ? chatModel.receiverName!
                          : chatModel.senderName!,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                  ),
                  Text(
                    formattedTime,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
              CustomProgressPlayer(
                  size: 10,
                  waveColor: whiteColor,
                  backgroundColor: color,
                  noteUrl: chatModel.message!,
                  height: 25,
                  width: 160,
                  mainWidth: 260,
                  mainHeight: 42),
              // VoiceMessageView(
              //   backgroundColor: color,
              //   circlesColor: primaryColor,
              //   size: 40,
              //   cornerRadius: 50,
              //   activeSliderColor: whiteColor,
              //   innerPadding: 2,
              //   controller: VoiceController(
              //     audioSrc: chatModel.message!,
              //     maxDuration: const Duration(seconds: 500),
              //     isFile: false,
              //     onComplete: () {},
              //     onPause: () {},
              //     onPlaying: () {},
              //     onError: (err) {},
              //   ),
              // ),
            ],
          ),
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 4),
                child: Icon(
                  isSeen ? Icons.done_all : Icons.done,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
