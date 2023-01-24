import 'dart:async';
import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

class PostReactCounter extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String type;

  const PostReactCounter(
      {required this.postId, required this.ownerId, required this.type});

  @override
  _PostReactCounterState createState() => _PostReactCounterState();
}

class _PostReactCounterState extends State<PostReactCounter> {
  int like = 0;
  int disLike = 0;
  int heartReact = 0;
  bool isLike = false;
  bool isDislike = false;
  bool isHeart = false;
  String reactTypeR = "notExists";
  String postId = Uuid().v4();
  bool isDisable = false;

  @override
  void initState() {
    super.initState();

    getCurrentReactCount();
  }

  addReact(String reactType) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isDisable = true;
        });

        getCurrentReactCount();

        Future.delayed(const Duration(milliseconds: 100), () {
          if (reactType == "like") {
            if (mounted)
              setState(() {
                isLike = true;
                isDislike = false;
                isHeart = false;
              });
          } else if (reactType == "disLike") {
            if (mounted)
              setState(() {
                isDislike = true;
                isLike = false;
                isHeart = false;
              });
          } else if (reactType == "heartReact") {
            if (mounted)
              setState(() {
                isDislike = false;
                isLike = false;
                isHeart = true;
              });
          }

          reactRtDatabaseReference
              .child(Constants.myId)
              .child(widget.postId)
              .once()
              .then((DataSnapshot dataSnapshot) {
            if (dataSnapshot.exists) {
              print(dataSnapshot.value);
              print("Data Existssssss\n");
            } else {
              print("Not Existsssssss");
              reactRtDatabaseReference
                  .child('reactors')
                  .child(widget.postId)
                  .push()
                  .set({
                'reactorId': Constants.myId,
                'reactorName': Constants.myName,
                'reactorPhoto': Constants.myPhotoUrl,
              });

              ///Slit is here

              //
              //     if (widget.type == "meme" ||
              //         widget.type == "memeT" ||
              //         widget.type == "videoMemeT" ||
              //         widget.type == "videoMeme") {
              //       switchMemerSlitsRTD
              //           .child(widget.ownerId)
              //           .once()
              //           .then((DataSnapshot dataSnapshot) {
              //         Map data = dataSnapshot.value;
              //         int slits = data['totalSlits'];
              //         setState(() {
              //           slits = slits + 1;
              //         });
              //         Future.delayed(const Duration(milliseconds: 200), () {
              //           switchMemerSlitsRTD.child(widget.ownerId).update({
              //             'totalSlits': slits,
              //           });
              //           print(
              //               "Slitsssssssssssssssssssssssssssssssssssssssss $slits");
              //         });
              //       });
              //     } else {
              //       print(
              //           "noooooooooooooooooooooot memeeeeeeeeeeeeeeeeeeeeeeeeeeee");
              //     }
              //   }
            }
          });

          reactRtDatabaseReference.child(widget.postId).set({
            'like': reactType == "like"
                ? like + 1
                : reactTypeR == "like"
                    ? like - 1
                    : like,
            'disLike': reactType == "disLike"
                ? disLike + 1
                : reactTypeR == "disLike"
                    ? disLike - 1
                    : disLike,
            'heartReact': reactType == "heartReact"
                ? heartReact + 1
                : reactTypeR == "heartReact"
                    ? heartReact - 1
                    : heartReact,
            "timestamp": DateTime.now().millisecondsSinceEpoch,
          });

          feedRtDatabaseReference
              .child(widget.ownerId)
              .child("feedItems")
              .child(widget.postId)
              .set({
            "type": reactType == "like"
                ? "like"
                : reactType == "disLike"
                    ? "disLike"
                    : reactType == "heartReact"
                        ? "loveIt"
                        : "",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "url": Constants.myPhotoUrl,
            "postId": widget.postId,
            "ownerId": widget.ownerId,
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "isRead": false,
          });

          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              reactRtDatabaseReference
                  .child(Constants.myId)
                  .child(widget.postId)
                  .set({
                'reactType': reactType,
                "timestamp": DateTime.now().millisecondsSinceEpoch,
              });
            });
            getCurrentReactCount();
          });
        });

        Timer(Duration(seconds: 3), () {
          setState(() {
            isDisable = false;
          });
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: "Wifi/Data not connected",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  removeReact(String reactType) {
    print("react Created");
    reactRtDatabaseReference.child(widget.postId).set({
      'like': reactType == "like" ? like - 1 : like,
      'disLike': reactType == "disLike" ? disLike - 1 : disLike,
      'heartReact': reactType == "heartReact" ? heartReact - 1 : heartReact,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    reactRtDatabaseReference.child(Constants.myId).child(widget.postId).set({
      'reactType': reactType,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  getCurrentReactCount() {
    reactRtDatabaseReference
        .child(widget.postId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;

        if (mounted)
          setState(() {
            like = data['like'];
            disLike = data['disLike'];
            heartReact = data['heartReact'];
          });

        int total = (like + disLike + heartReact) * 10;

        print(
            "Yes this React is EXIST total = =>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${total.toString()}");
      } else {
        print("there is no react on this post");
      }
    });

    reactRtDatabaseReference
        .child(Constants.myId)
        .child(widget.postId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;

        reactTypeR = data['reactType'];

        if (reactTypeR == "like") {
          if (mounted)
            setState(() {
              isLike = true;
              isDislike = false;
              isHeart = false;
              reactTypeR = data['reactType'];
            });
        } else if (reactTypeR == "disLike") {
          if (mounted)
            setState(() {
              isDislike = true;
              isLike = false;
              isHeart = false;
              reactTypeR = data['reactType'];
            });
        } else if (reactTypeR == "heartReact") {
          if (mounted)
            setState(() {
              isDislike = false;
              isLike = false;
              isHeart = true;
              reactTypeR = data['reactType'];
            });
        }

        print("Yes this React is EXIST ${data['unLike']}");
      } else {
        print("there is no react on this post");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.green.withOpacity(0.2)),
              ),
              onPressed: () => {
                if (isLike)
                  {
                    print("Already Liked"),
                  }
                else
                  {
                    isDisable == false
                        ? addReact("like")
                        : Fluttertoast.showToast(
                            msg: "Wait for 3 seconds to change React",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          ),
                    // getCurrentReactCount();
                  }
              },
              child: Column(
                children: [
                  Icon(
                    isLike
                        ? Icons.trending_up_rounded
                        : Icons.trending_up_rounded,
                    size: 25,
                    color: isLike ? Colors.green : Colors.grey,
                  ),
                  StreamBuilder(
                    stream:
                        reactRtDatabaseReference.child(widget.postId).onValue,
                    builder: (context, AsyncSnapshot dataSnapShot) {
                      if (!dataSnapShot.hasData) {
                        return Text(
                          "0",
                          style: TextStyle(
                            fontFamily: 'cute',
                            color: Colors.grey.shade600,
                            fontSize: 10,
                          ),
                        );
                      } else {
                        DataSnapshot snapshot = dataSnapShot.data.snapshot;
                        Map data = snapshot.value;
                        List item = [];

                        return dataSnapShot.data.snapshot.value == null
                            ? Text(
                                "0",
                                style: TextStyle(
                                  fontFamily: 'cute',
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              )
                            : DelayedDisplay(
                                fadeIn: true,
                                slidingCurve: Curves.easeInOutSine,
                                delay: Duration(milliseconds: 222),
                                slidingBeginOffset: Offset(0, -0.35),
                                child: Text(
                                  data['like'].toString(),
                                  style: TextStyle(
                                    fontFamily: 'cute',
                                    color: Colors.grey.shade600,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                      }
                    },
                  )
                ],
              ),
            ),
          ),

          // Column(
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         if (isHeart) {
          //           print("Already Liked");
          //           //
          //           // removeReact('heartReact');
          //           // getCurrentReactCount();
          //         } else {
          //           addReact("heartReact");
          //           // getCurrentReactCount();
          //         }
          //       },
          //       child: Icon(
          //         isHeart ? Icons.favorite : Icons.favorite_border_rounded,
          //         color: isHeart ? Colors.pink : Colors.grey,
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 1),
          //       child: StreamBuilder(
          //         stream: reactRtDatabaseReference.child(widget.postId).onValue,
          //         builder: (context, AsyncSnapshot dataSnapShot) {
          //           if (!dataSnapShot.hasData) {
          //             return Text(
          //               "0",
          //               style: TextStyle(
          //                 fontFamily: 'cute',
          //                 color: Colors.grey.shade600,
          //                 fontSize: 10,
          //               ),
          //             );
          //           } else {
          //             DataSnapshot snapshot = dataSnapShot.data.snapshot;
          //             Map data = snapshot.value;
          //             List item = [];
          //
          //             return dataSnapShot.data.snapshot.value == null
          //                 ? Text(
          //                     "0",
          //                     style: TextStyle(
          //                       fontFamily: 'cute',
          //                       color: Colors.grey.shade600,
          //                       fontSize: 10,
          //                     ),
          //                   )
          //                 : DelayedDisplay(
          //                     fadeIn: true,
          //                     slidingCurve: Curves.easeInOutSine,
          //                     delay: Duration(milliseconds: 222),
          //                     slidingBeginOffset: Offset(0, -0.35),
          //                     child: Text(
          //                       data['heartReact'].toString(),
          //                       style: TextStyle(
          //                         fontFamily: 'cute',
          //                         color: Colors.grey.shade600,
          //                         fontSize: 10,
          //                       ),
          //                     ),
          //                   );
          //           }
          //         },
          //       ),
          //     )
          //   ],
          // ),
          // SizedBox(
          //   width: 10,
          // ),
          SizedBox(
            width: 40,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.red.withOpacity(0.1)),
              ),
              onPressed: () => {
                if (isDislike)
                  {

                    // removeReact('disLike');
                    // getCurrentReactCount();
                  }
                else
                  {
                    isDisable == false
                        ? addReact("disLike")
                        : Fluttertoast.showToast(
                            msg: "Wait for 3 seconds to change React",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          ),
                    // getCurrentReactCount();
                  }
              },
              child: Column(
                children: [
                  Icon(
                    isDislike
                        ? Icons.trending_down_rounded
                        : Icons.trending_down_rounded,
                    color: isDislike ? Colors.red : Colors.grey,
                    size: 25,
                  ),
                  StreamBuilder(
                    stream:
                        reactRtDatabaseReference.child(widget.postId).onValue,
                    builder: (context, AsyncSnapshot dataSnapShot) {
                      if (!dataSnapShot.hasData) {
                        return Text(
                          "0",
                          style: TextStyle(
                            fontFamily: 'cute',
                            color: Colors.grey.shade600,
                            fontSize: 10,
                          ),
                        );
                      } else {
                        DataSnapshot snapshot = dataSnapShot.data.snapshot;
                        Map data = snapshot.value;
                        List item = [];

                        return dataSnapShot.data.snapshot.value == null
                            ? Text(
                                "0",
                                style: TextStyle(
                                  fontFamily: 'cute',
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              )
                            : DelayedDisplay(
                                fadeIn: true,
                                slidingCurve: Curves.easeInOutSine,
                                delay: Duration(milliseconds: 222),
                                slidingBeginOffset: Offset(0, -0.35),
                                child: Text(
                                  data['disLike'].toString(),
                                  style: TextStyle(
                                    fontFamily: 'cute',
                                    color: Colors.grey.shade600,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
