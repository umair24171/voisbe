// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
// import 'package:social_notes/screens/add_note_screen.dart/model/note_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/view/users_screen.dart';
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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<DisplayNotesProvider>(context, listen: false).getAllNotes();
      Provider.of<FilterProvider>(context, listen: false)
          .setSelectedFilter('For you');
      Provider.of<UserProvider>(context, listen: false).getUserData();
      Provider.of<ChatProvider>(context, listen: false).getAllUsersForChat();
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
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Consumer<FilterProvider>(builder: (context, filterPro, _) {
                return Text(
                  filterPro.selectedFilter,
                  style: TextStyle(
                      fontFamily: fontFamilyMedium,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: IconButton(
                  onPressed: () {
                    showMenu(
                        color: whiteColor,
                        context: context,
                        position: const RelativeRect.fromLTRB(0, 80, 0, 0),
                        items: [
                          PopupMenuItem(
                            onTap: () {
                              filterProvider.setSelectedFilter('Close Friends');
                            },
                            value: 'Close Friends',
                            child: Row(
                              children: [
                                Icon(Icons.group_outlined, color: blackColor),
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
                          PopupMenuItem(
                            onTap: () {
                              filterProvider.setSelectedFilter('Filter Topics');
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
                        ]);
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: blackColor,
                  ),
                ),
              ),
              Consumer<FilterProvider>(builder: (context, filterPro, _) {
                return filterPro.selectedFilter.contains('Filter Topics') ||
                        filterPro.selectedFilter.contains('Close Friends')
                    ? const Text('')
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Text(
                                '#Trends2024',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Text(
                                  '#Trends2024',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              })
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
                      return UsersScreen();
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
                              colors: filterpro.selectedFilter
                                      .contains('Close Friends')
                                  ? [greenColor, greenColor]
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
                                child: Stack(
                                  children:
                                      List.generate(topics.length, (index) {
                                    Color? color;
                                    switch (index % 4) {
                                      case 0:
                                        color = Colors.yellow;
                                        break;
                                      case 1:
                                        color = Colors.blue;
                                        break;
                                      case 2:
                                        color = Colors.green;
                                        break;
                                      case 3:
                                        color = Colors.red;
                                        break;
                                    }
                                    int reversedIndex =
                                        topics.length - index - 1;
                                    return Positioned(
                                      left: reversedIndex * 130.0,
                                      child: Container(
                                        width: 150,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            bottomRight: Radius.circular(40),
                                          ),
                                        ),
                                        height: 50,
                                        child: InkWell(
                                          onTap: () {
                                            filterPro.searchValue = '';
                                            filterPro.setSearchingValue(
                                                topics[reversedIndex]);
                                          },
                                          child: Text(
                                            topics[reversedIndex],
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              color: whiteColor,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
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
                              // physics: const BouncingScrollPhysics(),
                              // reverse: true,
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
