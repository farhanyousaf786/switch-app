import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:time_formatter/time_formatter.dart';

import 'SwitchChatComposer.dart';
import 'package:switchapp/MainPages/switchChat/SwitchMessage.dart';
import 'package:switchapp/MainPages/switchChat/relationShipButtons.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

late Map data; // for passing it as parameter

class SwitchChat extends StatefulWidget {
  SwitchChat({
    required this.receiverName,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverEmail,
    required this.groupChatId,
    required this.myId,
    required this.inRelationShipId,
    required this.listForSendButton,
    required this.blockBy,
    // this.inRelationShip
  });

  final String receiverName;
  final String receiverId;
  final String receiverAvatar;
  final String receiverEmail;
  final String groupChatId;
  final String inRelationShipId;
  final String myId;
  final String blockBy;
  final List listForSendButton;

  // final String inRelationShip;

  @override
  _SwitchChatState createState() => _SwitchChatState();
}

class _SwitchChatState extends State<SwitchChat> {
  @override
  void initState() {
    super.initState();
    _getLastVisitStatus();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoadingLastTimeVisit = false;
      });
    });
  }

  bool isRecording = false;
  bool isHide = true;
  bool animation2 = false;
  bool isLoadingLastTimeVisit = true;
  String swipeMessage = "";
  final FocusNode focusNode = FocusNode();
  late String replyMessage = "";

  loveTextFunction() {
    setState(() {
      animation1 = true;
    });
  }

  late Map userData;

  getUserData(String uid) async {
    await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          userData = dataSnapshot.value;
        });
      }
    });
  }

  _triggerSecondLoveAnimation() {
    setState(() {
      animation2 = true;
    });

    loveNoteBottomSheet(
      Constants.content,
      Constants.timeStamp,
    );
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        animation2 = false;
      });
    });
  }

  loveNoteBottomSheet(
    content,
    timeStamp,
  ) {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 2.2,
            child: SingleChildScrollView(
              child: Stack(children: [
                Container(

                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(Icons.linear_scale_sharp,
                          color: Colors.white,),
                      ],
                    ),
                  ),
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Love Note",
                          style: TextStyle(
                            fontFamily: 'cute',
                            color: Colors.pinkAccent,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: RiveAnimation.asset(
                            'images/chatNotes/loveNoteLogo.riv',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      height: 500,
                      width: 500,
                      child: RiveAnimation.asset(
                        'images/chatNotes/rocket-1.riv',
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 30,
                      right: 30,
                      bottom: 200,
                      child: DelayedDisplay(
                        delay: Duration(seconds: 4),
                        slidingBeginOffset: Offset(1, 0.0),
                        child: SingleChildScrollView(
                          child: Text(
                            content,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'cute'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          );
        });
  }

  recording() {
    if (isRecording == false) {
      setState(() {
        isRecording = true;
      });
    } else {
      setState(() {
        isRecording = false;
      });
    }
  }

  bool animation1 = false;

  Map? map;
  late String time = "";

  _getLastVisitStatus() {
    FirebaseDatabase.instance
        .reference()
        .child("switchLastVisit-786")
        .child(Constants.myId)
        .child(widget.receiverId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        map = dataSnapshot.value;

        int timestamp = int.parse(map!['timeStamp']);

        time = formatTime(timestamp);
      } else {
        setState(() {
          time = "";
        });
      }
    });
  }

  chatMoodButton(String moodData) {
    if (widget.inRelationShipId == widget.receiverId) {
      return RelationShipButtons(
        receiverAvatar: widget.receiverAvatar,
        receiverEmail: widget.receiverEmail,
        receiverName: widget.receiverName,
        receiverId: widget.receiverId,
        groupChatId: widget.groupChatId,
        moodData: moodData,
      );
    } else {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  _chatComposer() {
    if (widget.blockBy == "" || widget.blockBy == null) {
      return DelayedDisplay(
        delay: Duration(milliseconds: 50),
        slidingBeginOffset: Offset(0.0, 1),
        child: Container(
          child: SwitchChatComposer(
            replyMessage: replyMessage,
            onCancelReplyMessage: cancelReply,
            focusNode: focusNode,
            receiverAvatar: widget.receiverAvatar,
            receiverEmail: widget.receiverEmail,
            receiverName: widget.receiverName,
            receiverId: widget.receiverId,
            groupChatId: widget.groupChatId,
            myId: widget.myId,
            loveTextCallback: loveTextFunction,
            recordingCallBack: recording,
            inRelationShipId: widget.inRelationShipId,
            mood: data["mood"],
          ),
          color: Colors.transparent,
        ),
      );
    } else if (widget.myId == widget.blockBy) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "You Block this person",
          style: TextStyle(
            fontFamily: 'cute',
          ),
        ),
      );
    } else if (widget.myId != widget.blockBy) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "You Are Blocked",
          style: TextStyle(fontFamily: 'cute', color: Colors.red),
        ),
      );
    } else {
      return DelayedDisplay(
        delay: Duration(milliseconds: 50),
        slidingBeginOffset: Offset(0.0, 1),
        child: Container(
          child: SwitchChatComposer(
            replyMessage: replyMessage,
            onCancelReplyMessage: cancelReply,
            focusNode: focusNode,
            receiverAvatar: widget.receiverAvatar,
            receiverEmail: widget.receiverEmail,
            receiverName: widget.receiverName,
            receiverId: widget.receiverId,
            groupChatId: widget.groupChatId,
            myId: widget.myId,
            loveTextCallback: loveTextFunction,
            recordingCallBack: recording,
            inRelationShipId: widget.inRelationShipId,
            mood: data["mood"],
          ),
          color: Colors.transparent,
        ),
      );
    }
  }

  onReplyMessage(String message) {
    replyMessage = message;
    Constants.isMessageReply = "yes" + message;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      WillPopScope(
        onWillPop: () async {
          chatListRtDatabaseReference
              .child(Constants.myId)
              .child(widget.receiverId)
              .once()
              .then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
              chatListRtDatabaseReference
                  .child(Constants.myId)
                  .child(widget.receiverId)
                  .update({"isRead": true});
            }
          });

          Navigator.of(context).pop(true);

          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: StreamBuilder(
              stream: chatMoodReferenceRtd.child(Constants.myId).onValue,
              builder: (context, AsyncSnapshot dataSnapShot) {
                if (dataSnapShot.hasData) {
                  DataSnapshot snapshot = dataSnapShot.data.snapshot;
                  data = snapshot.value;
                  if (snapshot == null) {
                    print("empty data");
                  } else {
                    return Center(
                      child: Container(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              child: DelayedDisplay(
                                delay: Duration(milliseconds: 50),
                                slidingBeginOffset: Offset(0.0, -1),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, right: 8, top: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back_ios_sharp,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  chatListRtDatabaseReference
                                                      .child(Constants.myId)
                                                      .child(widget.receiverId)
                                                      .once()
                                                      .then((DataSnapshot
                                                          snapshot) {
                                                    if (snapshot.value !=
                                                        null) {
                                                      chatListRtDatabaseReference
                                                          .child(Constants.myId)
                                                          .child(
                                                              widget.receiverId)
                                                          .update(
                                                              {"isRead": true});
                                                      Navigator.pop(context);
                                                    } else {
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                },
                                              ),
                                              DelayedDisplay(
                                                  delay: Duration(seconds: 1),
                                                  slidingBeginOffset:
                                                      Offset(0.0, -1),
                                                  child: _chatVisitTime()),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  DelayedDisplay(
                                                    fadeIn: true,
                                                    slidingCurve:
                                                        Curves.easeInOutSine,
                                                    delay: Duration(
                                                        milliseconds: 222),
                                                    slidingBeginOffset:
                                                        Offset(0, -0.35),
                                                    child: Text(
                                                      "${widget.receiverName.characters.take(10)} ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'cutes',
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () => {
                                                  getUserData(
                                                      widget.receiverId),
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    final user =
                                                        Provider.of<User>(
                                                            context,
                                                            listen: false);

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Provider<
                                                                User>.value(
                                                          value: user,
                                                          child: SwitchProfile(
                                                            currentUserId:
                                                                user.uid,
                                                            mainProfileUrl:
                                                                userData['url'],
                                                            mainFirstName:
                                                                userData[
                                                                    'firstName'],
                                                            profileOwner:
                                                                userData[
                                                                    'ownerId'],
                                                            mainSecondName:
                                                                userData[
                                                                    'secondName'],
                                                            mainCountry:
                                                                userData[
                                                                    'country'],
                                                            mainDateOfBirth:
                                                                userData['dob'],
                                                            mainAbout: userData[
                                                                'about'],
                                                            mainEmail: userData[
                                                                'email'],
                                                            mainGender:
                                                                userData[
                                                                    'gender'],
                                                            username: userData[
                                                                'username'],
                                                            isVerified: userData[
                                                                'isVerified'],
                                                            action:
                                                                'notificationPage',
                                                            user: user,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            widget
                                                                .receiverAvatar),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      chatMoodButton(data['mood']),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SwitchMessages(
                                groupChatId: widget.groupChatId,
                                myId: widget.myId,
                                inRelationShipId: widget.inRelationShipId,
                                receiverId: widget.receiverId,
                                mood: data['mood'],
                                listForSendButton: widget.listForSendButton,
                                loveTextCallback: loveTextFunction,
                                onSwipedMessage: (message) {
                                  onReplyMessage(message);
                                  focusNode.requestFocus();
                                }),

                            _chatComposer(),
                            // this is bottom of the screen for in relationship category where we can type message
                          ],
                        ),
                      ),
                    );
                  }
                }
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'cutes'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      animation1 == true
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      animation1 = false;
                    });
                    _triggerSecondLoveAnimation();
                  },
                  child: Container(
                    child: RiveAnimation.asset(
                      'images/chatNotes/romanticLoveNote.riv',
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(),
      animation2 == true
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      animation1 = false;
                    });
                  },
                  child: Container(
                    child: RiveAnimation.asset(
                      'images/chatNotes/spark.riv',
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(),
      isRecording == true
          ? Scaffold(
              backgroundColor: Colors.black.withOpacity(0.5),
              body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 300),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(
                              Icons.record_voice_over_outlined,
                              size: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Recording..",
                            ),
                          ),
                        ],
                      ),
                    )),
              ))
          : SizedBox(),
    ]);
  }

  _chatVisitTime() {
    if (isLoadingLastTimeVisit) {
      return Text("");
    } else {
      if (time == "") {
        return Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            "Never visit this chat",
            style: TextStyle(
                 fontSize: 11, fontWeight: FontWeight.bold),
          ),
        );
      } else {
        return Container(
          width: MediaQuery.of(context).size.width/3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: MarqueeWidget(

                  child: Text(
                    "${widget.receiverName} Visit this chat",
                    style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold),
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  time,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      }
    }
  }

  void cancelReply() {
    setState(() {
      replyMessage = "";
      Constants.isMessageReply = "no";
    });

    print("message Cancel")
;  }
}
