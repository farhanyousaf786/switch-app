import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Universal/Constans.dart';

class ThemeService {

  Future<String> isDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("isDarkTheme") == null) {
      prefs.setString("isDarkTheme", "false");
      Constants.isDark = "false";
//check
      print("isDarkTheme: ${prefs.getString("isDarkTheme")}");

      return "false";
    } else {
      if (prefs.getString("isDarkTheme") == "true") {
        print("isDarkTheme: ${prefs.getString("isDarkTheme")}");

        Constants.isDark = "true";
        return "true";
      } else {
        print("isDarkTheme: ${prefs.getString("isDarkTheme")}");
        Constants.isDark = "false";
        return "false";
      }
      //  followSwitchId();
      // bottomSheetForFollowing();
    }
  }

  void switchTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("isDarkTheme") == "true") {
      prefs.setString("isDarkTheme", "false");

      Constants.isDark = "true";

      print("isDarkTheme: ${prefs.getString("isDarkTheme")}");
    } else if (prefs.getString("isDarkTheme") == "false") {
      prefs.setString("isDarkTheme", "true");
      Constants.isDark = "false";

      print("isDarkTheme: ${prefs.getString("isDarkTheme")}");
    }
  }
}
