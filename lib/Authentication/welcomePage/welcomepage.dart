/*
 * this is a simple page that show welcome screen.
 */

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:timelines/timelines.dart';

class WelcomePage extends StatefulWidget {
  final User user;

  const WelcomePage({required this.user});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            },
            child: Row(
              children: [
                Text(
                  'Done',
                  style: TextStyle(
                      fontSize: 18.0, fontFamily: 'cute', color: Colors.blue),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.navigate_next_outlined,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    DelayedDisplay(
                      delay: Duration(seconds: 1),
                      slidingBeginOffset: Offset(0.0, -1.0),
                      child: Container(
                        height: 100,
                        width: 200,
                        child: RiveAnimation.asset(
                          'images/switchLogoBlue.riv',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: DelayedDisplay(
                        delay: Duration(seconds: 2),
                        slidingBeginOffset: Offset(0.0, -1.0),
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'cute',
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: TextLiquidFill(
                        text: 'Switch App',
                        waveColor: Colors.blue.shade600,
                        boxBackgroundColor: Colors.white,
                        waveDuration: Duration(seconds: 2),
                        loadDuration: Duration(seconds: 2),
                        textStyle: TextStyle(
                          fontFamily: 'cute',
                          fontSize: 30.0,
                        ),
                        boxHeight: 80.0,
                      ),
                    ),
                  ],
                ),
              ),
              DelayedDisplay(
                delay: Duration(seconds: 3),
                slidingBeginOffset: Offset(0.0, -1.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 8,
                      ),
                      child: Text(
                        "Introduction:",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'cute',
                            fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
              DelayedDisplay(
                delay: Duration(seconds: 4),
                slidingBeginOffset: Offset(0.0, -1.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "This is a platform that will connect people around the world. Basically, this app will provide user to manage his/her profile, MEME profile etc."
                      "There are many Feature will be update in this app very soon. This could be consider a BETA version of App."
                      " Thank you to download this App.",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'cutes',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              DelayedDisplay(
                delay: Duration(seconds: 5),
                slidingBeginOffset: Offset(0.0, 0.40),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Road Map",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'cute'),
                      ),
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: SpinKitRipple(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: 280,
                  child: DelayedDisplay(
                    delay: Duration(seconds: 6),
                    slidingBeginOffset: Offset(0.0, 0.40),
                    child: Timeline.tileBuilder(
                      builder: TimelineTileBuilder.fromStyle(
                        contentsAlign: ContentsAlign.alternating,
                        contentsBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            "${index + 1}. ${roadMapList[index]}",
                            textAlign: TextAlign.center,
                            style: index < 8
                                ? TextStyle(
                                    decorationStyle: TextDecorationStyle.solid,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.black54,
                                    fontFamily: "cutes",
                                    fontWeight: FontWeight.bold)
                                : TextStyle(
                                    color: Colors.white,
                                    fontFamily: "cutes",
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        itemCount: roadMapList.length,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
