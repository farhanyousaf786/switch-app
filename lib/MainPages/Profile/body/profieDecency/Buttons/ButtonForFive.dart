import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

class ButtonForFive extends StatefulWidget {
  final int counterForOne;
  final int counterForFive;
  final int counterForTwo;
  final int counterForThree;
  final int counterForFour;
  final String profileId;
  final String mainId;
  final bool isOne;
  final bool isTwo;
  final bool isThree;
  final bool isFour;
  final bool isFive;
  final VoidCallback onPressedButton;
  final VoidCallback checkIfDecencyExist;

  const ButtonForFive({
    required   this.mainId,
    required  this.checkIfDecencyExist,
    required   this.isFive,
    required   this.isFour,
    required   this.isThree,
    required  this.isTwo,
    required  this.isOne,
    required   this.counterForOne,
    required   this.counterForFive,
    required   this.counterForFour,
    required   this.counterForThree,
    required   this.counterForTwo,
  required  this.profileId,
   required this.onPressedButton,
  });

  @override
  _ButtonForFiveState createState() => _ButtonForFiveState();
}

class _ButtonForFiveState extends State<ButtonForFive> {

  String postId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isFive) {
          userProfileDecencyReport.child(widget.profileId).update({
            "numberOfFive": widget.counterForFive + (1),
          });
          userProfileDecencyReport
              .child(widget.mainId)
              .child("DecencyReport")
              .child(widget.profileId)
              .update({
            "numberOfOne": false,
            "numberOfTwo": false,
            "numberOfThree": false,
            "numberOfFour": false,
            "numberOfFive": true,
          });
          if (widget.isOne) {
            userProfileDecencyReport.child(widget.profileId).update({
              "numberOfOne": widget.counterForOne - 1,
            });
          } else if (widget.isTwo) {
            userProfileDecencyReport.child(widget.profileId).update({
              "numberOfTwo": (widget.counterForTwo - 1),
            });
          } else if (widget.isThree) {
            userProfileDecencyReport.child(widget.profileId).update({
              "numberOfThree": widget.counterForThree - 1,
            });
          } else if (widget.isFour) {
            userProfileDecencyReport.child(widget.profileId).update({
              "numberOfFour": widget.counterForFour - 1,
            });
          } else if (widget.isFive) {
            userProfileDecencyReport.child(widget.profileId).update({
              "numberOfFive": widget.counterForFive - 1,
            });
          } feedRtDatabaseReference
              .child(widget.profileId)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "profileRating",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "postId": postId,
            "ownerId": widget.mainId,
            "rating": "5",
            "isRead": false,

          });
          widget.onPressedButton();
          widget.checkIfDecencyExist();

        } else {
          print("Already Exist");
        }
      },
      child: Container(
        padding: EdgeInsets.all(6),
        child: Text(
          "5",
          style: TextStyle(
              fontFamily: "cute", color: Colors.black, fontSize: 10,                              fontWeight: FontWeight.bold,
          ),
        ),
        margin: new EdgeInsets.all(9.0),
        decoration: BoxDecoration(
          color: !widget.isFive ? Colors.white : Colors.green.withOpacity(0.8),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
