import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/core/styles/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final Function(String value) onChanged;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      // style: TextStyle(fontSize: 14),
      onChanged: onChanged,
      maxLength: 20,
      textAlign: TextAlign.center,
      cursorColor: colorFiolet,
      decoration: InputDecoration(
        // counter: Align(
        //   alignment: Alignment.center,
        // ),
        counterText: "",
          // labelStyle: TextStyle(color: colorFiolet),
          hintText: title,
          hintStyle: TextStyle(color: context.isDarkMode ? Colors.white.withOpacity(.7) : Colors.grey[600]),
          alignLabelWithHint: true,
          disabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          )),
    );
  }
}
