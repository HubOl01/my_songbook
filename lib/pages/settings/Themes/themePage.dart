import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/core/styles/Themes.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/colors.dart';


class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(LocaleKeys.settings_theme_mode)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              // elevation: 100,
              color: Theme.of(context).primaryColor,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                LabeledRadio(
                    label: context.tr(LocaleKeys.theme_mode_auto),
                    groupValue: themeChanger.themeMode,
                    value: mode(0),
                    onChanged: themeChanger.toggleTheme),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 2.5,
                    height: 0,
                  ),
                ),
                LabeledRadio(
                    label: context.tr(LocaleKeys.theme_mode_light),
                    groupValue: themeChanger.themeMode,
                    value: mode(1),
                    onChanged: themeChanger.toggleTheme),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 2.5,
                    height: 0,
                  ),
                ),
                LabeledRadio(
                    label: context.tr(LocaleKeys.theme_mode_dark),
                    groupValue: themeChanger.themeMode,
                    value: mode(2),
                    onChanged: themeChanger.toggleTheme),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio(
      {required this.label,
      required this.groupValue,
      required this.value,
      required this.onChanged,
      super.key});
  final String label;
  final ThemeMode groupValue;
  final ThemeMode value;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      title: Text(label),
      trailing: Radio(
          fillColor: MaterialStateColor.resolveWith((states) => colorFiolet),
          focusColor: MaterialStateColor.resolveWith((states) => colorFiolet),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged),
    );
  }
}