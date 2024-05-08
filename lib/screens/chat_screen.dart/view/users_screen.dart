// import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/auth_screens/view/auth_screen.dart';
// import 'package:social_notes/screens/chat_screen.dart/model/chat_model.dart';

import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/view/chat_screen.dart';
import 'package:social_notes/screens/chat_screen.dart/view/search_users.dart';
import 'package:social_notes/screens/chat_screen.dart/view/widgets/recent_chats.dart';
import 'package:social_notes/screens/chat_screen.dart/view/widgets/single_chat_user.dart';
import 'package:social_notes/screens/custom_bottom_bar.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).getAllUsersForChat();
    Provider.of<ChatProvider>(context, listen: false).getRecentChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var reqPro = Provider.of<ChatProvider>(context, listen: false);

    var user = Provider.of<UserProvider>(context, listen: false).user;
    var allMessages = reqPro.recentChats.where((chat) {
      // Check if the sender ID is in the current user's followers
      return user!.followers.contains(
          chat.senderId == user.uid ? chat.receiverId : chat.senderId);
    }).toList();

    // var messageRequests = reqPro.recentChats.where((chat) {
    //   // Check if the sender ID is not in the current user's followers
    //   return !user!.followers.contains(
    //       chat.senderId == user.uid ? chat.receiverId : chat.senderId);
    // }).toList();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, BottomBar.routeName);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ),
        ),
        titleSpacing: 0,
        title: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 250,
                    decoration: const BoxDecoration(
                        color: Color(0xff11232f),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: whiteColor,
                                )),
                          ),
                          Consumer<UserProfileProvider>(
                              builder: (context, provider, _) {
                            return Expanded(
                              child: Card(
                                color: blackColor.withOpacity(0.2),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: provider.userAccounts.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 6),
                                        child: InkWell(
                                          onTap: () async {
                                            FirebaseAuth auth =
                                                FirebaseAuth.instance;
                                            UserCredential credential =
                                                await auth
                                                    .signInWithEmailAndPassword(
                                                        email: provider
                                                            .userAccounts[index]
                                                            .email,
                                                        password: provider
                                                            .userAccounts[index]
                                                            .password);
                                            if (credential.user != null) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BottomBar()),
                                                  (route) => false);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    provider.userAccounts[index]
                                                        .profileImage),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                provider
                                                    .userAccounts[index].name,
                                                style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    color: whiteColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return AuthScreen();
                                  },
                                ));
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: whiteColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add VOISBE account',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: fontFamily),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Row(
            children: [
              Text(
                user!.name,
                style: TextStyle(
                    color: blackColor,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600),
              ),
              if (user.isVerified)
                Image.network(
                  'https://media.istockphoto.com/id/1396933001/vector/vector-blue-verified-badge.jpg?s=612x612&w=0&k=20&c=aBJ2JAzbOfQpv2OCSr0k8kYe0XHutOGBAJuVjvWvPrQ=',
                  height: 20,
                  width: 20,
                ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: blackColor,
              )
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchUsers(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                'assets/images/message_icon.jpeg',
                height: 20,
                width: 20,
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: TextFormField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  reqPro.changeSearchStatus(true);
                  reqPro.searchedChats.clear();
                  for (var recentChat in allMessages) {
                    if (recentChat.senderName!
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        recentChat.receiverName!
                            .toLowerCase()
                            .contains(value.toLowerCase())) {
                      reqPro.searchedChats.add(recentChat);
                      break;
                    }
                  }
                } else {
                  reqPro.changeSearchStatus(false);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search',
                contentPadding: const EdgeInsets.only(top: 1, bottom: 5),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                ),
                fillColor: Colors.grey[300],
                filled: true,
                constraints: BoxConstraints(
                  maxHeight: 40,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 15),
            child: Text(
              'Recent Chats',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 22,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          RecentChats(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    reqPro.changeMessageReqStatus(false);
                  },
                  child: Consumer<ChatProvider>(builder: (context, chat, _) {
                    // var allMesag = chat.recentChats.where((chat) {
                    //   // Check if the sender ID is in the current user's followers
                    //   return user.followers.contains(chat.senderId == user.uid
                    //       ? chat.receiverId
                    //       : chat.senderId);
                    // }).toList();
                    var allMesag = chat.recentChats.where((chat) {
                      // Check if the sender ID is in the current user's followers
                      return user.followers.contains(chat.senderId == user.uid
                              ? chat.receiverId
                              : chat.senderId) ||
                          chat.senderId == user.uid;
                    }).toList();

                    return Text(
                      'All Messages (${allMesag.length})',
                      style: TextStyle(
                          color:
                              chat.isMessageReq ? Colors.grey[600] : blackColor,
                          fontFamily: fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
                InkWell(
                  onTap: () => reqPro.changeMessageReqStatus(true),
                  child: Consumer<ChatProvider>(builder: (context, chat, _) {
                    var messageReq = chat.recentChats.where((chat) {
                      // Check if the sender ID is not in the current user's followers
                      return !user.followers.contains(chat.senderId == user.uid
                              ? chat.receiverId
                              : chat.senderId) &&
                          chat.senderId != user.uid;
                    }).toList();
                    // messageReq
                    //     .removeWhere((element) => element.senderId == user.uid);
                    return Text(
                      'Message Requests (${messageReq.length})',
                      style: TextStyle(
                          color:
                              chat.isMessageReq ? blackColor : Colors.grey[600],
                          fontSize: 16,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
              child: Consumer<ChatProvider>(builder: (context, chatPro, _) {
            List<int> allMessagesIndex = [];
            List<int> messageRequestsIndex = [];

            for (int i = 0; i < chatPro.recentChats.length; i++) {
              if (user.followers.contains(
                  chatPro.recentChats[i].senderId == user.uid
                      ? chatPro.recentChats[i].receiverId
                      : chatPro.recentChats[i].senderId)) {
                allMessagesIndex.add(i);
              } else {
                messageRequestsIndex.add(i);
              }
            }

            var allMessages = chatPro.recentChats.where((chat) {
              // Check if the sender ID is in the current user's followers
              return user.followers.contains(chat.senderId == user.uid
                      ? chat.receiverId
                      : chat.senderId) ||
                  chat.senderId == user.uid;
            }).toList();

            // var messageRequests = chatPro.recentChats.where((chat) {
            //   // Check if the sender ID is not in the current user's followers
            //   return !user.followers.contains(
            //       chat.senderId == user.uid ? chat.receiverId : chat.senderId);
            // }).toList();
            var messageRequests = chatPro.recentChats.where((chat) {
              // Check if the sender ID is not in the current user's followers
              return !user.followers.contains(chat.senderId == user.uid
                      ? chat.receiverId
                      : chat.senderId) &&
                  chat.senderId != user.uid;
            }).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: reqPro.isSearching
                  ? reqPro.searchedChats.length
                  : chatPro.isMessageReq
                      ? messageRequests.length
                      : allMessages.length,
              itemBuilder: (context, index) {
                bool isSeen = false;
                if (reqPro.isSearching) {
                  isSeen = chatPro.searchedChats[index].seen!;
                } else if (chatPro.isMessageReq) {
                  isSeen = messageRequests[index].seen!;
                } else {
                  isSeen = allMessages[index].seen!;
                }
                var recentChats = reqPro.isSearching
                    ? reqPro.searchedChats
                    : chatPro.isMessageReq
                        ? messageRequests
                        : allMessages;

                var rec = recentChats[index].senderId == user.uid
                    ? recentChats[index].receiverId
                    : recentChats[index].senderId;
                var recName = recentChats[index].senderId == user.uid
                    ? recentChats[index].receiverName
                    : recentChats[index].senderName;
                var recPhotoUrl = recentChats[index].senderId == user.uid
                    ? recentChats[index].receiverImage
                    : recentChats[index].senderImage;
                var recToken = recentChats[index].senderId == user.uid
                    ? recentChats[index].receiverToken
                    : recentChats[index].senderToken;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                receiverId: rec,
                                receiverName: recName,
                                receiverPhotoUrl: recPhotoUrl,
                                rectoken: recToken,
                              )),
                    );
                  },
                  child: SingleChatUser(
                      chatModel: recentChats[index],
                      isSearching: reqPro.isSearching,
                      messageReqIndex: messageRequestsIndex,
                      index: index,
                      allMessgaesIndex: allMessagesIndex,
                      color: messageRequestsIndex.contains(index)
                          ? primaryColor
                          : color20,
                      isSeen: isSeen),
                );
              },
            );
          }))
        ],
      ),
    );
  }
}
