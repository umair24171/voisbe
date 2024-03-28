import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/view/widgets/single_post_note.dart';

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<DisplayNotesProvider>(builder: (context, displyPro, _) {
        for (var note in displyPro.notes) {
          for (var bookmark in displyPro.bookMarkPosts) {
            if (note.noteId == bookmark.postId) {
              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: displyPro.bookMarkPosts.length,
                itemBuilder: (context, index) =>
                    SingleNotePost(size: size, note: note),
              );
            }
          }
        }
        return Container();
      }),
    );
  }
}
