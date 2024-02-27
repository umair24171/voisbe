import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class ContactButtons extends StatelessWidget {
  const ContactButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomContactButton(
          icon: Icons.people,
          text: 'Follow',
        ),
        CustomContactButton(
          icon: Icons.email,
          text: 'Email',
        ),
        CustomContactButton(
          icon: Icons.mic,
          text: 'Message',
        ),
      ],
    );
  }
}

class CustomContactButton extends StatelessWidget {
  const CustomContactButton({
    super.key,
    required this.icon,
    required this.text,
  });
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style:
          ButtonStyle(backgroundColor: MaterialStatePropertyAll(primaryColor)),
      onPressed: () {},
      icon: Icon(
        icon,
        color: whiteColor,
      ),
      label: Text(
        text,
        style:
            TextStyle(color: whiteColor, fontSize: 12, fontFamily: fontFamily),
      ),
    );
  }
}
