import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/home_screen/view/widgets/animated_text.dart';
import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:voice_message_package/voice_message_package.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'For you',
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: blackColor,
                )),
            Expanded(
              child: Row(
                children: [
                  Text(
                    '#Trends2024',
                    overflow: TextOverflow.fade,
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
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border_outlined,
                color: blackColor,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.send,
                color: blackColor,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  // alignment: Alignment.center,
                  width: size.width * 0.87,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('jennaotizer'),
                              Image.network(
                                'https://media.istockphoto.com/id/1396933001/vector/vector-blue-verified-badge.jpg?s=612x612&w=0&k=20&c=aBJ2JAzbOfQpv2OCSr0k8kYe0XHutOGBAJuVjvWvPrQ=',
                                height: 20,
                                width: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: size.width * 0.4,
                          top: 7,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xffcf4836),
                                      blurRadius: 4,
                                      spreadRadius: 1)
                                ],
                                color: primaryColor.withOpacity(1),
                                borderRadius: BorderRadius.circular(18)),
                            child: Text(
                              'Confession or secret',
                              style: TextStyle(fontFamily: fontFamily),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            const AnimatedText(),
            VoiceMessageView(
              controller: VoiceController(
                audioSrc: 'https://dl.musichi.ir/1401/06/21/Ghors%202.mp3',
                maxDuration: const Duration(seconds: 0),
                isFile: false,
                onComplete: () {},
                onPause: () {},
                onPlaying: () {},
                onError: (err) {},
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1 day ago  ',
                    style: TextStyle(color: whiteColor, fontFamily: fontFamily),
                  ),
                  Text(
                    ' |  ',
                    style: TextStyle(color: whiteColor),
                  ),
                  Text(
                    'USHER - HERE I AM',
                    style: TextStyle(fontFamily: fontFamily, color: whiteColor),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border,
                        color: whiteColor,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: whiteColor,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.bookmark_border_sharp,
                        color: whiteColor,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image_outlined,
                        color: whiteColor,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        color: whiteColor,
                        size: 30,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '4,748 likes',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: whiteColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'View all 348 replies',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: whiteColor,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.mic,
                        color: primaryColor,
                      )),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 50, left: 5),
                          child: CircleVoiceNotes(),
                        );
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const CircleVoiceNotes();
                },
              ),
            )
            // Row(
            //   children: [
            //     Container(decoration: Boxde,)
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
