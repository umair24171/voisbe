import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/chat_screen.dart/view/widgets/custom_message_note.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: blackColor,
            )),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'jamiejones',
                  style: TextStyle(
                      fontFamily: fontFamily,
                      color: blackColor,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Business chat',
                  style: TextStyle(
                      fontFamily: fontFamily, color: Colors.grey, fontSize: 13),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.discount_outlined))
        ],
      ),
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Container(
              height: size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'))),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.1), // Transparent color
              ),
            ),
            SizedBox(
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Dec 11 AT 4:37 PM',
                          style: TextStyle(color: whiteColor),
                        ),
                        const CustomMessageNote(
                          isShare: true,
                          isMe: false,
                        ),
                        const CustomMessageNote(
                          isShare: false,
                          isMe: false,
                        ),
                        const CustomMessageNote(
                          isShare: false,
                          isMe: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 130,
                    decoration: BoxDecoration(color: whiteColor),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '❤️',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                              Text(
                                '🙌',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                              Text(
                                '🔥',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                              Text(
                                '👏',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                              Text(
                                '😥',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                              Text(
                                '😍',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                              Text(
                                '😮',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                              Text(
                                '😂',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: fontFamily),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text(
                                          'Add a reply',
                                          style: TextStyle(
                                              fontFamily: fontFamily,
                                              color: Colors.grey,
                                              fontSize: 13),
                                        ),
                                        suffixIcon: Icon(
                                          Icons.mic,
                                          color: blackColor,
                                          size: 30,
                                        ),
                                        constraints:
                                            const BoxConstraints(maxHeight: 50),
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(19)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(19))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
