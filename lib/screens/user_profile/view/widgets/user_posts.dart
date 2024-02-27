import 'package:flutter/material.dart';
// import 'package:social_notes/screens/home_screen/view/widgets/voice_message.dart';
import 'package:social_notes/screens/user_profile/view/widgets/single_post_note.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          itemCount: 12,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisExtent: 100, mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            return const SinglePostNote();
          },
        )
      ],
    );
  }
}
