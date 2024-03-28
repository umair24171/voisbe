import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
// import 'package:social_notes/screens/add_note_screen.dart/controllers/add_note_controller.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';

class TagUsersModalSheet extends StatelessWidget {
  const TagUsersModalSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var allUsers = Provider.of<ChatProvider>(context).users;
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    var tagProvider = Provider.of<NoteProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel,
                  size: 30,
                  color: blackColor,
                )),
          ),
          const SizedBox(
            height: 10,
          ),

          // Padding(
          //   padding: const EdgeInsets.all(12),
          //   child: TextFormField(
          //     decoration: InputDecoration(
          //       border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //           borderSide: BorderSide.none),
          //       filled: true,
          //       fillColor: Colors.grey[300],
          //       constraints: const BoxConstraints(maxHeight: 50, minHeight: 50),
          //       hintText: 'Search...',
          //       hintStyle:
          //           TextStyle(fontFamily: fontFamily, color: Colors.grey),
          //     ),
          //   ),
          // ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemCount: allUsers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!tagProvider.tags.contains(allUsers[index])) {
                      tagProvider.addTag(allUsers[index]);
                    } else {
                      tagProvider.removeTag(allUsers[index]);
                    }
                  },
                  child: Consumer<NoteProvider>(builder: (context, notePro, _) {
                    return Stack(
                      children: [
                        Column(children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(allUsers[index].photoUrl),
                          ),
                          Text(
                            allUsers[index].username,
                            style: TextStyle(fontFamily: fontFamily),
                          )
                        ]),
                        if (notePro.tags.contains(allUsers[index]))
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.check,
                              color: whiteColor,
                              size: 20,
                            ),
                          )
                      ],
                    );
                  }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
