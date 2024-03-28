import 'package:flutter/material.dart';
import 'package:social_notes/resources/colors.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      required this.label,
      required this.controller,
      required this.isPassword});

  final String label;
  final TextEditingController controller;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08, vertical: 7),
      child: isPassword
          ? PassFormField(controller: controller, label: label)
          : TextFormField(
              controller: controller,
              autovalidateMode: AutovalidateMode.always,
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 60),
                contentPadding: const EdgeInsets.only(
                  left: 20,
                  // bottom: 10,
                ),
                fillColor: whiteColor,

                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25)),
                alignLabelWithHint: true,
                hintText: label,
                hintStyle: TextStyle(
                    fontFamily: fontFamily, color: primaryColor, fontSize: 14),
                // label: Text(
                //   label,
                //   style: TextStyle(
                //       fontFamily: fontFamily,
                //       color: primaryColor,
                //       fontSize: 14),
                // ),
              ),
            ),
    );
  }
}

class PassFormField extends StatefulWidget {
  const PassFormField({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  State<PassFormField> createState() => _PassFormFieldState();
}

class _PassFormFieldState extends State<PassFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.always,
      decoration: InputDecoration(
        // alignLabelWithHint: true,
        constraints: const BoxConstraints(maxHeight: 70),
        suffix: InkWell(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 0),
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: primaryColor,
              size: 20,
            ),
          ),
        ),

        //  IconButton(
        //     onPressed: () {

        //     },
        //     icon: Icon(
        //       _obscureText ? Icons.visibility : Icons.visibility_off,
        //       color: blackColor,
        //     )),
        contentPadding: const EdgeInsets.only(
          left: 20,
          // bottom: 20
          // bottom: 10,
        ),
        fillColor: whiteColor,
        //  alignLabelWithHint: true,
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25)),
        hintText: widget.label,
        hintStyle: TextStyle(
            fontFamily: fontFamily, color: primaryColor, fontSize: 14),
        // label: Text(
        //   widget.label,
        //   style: TextStyle(
        //       fontFamily: fontFamily, color: primaryColor, fontSize: 14),
        // ),
      ),
    );
  }
}
