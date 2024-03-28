import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/resources/show_snack.dart';
import 'package:social_notes/screens/add_note_screen/controllers/add_note_controller.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/custom_bottom_bar.dart';
import 'package:social_notes/screens/profile_screen/controller/update_profile_controller.dart';
import 'package:social_notes/screens/profile_screen/provider.dart/update_profile_provider.dart';
// import 'package:social_notes/screens/home_screen/view/home_screen.dart';
import 'package:social_notes/screens/profile_screen/widgets/custom_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String username = '';
  String bio = '';
  String link = '';
  String contact = '';
  String price = '';
  String soundPack = 'Upload your sound pack';
  bool subscription = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userProvider = Provider.of<UserProvider>(
      context,
    );
    userProvider.getUserData();
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: userProvider.user == null
          ? SpinKitThreeBounce(
              color: whiteColor,
              size: 20,
            )
          : SizedBox(
              // alignment: Alignment.center,
              height: size.height,

              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              userProvider.user!.photoUrl.isNotEmpty
                                  ? userProvider.user!.photoUrl
                                  : 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
                            ))),
                  ),
                  // ColorFiltered(
                  //   colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcATop),
                  //   child: ShaderMask(
                  //     blendMode: BlendMode.srcATop,
                  //     shaderCallback: (Rect bounds) {
                  //       return LinearGradient(
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //         stops: const [1.0, 0],
                  //         colors: [primaryColor, primaryColor],
                  //       ).createShader(bounds);
                  //     },
                  //     child: Container(
                  //       height: size.height,
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           begin: Alignment.topCenter,
                  //           end: Alignment.bottomCenter,
                  //           colors: [Colors.transparent, primaryColor],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: size.height,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xffED695A)],
                        ),
                      ),
                    ),
                  ),
                  CustomScrollView(slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: whiteColor, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: userProvider.imageFile == null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                userProvider.user!.photoUrl
                                                        .isNotEmpty
                                                    ? userProvider
                                                        .user!.photoUrl
                                                    : 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
                                            radius: 50,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: FileImage(
                                                userProvider.imageFile!),
                                            radius: 50,
                                          ),
                                  ),
                                  Positioned(
                                    left: 70,
                                    bottom: 5,
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            userProvider.pickImage();
                                          },
                                          child: const Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomListTile(
                            username: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            name: 'Name',
                            subtitile: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            isLink: false,
                            inputText: '',
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                          CustomListTile(
                            username: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            name: 'Username',
                            subtitile: username.isEmpty
                                ? userProvider.user!.name
                                : username,
                            isLink: false,
                            inputText: '',
                            onChanged: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                          ),
                          CustomListTile(
                            username: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            isLink: false,
                            name: 'Biography',
                            subtitile:
                                bio.isNotEmpty ? bio : userProvider.user!.bio,
                            inputText: '',
                            onChanged: (value) {
                              setState(() {
                                bio = value;
                              });
                            },
                          ),
                          CustomListTile(
                            username: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            name: 'Link',
                            subtitile: link.isNotEmpty
                                ? link
                                : userProvider.user!.link,
                            isLink: true,
                            inputText: '',
                            onChanged: (value) {
                              setState(() {
                                link = value;
                              });
                            },
                          ),

                          CustomListTile(
                            username: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            name: 'Contact',
                            subtitile: contact.isNotEmpty
                                ? contact
                                : userProvider.user!.contact,
                            isLink: true,
                            inputText: '',
                            onChanged: (value) {
                              setState(() {
                                contact = value;
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Text(
                                'Verified Users Only',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text(
                                  'Subscription',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: fontFamily,
                                      color: whiteColor),
                                ),
                              ),
                              Consumer<UserProvider>(
                                  builder: (context, sub, child) {
                                return GestureDetector(
                                  onTap: () {
                                    sub.setIsSubscription();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      // width: 100,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 7),
                                            decoration: BoxDecoration(
                                                color: sub.isSubscription
                                                    ? primaryColor
                                                    : blackColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(18),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                18))),
                                            child: Text(
                                              'ON',
                                              style:
                                                  TextStyle(color: whiteColor),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: sub.isSubscription
                                                    ? blackColor
                                                    : primaryColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(18),
                                                        bottomRight:
                                                            Radius.circular(
                                                                18))),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 7),
                                            child: Text(
                                              'OFF',
                                              style:
                                                  TextStyle(color: whiteColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'If enabled users will be able to subscribe to you for a monthly payment (starting from USD 3.99) and receive the subscriber special for the time of being subscribed.',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontFamily: fontFamily,
                                  fontSize: 12),
                            ),
                          ),
                          Divider(
                            endIndent: 25,
                            indent: 25,
                            height: 1,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          CustomListTile(
                            username: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            name: 'Price per month',
                            subtitile: price.isNotEmpty
                                ? price
                                : userProvider.user!.price.toString(),
                            isLink: true,
                            inputText: '',
                            onChanged: (value) {
                              setState(() {
                                price = value;
                              });
                            },
                          ),
                          CustomListTile(
                            username: name.isEmpty
                                ? userProvider.user!.username
                                : name,
                            name: 'Sound Pack',
                            subtitile: soundPack,
                            isLink: true,
                            isSound: true,
                            inputText: '',
                            onChanged: (value) {
                              setState(() {
                                soundPack = value;
                              });
                            },
                          ),
                          // CustomListTile(
                          //   name: 'Pricing',
                          //   subtitile: '',
                          //   isLink: true,
                          //   inputText: 'USD 4.99',
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'As a verified user you are able to upload and offer your own sound pack. Subscribers will then be able to use your sounds that will be included in their subscription. Your sound will appear in their sound library, ready to be used non-commercially. ',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontFamily: fontFamily,
                                  fontSize: 12),
                            ),
                          ),
                          Divider(
                            endIndent: 10,
                            indent: 10,
                            height: 1,
                            color: Colors.white.withOpacity(0.2),
                          ),

                          Consumer<UpdateProfileProvider>(
                              builder: (context, updatePro, _) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, right: 20, top: 5),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                        fixedSize:
                                            const MaterialStatePropertyAll(
                                                Size(145, 40)),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                whiteColor)),
                                    onPressed: () async {
                                      userProvider.setUserLoading(true);
                                      if (link.isNotEmpty ||
                                          userProvider.user!.link.isNotEmpty) {
                                        if (!link.contains('www') ||
                                            !link.contains('.') ||
                                            !link.contains('com')) {
                                          userProvider.setUserLoading(false);
                                          showSnackBar(context,
                                              'Please enter valid link');
                                          return;
                                        }
                                      }

                                      if (userProvider.imageFile == null) {
                                        userProvider.setUserLoading(false);
                                        showSnackBar(
                                            context, 'Please select image');
                                      }
                                      String image = await AddNoteController()
                                          .uploadFile('profile',
                                              userProvider.imageFile!, context);

                                      UpdateProfileController()
                                          .updateProfile(
                                              name.isEmpty
                                                  ? userProvider.user!.username
                                                  : name,
                                              username.isEmpty
                                                  ? userProvider.user!.username
                                                  : username,
                                              bio.isEmpty
                                                  ? userProvider.user!.bio
                                                  : bio,
                                              link.isEmpty
                                                  ? userProvider.user!.link
                                                  : link,
                                              contact.isEmpty
                                                  ? userProvider.user!.contact
                                                  : contact,
                                              userProvider.isSubscription,
                                              price.isNotEmpty
                                                  ? double.parse(price)
                                                  : userProvider.user!.price,
                                              updatePro.fileUrls,
                                              image,
                                              context)
                                          .then((value) {
                                        navPush(BottomBar.routeName, context);
                                        // userProvider.isSubscription = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: blackColor,
                                      size: 25,
                                    ),
                                    label: userProvider.userLoading
                                        ? SpinKitThreeBounce(
                                            color: blackColor,
                                            size: 13,
                                          )
                                        : Text(
                                            'Save profile',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: blackColor,
                                                fontFamily: fontFamily),
                                          )),
                              ),
                            );
                          })
                          // CustomListTile(
                          //   name: 'Pricing',
                          //   subtitile: '',
                          //   isLink: true,
                          //   inputText: 'jennaotizer@gmail.com',
                          // ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ),
    );
  }
}
