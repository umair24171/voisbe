import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
// import 'package:social_notes/screens/settings_screen/view/widgets/subscription_list_tile.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';

class CloseFriendsScreen extends StatefulWidget {
  const CloseFriendsScreen({super.key});

  @override
  State<CloseFriendsScreen> createState() => _CloseFriendsScreenState();
}

class _CloseFriendsScreenState extends State<CloseFriendsScreen> {
  @override
  void initState() {
    Provider.of<UserProfileProvider>(context, listen: false).getFollowing(
        Provider.of<UserProvider>(context, listen: false).user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () {
            navPop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
            size: 30,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Close Friends',
          style: TextStyle(
              color: blackColor,
              fontSize: 18,
              fontFamily: khulaBold,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: blackColor,
                  ),
                  contentPadding: const EdgeInsets.all(0).copyWith(left: 14),
                  constraints: BoxConstraints(
                      maxWidth: size.width * 0.9, minHeight: 36, maxHeight: 36),
                  hintText: 'Search',
                  fillColor: const Color(0xffD9D9D9),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: const Color(0xff3C3C43),
                    fontFamily: khulaRegular,
                    fontSize: 17,
                  )),
            ),
          ),
          Consumer<UserProfileProvider>(builder: (context, userPro, _) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: userPro.following.length,
                itemBuilder: (context, index) {
                  UserModel user = userPro.following[index];
                  return CloseFriendListTile(
                    user: user,
                  );
                });
          }),
          // const SubsccriptionListTile(
          //     currentUserId: '',
          //     userId: '',
          //     image: '',
          //     username: 'Username',
          //     subscritpionStatus: 'Cancel'),
          // const SubsccriptionListTile(
          //     currentUserId: '',
          //     userId: '',
          //     image: '',
          //     username: 'Username',
          //     subscritpionStatus: 'Cancel'),
          // const SubsccriptionListTile(
          //     currentUserId: '',
          //     userId: '',
          //     image: '',
          //     username: 'Username',
          //     subscritpionStatus: 'Cancel'),
          // const SubsccriptionListTile(
          //     currentUserId: '',
          //     userId: '',
          //     image: '',
          //     username: 'Username',
          //     subscritpionStatus: 'Cancel'),
          // const SubsccriptionListTile(
          //     currentUserId: '',
          //     userId: '',
          //     image: '',
          //     username: 'Username',
          //     subscritpionStatus: 'Cancel'),
        ],
      ),
    );
  }
}

class CloseFriendListTile extends StatelessWidget {
  const CloseFriendListTile({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    return ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            user.photoUrl,
          ),
        ),
        title: Text(user.name,
            style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontFamily: khulaRegular,
                fontWeight: FontWeight.w600)),
        trailing: Consumer<UserProvider>(builder: (context, userPro, _) {
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () async {
              if (userPro.user!.closeFriends.contains(user.uid)) {
                userPro.removeUSerFieldForCloseFriends(user.uid);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userProvider!.uid)
                    .update({
                  'closeFriends': FieldValue.arrayRemove([user.uid])
                });
              } else {
                userPro.updateUserFieldForCloseFriends(user.uid);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userProvider!.uid)
                    .update({
                  'closeFriends': FieldValue.arrayUnion([user.uid])
                });
              }
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                // height: 33,
                // width: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: userPro.user!.closeFriends.contains(user.uid)
                      ? whiteColor
                      : blackColor,
                  border: Border.all(
                    width: 1,
                    color: const Color(0xff868686),
                  ),
                ),
                child: userPro.user!.closeFriends.contains(user.uid)
                    ? SvgPicture.asset(
                        'assets/icons/x.svg',
                        height: 25,
                        width: 25,
                      )
                    // Icon(Icons.cancel, color: blackColor, size: 20)
                    : SvgPicture.asset(
                        'assets/icons/check.svg',
                        height: 25,
                        width: 25,
                      )
                // Icon(Icons.check, color: whiteColor, size: 20),
                ),
          );
        })
        //  ElevatedButton(
        //   style:
        //    ButtonStyle(
        //     minimumSize: const MaterialStatePropertyAll(Size(33, 33)),
        //     alignment: Alignment.center,
        //     elevation: const MaterialStatePropertyAll(0),
        //     backgroundColor: MaterialStateProperty.all(whiteColor),
        //     side: const MaterialStatePropertyAll(
        //       BorderSide(color: Color(0xff868686), width: 1),
        //     ),
        //   ),
        //   onPressed: () {},
        //   child:
        // Text('Cancel',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //           color: blackColor,
        //           fontSize: 18,
        //           fontFamily: khulaRegular,
        //           fontWeight: FontWeight.w600)),
        // ),
        );
  }
}
