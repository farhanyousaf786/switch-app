import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class Mood extends StatefulWidget {
  final User user;

  const Mood({required this.user});

  @override
  _MoodState createState() => _MoodState();
}

class _MoodState extends State<Mood> {
   String? mood;
  late Map moodData;

  @override
  void initState() {
    super.initState();
    getMood();
  }

  getMood() {
    switchUserMoodsRTD.child(widget.user.uid).once().then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot == null) {
        setState(() {
          mood = "happy";
          Constants.mood = "happy";
        });
      } else {
        moodData = dataSnapshot.value;

        mood = moodData['mood'];
        setState(() {
          Constants.mood = mood!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_sharp,
            size: 18,
          ),
        ),
        elevation: 6,
        title: Text(
          "Mood",
          style:
              TextStyle( fontFamily: 'cute', fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "This feature will update in future. And it will be an amazing experience for you all. Stay Tuned",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'cute',
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                height: 350,
                width: 180,
                child: ListView(children: [
                  GestureDetector(
                    onTap: () {
                      switchUserMoodsRTD.child(widget.user.uid).set({"mood": "happy"});

                      setState(() {
                        mood = "happy";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: mood == "happy"
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "Happy",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontFamily: 'cute',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      switchUserMoodsRTD
                          .child(widget.user.uid)
                          .set({"mood": "romantic"});

                      setState(() {
                        mood = "romantic";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: mood == "romantic"
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "romantic",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontFamily: 'cute',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      switchUserMoodsRTD.child(widget.user.uid).set({"mood": "angry"});

                      setState(() {
                        mood = "angry";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: mood == "angry"
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "Angry",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontFamily: 'cute',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      switchUserMoodsRTD.child(widget.user.uid).set({"mood": "sad"});

                      setState(() {
                        mood = "sad";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: mood == "sad"
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "Sad",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontFamily: 'cute',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          Positioned(
            height: 300,
            top: 480,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 350,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Lottie.asset(
                    'images/MoodBG.json',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
