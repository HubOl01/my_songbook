import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/styles/colors.dart';
import '../../generated/locale_keys.g.dart';

class ButtonSaveSong extends StatefulWidget {
  final Function()? onPressed;

  const ButtonSaveSong({super.key, this.onPressed});

  @override
  State<ButtonSaveSong> createState() => _ButtonSaveSongState();
}

class _ButtonSaveSongState extends State<ButtonSaveSong> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(widget.onPressed == null
            ? colorFiolet.withValues(alpha: .5)
            : colorFiolet),
      ),
      child: Text(
        tr(LocaleKeys.add_song_save),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
