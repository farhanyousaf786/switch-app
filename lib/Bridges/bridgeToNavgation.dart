/*
 * This class will manage the flow of app.
 * DATA COLLECTED from firebase.
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Authentication/SignOut/SignOut.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/MainPages/NavigationBar/NavigationBar.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/postReportPage.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:url_launcher/url_launcher.dart';

class BridgeToNavigationPage extends StatefulWidget {
  final User user;

  const BridgeToNavigationPage({required this.user});

  @override
  _BridgeToNavigationPageState createState() => _BridgeToNavigationPageState();
}

class _BridgeToNavigationPageState extends State<BridgeToNavigationPage> {
  bool isLoading = true;
  bool clickHereButton = true;
  bool isUsernameSet = false;
  String message = "Network Searching..";
  String updateLink = "http://switchapp.live/#/switchappinfo";
  String isAppLive = "";
  String appVersion = "";
  String memeComp = "";
  Map? controlData;
  SignOut signOut = new SignOut();


  @override
  void initState() {
    print(widget.user.uid);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted)
        setState(() {
          clickHereButton = false;
        });
    });
    userData(widget.user);
    checkAppControl();
    super.initState();
  }

  userData(User user) {
    checkUserData(user);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });
  }

  checkUserData(User user) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('username')) {
      getUserData(prefs);
    } else {
      print("*****((Set User Data at Bridget To Navigation))*****");
      Map userMap;
      userRefRTD.child(user.uid).once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          userMap = dataSnapshot.value;
          prefs.setString("firstName", userMap['firstName']);
          prefs.setString("ownerId", userMap['ownerId']);
          prefs.setString("url", userMap['url']);
          prefs.setString("secondName", userMap['secondName']);
          prefs.setString("email", userMap['email']);
          prefs.setString("currentMood", userMap['currentMood']);
          prefs.setString("gender", userMap['gender']);
          prefs.setString("country", userMap['country']);
          prefs.setString("dob", userMap['dob']);
          prefs.setString("about", userMap['about']);
          prefs.setString("username", userMap['username']);
          prefs.setString("isVerified", userMap['isVerified']);
          prefs.setString("isBan", userMap['isBan']);
          getUserData(prefs);
        }
      });
    }
  }

  getUserData(SharedPreferences prefs) {
    print("*****((Get User Data at Bridget To Navigation))*****");
    Constants.myName = prefs.getString("firstName")!;
    Constants.myId = prefs.getString("ownerId")!;
    Constants.imageUrl = prefs.getString("url")!;
    Constants.mySecondName = prefs.getString("secondName")!;
    Constants.myEmail = prefs.getString("email")!;
    Constants.mood = prefs.getString("currentMood")!;
    Constants.gender = prefs.getString("gender")!;
    Constants.country = prefs.getString("country")!;
    Constants.dob = prefs.getString("dob")!;
    Constants.about = prefs.getString("about")!;
    Constants.username = prefs.getString("username")!;
    Constants.isVerified = prefs.getString("isVerified")!;
    Constants.isBan = prefs.getString("isBan")!;
    print("username >>>>>>>>>>>>>>>>>> ${prefs.getString("username")!}");
  }

  checkAppControl() async {
    await appControlRTD.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        if (mounted)
          setState(() {
            controlData = dataSnapshot.value;
          });
        message = controlData?['message'];
        updateLink = controlData?["updateLink"];
        isAppLive = controlData?["isAppLive"];
        appVersion = controlData?["appVersion"];
        memeComp = controlData?["compStatus"];
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return uI();
  }

  // if isAppLive == 'true' the app will check if user ban or not and proceed accordingly.

  // if isAppLive == 'false' and connection is good then app will show message that is update
  // through firebase, because then firebase change [message = "Network Searching.."] to it's
  //  updated message.

  // if isAppLive == 'true' and message = "Network Searching.." then app will show network error
  // or may be go to main page to show errors in different sections of app.

  // default link will lead you to switchapp.live website for details

  // How to block app

  // Go to firebase, Change isAppLive = 'yes' to 'no', and give message
  Widget uI() {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "",
                  style: TextStyle(
                      fontFamily: 'cute', fontSize: 18, color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinKitThreeBounce(
                  color: Colors.blue,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (isAppLive == "yes") {
      if (Constants.isBan == "true") {
        return Scaffold(
          backgroundColor: Colors.lightBlue,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Switch App",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'cute', fontSize: 25),
            ),
            backgroundColor: Colors.lightBlue,
            actions: [
              Center(
                  child: Text(
                "Log Out",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'cute', fontSize: 15),
              )),
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => signOut.signOut(widget.user.uid, context)),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "You are Ban from Switch!",
                    style: TextStyle(
                        fontFamily: 'cute', fontSize: 15, color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "There could be many reasons for this, If you think this is by mistake. \n\n Or Send us report And email us at mail@switchapp.live",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'cute', fontSize: 14, color: Colors.blue),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(15)),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostReport(
                              reportById: widget.user.uid,
                              reportedId: "",
                              postId: "",
                              type: "ForRecoverAccount",
                            ),
                          ),
                        )
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Send Your Claim",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'cutes'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return NavigationPage(
          user: widget.user,
          controlData: controlData,
          appVersion: appVersion,
        );
      }
    } else {
      return widget.user.uid == Constants.switchId
          ? NavigationPage(
              user: widget.user,
              controlData: controlData,
              appVersion: appVersion,
            )
          : Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    clickHereButton == true
                        ? Container(
                            width: 0,
                            height: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              message,
                              style: TextStyle(
                                  fontFamily: 'cute',
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                          ),
                    clickHereButton == true
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LandingPage(),
                                ),
                                (route) => false,
                              ),
                              child: Container(
                                height: 38,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Refresh",
                                    style: TextStyle(
                                        fontFamily: 'cute',
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 16,
                      ),
                    ),
                    clickHereButton == true
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : SizedBox(
                            height: 20,
                          ),
                    clickHereButton == true
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Click below for more info.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'cute',
                                  color: Colors.blue,
                                  fontSize: 12),
                            ),
                          ),
                    clickHereButton == true
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : TextButton(
                            onPressed: () => _launchURL(),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Click here",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'cute',
                                    color: Colors.grey,
                                    fontSize: 10),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
    }
  }

  _launchURL() async {
    if (await canLaunch(updateLink)) {
      await launch(updateLink);
    } else {
      throw 'Could not launch $updateLink';
    }
  }

}
