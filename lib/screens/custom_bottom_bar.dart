import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/view/add_note_screen.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
// import 'package:social_notes/screens/chat_screen.dart/view/chat_screen.dart';
import 'package:social_notes/screens/chat_screen.dart/view/users_screen.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
// import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/home_screen.dart';
// import 'package:social_notes/screens/profile_screen/profile_screen.dart';
import 'package:social_notes/screens/search_screen/view/search_screen.dart';
import 'package:social_notes/screens/upload_sounds/provider/sound_provider.dart';
import 'package:social_notes/screens/user_profile/view/user_profile_screen.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_player.dart';

import 'add_note_screen/provider/note_provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  static const routeName = 'bottom-bar';

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  PageController pageController = PageController();

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void initState() {
    Provider.of<NoteProvider>(context, listen: false).initRecorder();
    // Future.delayed(
    //   const Duration(seconds: 5),
    //   () {
    //     Provider.of<UserProvider>(context, listen: false).getUserData();
    //   },
    // );
    var provider = Provider.of<DisplayNotesProvider>(context, listen: false);

    provider.getAllNotes();
    Provider.of<SoundProvider>(context, listen: false).getFreeSoundPacks();
    Provider.of<SoundProvider>(context, listen: false)
        .getSubscribedSoundPacks();
    Provider.of<SoundProvider>(context, listen: false).getSavedNotes();
    Provider.of<DisplayNotesProvider>(context, listen: false)
        .getBookMarkPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        children: [
          const HomeScreen(),
          SearchScreen(),
          const AddNoteScreen(),
          const UsersScreen(),
          UserProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: navigationTapped,
        currentIndex: _page,
        backgroundColor: whiteColor,
        selectedIconTheme: IconThemeData(color: blackColor),
        unselectedIconTheme: IconThemeData(color: blackColor),
        items: [
          BottomNavigationBarItem(
            backgroundColor: whiteColor,
            icon: Image.asset(
              'assets/images/navibar_home.png',
              height: 20,
              width: 20,
            ),
            // backgroundColor: primaryColor,
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/navibar_explore.png',
              height: 20,
              width: 20,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/navibar_newpost.png',
              height: 20,
              width: 20,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.black,
              size: 24,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(Provider.of<UserProvider>(context,
                              listen: false)
                          .user !=
                      null
                  ? Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .photoUrl
                  : 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
            ),
            label: '',
            // backgroundColor: primaryColor,
          )
        ],
      ),
    );
  }
}
