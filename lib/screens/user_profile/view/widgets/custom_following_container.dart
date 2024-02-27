import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class CustomFollowing extends StatelessWidget {
  const CustomFollowing({super.key, required this.number, required this.text});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w600),
        ),
        Text(
          text,
          style: TextStyle(color: primaryColor, fontSize: 14),
        )
      ],
    );
  }
}
