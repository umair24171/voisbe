import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
// import 'package:social_notes/screens/profile_screen/controller/update_profile_controller.dart';
import 'package:social_notes/screens/profile_screen/provider.dart/update_profile_provider.dart';
import 'package:social_notes/screens/upload_sounds/view/upload_sound.dart';

class CustomListTile extends StatefulWidget {
  CustomListTile({
    Key? key,
    required this.name,
    required this.subtitile,
    required this.inputText,
    required this.isLink,
    this.isSound = false,
    required this.username,
    required this.onChanged,
  }) : super(key: key);

  final String name;
  final String subtitile;
  final String inputText;
  final bool isLink;
  final ValueChanged<String> onChanged;
  bool isSound;
  final String username;

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  late TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.subtitile);
    _isEditing = false;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var updateProvider =
        Provider.of<UpdateProfileProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 15, vertical: widget.isLink ? 3 : 6),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: !widget.isLink
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              !widget.isLink
                  ? Expanded(
                      flex: 9,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child:
                              // _isEditing
                              //     ?
                              TextFormField(
                            controller: _textEditingController,

                            onChanged: (value) {
                              widget.onChanged(value);
                            },
                            // textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: fontFamily,
                                fontSize: 14),
                            decoration: const InputDecoration(
                              constraints: BoxConstraints(maxHeight: 20),
                              contentPadding: EdgeInsets.only(bottom: 14),

                              border: InputBorder.none,
                              // suffixIcon: IconButton(
                              //   icon: const Icon(Icons.check),
                              //   color: Colors.white,
                              //   onPressed: () {
                              //     widget.onChanged(_textEditingController.text);
                              //     setState(() {
                              //       _isEditing = !_isEditing;
                              //     });
                              //   },
                              // ),
                            ),
                          )
                          // : GestureDetector(
                          //     onTap: () {
                          //       setState(() {
                          //         _isEditing = true;
                          //       });
                          //     },
                          //     child: Text(
                          //       widget.subtitile,
                          //       overflow: TextOverflow.fade,
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.w500,
                          //         fontFamily: fontFamily,
                          //         color: whiteColor,
                          //       ),
                          //     ),
                          //   ),
                          ),
                    )
                  : Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: blackColor,
                                    borderRadius: BorderRadius.circular(19),
                                  ),
                                  child:
                                      //  _isEditing
                                      //     ?
                                      TextFormField(
                                    focusNode: _focusNode,
                                    readOnly: _isEditing
                                        ? false
                                        : widget.isSound
                                            ? true
                                            : !_isEditing
                                                ? true
                                                : false,
                                    onChanged: (value) {
                                      widget.onChanged(value);
                                    },
                                    controller: _textEditingController,
                                    textAlignVertical: TextAlignVertical.top,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 14,
                                        fontFamily: fontFamily),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,

                                      contentPadding: const EdgeInsets.only(
                                        bottom: 18,
                                        top: 0,
                                        left: 10,
                                        right: 15,
                                      ),
                                      constraints: BoxConstraints(
                                        maxHeight: 34,
                                        maxWidth: size.width * 0.8,
                                      ),
                                      // suffixIcon: IconButton(
                                      //   icon: const Icon(Icons.check),
                                      //   color: Colors.white,
                                      //   onPressed: () {},
                                      // ),
                                    ),
                                  )
                                  // : GestureDetector(
                                  //     onTap: () {
                                  //       setState(() {
                                  //         _isEditing = true;
                                  //       });
                                  //     },
                                  //     child: Text(
                                  //       widget.subtitile,
                                  //       style: TextStyle(
                                  //           fontFamily: fontFamily,
                                  //           color: whiteColor),
                                  //     ),
                                  //   ),
                                  ),
                            ),
                            Positioned(
                              left: size.width * 0.52,
                              top: 7,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: widget.isSound
                                    ? GestureDetector(
                                        onTap: () {
                                          showBottomSheet(
                                            context: context,
                                            builder: (context) => UploadSound(
                                              username: widget.username,
                                            ),
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/images/uploadsound.png',
                                          height: 15,
                                          width: 15,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          _isEditing = !_isEditing;
                                          setState(() {});
                                          if (_isEditing) {
                                            FocusScope.of(context)
                                                .requestFocus(_focusNode);
                                          }
                                        },
                                        child: Icon(
                                          // _isEditing
                                          //     ? Icons.check
                                          //     :
                                          _isEditing
                                              ? Icons.check
                                              : Icons.edit_outlined,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          if (!widget.isLink) const SizedBox(height: 10),
          Divider(
            endIndent: 10,
            indent: 10,
            height: 1,
            color: Colors.white.withOpacity(0.2),
          )
        ],
      ),
    );
  }
}
