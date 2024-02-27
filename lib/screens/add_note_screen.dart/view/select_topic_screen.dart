import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/add_note_screen.dart/view/add_hashtags_screen.dart';

class SelectTopicScreen extends StatefulWidget {
  SelectTopicScreen({super.key});
  static const routeName = '/select-topic';

  @override
  State<SelectTopicScreen> createState() => _SelectTopicScreenState();
}

class _SelectTopicScreenState extends State<SelectTopicScreen> {
  List<String> _selectedOptions = [];

  List<String> topics = [
    'Need support',
    'Relationship & love',
    'Confession & secret',
    'Inspiration & motivation',
    'Food & Cooking',
    'Personal Story',
    'Business',
    'Something I learned',
    'Education & Learning',
    'Books & Literature',
    'Spirit & Mind',
    'Travel & Adventure',
    'Fashion & Style',
    'Creativity & Art',
    'Humor & Comedy',
    'Sports & Fitness',
    'Technology & Innovation',
    'Current Events & News',
    'Health & Wellness',
    'Hobbies & Interests'
  ];
  Color _randomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'ADD 1 TOPIC',
              style: TextStyle(
                  color: whiteColor,
                  fontFamily: fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 15,
                  children: topics
                      .map((e) => ChoiceChip(
                            avatarBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            label: Text(e),
                            backgroundColor: _randomColor(),
                            labelStyle: TextStyle(color: whiteColor),
                            selected: _selectedOptions.contains(e),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedOptions.add(e);
                                } else {
                                  _selectedOptions.remove(e);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(blackColor),
                  fixedSize: const MaterialStatePropertyAll(
                    Size(100, 10),
                  ),
                ),
                onPressed: () {},
                label: Text(
                  'Back',
                  style: TextStyle(
                      color: whiteColor, fontFamily: fontFamily, fontSize: 12),
                ),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: whiteColor,
                  size: 15,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        fixedSize:
                            const MaterialStatePropertyAll(Size(100, 10)),
                        backgroundColor: MaterialStatePropertyAll(whiteColor)),
                    onPressed: () {},
                    label: Text(
                      'Skip',
                      style: TextStyle(
                          color: blackColor,
                          fontFamily: fontFamily,
                          fontSize: 12),
                    ),
                    icon: Icon(
                      Icons.skip_next,
                      color: blackColor,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        fixedSize: const MaterialStatePropertyAll(
                          Size(100, 10),
                        ),
                        backgroundColor: MaterialStatePropertyAll(whiteColor)),
                    onPressed: () {
                      navPush(AddHashtagsScreen.routeName, context);
                    },
                    label: Text(
                      'Next',
                      style: TextStyle(
                          color: blackColor,
                          fontFamily: fontFamily,
                          fontSize: 12),
                    ),
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: blackColor,
                      size: 15,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
