import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
// import 'package:social_notes/resources/show_snack.dart';
import 'package:social_notes/resources/white_overlay_popup.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/auth_screens/view/auth_screen.dart';
import 'package:social_notes/screens/home_screen/controller/share_services.dart';
import 'package:social_notes/screens/settings_screen/view/settings_screen.dart';

// import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';

// import 'package:social_notes/screens/notifications_screen/notifications_screen.dart';
import 'package:social_notes/screens/subscribe_screen.dart/view/subscribe_screen.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
import 'package:social_notes/screens/user_profile/view/followers_screen.dart';
import 'package:social_notes/screens/user_profile/view/following_screen.dart';
import 'package:social_notes/screens/user_profile/view/widgets/contact_button.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_following_container.dart';
import 'package:social_notes/screens/user_profile/view/widgets/other_user_posts.dart';
import 'package:social_notes/screens/user_profile/view/widgets/report_user.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Provider.of<UserProfileProvider>(context, listen: false)
        .otherUserProfile(userId);

    var userProvider = Provider.of<UserProfileProvider>(
      context,
    ).otherUser;
    var currentUSer = Provider.of<UserProvider>(context, listen: false).user;

    // userProvider.otherUser;
    return userProvider == null
        ? SpinKitThreeBounce(
            color: primaryColor,
            size: 20,
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(children: [
                Row(
                  children: [
                    Text(
                      userProvider.name,
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                    if (userProvider.isVerified)
                      Image.network(
                        'https://media.istockphoto.com/id/1396933001/vector/vector-blue-verified-badge.jpg?s=612x612&w=0&k=20&c=aBJ2JAzbOfQpv2OCSr0k8kYe0XHutOGBAJuVjvWvPrQ=',
                        height: 20,
                        width: 20,
                      ),
                  ],
                ),
                // Icon(
                //   Icons.keyboard_arrow_down_outlined,
                //   color: blackColor,
                // )
              ]),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    color: blackColor,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const SettingsScreen();
                      },
                    ));
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
                            image: NetworkImage(userProvider.photoUrl))),
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
                                      backgroundImage:
                                          NetworkImage(userProvider.photoUrl),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      userProvider.name,
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    if (userProvider.isVerified)
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
                              InkWell(
                                onTap: () {
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .setIsNotificationEnabled();
                                  if (Provider.of<UserProvider>(context,
                                          listen: false)
                                      .isNotificationEnabled) {
                                    showWhiteOverlayPopup(
                                        context, Icons.check_box_outlined, null,
                                        title: 'Successful',
                                        isUsernameRes: false,
                                        message:
                                            'You will now receive the notifications about the ${userProvider.username} posts');
                                  } else {
                                    showWhiteOverlayPopup(
                                        context, Icons.check_box_outlined, null,
                                        title: 'Successful',
                                        isUsernameRes: false,
                                        message:
                                            'You will not receive the notifications about the ${userProvider.username} posts');
                                  }
                                },
                                child: Consumer<UserProvider>(
                                    builder: (context, notiPro, _) {
                                  return Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: !notiPro.isNotificationEnabled
                                          ? SvgPicture.asset(
                                              'assets/icons/Bell inactive.svg',
                                              height: 30,
                                              width: 30,
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/Bell active.svg',
                                              height: 30,
                                              width: 30,
                                            )
                                      // Icon(
                                      //   Icons.notifications_none_outlined,
                                      //   color: primaryColor,
                                      //   size: 30,
                                      // ),
                                      );
                                }),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              // if (userProvider.isSubscriptionEnable)
                              InkWell(
                                onTap: () {
                                  navPush(SubscribeScreen.routeName, context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: userProvider.subscribedUsers
                                            .contains(currentUSer!.uid)
                                        ? SvgPicture.asset(
                                            'assets/icons/Sub active.svg',
                                            height: 28,
                                            width: 28,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/Sub inactive.svg',
                                            height: 30,
                                            width: 30,
                                          )),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: whiteColor,
                                        elevation: 0,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                navPop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        elevation: 0,
                                                        backgroundColor:
                                                            whiteColor,
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                              child: Text(
                                                                'Block User',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        khulaRegular,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                            Text(
                                                              'They won’t be able to find your profile or posts. VOISBE won’t let them know you blocked them.',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    khulaRegular,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        elevation:
                                                                            0,
                                                                        backgroundColor:
                                                                            blackColor),
                                                                    onPressed:
                                                                        () async {
                                                                      if (!currentUSer
                                                                          .blockedUsers
                                                                          .contains(
                                                                              userProvider.uid)) {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .doc(currentUSer.uid)
                                                                            .update({
                                                                          'blockedUsers':
                                                                              FieldValue.arrayUnion([
                                                                            userProvider.uid
                                                                          ])
                                                                        });
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .doc(userProvider.uid)
                                                                            .update({
                                                                          'blockedByUsers':
                                                                              FieldValue.arrayUnion([
                                                                            currentUSer.uid
                                                                          ])
                                                                        });

                                                                        navPop(
                                                                            context);
                                                                        showWhiteOverlayPopup(
                                                                            context,
                                                                            Icons
                                                                                .check_box_outlined,
                                                                            null,
                                                                            title:
                                                                                'Successful!',
                                                                            message:
                                                                                'User blocked ',
                                                                            isUsernameRes:
                                                                                false);

                                                                        // FirebaseFirestore.instance.collection('users').doc(userProvider.uid).update({'blockedUsers': }).then((value) => navPop(context));
                                                                      } else {
                                                                        showWhiteOverlayPopup(
                                                                            context,
                                                                            Icons
                                                                                .error_outline,
                                                                            null,
                                                                            title:
                                                                                'Oops!',
                                                                            message:
                                                                                'User already blocked ',
                                                                            isUsernameRes:
                                                                                false);
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      'Block User',
                                                                      style: TextStyle(
                                                                          color:
                                                                              whiteColor,
                                                                          fontFamily:
                                                                              khulaRegular),
                                                                    )),
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        elevation:
                                                                            0,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                20)),
                                                                        side: const BorderSide(
                                                                            color: Color(
                                                                                0xff868686),
                                                                            width:
                                                                                1),
                                                                        backgroundColor:
                                                                            whiteColor),
                                                                    onPressed:
                                                                        () {
                                                                      navPop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color:
                                                                              blackColor,
                                                                          fontFamily:
                                                                              khulaRegular),
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ));
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 4)
                                                        .copyWith(bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Block User',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              khulaRegular,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: blackColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              endIndent: 0,
                                              indent: 0,
                                              height: 1,
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (!currentUSer.closeFriends
                                                    .contains(
                                                        userProvider.uid)) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(currentUSer.uid)
                                                      .update({
                                                    'closeFriends':
                                                        FieldValue.arrayUnion(
                                                            [userProvider.uid])
                                                  }).then((value) {
                                                    navPop(context);
                                                    showWhiteOverlayPopup(
                                                        context,
                                                        Icons
                                                            .check_box_outlined,
                                                        null,
                                                        title: 'Successful!',
                                                        message:
                                                            'User Added to Close Friends ',
                                                        isUsernameRes: false);
                                                  });

                                                  // FirebaseFirestore.instance.collection('users').doc(userProvider.uid).update({'blockedUsers': }).then((value) => navPop(context));
                                                } else {
                                                  showWhiteOverlayPopup(context,
                                                      Icons.error_outline, null,
                                                      title: 'Oops!',
                                                      message:
                                                          'User already added ',
                                                      isUsernameRes: false);
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 4)
                                                        .copyWith(bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Add as close friend',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              khulaRegular,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: blackColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              endIndent: 0,
                                              indent: 0,
                                              height: 1,
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return const ReportUser();
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 4)
                                                        .copyWith(bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Report User',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              khulaRegular,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: blackColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              endIndent: 0,
                                              indent: 0,
                                              height: 1,
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                DeepLinkPostService
                                                    deepLinkPostService =
                                                    DeepLinkPostService();
                                                deepLinkPostService
                                                    .shareProfileLink(userId)
                                                    .then((value) {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: value));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          content: Text(
                                                            'Link was copied to clipboard!',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                color:
                                                                    blackColor),
                                                          )));
                                                  navPop(context);
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 4)
                                                        .copyWith(bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Copy profile URL ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              khulaRegular,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: blackColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Divider(
                                            //   endIndent: 10,
                                            //   indent: 10,
                                            //   height: 1,
                                            //   color: Colors.black
                                            //       .withOpacity(0.1),
                                            // ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.more_horiz,
                                  color: whiteColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          // height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                userProvider.username,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.1, vertical: 13),
                                child: Center(
                                  child: Text(
                                    userProvider.bio,
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
                                var url = 'https://${userProvider.link}';
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
                                  userProvider.link,
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SubscribeScreen();
                                }));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 5),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/images/sounds_button.png',
                                      height: 15,
                                      width: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      child: Text(
                                        'Audio',
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontFamily: fontFamily,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
                                CustomPostsLength(
                                  id: userProvider.uid,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return FollowersScreen(
                                          userId: userProvider.uid);
                                    }));
                                  },
                                  child: CustomFollowing(
                                    number: '${userProvider.followers.length}',
                                    text: 'Followers',
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return FollowingScreen(
                                          userId: userProvider.uid);
                                    }));
                                  },
                                  child: CustomFollowing(
                                    number: '${userProvider.following.length}',
                                    text: 'Followings',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (userProvider.uid != currentUSer.uid)
                          const OtherContactButtons(),
                        const SizedBox(
                          height: 20,
                        ),
                        const OtherUserPosts(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class CustomPostsLength extends StatefulWidget {
  const CustomPostsLength({super.key, required this.id});
  final String id;
  @override
  State<CustomPostsLength> createState() => _CustomPostsLengthState();
}

class _CustomPostsLengthState extends State<CustomPostsLength> {
  int numberOfPosts = 0;
  @override
  void initState() {
    getUsersPosts();
    super.initState();
  }

  getUsersPosts() async {
    await FirebaseFirestore.instance
        .collection('notes')
        .where('userUid', isEqualTo: widget.id)
        .get()
        .then((value) {
      setState(() {
        numberOfPosts = value.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomFollowing(
      number: '$numberOfPosts',
      text: 'Posts',
    );
  }
}
