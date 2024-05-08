import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key, required this.userId});
  final String userId;

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      var otherUser =
          Provider.of<UserProfileProvider>(context, listen: false).otherUser;
      Provider.of<UserProfileProvider>(context, listen: false)
          .getFollowing(otherUser!.uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Followings',
          style: TextStyle(
              fontSize: 18,
              fontFamily: khulaRegular,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<UserProfileProvider>(builder: (context, followersPro, _) {
        return ListView.builder(
            itemCount: followersPro.following.length,
            itemBuilder: (context, index) {
              UserModel user = followersPro.following[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                title: Text(
                  user.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: khulaRegular,
                      fontWeight: FontWeight.w700),
                ),
                // subtitle: Text(
                //   'User Bio',
                //   style: TextStyle(
                //       fontSize: 14,
                //       fontFamily: khulaRegular,
                //       fontWeight: FontWeight.w400),
                // ),
                trailing: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel followUSer =
                            UserModel.fromMap(snapshot.data!.data()!);
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: blackColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              followersPro.followUser(userProvider, user);
                            },
                            child: Text(
                              followUSer.followers.contains(userProvider!.uid)
                                  ? 'Following'
                                  : 'Follow',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontFamily: khulaRegular,
                                  fontWeight: FontWeight.w700),
                            ));
                      } else {
                        return const SizedBox();
                      }
                    }),
              );
            });
      }),
    );
  }
}
