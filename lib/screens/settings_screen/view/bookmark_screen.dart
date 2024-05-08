import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/settings_screen/view/widgets/single_bookmark_item.dart';
import 'package:social_notes/screens/upload_sounds/provider/sound_provider.dart';

class BookMarkScreenSettings extends StatefulWidget {
  const BookMarkScreenSettings({super.key});

  @override
  State<BookMarkScreenSettings> createState() => _BookMarkScreenSettingsState();
}

class _BookMarkScreenSettingsState extends State<BookMarkScreenSettings> {
  @override
  void initState() {
    super.initState();
    Provider.of<DisplayNotesProvider>(context, listen: false)
        .getBookMarkPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
            size: 30,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Bookmarks',
          style: TextStyle(
              color: blackColor,
              fontSize: 18,
              fontFamily: khulaBold,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<DisplayNotesProvider>(builder: (context, displayPro, _) {
        List<NoteModel> allNotes = [];
        for (var note in displayPro.notes) {
          for (var bookmark in displayPro.bookMarkPosts) {
            if (note.noteId == bookmark.postId) {
              allNotes.add(note);
            }
          }
        }
        return GridView.builder(
          itemCount: allNotes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              mainAxisExtent: 121,
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return SingleBookMarkItem(
              note: allNotes[index],
            );
          },
        );
      }),
    );
  }
}
