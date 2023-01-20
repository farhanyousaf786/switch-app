import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/MainPages/TimeLineSwitch/MemeAndStuff/memeCompetition/uploadShotMeme.dart';

import 'uploadFlickMeme.dart';

class ParticipatePage extends StatefulWidget {
  final User user;

  const ParticipatePage({required this.user});

  @override
  _ParticipatePageState createState() => _ParticipatePageState();
}

class _ParticipatePageState extends State<ParticipatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          "Upload Page",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'cute',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<User>.value(
                        value: widget.user,
                        child: UploadFlickMeme(
                          type: "videoMemeT",
                          user: widget.user,
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      child: Center(
                        child: Text(
                          "Upload Meme (Video)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'cutes',
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      height: 40,
                      width: 200,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<User>.value(
                        value: widget.user,
                        child: UploadShotMemes(
                          type: "memeT",
                          uid: widget.user.uid,
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      child: Center(
                        child: Text(
                          "Upload Meme (Image)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'cutes',
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      height: 40,
                      width: 200,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  "RULES",
                  style: TextStyle(
                    color: Colors.red.shade200,
                    fontFamily: 'cute',
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            DelayedDisplay(
              fadeIn: true,
              delay: Duration(milliseconds: 300),
              slidingBeginOffset: Offset(0.0, 0.40),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 5),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "Limitations for MEMER:",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'cute',
                                  fontSize: 17),
                            ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "1) A meme profile with copied meme will not be ranked on TOP MEMERS.\n\n 2) Original Meme Content will be appreciated separably in this app.\n\n 3) If a meme being reported (copied meme), then the reported profile will be deleted after 1 or 2 warnings.\n\n"
                              "4) Such Meme Profile that disrespect any Religion, will be terminated w/o any warning.",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontFamily: 'cutes',
                                  fontSize: 13),
                            ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 5),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "Advantages of participation:",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'cute',
                                  fontSize: 17),
                            ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "1) Winners will be shown separately on the top of the Switch for a week. \n\n 2) Winner will be able get monetization ticket in future updates of Switch App &many more.",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontFamily: 'cutes',
                                  fontSize: 13),
                            ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 5),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "Meme Decency:",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'cute',
                                  fontSize: 17),
                            ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "In Future Updates, We will Rank Profiles with respect to (Meme Decency + Total Following).",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontFamily: 'cutes',
                                  fontSize: 13),
                            ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 5),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "What if my Meme is not showing after Post it?",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'cute',
                                  fontSize: 17),
                            ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Container(
                                child: Flexible(
                                    child: Text(
                              "If your Meme is not showing after posting it, You may visit your Meme Profile through, Timeline > Profile Picture > Meme Profile.",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontFamily: 'cutes',
                                  fontSize: 13),
                            ))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
