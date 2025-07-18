import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../storage/storage.dart';
import 'colors.dart';

class Themes {
  static final dark = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    // hintColor: Colors.blue,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorFiolet),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorFiolet,
      selectionColor: colorFiolet.withValues(alpha: .5),
      selectionHandleColor: colorFiolet,
    ),
    sliderTheme: SliderThemeData(
        activeTrackColor: colorFiolet,
        overlayColor: colorFiolet.withValues(alpha: 0.3),
        thumbColor: colorFiolet,
        inactiveTrackColor: colorFiolet.withValues(alpha: 0.3)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ButtonStyle(backgroundColor: WidgetStatePropertyAll(colorFiolet))),
    // progressIndicatorTheme: const ProgressIndicatorThemeData(
    // color: Colors.blue, linearTrackColor: Colors.blue),
    // inputDecorationTheme: InputDecorationTheme(
    // border: OutlineInputBorder(borderSide: BorderSide(color: lineColorDark)),
    // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: lineColorDark)),
    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: lineColorDark)),
    // labelStyle: const TextStyle(color: Colors.blue, fontSize: 24.0),
    // ),
    // brightness: Brightness.light,
    appBarTheme: AppBarTheme(
        backgroundColor: appBarColorDark,
        foregroundColor: textColorDark,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)))),
    scaffoldBackgroundColor: backgroundColorDark,
    // primaryColor: textColorDark,
    textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColorDark),
        bodySmall: TextStyle(color: subColorDark)),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: backgroundColorDark),
    primaryTextTheme:
        const TextTheme(titleMedium: TextStyle(color: Colors.white)),
    // colorSchemeSeed: Colors.black,
    // colorScheme: ColorScheme(
    //   brightness: Brightness.light,
    //   background: backgroundColor,
    //   onBackground: backgroundColorDark,
    //   primary: textColor,
    //   onPrimary: textColor,
    //   secondary: textColor,
    //   onSecondary: textColor,
    //   error: Colors.red,
    //   onError: Colors.red[800]!,
    //   surface: backgroundColorDark,
    //   onSurface: backgroundColorDark,
    // ),
    // useMaterial3: true,
    // bottomAppBarTheme: BottomAppBarTheme(
    //   color: appBarColor
    // ),

    // bottomAppBarTheme: BottomAppBarTheme(),
    // bottomSheetTheme: BottomSheetThemeData(backgroundColor: appBarColor),
    tabBarTheme: TabBarThemeData(indicatorColor: colorFiolet),
    primaryColor: appBarColorDark,
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.black87,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(
          color: Colors.white,
        )),
    dividerColor: lineColorDark,

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appBarColorDark,
        selectedIconTheme: IconThemeData(color: colorFiolet),
        unselectedIconTheme: IconThemeData(color: textColorDark)),
    iconTheme: IconThemeData(color: textColorDark),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(colorFiolet),
            overlayColor:
                WidgetStatePropertyAll(colorFiolet.withValues(alpha: .2)))),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: textColorDark,
      backgroundColor: backgroundColorDark,
    ),
    listTileTheme:
        ListTileThemeData(iconColor: textColorDark, textColor: textColorDark),
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return colorFiolet;
        }
        return Colors.white;
      }),
      trackColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return colorFiolet.withValues(alpha: 0.2);
        }
        return Colors.white.withValues(alpha: 0.2);
      }),
    ),

    dialogTheme: DialogThemeData(
        backgroundColor: backgroundColorDark,
        titleTextStyle: TextStyle(
            color: textColorDark, fontSize: 25, fontWeight: FontWeight.bold)),
  );

  static final light = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    sliderTheme: SliderThemeData(
        activeTrackColor: colorFiolet,
        overlayColor: colorFiolet.withValues(alpha: 0.3),
        thumbColor: colorFiolet,
        inactiveTrackColor: colorFiolet.withValues(alpha: 0.3)),
    primaryTextTheme:
        const TextTheme(titleMedium: TextStyle(color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(colorFiolet),
            foregroundColor: const WidgetStatePropertyAll(Colors.white))),
    inputDecorationTheme: const InputDecorationTheme(),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorFiolet),
    tabBarTheme: TabBarThemeData(indicatorColor: colorFiolet),
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return colorFiolet;
        }
        return Colors.white;
      }),
      trackColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return colorFiolet.withValues(alpha: 0.2);
        }
        return colorFiolet.withValues(alpha: 0.05);
      }),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorFiolet,
      selectionColor: colorFiolet.withValues(alpha: .5),
      selectionHandleColor: colorFiolet,
    ),

    appBarTheme: AppBarTheme(
        backgroundColor: colorFiolet,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)))),
    primaryColor: Colors.white,
    // iconTheme: const IconThemeData(color: Colors.),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(colorFiolet),
            overlayColor:
                WidgetStatePropertyAll(colorFiolet.withValues(alpha: .2)))),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      // surfaceTintColor: C
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color: colorFiolet)),
  );
}

ThemeMode mode(int isDarked) {
  var mode = ThemeMode.system;
  switch (isDarked) {
    case 1:
      mode = ThemeMode.light;
      break;
    case 2:
      mode = ThemeMode.dark;
      break;
    default:
      mode = ThemeMode.system;
      break;
  }
  return mode;
}

int reversMode(ThemeMode mode) {
  var index = 0;
  switch (mode) {
    case ThemeMode.light:
      index = 1;
      break;
    case ThemeMode.dark:
      index = 2;
      break;
    default:
      index = 0;
      break;
  }
  return index;
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = mode(indexMode ?? 0);
  ThemeMode get themeMode => _themeMode;
  // bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(themeMode) async {
    // themeMode = isOn == 2 ? ThemeMode.dark : isOn == 1 ? ThemeMode.light : ThemeMode.system;
    _themeMode = themeMode;
    int index = reversMode(_themeMode);
    switCH(index);
    AppMetrica.reportEvent('ThemePage: $_themeMode');
    notifyListeners();
  }
  // bool isOn = false;

  // ThemeData get currentTheme => isOn ? Themes.dark : Themes.light;
  // toggleTheme() {
  //   isOn = !isOn;
  //   notifyListeners();
  // }
}
