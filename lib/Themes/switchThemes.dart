import 'package:flutter/material.dart';

const Color blueishColor = Color(0xFF4e5ae8);
const Color yellowColor = Color(0xFFFFB746);
const Color pinkColor = Color(0xFFff4667);
const Color whiteColor = Colors.white;
const primaryColor = blueishColor;
const Color darkGreyColor = Color(0xFF121212);

class Themes {

  final Color darkModeColor = Color(0xFF424242);
  final Color darkGrey = Color(0xFF121212);



  static final light = ThemeData(
    primaryColor: primaryColor,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    bottomAppBarColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,

    ),

  );
  static final dark = ThemeData(
    primaryColor: Colors.grey.shade900,
    brightness: Brightness.dark,
    backgroundColor: Colors.grey.shade900,
    scaffoldBackgroundColor: Colors.grey.shade900,
    bottomAppBarColor: Colors.grey.shade900,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade900,

    ),
  );
}
