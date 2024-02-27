import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class SingleSearchItem extends StatelessWidget {
  const SingleSearchItem({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.2,
      width: size.width * 0.5,
      child: Stack(
        children: [
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.5,
            child: Image.network(
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 30,
            left: 54,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.play_circle_fill_outlined,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(18)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text(
                            'Travel & Adventure',
                            style:
                                TextStyle(fontFamily: fontFamily, fontSize: 11),
                          )),
                    ),
                    Positioned(
                        left: size.width * 0.18,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xffcf4836),
                                    blurRadius: 4,
                                    spreadRadius: 1)
                              ],
                              color: whiteColor.withOpacity(1),
                              borderRadius: BorderRadius.circular(18)),
                          child: Text(
                            'View Post',
                            style:
                                TextStyle(fontFamily: fontFamily, fontSize: 11),
                          ),
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
