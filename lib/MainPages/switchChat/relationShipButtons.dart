import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class RelationShipButtons extends StatefulWidget {
  RelationShipButtons(
      {
        required   this.receiverAvatar,
        required   this.receiverId,
        required   this.receiverName,
        required   this.receiverEmail,
        required    this.groupChatId,
        required    this.moodData});

  // final BaseAuth auth;
  // final VoidCallback onSignedOut;
  final String groupChatId;
  final String receiverName;
  final String receiverId;
  final String receiverAvatar;
  final String receiverEmail;
  final String moodData;


  @override
  _RelationShipButtonsState createState() => _RelationShipButtonsState();
}

class _RelationShipButtonsState extends State<RelationShipButtons> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage(
                          widget.moodData == 'romantic'
                              ? "images/romanticChatMood.gif"
                              : widget.moodData == 'sad'
                                  ? "images/sadChatMood.gif"
                                  : widget.moodData == 'angry'
                                      ? "images/angryChat.gif"
                                      : widget.moodData == 'break'
                                          ? "images/breakChat2.gif"
                                          : "images/romanticChatMood.gif",
                        ),
                        fit: BoxFit.scaleDown,
                        scale: 2),
                    color: Colors.white),
              ),
            ],
          ),
        ),
        isExpanded
            ? Container(
                padding: const EdgeInsets.only(left: 80, right: 10, top: 15),
                child: Text("List of Love Note"),)
            : DelayedDisplay(
                delay: Duration(seconds: 1),
                slidingBeginOffset: Offset(1, 0.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 70, right: 10, top: 15),
                  child: StreamBuilder(
                    stream: chatMoodReferenceRtd.child(Constants.myId).onValue,
                    builder: (context,AsyncSnapshot dataSnapShot) {
                      if (dataSnapShot.hasData) {
                        DataSnapshot snapshot = dataSnapShot.data.snapshot;
                        Map data = snapshot.value;
                        if (snapshot == null) {
                          print("empty data");
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    chatMoodReferenceRtd
                                        .child(Constants.myId)
                                        .update({
                                      'mood': "romantic",
                                      "timestamp":
                                          DateTime.now().millisecondsSinceEpoch,
                                    });
                                    chatMoodReferenceRtd
                                        .child(widget.receiverId)
                                        .update(
                                      {
                                        'mood': "romantic",
                                        "timestamp": DateTime.now()
                                            .millisecondsSinceEpoch,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                      color: data["mood"] == "romantic"
                                          ? Colors.pink.shade200
                                          : Colors.white,
                                    ),
                                    margin: EdgeInsets.all(8),
                                    child: Center(
                                      child: Shimmer.fromColors(
                                        baseColor: data["mood"] == "romantic"
                                            ? Colors.white
                                            : Colors.pink,
                                        highlightColor: Colors.pink,
                                        period: Duration(seconds: 3),
                                        child: Text(
                                          "Romantic",
                                          style: TextStyle(
                                              color: Colors.pink,
                                              fontSize: 12,
                                              fontFamily: 'cute',
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    chatMoodReferenceRtd
                                        .child(Constants.myId)
                                        .update({
                                      'mood': "break",
                                      "timestamp":
                                          DateTime.now().millisecondsSinceEpoch,
                                    });
                                    chatMoodReferenceRtd
                                        .child(widget.receiverId)
                                        .update(
                                      {
                                        'mood': "break",
                                        "timestamp": DateTime.now()
                                            .millisecondsSinceEpoch,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                      color: data["mood"] == "break"
                                          ? Colors.lightBlue.shade200
                                          : Colors.white,
                                    ),
                                    margin: EdgeInsets.all(8),
                                    child: Center(
                                      child: Shimmer.fromColors(
                                        baseColor: data["mood"] == "break"
                                            ? Colors.white
                                            : Colors.pink,
                                        highlightColor: Colors.pink,
                                        period: Duration(seconds: 3),
                                        child: Text(
                                          "Break",
                                          style: TextStyle(
                                              color: Colors.pink,
                                              fontSize: 12,
                                              fontFamily: 'cute',
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    chatMoodReferenceRtd
                                        .child(Constants.myId)
                                        .update({
                                      'mood': "sad",
                                      "timestamp":
                                          DateTime.now().millisecondsSinceEpoch,
                                    });
                                    chatMoodReferenceRtd
                                        .child(widget.receiverId)
                                        .update(
                                      {
                                        'mood': "sad",
                                        "timestamp": DateTime.now()
                                            .millisecondsSinceEpoch,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                      color: data["mood"] == "sad"
                                          ? Colors.grey.shade200
                                          : Colors.white,
                                    ),
                                    margin: EdgeInsets.all(8),
                                    child: Center(
                                      child: Shimmer.fromColors(
                                        baseColor: data["mood"] == "sad"
                                            ? Colors.white
                                            : Colors.pink,
                                        highlightColor: Colors.pink,
                                        period: Duration(seconds: 3),
                                        child: Text(
                                          "Sad",
                                          style: TextStyle(
                                              color: Colors.pink,
                                              fontSize: 12,
                                              fontFamily: 'cute',
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    chatMoodReferenceRtd
                                        .child(Constants.myId)
                                        .update({
                                      'mood': "angry",
                                      "timestamp":
                                          DateTime.now().millisecondsSinceEpoch,
                                    });
                                    chatMoodReferenceRtd
                                        .child(widget.receiverId)
                                        .update(
                                      {
                                        'mood': "angry",
                                        "timestamp": DateTime.now()
                                            .millisecondsSinceEpoch,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                      color: data["mood"] == "angry"
                                          ? Colors.red.shade200
                                          : Colors.white,
                                    ),
                                    margin: EdgeInsets.all(8),
                                    child: Center(
                                      child: Shimmer.fromColors(
                                        baseColor: data["mood"] == "angry"
                                            ? Colors.white
                                            : Colors.pink,
                                        highlightColor: Colors.pink,
                                        period: Duration(seconds: 3),
                                        child: Text(
                                          "Angry",
                                          style: TextStyle(
                                              color: Colors.pink,
                                              fontSize: 12,
                                              fontFamily: 'cute',
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    chatMoodReferenceRtd
                                        .child(Constants.myId)
                                        .update({
                                      'mood': "ignore",
                                      "timestamp":
                                          DateTime.now().millisecondsSinceEpoch,
                                    });
                                    chatMoodReferenceRtd
                                        .child(widget.receiverId)
                                        .update(
                                      {
                                        'mood': "ignore",
                                        "timestamp": DateTime.now()
                                            .millisecondsSinceEpoch,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                      color: data["mood"] == "ignore"
                                          ? Colors.teal.shade200
                                          : Colors.white,
                                    ),
                                    margin: EdgeInsets.all(8),
                                    child: Center(
                                      child: Shimmer.fromColors(
                                        baseColor: data["mood"] == "ignore"
                                            ? Colors.white
                                            : Colors.pink,
                                        highlightColor: Colors.pink,
                                        period: Duration(seconds: 3),
                                        child: Text(
                                          "ignore",
                                          style: TextStyle(
                                              color: Colors.pink,
                                              fontSize: 12,
                                              fontFamily: 'cute',
                                              fontWeight: FontWeight.w100),
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
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 100, left: 20, right: 20),
                        child: Text(
                          "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'cutes'),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
