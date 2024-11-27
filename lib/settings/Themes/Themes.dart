import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:my_songbook/Storage/storage.dart';
import 'package:my_songbook/main.dart';
import 'package:my_songbook/styles/colors.dart';

class Themes {
  static final dark = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    // hintColor: Colors.blue,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorFiolet),
    indicatorColor: colorFiolet,
    sliderTheme: SliderThemeData(
        activeTrackColor: colorFiolet,
        overlayColor: colorFiolet.withOpacity(0.3),
        thumbColor: colorFiolet,
        inactiveTrackColor: colorFiolet.withOpacity(0.3)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(colorFiolet))),
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
    // c: backgroundColorDark,
    dialogBackgroundColor: backgroundColorDark,
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
    primaryColor: appBarColorDark,
    snackBarTheme: SnackBarThemeData(
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: textColorDark,
      backgroundColor: backgroundColorDark,
    ),
    listTileTheme:
        ListTileThemeData(iconColor: textColorDark, textColor: textColorDark),
    switchTheme: SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.2)),
    ),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
            color: textColorDark, fontSize: 25, fontWeight: FontWeight.bold)),
  );

  static final light = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    sliderTheme: SliderThemeData(
        activeTrackColor: colorFiolet,
        overlayColor: colorFiolet.withOpacity(0.3),
        thumbColor: colorFiolet,
        inactiveTrackColor: colorFiolet.withOpacity(0.3)),
    primaryTextTheme:
        const TextTheme(titleMedium: TextStyle(color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(colorFiolet),
            foregroundColor: WidgetStatePropertyAll(Colors.white))),
    inputDecorationTheme: InputDecorationTheme(),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorFiolet),
    indicatorColor: colorFiolet,
    appBarTheme: AppBarTheme(
        backgroundColor: colorFiolet,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)))),
    primaryColor: Colors.white,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
       foregroundColor: WidgetStatePropertyAll(colorFiolet)
      )
    ),
    dialogTheme: DialogTheme(
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
    AppMetrica.reportEvent('ThemePage: ${_themeMode}');
    notifyListeners();
  }
  // bool isOn = false;

  // ThemeData get currentTheme => isOn ? Themes.dark : Themes.light;
  // toggleTheme() {
  //   isOn = !isOn;
  //   notifyListeners();
  // }
}
