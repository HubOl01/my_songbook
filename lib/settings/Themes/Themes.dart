import 'package:flutter/material.dart';
import 'package:my_songbook/Storage/storage.dart';
import 'package:my_songbook/main.dart';
import 'package:my_songbook/styles/colors.dart';

class Themes {
  static final dark = ThemeData(
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
            backgroundColor: MaterialStatePropertyAll(colorFiolet))),
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
        bodyLarge: TextStyle(backgroundColor: textColorDark),
        bodySmall: TextStyle(backgroundColor: subColorDark)),
    backgroundColor: backgroundColorDark,
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
    brightness: Brightness.light,
    // hintColor: Colors.blue,
    sliderTheme: SliderThemeData(
        activeTrackColor: colorFiolet,
        overlayColor: colorFiolet.withOpacity(0.3),
        thumbColor: colorFiolet,
        inactiveTrackColor: colorFiolet.withOpacity(0.3)),
    // iconButtonTheme: IconButtonThemeData(
    // style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(colorFiolet), iconColor: MaterialStatePropertyAll(colorWhite))),
    // indicatorColor: Colors.blue,
    // primaryTextTheme:
    // const TextTheme(titleMedium: TextStyle(color: Colors.black)),
    // buttonTheme: ButtonThemeData(buttonColor: colorFiolet),
    primaryTextTheme:
        const TextTheme(titleMedium: TextStyle(color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(colorFiolet))),
    // progressIndicatorTheme: const ProgressIndicatorThemeData(
    // color: Colors.blue, linearTrackColor: Colors.blue),
    inputDecorationTheme: InputDecorationTheme(
        // hintStyle: TextStyle(color: colorFiolet),
        // helperStyle: TextStyle(color: colorFiolet),
        // labelStyle: TextStyle(color: colorFiolet),
        // border: OutlineInputBorder(borderSide: BorderSide(color: lineColor)),
        // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorFiolet)),
        // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorFiolet), ),
        // labelStyle: const TextStyle(color: Colors.blue, fontSize: 24.0),
        ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorFiolet),
    indicatorColor: colorFiolet,
    // scrollbarTheme: ScrollbarThemeData(
    //   colo
    // ),
    // brightness: Brightness.light,
    appBarTheme: AppBarTheme(
        backgroundColor: colorFiolet,
        // foregroundColor: textColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)))),
    // scaffoldBackgroundColor: colorWhite,
    // primaryColor: colorWhite,
    // textTheme: TextTheme(
    //     bodyLarge: TextStyle(backgroundColor: textColor),
    //     bodySmall: TextStyle(backgroundColor: subColor)),
    // backgroundColor: backgroundColor,
    // dialogBackgroundColor: backgroundColor,
    // dialogTheme: DialogTheme(

    // titleTextStyle: TextStyle(
    // color: textColor, fontSize: 25, fontWeight: FontWeight.bold)
    // ),

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
    // snackBarTheme: SnackBarThemeData(
    //   backgroundColor: Colors.black87,
    //   actionTextColor: Colors.white,
    //   contentTextStyle: TextStyle(color: Colors.white,)
    // ),
    // dividerColor: lineColor,
    primaryColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // backgroundColor: colorFiolet,
        // unselectedIconTheme: IconThemeData(color: colorFiolet)
        selectedIconTheme: IconThemeData(color: colorFiolet)),
    // expansionTileTheme: ExpansionTileThemeData(backgroundColor: colorFiolet.withOpacity(0.3))
    // iconTheme: IconThemeData(color: colorWhite),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   foregroundColor: textColor,
    //   backgroundColor: backgroundColor,
    // ),
    // listTileTheme:
    //     ListTileThemeData(iconColor: textColor, textColor: textColor),
    // switchTheme: SwitchThemeData(
    // thumbColor:
    // MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    // if (states.contains(MaterialState.selected)) {
    // return Colors.blue;
    // }
    // return Colors.white;
    // }),
    // trackColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.2)),
    // ),
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
    notifyListeners();
  }
  // bool isOn = false;

  // ThemeData get currentTheme => isOn ? Themes.dark : Themes.light;
  // toggleTheme() {
  //   isOn = !isOn;
  //   notifyListeners();
  // }
}
