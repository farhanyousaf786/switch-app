import 'package:emojis/emoji.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Authentication/Auth/Auth.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/MainPages/AppSettings/privacyPolicy.dart';
import 'package:switchapp/MainPages/Profile/memeProfile/Meme-profile.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/complaintPage.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Themes/switchThemes.dart';
import 'package:switchapp/Themes/theme_services.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:switchapp/main.dart';

import '../../Authentication/SignOut/SignOut.dart';

class AppSettings extends StatefulWidget {
  final User user;

  AppSettings({required this.user});

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool isThemeChanging = false;
  SignOut signOut = new SignOut();

  List<Emoji> emList = Emoji.all(); // list of all Emojis
  List roadMapList = [
    "Launch Switch App",
    "Image Meme Posting",
    "Meme Ranking",
    "Clusty Chat",
    "Profile Rating",
    "Memer Ranking",
    "Memer Decency",
    "Profile Decency",
    "Video Meme Posting",
    "Group Chat",
    "MEME Competition will be added (b/w) Memer's Followers",
    "Meme Tournament (B/w) Memers",
    "Chat List Search",
    "Dark theme",
    "Clusty Friend",
    "Chat emoji",
    "Voice & Video Call",
    "Camera Filters",
    "will add more language",
  ];

  @override
  void initState() {
    super.initState();
    // getNotification();
  }

  // getNotification() {
  //   feedRtDatabaseReference
  //       .child(Constants.myId)
  //       .child("feedItems")
  //       .orderByChild("timestamp")
  //       .limitToLast(1)
  //       .onChildAdded
  //       .listen((data) {
  //     Map nData = data.snapshot.value;
  //     Future.delayed(const Duration(seconds: 1), () {
  //       //  widget.notification();
  //     });
  //   });
  // }

  TextEditingController userText = TextEditingController();

  _openBottomSheet(String type) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
               BarTop(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    type,
                    style: TextStyle(
                        fontSize: 20,
                         fontWeight: FontWeight.bold,
                        fontFamily: "cute", color: Colors.pink),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    maxLength: 500,
                    style: TextStyle(
                        color: Colors.lightBlue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    controller: userText,
                    decoration: InputDecoration(
                      fillColor: Colors.blue.shade50.withOpacity(0.5),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: new BorderSide(
                            color: Colors.lightBlue.shade700, width: 1),
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: new BorderSide(
                            color: Colors.lightBlue.shade700, width: 1),
                      ),
                      labelText: ' Write Here',
                      labelStyle: TextStyle(
                        fontFamily: "Cute",
                         fontWeight: FontWeight.bold,
                        color: Colors.lightBlue.shade700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => {
                    reportRTD.child(Constants.myId).push().set({
                      "type": "postReport",
                      "postId": "",
                      "description": userText.text,
                      "reportId": "",
                      "reportSenderId": Constants.myId,
                    }),
                    Fluttertoast.showToast(
                      msg: "Message sent, Wait for response",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.blue.withOpacity(0.8),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    ),
                    Navigator.pop(context),
                  },
                  child: Text("Send"),
                  // color: Colors.lightBlue.shade50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.isDark == "true"
          ? Themes().darkGrey.withOpacity(0.01) : Colors.white,
      appBar: AppBar(

        leading:  Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: RiveAnimation.asset(
            'images/authLogo.riv',
          ),
        ),
        backgroundColor:
            Constants.isDark == "true" ? Themes().darkModeColor : Colors.blue,
        elevation: 0,
        // title: Text(
        //   "Switch",
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       color: Colors.white, fontFamily: 'cute', fontSize: 20),
        // ),
        centerTitle: true,
        actions: [
          Center(
              child: Text(
            "Log Out ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
                color: Colors.white, fontFamily: 'cute', fontSize: 12),
          ),),
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onTap: () => signOut.signOut(widget.user.uid, context)),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                // Container(
                //   height: 130,
                //   width: MediaQuery.of(context).size.width,
                //   child: Material(
                //     clipBehavior: Clip.antiAlias,
                //     elevation: 10,
                //     color: Constants.isDark == "true"
                //         ? Themes().darkModeColor
                //         : Colors.blue,
                //     borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(15),
                //         bottomLeft: Radius.circular(15)),
                //     child: RiveAnimation.asset(
                //       'images/authLogo.riv',
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.white60,
                            // borderRadius: BorderRadius.circular(20),
                            ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Our Goal",
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,

                                  fontFamily: 'cute'),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Text(
                                  "As we know that, currently Memes are holding the advertising industry indirectly and directly."
                                  " Our plan is to make this platform an original meme content genrator."
                                  " First a meme must be generate here and the it should viral to other social platforms."
                                  "Moreover, we want to make this platform an earning source for Memers. Hope it will go well.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'cute'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.6,
                      decoration: BoxDecoration(
                          // color: Colors.white60,
                          // borderRadius: BorderRadius.circular(20),
                          ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                (states) => Constants.isDark == "true"
                                    ? Colors.grey
                                    : Colors.blueGrey,
                              ),
                              backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Constants.isDark == "true"
                                    ? Colors.grey
                                    : Colors.black12,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isThemeChanging = true;
                              });

                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _themeFunction();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Constants.isDark == "true"
                                      ? "Light Mode "
                                      : "Dark Mode ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'cute',

                                    color: Constants.isDark == "true"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Icon(
                                  Constants.isDark == "true"
                                      ? Icons.wb_sunny
                                      : Icons.nightlight_round,
                                  color: Constants.isDark == "true"
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.user.uid == Constants.switchIdLaaSY
                    ? SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 20, right: 20),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                // color: Colors.white60,
                                // borderRadius: BorderRadius.circular(20),
                                ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.white.withOpacity(0.5)),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                      (states) => Colors.green.withOpacity(0.9),
                                    ),
                                  ),
                                  onPressed: () async {
                                    //introForMemeProfile
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt("intro", 0);
                                    prefs.setInt("introForMemeProfile", 0);
                                    prefs.setInt("chatListIntro", 0);

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LandingPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Watch introduction",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'cute'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                widget.user.uid == Constants.switchIdLaaSY
                    ? SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 20, right: 20),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                // color: Colors.white60,
                                // borderRadius: BorderRadius.circular(20),
                                ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white
                                                  .withOpacity(0.5)),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.blue
                                                  .withOpacity(0.9))),
                                  onPressed: () =>
                                      {universalMethods.whatsNew(context)},
                                  child: Text(
                                    "Whats New",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'cute'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ComplaintUs()))
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Send Us Complaint",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'cute',
                              fontSize: 13),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy())),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Terms of use & Privacy Policy",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'cute',
                              fontSize: 13),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Switch App",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        fontFamily: 'cute'),
                  )),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Center(
                    child: Text(
                      "Version 1.5",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                          fontFamily: 'cute'),
                    ),
                  ),
                ),
              ],
            ),
            // isThemeChanging
            //     ? Center(
            //         child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           padding: EdgeInsets.all(8),
            //             decoration: BoxDecoration(
            //                 color: Colors.white.withOpacity(0.9),
            //                 borderRadius: BorderRadius.circular(10)),
            //             width: MediaQuery.of(context).size.width / 1.5,
            //             child: Center(
            //               child: Text(
            //                 "Changing Theme..",
            //                 style: TextStyle(
            //                     color: Colors.lightBlue,
            //                     fontSize: 16,
            //                     fontFamily: 'cute'),
            //               ),
            //             )),
            //       ),)
            //     : Container(
            //         height: 0,
            //         width: 0,
            //       ),
          ],
        ),
      ),
    );
  }

  void _themeFunction() {
    ThemeService().switchTheme();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (Constants.isDark == "true") {
        setState(() {
          Constants.isDark = "false";
        });
      } else {
        setState(() {
          Constants.isDark = "true";
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyApp(),
        ),
        (route) => false,
      );
    });
  }
}
