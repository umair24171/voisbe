import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/view/chat_screen.dart';

class SearchUsers extends StatelessWidget {
  const SearchUsers({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              // flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: TextFormField(
                  // textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                        maxHeight: 35, maxWidth: size.width * 0.8),
                    fillColor: Colors.grey[300],
                    contentPadding: const EdgeInsets.only(bottom: 14),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: 'Search Users',
                    hintStyle:
                        TextStyle(fontFamily: fontFamily, color: Colors.grey),

                    // label: Text(
                    //   'Search Users',
                    //   style:
                    //       TextStyle(fontFamily: fontFamily, color: Colors.grey),
                    // ),
                  ),
                  onFieldSubmitted: (value) {
                    chatProvider.changeSearchStatus(true);
                    chatProvider.setSearchText(value);
                    for (int i = 0; i < chatProvider.users.length; i++) {
                      if (chatProvider.users[i].name.contains(value)) {
                        chatProvider.users.add(chatProvider.users[i]);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12),
        //     child: Icon(
        //       Icons.more_horiz,
        //       color: blackColor,
        //     ),
        //   ),
        // ],
      ),
      body: ListView.builder(
        itemCount: chatProvider.users.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receiverUser: chatProvider.users[index],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(chatProvider.users[index].photoUrl),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    chatProvider.users[index].username,
                    style: TextStyle(
                        color: blackColor,
                        fontFamily: fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
