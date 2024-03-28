import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/show_snack.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
// import 'package:social_notes/screens/custom_bottom_bar.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});
  static const routeName = '/subscribe-screen';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var otherUser =
        Provider.of<UserProfileProvider>(context, listen: false).otherUser;
    var currentUser = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(otherUser!.photoUrl.isEmpty
                          ? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'
                          : otherUser.photoUrl),
                    ),
                    Positioned(
                        bottom: size.width * 0.01,
                        left: size.width * 0.22,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Icon(
                            Icons.star_border,
                            color: primaryColor,
                          ),
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(
              // height: 156,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Subscribe to ${otherUser.username}',
                    style: TextStyle(
                        color: whiteColor,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1, vertical: 10),
                    child: Text(
                      'Monthly payment of USD ${otherUser.price} You receive accessto the following specials',
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 12,
                          fontFamily: fontFamily),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: whiteColor,
                          ),
                          Expanded(
                            child: Text(
                              'Free usage of ${otherUser.username}\'s sound pack',
                              overflow: TextOverflow.fade,
                              style: TextStyle(color: whiteColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: whiteColor,
                        ),
                        Expanded(
                          child: Text(
                            'Subscriber badge',
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: whiteColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: whiteColor,
                        ),
                        Expanded(
                          child: Text(
                            'Access to longer voice messages',
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: whiteColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: whiteColor,
                        ),
                        Expanded(
                          child: Text(
                            'Your replies are shown  at the top of Jenna Otizer\'s post',
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: whiteColor),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Consumer<UserProvider>(builder: (context, loadProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () async {
                    loadProvider.setUserLoading(true);
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(otherUser.uid)
                        .update({
                      'subscribedUsers':
                          FieldValue.arrayUnion([currentUser!.uid])
                    }).then((value) async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .update({
                        'subscribedSoundPacks':
                            FieldValue.arrayUnion([otherUser.uid])
                      });
                    }).then((value) {
                      loadProvider.setUserLoading(false);
                      currentUser.subscribedSoundPacks.add(otherUser.uid);
                      showSnackBar(context, 'Subscribed successfully');
                    }).onError((error, stackTrace) {
                      loadProvider.setUserLoading(false);
                      log('Error: $error');
                    });
                  },
                  child: Container(
                    width: size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: loadProvider.userLoading
                        ? SpinKitThreeBounce(
                            color: blackColor,
                            size: 13,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: blackColor, size: 30),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Subscribe',
                                style: TextStyle(
                                    color: blackColor,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'By tapping Subscribe, you agree to the ',
                    style: TextStyle(
                        color: whiteColor,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                  Text(
                    'Subscription Terms',
                    style: TextStyle(
                        color: blackColor,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }
}
