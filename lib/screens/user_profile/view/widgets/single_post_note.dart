import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class SinglePostNote extends StatelessWidget {
  const SinglePostNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(width: 3, color: greenColor)),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: whiteColor,
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_circle_fill_outlined,
                      color: greenColor,
                    )),
              )
            ],
          ),
          Text(
            'Jamie',
            style: TextStyle(fontFamily: fontFamily, color: whiteColor),
          )
        ],
      ),
    );
  }
}
