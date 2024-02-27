import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/user_profile/view/widgets/contact_button.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_following_container.dart';
import 'package:social_notes/screens/user_profile/view/widgets/user_posts.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Row(
            children: [
              Text(
                'jennaotizer',
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Image.network(
                'https://media.istockphoto.com/id/1396933001/vector/vector-blue-verified-badge.jpg?s=612x612&w=0&k=20&c=aBJ2JAzbOfQpv2OCSr0k8kYe0XHutOGBAJuVjvWvPrQ=',
                height: 20,
                width: 20,
              )
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
                color: blackColor,
              ))
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
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: blackColor,
              size: 30,
            ),
          )
        ],
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              height: size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'))),
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'jennaotizar',
                              style: TextStyle(fontFamily: fontFamily),
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
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_none_outlined,
                              color: primaryColor,
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star_border_outlined,
                              color: primaryColor,
                            )),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz,
                            color: whiteColor,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Jenna Otizer',
                          style: TextStyle(
                              color: whiteColor,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.1),
                            child: Text(
                              'Sharing my thoughts with my fans. Thank you for your support, it means the world',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 12,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'www.jennao.com',
                          style: TextStyle(
                              color: whiteColor, fontFamily: fontFamily),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.volume_down_rounded,
                              color: whiteColor,
                              size: 14,
                            ),
                            Text(
                              'Sounds',
                              style: TextStyle(
                                  color: whiteColor, fontFamily: fontFamily),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: size.width * 0.1),
                    child: Container(
                      // alignment: Alignment.center,
                      // height: 100,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(25)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomFollowing(
                            number: '135',
                            text: 'Posts',
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          CustomFollowing(
                            number: '1.2M',
                            text: 'Followers',
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          CustomFollowing(
                            number: '138',
                            text: 'Minutes',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const ContactButtons(),
                  const SizedBox(
                    height: 20,
                  ),
                  const UserPosts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
