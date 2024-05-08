// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';

import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
// import 'package:social_notes/screens/add_note_screen.dart/model/note_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/view/users_screen.dart';
// import 'package:social_notes/screens/home_screen/controller/share_services.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/provider/filter_provider.dart';
import 'package:social_notes/screens/home_screen/view/widgets/single_post_note.dart';
import 'package:social_notes/screens/notifications_screen/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<DisplayNotesProvider>(context, listen: false).getAllNotes();
      Provider.of<FilterProvider>(context, listen: false)
          .setSelectedFilter('For you');
      Provider.of<UserProvider>(context, listen: false).getUserData();
      Provider.of<DisplayNotesProvider>(context, listen: false).getAllUsers();

      // getSoundsOfUnsubscribedUsers();
    });
  }

  // getSoundsOfUnsubscribedUsers() {
  //   var soundPro = Provider.of<SoundProvider>(context, listen: false);
  //   log('sounds of unsubscribed users ${soundPro.soundPacksMap}');
  // }

  List<String> topics = [
    'Need support',
    'Relationship & love',
    'Confession & secret',
    'Inspiration & motivation',
    'Food & Cooking',
    'Personal Story',
    'Business',
    'Something I learned',
    'Education & Learning',
    'Books & Literature',
    'Spirit & Mind',
    'Travel & Adventure',
    'Fashion & Style',
    'Creativity & Art',
    'Humor & Comedy',
    'Sports & Fitness',
    'Technology & Innovation',
    'Current Events & News',
    'Health & Wellness',
    'Hobbies & Interests'
  ];
  List<Color> topicColors = [
    const Color(0xff503e3b), // color1
    const Color(0xffcd3826), // color2
    const Color(0xffcf4736), // color3
    const Color(0xffe6b619), // color4
    const Color(0xff8ab756), // color5
    const Color(0xffeb6447), // color6
    const Color(0xff3694de), // color7
    const Color(0xffe69319), // color8
    const Color(0xff7c69de), // color9
    const Color(0xff885341), // color10
    const Color(0xff9235a2), // color11
    const Color(0xff56a559), // color12
    const Color(0xffd53269), // color13
    const Color(0xff6a46ab), // color14
    const Color(0xffe154a1), // color15
    const Color(0xff15acbf), // color16
    const Color(0xff45897a), // color17
    const Color(0xff472861), // color18
    const Color(0xff37728c), // color19
    const Color(0xff6cb57f), // color20
  ];

  Color _getColor(int index) {
    return topicColors[index % topicColors.length];
  }

  // Color _getColor(int index) {
  //   switch (index % 4) {
  //     case 0:
  //       return Colors.purple;
  //     case 1:
  //       return Colors.blue;
  //     case 2:
  //       return Colors.green;
  //     case 3:
  //       return Colors.red;
  //     default:
  //       return Colors.purple;
  //   }
  // }
  PageController _pageController = PageController();
  int currentIndex = 0;
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<DisplayNotesProvider>(
      context,
    );
    var filterProvider = Provider.of<FilterProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    // userProvider.getUserData();
    Provider.of<ChatProvider>(context, listen: false).getAllUsersForChat();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottomOpacity: 0,
          foregroundColor: whiteColor,
          shadowColor: whiteColor,
          scrolledUnderElevation: 0,
          surfaceTintColor: whiteColor,
          backgroundColor: whiteColor,
          forceMaterialTransparency: false,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Consumer<FilterProvider>(builder: (context, filterPro, _) {
                return Text(
                  filterPro.selectedFilter,
                  style: TextStyle(
                      color: blackColor,
                      fontFamily: fontFamilyMedium,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: Consumer<FilterProvider>(builder: (context, filPro, _) {
                  return IconButton(
                    onPressed: () {
                      showMenu(
                          elevation: 0,
                          color: whiteColor,
                          surfaceTintColor: whiteColor,
                          shadowColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          context: context,
                          position: const RelativeRect.fromLTRB(0, 80, 0, 0),
                          items: [
                            if (!filPro.selectedFilter
                                .contains('Close Friends'))
                              PopupMenuItem(
                                onTap: () {
                                  filterProvider
                                      .setSelectedFilter('Close Friends');
                                },
                                value: 'Close Friends',
                                child: Row(
                                  children: [
                                    Icon(Icons.group_outlined,
                                        color: blackColor),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'Close Friends',
                                      style: TextStyle(fontFamily: fontFamily),
                                    ),
                                  ],
                                ),
                              ),
                            if (!filPro.selectedFilter
                                .contains('Filter Topics'))
                              PopupMenuItem(
                                onTap: () {
                                  filterProvider
                                      .setSelectedFilter('Filter Topics');
                                },
                                value: 'Filter Topics',
                                child: Row(
                                  children: [
                                    Icon(Icons.filter_list, color: blackColor),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'Filter Topics',
                                      style: TextStyle(fontFamily: fontFamily),
                                    ),
                                  ],
                                ),
                              ),
                            if (filPro.selectedFilter
                                    .contains('Filter Topics') ||
                                filPro.selectedFilter.contains('Close Friends'))
                              PopupMenuItem(
                                onTap: () {
                                  filterProvider.setSelectedFilter('For you');
                                },
                                value: 'For you',
                                child: Row(
                                  children: [
                                    Icon(Icons.person_outline,
                                        color: blackColor),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'For you',
                                      style: TextStyle(fontFamily: fontFamily),
                                    ),
                                  ],
                                ),
                              ),
                          ]);
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: blackColor,
                    ),
                  );
                }),
              ),
              // Consumer<FilterProvider>(builder: (context, filterPro, _) {
              //   return filterPro.selectedFilter.contains('Filter Topics') ||
              //           filterPro.selectedFilter.contains('Close Friends')
              //       ? const Text('')
              //       : Expanded(
              //           child: Padding(
              //             padding: const EdgeInsets.only(left: 8),
              //             child: Row(
              //               children: [
              //                 Text(
              //                   '#Trends2024',
              //                   overflow: TextOverflow.ellipsis,
              //                   style: TextStyle(
              //                       fontFamily: fontFamily,
              //                       fontSize: 12,
              //                       fontWeight: FontWeight.w600),
              //                 ),
              //                 const SizedBox(
              //                   width: 6,
              //                 ),
              //                 Expanded(
              //                   child: Text(
              //                     '#Trends2024',
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(
              //                         fontFamily: fontFamily,
              //                         fontSize: 12,
              //                         fontWeight: FontWeight.w600),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              // })
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const NotificationScreen();
                    },
                  ));
                },
                icon: Icon(
                  Icons.favorite_border_outlined,
                  color: blackColor,
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14).copyWith(left: 2),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const UsersScreen();
                    },
                  ));
                },
                child: Image.asset(
                  'assets/images/navibar_messages.png',
                  height: 22,
                  width: 22,
                ),
              ),
            )
          ],
        ),
        body: provider.notes.isEmpty
            ? Center(
                child: SpinKitThreeBounce(
                  color: primaryColor,
                  size: 20,
                ),
              )
            : Stack(
                children: [
                  Consumer<FilterProvider>(builder: (context, filterpro, _) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [
                                0.25,
                                0.75,
                              ],
                              colors: filterpro.selectedFilter
                                      .contains('Close Friends')
                                  ? [greenColor.withOpacity(0.5), greenColor]
                                  : [
                                      const Color(0xffee856d),
                                      const Color(0xffed6a5a)
                                    ])),
                    );
                  }),
                  Column(
                    children: [
                      Consumer<FilterProvider>(
                          builder: (context, filterPro, _) {
                        return !filterProvider.selectedFilter
                                .contains('Filter Topics')
                            ? const Text('')
                            : SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount: topics.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Stack(
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 50,
                                        color: _getColor(
                                            index + 1 < topics.length
                                                ? index + 1
                                                : index),
                                      ),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: _getColor(index),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            bottomRight: Radius.circular(40),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            filterPro.searchValue = '';
                                            filterPro.setSearchingValue(
                                                topics[index]);
                                          },
                                          child: Text(
                                            topics[index],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                        // SingleChildScrollView(
                        //     keyboardDismissBehavior:
                        //         ScrollViewKeyboardDismissBehavior.onDrag,
                        //     scrollDirection: Axis.horizontal,
                        //     child: Row(
                        //       children:
                        //           List.generate(topics.length, (index) {
                        //         Color? color;
                        //         switch (index % 20) {
                        //           case 0:
                        //             color = const Color(0xff503e3b);
                        //             break;
                        //           case 1:
                        //             color = const Color(0xffcd3826);
                        //             break;
                        //           case 2:
                        //             color = const Color(0xffcf4736);
                        //             break;
                        //           case 3:
                        //             color = const Color(0xffe6b619);
                        //             break;
                        //           case 4:
                        //             color = const Color(0xff8ab756);
                        //             break;
                        //           case 5:
                        //             color = const Color(0xffeb6447);
                        //             break;
                        //           case 6:
                        //             color = const Color(0xff3694de);
                        //             break;
                        //           case 7:
                        //             color = const Color(0xffe69319);
                        //             break;
                        //           case 8:
                        //             color = const Color(0xff7c69de);
                        //             break;
                        //           case 9:
                        //             color = const Color(0xff885341);
                        //             break;
                        //           case 10:
                        //             color = const Color(0xff9235a2);
                        //             break;
                        //           case 11:
                        //             color = const Color(0xff56a559);
                        //             break;
                        //           case 12:
                        //             color = const Color(0xffd53269);
                        //             break;
                        //           case 13:
                        //             color = const Color(0xff6a46ab);
                        //             break;
                        //           case 14:
                        //             color = const Color(0xffe154a1);
                        //             break;
                        //           case 15:
                        //             color = const Color(0xff15acbf);
                        //             break;
                        //           case 16:
                        //             color = const Color(0xff45897a);
                        //             break;
                        //           case 17:
                        //             color = const Color(0xff472861);
                        //             break;
                        //           case 18:
                        //             color = const Color(0xff37728c);
                        //             break;
                        //           case 19:
                        //             color = const Color(0xff6cb57f);
                        //             break;
                        //         }

                        //         return Container(
                        //           width: 150,
                        //           height: 50,
                        //           alignment: Alignment.center,
                        //           decoration: BoxDecoration(
                        //             color: color,
                        //             borderRadius: const BorderRadius.only(
                        //               topRight: Radius.circular(40),
                        //               bottomRight: Radius.circular(40),
                        //             ),
                        //           ),
                        //           child: InkWell(
                        //             onTap: () {
                        // filterPro.searchValue = '';
                        // filterPro
                        //     .setSearchingValue(topics[index]);
                        //             },
                        //             child: Padding(
                        //               padding: const EdgeInsets.symmetric(
                        //                   horizontal: 5),
                        //               child: Text(
                        //                 topics[index],
                        //                 style: TextStyle(
                        //                   fontFamily: fontFamily,
                        //                   color: whiteColor,
                        //                   fontSize: 11,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       }),
                        //     ),
                        //   );
                      }),
                      Expanded(
                        child: Consumer<FilterProvider>(
                            builder: (context, filPro, _) {
                          if (filPro.selectedFilter.contains('Close Friends')) {
                            filPro.closeFriendsPosts.clear();
                            for (var element in userProvider.user!.followers) {
                              for (var note in provider.notes) {
                                if (element.contains(note.userUid)) {
                                  filPro.closeFriendsPosts.add(note);
                                }
                              }
                            }
                          } else if (filPro.selectedFilter
                              .contains('Filter Topics')) {
                            filPro.searcheNote.clear();
                            for (var note in provider.notes) {
                              if (note.topic.contains(filPro.searchValue)) {
                                filPro.searcheNote.add(note);
                              }
                            }
                          }
                          return PageView.builder(
                              controller: _pageController,

                              // physics: const BouncingScrollPhysics(),
                              // reverse: true,
                              onPageChanged: (value) {
                                debugPrint("hello $value");
                                setState(() {
                                  currentIndex = value;
                                });
                              },
                              itemCount: filPro.selectedFilter
                                      .contains('Close Friends')
                                  ? filPro.closeFriendsPosts.length
                                  : filPro.selectedFilter
                                          .contains('Filter Topics')
                                      ? filPro.searcheNote.length
                                      : provider.notes.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return SingleNotePost(
                                  isPlaying: isPlaying,
                                  postIndex: currentIndex,
                                  pageController: _pageController,
                                  currentIndex: index,
                                  size: size,
                                  note: filPro.selectedFilter
                                          .contains('Close Friends')
                                      ? filPro.closeFriendsPosts[index]
                                      : filPro.selectedFilter
                                              .contains('Filter Topics')
                                          ? filPro.searcheNote[index]
                                          : provider.notes[index],
                                );
                              });
                        }),
                      ),
                    ],
                  )
                ],
              ));
  }
}
