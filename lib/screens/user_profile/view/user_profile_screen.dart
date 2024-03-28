import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
// import 'package:social_notes/resources/custom_popup.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
// import 'package:social_notes/screens/auth_screens/view/auth_screen.dart';
import 'package:social_notes/screens/notifications_screen/notifications_screen.dart';
import 'package:social_notes/screens/profile_screen/profile_screen.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_drawer.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_following_container.dart';
import 'package:social_notes/screens/user_profile/view/widgets/user_posts.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Provider.of<UserProfileProvider>(context, listen: false)
        .getUserPosts(FirebaseAuth.instance.currentUser!.uid);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.getUserData();
    return userProvider.user == null
        ? SpinKitThreeBounce(
            color: primaryColor,
            size: 20,
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: const CustomDrawer(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(children: [
                Row(
                  children: [
                    Text(
                      userProvider.user!.name,
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                    Image.network(
                      'https://media.istockphoto.com/id/1396933001/vector/vector-blue-verified-badge.jpg?s=612x612&w=0&k=20&c=aBJ2JAzbOfQpv2OCSr0k8kYe0XHutOGBAJuVjvWvPrQ=',
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(0, 70, 0, 0),
                        items: [
                          PopupMenuItem(
                            child: Text(
                              'Add Account',
                              style: TextStyle(fontFamily: fontFamily),
                            ),
                          ),
                        ]);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: blackColor,
                  ),
                )
              ]),
              actions: [
                // PopupMenuCreatePost(),
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
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: blackColor,
                    size: 30,
                  ),
                )
              ],
            ),
            body: SizedBox(
              height: size.height,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    height: size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userProvider.user!.photoUrl))),
                  ),
                  ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(primaryColor, BlendMode.srcATop),
                    child: ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [1.0, 0],
                          colors: [primaryColor, primaryColor],
                        ).createShader(bounds);
                      },
                      child: Container(
                        height: size.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, primaryColor],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(18)),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundImage: NetworkImage(
                                          userProvider.user!.photoUrl),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      userProvider.user!.name,
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Image.network(
                                      'https://media.istockphoto.com/id/1396933001/vector/vector-blue-verified-badge.jpg?s=612x612&w=0&k=20&c=aBJ2JAzbOfQpv2OCSr0k8kYe0XHutOGBAJuVjvWvPrQ=',
                                      height: 20,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              // Container(
                              //   padding: const EdgeInsets.all(6),
                              //   decoration: BoxDecoration(
                              //       color: whiteColor,
                              //       borderRadius: BorderRadius.circular(30)),
                              //   child: Icon(
                              //     Icons.notifications_none_outlined,
                              //     color: primaryColor,
                              //     size: 30,
                              //   ),
                              // ),
                              const SizedBox(
                                width: 5,
                              ),
                              // Container(
                              //   padding: const EdgeInsets.all(6),
                              //   decoration: BoxDecoration(
                              //       color: whiteColor,
                              //       borderRadius: BorderRadius.circular(30)),
                              //   child: Icon(
                              //     Icons.star_border_outlined,
                              //     color: primaryColor,
                              //     size: 30,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   width: 2,
                              // ),
                              PopupMenuButton(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: whiteColor,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ProfileScreen.routeName);
                                    },
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(fontFamily: fontFamily),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                userProvider.user!.username,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.1, vertical: 5),
                                child: Center(
                                  child: Text(
                                    userProvider.user!.bio,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 13,
                                        fontFamily: fontFamily),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                var url = 'https://${userProvider.user!.link}';
                                if (await launchUrl(Uri.parse(url))) {
                                } else {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                    color: blackColor,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Text(
                                  userProvider.user!.link,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 7, vertical: 5),
                            //   decoration: BoxDecoration(
                            //       color: primaryColor,
                            //       borderRadius: BorderRadius.circular(15)),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Image.asset(
                            //         'assets/images/sounds_button.png',
                            //         height: 15,
                            //         width: 15,
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 7),
                            //         child: Text(
                            //           'Sounds',
                            //           style: TextStyle(
                            //               color: whiteColor,
                            //               fontFamily: fontFamily,
                            //               fontWeight: FontWeight.w600),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.06)
                              .copyWith(top: 15, bottom: 5),
                          child: Container(
                            // alignment: Alignment.center,
                            // height: 100,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 15),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomFollowing(
                                  number:
                                      '${Provider.of<UserProfileProvider>(context, listen: false).userPosts.length}',
                                  text: 'Posts',
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                CustomFollowing(
                                  number:
                                      '${userProvider.user!.followers.length}',
                                  text: 'Followers',
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                const CustomFollowing(
                                  number: '0',
                                  text: 'Minutes',
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const CurrentContact(),
                        const SizedBox(
                          height: 20,
                        ),
                        UserPosts(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
