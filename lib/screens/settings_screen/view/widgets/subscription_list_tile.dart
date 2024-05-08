import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/settings_screen/controllers/settings_provider.dart';

class SubsccriptionListTile extends StatelessWidget {
  const SubsccriptionListTile(
      {super.key,
      required this.image,
      required this.username,
      required this.userId,
      required this.currentUserId,
      required this.subscritpionStatus});
  final String image;
  final String username;
  final String subscritpionStatus;
  final String userId;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            image,
          ),
        ),
        title: Text(username,
            style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontFamily: khulaRegular,
                fontWeight: FontWeight.w600)),
        trailing: InkWell(
          onTap: () {
            Provider.of<SettingsProvider>(context, listen: false)
                .removeSubscription(userId, currentUserId);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            // width: 33,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
              border: Border.all(
                width: 1,
                color: const Color(0xff868686),
              ),
            ),
            child:
                Consumer<SettingsProvider>(builder: (context, settingPro, _) {
              return Text(subscritpionStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 18,
                      fontFamily: khulaRegular,
                      fontWeight: FontWeight.w600));
            }),
          ),
        )
        //  ElevatedButton(
        //   style:
        //    ButtonStyle(
        //     minimumSize: const MaterialStatePropertyAll(Size(33, 33)),
        //     alignment: Alignment.center,
        //     elevation: const MaterialStatePropertyAll(0),
        //     backgroundColor: MaterialStateProperty.all(whiteColor),
        //     side: const MaterialStatePropertyAll(
        //       BorderSide(color: Color(0xff868686), width: 1),
        //     ),
        //   ),
        //   onPressed: () {},
        //   child:
        // Text('Cancel',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //           color: blackColor,
        //           fontSize: 18,
        //           fontFamily: khulaRegular,
        //           fontWeight: FontWeight.w600)),
        // ),
        );
  }
}
