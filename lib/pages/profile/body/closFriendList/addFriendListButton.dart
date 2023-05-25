import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

class AddFriendListButton extends StatefulWidget {
  final String profileOwner;
  final String currentUserId;
  final String mainFirstName;
  final String mainProfileUrl;
  final String gender;

  const AddFriendListButton(
      {required this.profileOwner,
      required this.currentUserId,
      required this.mainFirstName,
      required this.mainProfileUrl,
      required this.gender});

  @override
  _AddFriendListButtonState createState() => _AddFriendListButtonState();
}

class _AddFriendListButtonState extends State<AddFriendListButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfAlreadyFriend();
    getBestFriendsData();
  }

  late Map friendsData;
  List friendList = [];

  getBestFriendsData() {
    bestFriendsRtd
        .child(widget.currentUserId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          friendsData = dataSnapshot.value;
        });

        friendsData
            .forEach((index, data) => friendList.add({"key": index, ...data}));
      } else {}
    });
  }
  String postId = Uuid().v4();

  bool isFriend = false;

  addFriends() {
    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: isFriend
                ? MediaQuery.of(context).size.height / 3
                : MediaQuery.of(context).size.height / 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BarTop(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Add As Bestie",
                      style: TextStyle(
                          color: Colors.lightBlue, fontSize: 20, fontFamily: 'cute'),
                    ),
                  ),
                  Divider(),
                  isFriend
                      ? Text("")
                      : Padding(
                          padding:
                              const EdgeInsets.only(top: 20, left: 5, right: 5),
                          child: Text(
                            "If you add Him/Her As your bestie, he/she will get Notification of your relationship status."
                            "Your besties will be notify your current Mood if you change your Mood."
                            "He/she will get direct notice if you update your status",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'cute'),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "So, Are you Sure?",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'cute'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "cute",
                                 fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          onTap: () {
                            if (!isFriend) {
                              if (friendList.length > 19) {
                              } else {
                                bestFriendsRtd
                                    .child(widget.currentUserId)
                                    .child(widget.profileOwner)
                                    .set({
                                  'userId': widget.profileOwner,
                                  'firstName': widget.mainFirstName,
                                  'profileUrl': widget.mainProfileUrl,
                                });

                                feedRtDatabaseReference
                                    .child(widget.profileOwner)
                                    .child("feedItems")
                                    .child(postId)
                                    .set({
                                  "type": "Friend",
                                  "firstName": Constants.myName,
                                  "secondName": Constants.mySecondName,
                                  "comment": "",
                                  "timestamp":
                                      DateTime.now().millisecondsSinceEpoch,
                                  "url": Constants.myPhotoUrl,
                                  "postId": postId,
                                  "ownerId": widget.currentUserId,
                                  "photourl": "",
                                  "isRead": false,

                                });

                                setState(() {
                                  isFriend = true;
                                });
                              }
                            } else {
                              bestFriendsRtd
                                  .child(widget.currentUserId)
                                  .child(widget.profileOwner)
                                  .remove();

                              feedRtDatabaseReference
                                  .child(widget.profileOwner)
                                  .child("feedItems")
                                  .child(postId)
                                  .set({
                                "type": "unFriend",
                                "firstName": Constants.myName,
                                "secondName": Constants.mySecondName,
                                "comment": "",
                                "timestamp":
                                    DateTime.now().millisecondsSinceEpoch,
                                "url": Constants.myPhotoUrl,
                                "postId": postId,
                                "ownerId": widget.currentUserId,
                                "photourl": "",
                                "isRead": false,

                              });

                              setState(() {
                                isFriend = false;
                              });
                            }
                            Navigator.pop(context);
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Cute",
                                 fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  checkIfAlreadyFriend() {
    bestFriendsRtd
        .child(widget.currentUserId)
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          isFriend = true;
        });
      } else {
        setState(() {
          isFriend = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addFriends();
      },
      child: isFriend
          ? Text(
              widget.gender == "Female" ? "Remove Her" : "Remove Him",
              style: TextStyle(
                  fontSize: 15, color: Colors.green, fontFamily: 'cute'),
            )
          : Text(
              widget.gender == "Female" ? "Add Her" : "Add Him",
              style: TextStyle(
                  fontSize: 15, color: Colors.grey, fontFamily: 'cute'),
            ),
    );
  }
}
