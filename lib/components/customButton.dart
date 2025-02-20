import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/styles/colors.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  const CustomButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(onPressed == null
                ? context.isDarkMode
                    ? Colors.white.withValues(alpha: .7)
                    : Colors.grey[600]!.withValues(alpha: .5)
                : colorFiolet),
            foregroundColor: WidgetStatePropertyAll(onPressed == null
                ? context.isDarkMode
                    ? Colors.black.withValues(alpha: .5)
                    : Colors.white
                : Colors.white),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                // Change your radius here
                borderRadius: BorderRadius.circular(10),
              ),
            )),
        child: child);
  }
}
