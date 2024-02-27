import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/custom_bottom_bar.dart';
import 'package:social_notes/screens/home_screen/view/home_screen.dart';
import 'package:social_notes/screens/profile_screen/widgets/custom_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontFamily: fontFamily),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        // alignment: Alignment.center,
        height: size.height,

        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
                      ))),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcATop),
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
            CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
                            radius: 50,
                          ),
                          Positioned(
                            left: 60,
                            bottom: 5,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomListTile(
                      name: 'Name',
                      subtitile: 'Jenna Otizer',
                      isLink: false,
                      inputText: '',
                    ),
                    CustomListTile(
                      name: 'Username',
                      subtitile: 'jennaotizer',
                      isLink: false,
                      inputText: '',
                    ),
                    CustomListTile(
                      isLink: false,
                      name: 'Biography',
                      subtitile:
                          'Sharing my thoughts with my fans.Thank you for your support, it means the world',
                      inputText: '',
                    ),
                    CustomListTile(
                      name: 'Link',
                      subtitile: '',
                      isLink: true,
                      inputText: 'www.jeenao.com',
                    ),

                    CustomListTile(
                      name: 'Contact',
                      subtitile: '',
                      isLink: true,
                      inputText: 'jennaotizer@gmail.com',
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'Subscription',
                            style: TextStyle(
                                fontFamily: fontFamily, color: whiteColor),
                          ),
                        ),
                        Container(
                          // width: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                    color: blackColor,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        bottomLeft: Radius.circular(14))),
                                child: Text(
                                  'ON',
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(14),
                                        bottomRight: Radius.circular(14))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                child: Text(
                                  'Off',
                                  style: TextStyle(color: whiteColor),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      child: Text(
                        'If enabled users will be able to subscribe to you for a monthly payment (starting from USD 3.99) and receive the subscriber special for the time of being processed',
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: fontFamily,
                            fontSize: 13),
                      ),
                    ),
                    Divider(
                      endIndent: 10,
                      indent: 10,
                      height: 1,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    CustomListTile(
                      name: 'Price per month',
                      subtitile: '',
                      isLink: true,
                      inputText: 'USD 4.99',
                    ),
                    CustomListTile(
                      name: 'Sound pack',
                      subtitile: '',
                      isLink: true,
                      inputText: 'Upload your sound pack',
                    ),
                    CustomListTile(
                      name: 'Pricing',
                      subtitile: '',
                      isLink: true,
                      inputText: 'USD 4.99',
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(whiteColor)),
                            onPressed: () {
                              navPush(BottomBar.routeName, context);
                            },
                            icon: Icon(
                              Icons.check,
                              color: blackColor,
                            ),
                            label: Text(
                              'Save profile',
                              style: TextStyle(
                                  color: blackColor, fontFamily: fontFamily),
                            )),
                      ),
                    )
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
