import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key, required this.userId});
  final String userId;

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  void initState() {
    Provider.of<UserProfileProvider>(context, listen: false)
        .getFollowers(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    // var otherUser =
    //     Provider.of<UserProfileProvider>(context, listen: false).otherUser;
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
          'Followers',
          style: TextStyle(
              fontSize: 18,
              fontFamily: khulaRegular,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<UserProfileProvider>(builder: (context, followersPro, _) {
        return ListView.builder(
            itemCount: followersPro.followers.length,
            itemBuilder: (context, index) {
              UserModel user = followersPro.followers[index];
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
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Provider.of<UserProfileProvider>(context, listen: false)
                        .followUser(userProvider!, user);
                  },
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserModel followUSer =
                              UserModel.fromMap(snapshot.data!.data()!);
                          return Text(
                            followUSer.followers.contains(userProvider!.uid)
                                ? 'Following'
                                : 'Follow',
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 14,
                                fontFamily: khulaRegular,
                                fontWeight: FontWeight.w700),
                          );
                        } else {
                          return Text(
                            '',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: khulaRegular,
                                fontWeight: FontWeight.w700,
                                color: whiteColor),
                          );
                        }
                      }),
                ),
              );
            });
      }),
    );
  }
}
