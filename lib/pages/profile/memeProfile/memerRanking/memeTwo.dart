import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

class MemeButtonForTwo extends StatefulWidget {
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

  const MemeButtonForTwo({
    required    this.mainId,
    required  this.checkIfDecencyExist,
    required  this.isFive,
    required   this.isFour,
    required  this.isThree,
    required   this.isTwo,
    required   this.isOne,
    required  this.counterForOne,
    required   this.counterForFive,
    required   this.counterForFour,
    required  this.counterForThree,
    required  this.counterForTwo,
    required  this.profileId,
    required  this.onPressedButton,
  }) ;

  @override
  _ButtonForTwoState createState() => _ButtonForTwoState();
}

class _ButtonForTwoState extends State<MemeButtonForTwo> {
  String postId = Uuid().v4();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isTwo) {
          memeProfileRtd.child(widget.profileId).update({
            "numberOfTwo": widget.counterForTwo + 1,
          });
          memeProfileRtd
              .child(widget.mainId)
              .child("MemeDecencyReport")
              .child(widget.profileId)
              .update({
            "numberOfTwo": true,
            "numberOfOne": false,
            "numberOfThree": false,
            "numberOfFour": false,
            "numberOfFive": false,
          });
          if (widget.isOne) {
            memeProfileRtd.child(widget.profileId).update({
              "numberOfOne": widget.counterForOne - 1,
            });
          } else if (widget.isTwo) {

            memeProfileRtd.child(widget.profileId).update({
              "numberOfTwo": (widget.counterForTwo - 1),
            });
          } else if (widget.isThree) {

            memeProfileRtd.child(widget.profileId).update({
              "numberOfThree": widget.counterForThree - 1,
            });
          } else if (widget.isFour) {

            memeProfileRtd.child(widget.profileId).update({
              "numberOfFour": widget.counterForFour - 1,
            });
          } else if (widget.isFive) {

            memeProfileRtd.child(widget.profileId).update({
              "numberOfFive": widget.counterForFive - 1,
            });
          }
          feedRtDatabaseReference
              .child(widget.profileId)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "memeProfileRating",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "ownerId": widget.mainId,
            "rating": "2",
            "isRead": false,
            'postId': postId

          });
          widget.onPressedButton();
          widget.checkIfDecencyExist();
        } else {
          print("Already Exist");
        }
      },
      child: Container(
        width: 35,
        height: 35,
        padding: EdgeInsets.all(6),
        child: Center(
          child: Text(
            "2",
            style: TextStyle(
              color: Colors.black, fontSize: 10,
               fontWeight: FontWeight.bold,
              fontFamily: "cute",),
          ),
        ),
        margin: new EdgeInsets.all(9.0),
        decoration: BoxDecoration(
          color: !widget.isTwo ? Colors.white : Colors.pink.withOpacity(0.5),
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
