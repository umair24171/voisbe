// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/add_note_screen/controllers/add_note_controller.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/custom_bottom_bar.dart';
import 'package:social_notes/screens/upload_sounds/provider/sound_provider.dart';
// import 'package:social_notes/screens/home_screen/view/home_screen.dart';
import 'package:uuid/uuid.dart';

class AddHashtagsScreen extends StatefulWidget {
  const AddHashtagsScreen(
      {super.key,
      required this.title,
      required this.taggedPeople,
      required this.selectedTopic});

  final String title;
  final List<String> taggedPeople;
  final String selectedTopic;

  static const routeName = '/add-hastags';
  @override
  State<AddHashtagsScreen> createState() => _AddHashtagsScreenState();
}

class _AddHashtagsScreenState extends State<AddHashtagsScreen> {
  final List<String> _selectedOptions = [];

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
  List<String> recommended = [
    '#Relationship',
    '#Partnership',
    '#Lovelife',
    '#BestFriend',
    '#Happiness',
    '#Smiling',
    '#Soulmate',
    '#Passionate',
  ];
  List<String> trendings = [
    '#Thoughts',
    '#Momhacks',
    '#Trends24',
    '#Mymine',
    '#MySecret',
    '#Tipps',
    '#Though',
    '#Passion',
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    var noteProvider = Provider.of<NoteProvider>(context, listen: false);
    var soundPro = Provider.of<SoundProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffee856d), Color(0xffed6a5a)])),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'ADD #HASHTAGS',
                      style: TextStyle(
                          color: whiteColor,
                          fontFamily: fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Select upto 10',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: whiteColor,
                        fontSize: 12),
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
                              hintText: 'Search for Hashtags',
                              hintStyle: TextStyle(
                                  fontFamily: fontFamily,
                                  color: primaryColor,
                                  fontSize: 12),
                              // label: Text(
                              //   'Search for Hashtags',
                              //   style: TextStyle(
                              //       fontFamily: fontFamily,
                              //       color: primaryColor,
                              //       fontSize: 12),
                              // ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 15,
                          children: hashtags
                              .map((e) => ChoiceChip(
                                    showCheckmark: false,
                                    // avatarBorder: RoundedRectangleBorder(
                                    //     borderRadius:
                                    //         BorderRadius.circular(10)),
                                    selectedColor: whiteColor,

                                    label: Text(
                                      e,
                                      style: TextStyle(
                                          color: _selectedOptions.contains(e)
                                              ? blackColor
                                              : whiteColor),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        side: BorderSide(color: whiteColor)),
                                    backgroundColor: primaryColor,

                                    labelStyle: TextStyle(
                                        color: _selectedOptions.contains(e)
                                            ? blackColor
                                            : whiteColor),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 15,
                          children: recommended
                              .map((e) => ChoiceChip(
                                    showCheckmark: false,
                                    selectedColor: whiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        side: BorderSide(color: whiteColor)),
                                    label: Text(
                                      e,
                                      style: TextStyle(
                                          color: _selectedOptions.contains(e)
                                              ? blackColor
                                              : whiteColor),
                                    ),
                                    backgroundColor: primaryColor,
                                    labelStyle: TextStyle(
                                        color: _selectedOptions.contains(e)
                                            ? blackColor
                                            : whiteColor),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 15,
                          children: trendings
                              .map((e) => ChoiceChip(
                                    showCheckmark: false,
                                    selectedColor: whiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        side: BorderSide(color: whiteColor)),
                                    label: Text(
                                      e,
                                      style: TextStyle(
                                          color: _selectedOptions.contains(e)
                                              ? blackColor
                                              : whiteColor),
                                    ),
                                    backgroundColor: primaryColor,
                                    labelStyle: TextStyle(
                                        color: _selectedOptions.contains(e)
                                            ? blackColor
                                            : whiteColor),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(blackColor),
                            fixedSize: const MaterialStatePropertyAll(
                              Size(100, 10),
                            ),
                          ),
                          onPressed: () {
                            navPop(context);
                          },
                          label: Text(
                            'Back',
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: fontFamily,
                                fontSize: 12),
                          ),
                          icon: Image.asset(
                            'assets/images/back.png',
                            height: 13,
                            width: 13,
                          ),
                        ),
                        Consumer<UserProvider>(
                            builder: (context, loadingPro, _) {
                          return ElevatedButton.icon(
                            style: ButtonStyle(
                                fixedSize: const MaterialStatePropertyAll(
                                  Size(100, 10),
                                ),
                                backgroundColor:
                                    MaterialStatePropertyAll(whiteColor)),
                            onPressed: () async {
                              loadingPro.setUserLoading(true);
                              String noteId = const Uuid().v4();
                              String noteUrl = soundPro.voiceUrl == null
                                  ? await AddNoteController().uploadFile(
                                      'voices',
                                      noteProvider.voiceNote!,
                                      context)
                                  : soundPro.voiceUrl!;
                              NoteModel note = NoteModel(
                                  userToken: userProvider!.token,
                                  isPinned: false,
                                  noteId: noteId,
                                  username: userProvider.username,
                                  photoUrl: userProvider.photoUrl,
                                  title: widget.title,
                                  userUid: userProvider.uid,
                                  tagPeople: noteProvider.tags,
                                  likes: [],
                                  noteUrl: noteUrl,
                                  publishedDate: DateTime.now(),
                                  comments: [],
                                  topic: widget.selectedTopic,
                                  hashtags: _selectedOptions);
                              AddNoteController()
                                  .addNote(note, noteId)
                                  .then((value) {
                                noteProvider.removeVoiceNote();
                                loadingPro.setUserLoading(false);

                                navPush(BottomBar.routeName, context);
                              });
                            },
                            label: loadingPro.userLoading
                                ? SpinKitThreeBounce(
                                    color: blackColor,
                                    size: 12,
                                  )
                                : Text(
                                    'Share',
                                    style: TextStyle(
                                        color: blackColor,
                                        fontFamily: fontFamily,
                                        fontSize: 12),
                                  ),
                            icon: Image.asset(
                              'assets/images/share.png',
                              height: 15,
                              width: 15,
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
