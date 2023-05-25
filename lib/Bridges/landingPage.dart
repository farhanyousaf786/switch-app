import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/services/auth/auth_service.dart';
import 'package:switchapp/pages/sign_in/SignInPage.dart';
import 'package:switchapp/pages/sign_options/SignOption.dart';
import 'package:switchapp/Bridges/bridgeToNavgation.dart';
import 'package:switchapp/Bridges/bridgeToSetEmailVerification.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/need_help/need_help_page.dart';
import '../pages/user_agreement/userAgreementPage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    intro();
    setNotificationCounter();
    checkUserData();
    super.initState();
  }

  checkUserData() async {

  }
  intro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// this intro is for main feed page
    if (prefs.getInt("intro") == null) {
      prefs.setInt("intro", 0);
      print("intro: ${prefs.getInt("intro")}");
      Constants.isIntro = "true";
    } else {
      if (prefs.getInt("intro")! <= 0) {
        print("intro: ${prefs.getInt("intro")}");
        Constants.isIntro = "true";
      } else {
        print("intro: ${prefs.getInt("intro")}");
        Constants.isIntro = "false";
      }
    }

    /// this intro is for Meme Profile page
    if (prefs.getInt("introForMemeProfile") == null) {
      prefs.setInt("introForMemeProfile", 0);
      print("introForMemeProfile: ${prefs.getInt("introForMemeProfile")}");
      Constants.isIntroForMemeProfile = "true";
    } else {
      if (prefs.getInt("introForMemeProfile")! <= 0) {
        print("introForMemeProfile: ${prefs.getInt("introForMemeProfile")}");
        Constants.isIntroForMemeProfile = "true";
      } else {
        print("introForMemeProfile: ${prefs.getInt("introForMemeProfile")}");
        Constants.isIntroForMemeProfile = "false";
      }
    }

    /// this intro is for ChatList page
    if (prefs.getInt("chatListIntro") == null) {
      prefs.setInt("chatListIntro", 0);
      Constants.introForChatListPage = "true";
    } else {
      if (prefs.getInt("chatListIntro")! <= 0) {
        print("chatListIntro: ${prefs.getInt("chatListIntro")}");
        Constants.introForChatListPage = "true";
      } else {
        print("chatListIntro: ${prefs.getInt("chatListIntro")}");
        Constants.introForChatListPage = "false";
      }
    }
  }

  setNotificationCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("notifyCounter", "0");
    setState(() {
      Constants.notifyBell = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// auth for checking that user is signIn or Not
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return HomeLanding();
            } else if (!user.emailVerified) {
              ///Main page take us to transation to one to another page through Navigation bar
              return BridgeToSetEmailVerification();
            } else {
              return Provider<User>.value(
                value: user,
                child: BridgeToNavigationPage(
                  user: user,
                ),
              );
            }
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                ),
              ),
            );
          }
        });
  }
}
