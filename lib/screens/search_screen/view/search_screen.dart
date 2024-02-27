import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/search_screen/view/widgets/single_search_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(maxHeight: 45),
                      fillColor: Colors.black12,
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                color: blackColor,
              ),
            ),
          ],
        ),
        body: GridView.builder(
          itemCount: 10,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: size.height * 0.2,
          ),
          itemBuilder: (context, index) => const SingleSearchItem(),
        ));
  }
}
