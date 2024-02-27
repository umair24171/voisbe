import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
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
                    'Subscribe to Jenna Otizer',
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
                      'Monthly payment of USD 4.99 You receive accessto the following specials',
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
                              'Free usage of Jenna Otizer\'s sound pack',
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
                    child: Container(
                      // width: size.width * 0.7,
                      // height: 50,
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
