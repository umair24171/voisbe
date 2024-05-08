import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/view/add_note_screen.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
// import 'package:social_notes/screens/chat_screen.dart/view/chat_screen.dart';
import 'package:social_notes/screens/chat_screen.dart/view/users_screen.dart';
import 'package:social_notes/screens/home_screen/controller/share_services.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
// import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/home_screen.dart';
// import 'package:social_notes/screens/profile_screen/profile_screen.dart';
import 'package:social_notes/screens/search_screen/view/search_screen.dart';
import 'package:social_notes/screens/upload_sounds/provider/sound_provider.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
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
    // Provider.of<SoundProvider>(context, listen: false).getFreeSoundPacks();
    // Provider.of<SoundProvider>(context, listen: false)
    //     .getSubscribedSoundPacks();
    // Provider.of<SoundProvider>(context, listen: false).getSavedNotes();

    Provider.of<UserProfileProvider>(context, listen: false).geUserAccounts();
    Provider.of<ChatProvider>(context, listen: false).getAllUsersForChat();
    Provider.of<DisplayNotesProvider>(context, listen: false).getAllUsers();
    DeepLinkPostService().initDynamicLinks(context);
    DeepLinkPostService().initDynamicLinksForProfile(context);
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
          AddNoteScreen(),
          const UsersScreen(),
          UserProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        onTap: navigationTapped,
        currentIndex: _page,
        backgroundColor: whiteColor,
        selectedIconTheme: IconThemeData(color: blackColor),
        unselectedIconTheme: IconThemeData(color: blackColor),
        items: [
          BottomNavigationBarItem(
            backgroundColor: whiteColor,
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 35,
              width: 35,
            ),
            // Image.asset(
            //   'assets/images/home_nav.png',
            //   height: 40,
            //   width: 40,
            // ),
            // backgroundColor: primaryColor,
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Search.svg',
              height: 35,
              width: 35,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Add_ring.svg',
              height: 35,
              width: 35,
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Subtract.svg',
              height: 30,
              width: 30,
              color: Color(0xff33363f),
            ),
            label: '',
            // backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Consumer<UserProvider>(builder: (context, userPro, _) {
              return CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(userPro.user != null
                    ? userPro.user!.photoUrl
                    : 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
              );
            }),
            label: '',
            // backgroundColor: primaryColor,
          )
        ],
      ),
    );
  }
}
