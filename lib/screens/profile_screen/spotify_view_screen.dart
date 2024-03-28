import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/profile_screen/model/sound_pack_model.dart';
import 'package:social_notes/screens/profile_screen/provider.dart/update_profile_provider.dart';
import 'package:social_notes/screens/search_screen/view/provider/search_screen_provider.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_player.dart';
import 'package:social_notes/spotify/methods/model/provider/tracks_provider.dart';
import 'package:social_notes/spotify/methods/model/track_model.dart';
import 'package:voice_message_package/voice_message_package.dart';

class SpotifyViewScreen extends StatelessWidget {
  const SpotifyViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tracksPro = Provider.of<TracksProvider>(context).allTracks;

    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
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
                        var pro =
                            Provider.of<TracksProvider>(context, listen: false);
                        pro.setSearchTrack(true);
                        pro.searchedTracks.clear();

                        for (int i = 0; i < tracksPro.length; i++) {
                          if (tracksPro[i]
                              .name
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                            pro.searchedTracks.add(tracksPro[i]);
                          }
                        }
                      } else {
                        var pro =
                            Provider.of<TracksProvider>(context, listen: false);
                        pro.setSearchTrack(false);
                        pro.searchedTracks.clear();
                      }
                    },
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
                      ),
                      label: Text(
                        'Search',
                        style: TextStyle(
                            fontFamily: fontFamily, color: Colors.grey),
                      ),
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
        body: Scaffold(
          body: Column(
            children: [
              Expanded(
                child:
                    Consumer<TracksProvider>(builder: (context, trackPro, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: trackPro.isSearching
                        ? trackPro.searchedTracks.length
                        : tracksPro.length,
                    itemBuilder: (context, index) {
                      return SingleAddSound(
                        track: trackPro.isSearching
                            ? trackPro.searchedTracks[index]
                            : tracksPro[index],
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ));
  }
}

class SingleAddSound extends StatelessWidget {
  const SingleAddSound({Key? key, required this.track}) : super(key: key);
  final Track track;

  @override
  Widget build(BuildContext context) {
    var currentUSer = Provider.of<UserProvider>(context, listen: false).user;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              track.name,
              style: TextStyle(
                  color: blackColor,
                  fontFamily: fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: CustomProgressPlayer(
                    noteUrl: track.trackUrl!,
                    height: 30,
                    width: 120,
                    mainHeight: 60,
                    mainWidth: 240),
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(6),
                  //   decoration: BoxDecoration(
                  //       color: blackColor,
                  //       borderRadius: BorderRadius.circular(16)),
                  //   child: Icon(
                  //     Icons.bookmark_border,
                  //     size: 17,
                  //     color: whiteColor,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<UpdateProfileProvider>(context, listen: false)
                          .createSoundCollection(
                              currentUSer!.name,
                              track.name,
                              track.trackUrl!,
                              SoundPackType.premium,
                              true,
                              true);
                      navPop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: whiteColor,
                            size: 15,
                          ),
                          Text(
                            'Upload',
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: fontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
