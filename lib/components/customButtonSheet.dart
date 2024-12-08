import 'package:flutter/material.dart';
import 'package:my_songbook/core/styles/colors.dart';

class CustomButtonSheet extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final bool? isSecond;
  final bool? isDelete;
  final double? fontSize;
  final double? width;
  final double? height;
  const CustomButtonSheet({
    super.key,
    this.onPressed,
    this.title = '',
    this.isSecond = false,
    this.isDelete = false,
    this.height,
    this.width,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(TextStyle(
              fontSize: fontSize,
              color: onPressed == null
                  ? Colors.white.withOpacity(.5)
                  : Colors.white)),
          elevation: const WidgetStatePropertyAll(0),
          // foregroundColor: WidgetStatePropertyAll(TextColors.textButton),
          backgroundColor: WidgetStatePropertyAll(
              isSecond! ? Colors.grey[600]!.withOpacity(.5) : isDelete! ? Colors.red[300] : colorFiolet),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: Text(
          title,
        ),
      ),
    );
  }
}
