import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final onPressed;
  final child;
  const CustomButton({super.key, required this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            // Change your radius here
            borderRadius: BorderRadius.circular(10),
          ),
        )));
  }
}
