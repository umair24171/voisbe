import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class CircleVoiceNotes extends StatelessWidget {
  const CircleVoiceNotes({super.key});

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
                child: const CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D')),
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
