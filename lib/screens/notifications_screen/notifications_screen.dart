import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(fontFamily: fontFamily),
          ),
        ),
        body: Center(
          child: Text(
            'No Notifications',
            style: TextStyle(fontFamily: fontFamily, color: whiteColor),
          ),
        ));
  }
}
