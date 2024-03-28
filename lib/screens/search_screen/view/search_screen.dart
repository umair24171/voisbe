import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/model/note_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/search_screen/view/provider/search_screen_provider.dart';
import 'package:social_notes/screens/search_screen/view/widgets/single_search_item.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  List<NoteModel> mostEngagedPosts = [];
  List<NoteModel> postContainsSubscribers = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<DisplayNotesProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    provider.getAllNotes();
    var allPosts = provider.notes;
    mostEngagedPosts.clear();
    postContainsSubscribers.clear();
    for (int i = 0; i < provider.notes.length; i++) {
      if (allPosts[i].likes.length > 1) {
        mostEngagedPosts.add(allPosts[i]);
        allPosts.removeAt(i);
      }
      if (userProvider!.subscribedSoundPacks.contains(allPosts[i].userUid)) {
        postContainsSubscribers.add(allPosts[i]);
        allPosts.removeAt(i);
      }
    }

    allPosts = [...mostEngagedPosts, ...postContainsSubscribers, ...allPosts];
    // allPosts.sort((a, b) => b.likes.length.compareTo(a.likes.length));

    // var postsProvider =
    //     Provider.of<DisplayNotesProvider>(context, listen: false);
    // postsProvider.getAllNotes();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                // flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        var pro = Provider.of<SearchScreenProvider>(context,
                            listen: false);
                        pro.setSearching(true);
                        pro.searchedNotes.clear();
                        pro.setSearching(true);
                        for (int i = 0; i < allPosts.length; i++) {
                          if (allPosts[i]
                                  .topic
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              allPosts[i]
                                  .username
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            pro.searchedNotes.add(allPosts[i]);
                          }
                        }
                      } else {
                        var pro = Provider.of<SearchScreenProvider>(context,
                            listen: false);
                        pro.setSearching(false);
                        pro.searchedNotes.clear();
                      }
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                          maxHeight: 35, maxWidth: size.width * 0.8),
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.only(bottom: 18),
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(fontFamily: fontFamily, color: Colors.grey),
                      // label: Text(
                      //   'Search',
                      //   style: TextStyle(
                      //       fontFamily: fontFamily, color: Colors.grey),
                      // ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 12),
          //     child: Icon(
          //       Icons.more_horiz,
          //       color: blackColor,
          //     ),
          //   ),
          // ],
        ),
        body: Consumer<SearchScreenProvider>(builder: (context, searchPro, _) {
          return GridView.builder(
            itemCount: searchPro.isSearching
                ? searchPro.searchedNotes.length
                : allPosts.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: size.height * 0.2,
            ),
            itemBuilder: (context, index) => SingleSearchItem(
              index: index,
              noteModel: searchPro.isSearching
                  ? searchPro.searchedNotes[index]
                  : allPosts[index],
            ),
          );
        }));
  }
}
