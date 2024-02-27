import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile(
      {super.key,
      required this.name,
      required this.subtitile,
      required this.inputText,
      required this.isLink});
  final String name;
  final String subtitile;
  final String inputText;
  bool isLink;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    name,
                    style: TextStyle(fontFamily: fontFamily, color: whiteColor),
                  ),
                ),
                !isLink
                    ? Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            subtitile,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontFamily: fontFamily, color: whiteColor),
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width * 0.7,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.08,
                                      vertical: 8),
                                  decoration: BoxDecoration(
                                    color: blackColor,
                                    borderRadius: BorderRadius.circular(19),
                                  ),
                                  child: Text(
                                    inputText,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        color: whiteColor),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: size.width * 0.55,
                                top: 5,
                                // bottom: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                if (!isLink) const SizedBox(),
                if (!isLink) const SizedBox(),
              ],
            ),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white.withOpacity(0.2),
            )
          ],
        ),
      ),
    );
  }
}
