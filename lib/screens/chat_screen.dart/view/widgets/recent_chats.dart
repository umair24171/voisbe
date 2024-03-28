import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/model/recent_chat_model.dart';

class RecentChats extends StatelessWidget {
  RecentChats({
    super.key,
  });
  List<RecentChatModel> recentChats = [];

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: 100,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<RecentChatModel> chatModel = snapshot.data!.docs
                    .map((e) => RecentChatModel.fromMap(e.data()))
                    .toList();
                recentChats.clear();
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  if (chatModel[i].senderId == user!.uid ||
                      chatModel[i].receiverId == user.uid) {
                    recentChats.add(chatModel[i]);
                  }
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: recentChats.length,
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45),
                                  border:
                                      Border.all(width: 3, color: greenColor)),
                              child: CircleAvatar(
                                  radius: 33,
                                  backgroundImage: NetworkImage(
                                      user!.uid == recentChats[index].senderId
                                          ? recentChats[index].receiverImage!
                                          : recentChats[index].senderImage!)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              user.uid == recentChats[index].senderId
                                  ? recentChats[index].receiverName!
                                  : recentChats[index].senderName!,
                              style: TextStyle(
                                  fontFamily: fontFamily, color: blackColor),
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return const Text('');
              }
            }),
      ),
    );
  }
}
