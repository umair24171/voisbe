import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen.dart/view/add_note_screen.dart';
import 'package:social_notes/screens/chat_screen.dart/view/chat_screen.dart';
import 'package:social_notes/screens/home_screen/view/home_screen.dart';
import 'package:social_notes/screens/profile_screen/profile_screen.dart';
import 'package:social_notes/screens/search_screen/view/search_screen.dart';
import 'package:social_notes/screens/user_profile/view/user_profile_screen.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        children: const [
          HomeScreen(),
          SearchScreen(),
          AddNoteScreen(),
          ChatScreen(),
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
            icon: const Icon(
              Icons.home,
              color: Colors.black,
              size: 25,
            ),
            // backgroundColor: primaryColor,
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 25,
              // color: _page == 1 ? Colors.black : secondaryColor,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: Colors.black,
              size: 25,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: Colors.black,
              size: 25,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          const BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
            ),
            label: '',
            // backgroundColor: primaryColor,
          )
        ],
      ),
    );
  }
}
