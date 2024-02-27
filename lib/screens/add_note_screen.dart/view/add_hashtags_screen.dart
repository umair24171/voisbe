import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class AddHashtagsScreen extends StatefulWidget {
  AddHashtagsScreen({super.key});

  static const routeName = '/add-hastags';
  @override
  State<AddHashtagsScreen> createState() => _AddHashtagsScreenState();
}

class _AddHashtagsScreenState extends State<AddHashtagsScreen> {
  List<String> _selectedOptions = [];

  List<String> hashtags = [
    '#Partnership',
    '#Momhacks',
    '#Trends24',
    '#Adventure',
    '#Sharingmyideas',
    '#Foodlover',
    '#Dreamingbig',
    '#Businesshack',
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ADD #HASHTAGS',
                style: TextStyle(
                    color: whiteColor,
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Select upto 10',
                style: TextStyle(
                    fontFamily: fontFamily, color: whiteColor, fontSize: 12),
              ),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text(
                            'Search for Hashtags',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: primaryColor,
                                fontSize: 12),
                          ),
                          filled: true,
                          fillColor: whiteColor,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: primaryColor,
                          ),
                          constraints: BoxConstraints(
                              maxHeight: 40, maxWidth: size.width * 0.7),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    Positioned(
                      left: size.width * 0.55,
                      bottom: 6,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(blackColor)),
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: whiteColor, fontFamily: fontFamily),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 15,
                      children: hashtags
                          .map((e) => ChoiceChip(
                                avatarBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                label: Text(e),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: whiteColor)),
                                backgroundColor: primaryColor,
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
              Text(
                'TOPIC RECOMMENDED',
                style: TextStyle(
                    color: whiteColor,
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 15,
                      children: hashtags
                          .map((e) => ChoiceChip(
                                avatarBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                label: Text(e),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: whiteColor)),
                                backgroundColor: primaryColor,
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
              Text(
                'TRENDING',
                style: TextStyle(
                    color: whiteColor,
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 15,
                      children: hashtags
                          .map((e) => ChoiceChip(
                                avatarBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                label: Text(e),
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: whiteColor),
                                ),
                                backgroundColor: primaryColor,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            color: whiteColor,
                            fontFamily: fontFamily,
                            fontSize: 12),
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: whiteColor,
                        size: 15,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          fixedSize: const MaterialStatePropertyAll(
                            Size(100, 10),
                          ),
                          backgroundColor:
                              MaterialStatePropertyAll(whiteColor)),
                      onPressed: () {},
                      label: Text(
                        'Share',
                        style: TextStyle(
                            color: blackColor,
                            fontFamily: fontFamily,
                            fontSize: 12),
                      ),
                      icon: Icon(
                        Icons.check,
                        color: blackColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
