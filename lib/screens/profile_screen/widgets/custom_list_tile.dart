import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_notes/resources/colors.dart';

class CustomListTile extends StatefulWidget {
  CustomListTile({
    Key? key,
    required this.name,
    required this.subtitile,
    required this.inputText,
    required this.isLink,
    this.isSound = false,
    required this.username,
    this.isVerifiedForPrice = true,
    required this.onChanged,
    // required this.validate,
    this.textCapitalization = TextCapitalization.none,
    this.userNameError,
    this.linkError,
    this.contactError,
    this.priceError,
    this.isBio = false,
    this.isUserName = false,
    this.isPrice = false,
    this.validator,
  }) : super(key: key);

  final String name;
  final String subtitile;
  final String inputText;
  final bool isLink;
  final ValueChanged<String> onChanged;
  bool isBio;
  bool isPrice;
  bool isVerifiedForPrice;

  bool isSound;
  final String username;
  String? Function(String?)? validator;
  TextCapitalization textCapitalization;
  // bool validate;
  String? userNameError;
  String? linkError;
  String? contactError;
  String? priceError;
  bool isUserName;

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
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: widget.isBio
              ? 0
              : widget.isLink
                  ? 3
                  : 6),
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
                  padding: EdgeInsets.only(
                      left: 8,
                      top: widget.contactError != null ||
                              widget.userNameError != null ||
                              widget.linkError != null ||
                              widget.priceError != null
                          ? 14
                          : widget.isBio
                              ? 23
                              : 0),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      // height: 1,
                      fontFamily: fontFamily,
                      color:
                          widget.isVerifiedForPrice ? whiteColor : Colors.grey,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.userNameError != null)
                              Text(
                                widget.userNameError!,
                                style: TextStyle(
                                    height: 0,
                                    color: greenColor,
                                    fontSize: 12,
                                    fontFamily: fontFamily),
                              ),
                            if (widget.isBio)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Text(
                                  'Max 160 characters',
                                  style: TextStyle(
                                      height: 0,
                                      color: greenColor,
                                      fontSize: 12,
                                      fontFamily: fontFamily),
                                ),
                              ),
                            Container(
                              height: widget.isBio ? null : 20,
                              // height: widget.isBio ? 20 : null,
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      widget.isUserName
                                          ? 9
                                          : widget.isBio
                                              ? 160
                                              : 30),
                                ],
                                // maxLines: widget.isBio ? 3 : 1,
                                maxLength: widget.isBio ? 160 : null,
                                maxLines: widget.isBio ? 3 : 1,
                                textCapitalization: widget.textCapitalization,
                                autovalidateMode: null,
                                // validator: widget.validator,

                                controller: _textEditingController,
                                // onFieldSubmitted: (value) {
                                //   if (!widget.isBio) {
                                //     widget.onChanged(value);
                                //   }
                                // },
                                onChanged: (value) {
                                  widget.onChanged(value);
                                },
                                textAlignVertical: widget.isBio
                                    ? TextAlignVertical.top
                                    : TextAlignVertical.bottom,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: fontFamily,
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  counterText: "",
                                  errorStyle: TextStyle(fontFamily: fontFamily),
                                  constraints: BoxConstraints(
                                      minHeight: 20,
                                      maxHeight: widget.isBio ? 90 : 20),
                                  contentPadding: widget.isBio
                                      ? const EdgeInsets.only(
                                          left: 0, right: 0, top: 0, bottom: 0)
                                      : const EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 0,
                                          bottom: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.linkError != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  widget.linkError!,
                                  style: TextStyle(
                                      height: 0,
                                      color: greenColor,
                                      fontSize: 12,
                                      fontFamily: fontFamily),
                                ),
                              ),
                            if (widget.contactError != null)
                              Text(
                                widget.contactError!,
                                style: TextStyle(
                                    height: 0,
                                    color: greenColor,
                                    fontSize: 12,
                                    fontFamily: fontFamily),
                              ),
                            if (widget.priceError != null)
                              Text(
                                widget.priceError!,
                                style: TextStyle(
                                    height: 0,
                                    color: greenColor,
                                    fontSize: 12,
                                    fontFamily: fontFamily),
                              ),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(60),
                                    ],
                                    autovalidateMode: null,
                                    keyboardType: widget.isPrice
                                        ? TextInputType.number
                                        : TextInputType.text,
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
                                      fillColor: widget.isVerifiedForPrice
                                          ? blackColor
                                          : const Color(0xff6f6f6f),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                          borderSide: BorderSide.none),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                          borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.only(
                                        bottom: 18,
                                        top: 0,
                                        left: 10,
                                        right: 15,
                                      ),
                                      constraints: BoxConstraints(
                                        minHeight: 34,
                                        maxHeight: 34,
                                        // widget.validate &&
                                        //         widget.validator != null
                                        //     ? 54
                                        //     : 34,
                                        maxWidth: size.width * 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: size.width * 0.52,
                                  top: 7,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: widget.isVerifiedForPrice
                                          ? primaryColor
                                          : const Color(0xffcdcdcd),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: widget.isSound
                                        ? GestureDetector(
                                            onTap: () {
                                              // showBottomSheet(
                                              //   context: context,
                                              //   builder: (context) => UploadSound(
                                              //     username: widget.username,
                                              //   ),
                                              // );
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
