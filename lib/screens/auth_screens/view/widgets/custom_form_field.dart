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
          horizontal: MediaQuery.of(context).size.width * 0.08, vertical: 5),
      child: Container(
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: whiteColor),
        child: TextFormField(
          obscureText: isPassword,
          controller: controller,
          autovalidateMode: AutovalidateMode.always,
          decoration: InputDecoration(
              suffix: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.visibility)),
              contentPadding: const EdgeInsets.only(
                left: 15,
                bottom: 5,
              ),
              border: InputBorder.none,
              hintText: label,
              hintStyle:
                  TextStyle(fontFamily: fontFamily, color: primaryColor)),
        ),
      ),
    );
  }
}
