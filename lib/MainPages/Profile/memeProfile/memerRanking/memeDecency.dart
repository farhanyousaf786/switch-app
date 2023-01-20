import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

import 'memeFive.dart';
import 'memeFour.dart';
import 'memeOne.dart';
import 'memeThree.dart';
import 'memeTwo.dart';

class MemeDecency extends StatefulWidget {
  final VoidCallback onPressedButton2;

  final String mainId;
  final String profileId;

  const MemeDecency(
      {required this.mainId, required this.profileId, required this.onPressedButton2})
      ;

  @override
  _ProfileDecencyState createState() => _ProfileDecencyState();
}

class _ProfileDecencyState extends State<MemeDecency> {
  ///5 star - 252
  /// 4 star - 124
  /// 3 star - 40
  /// 2 star - 29
  /// 1 star - 33
  /// (5*252 + 4*124 + 3*40 + 2*29 + 1*33) / (252+124+40+29+33) = 4.11 and change

  double userMemePercentageDecency = 0;
  double userMemeDecency = 0;
  int counterForTwo = 0;
  int counterForOne = 0;
  int counterForThree = 0;
  int counterForFour = 0;
  int counterForFive = 0;
  bool isOne = false;
  bool isTwo = false;
  bool isThree = false;
  bool isFour = false;
  bool isFive = false;
  Color indicatorColor = Colors.blue;
  bool isDataReady = false;

  getDecencyReport() async {
    if (widget.mainId != widget.profileId) {
      late Map data;

      memeProfileRtd
          .child(widget.profileId)
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          setState(() {
            data = dataSnapshot.value;
          });

          setState(() {
            counterForFour = data['numberOfFour'];
            counterForFive = data['numberOfFive'];
            counterForThree = data['numberOfThree'];
            counterForTwo = data['numberOfTwo'];
            counterForOne = data['numberOfOne'];
          });

          userMemeDecency = ((5 * counterForFive +
                  4 * counterForFour +
                  3 * counterForThree +
                  2 * counterForTwo +
                  1 * counterForOne) /
              (counterForTwo +
                  counterForOne +
                  counterForThree +
                  counterForFour +
                  counterForFive));

          userMemePercentageDecency = (userMemeDecency / 5) * 100;
        }else{

          print("mullllllllllllllllllllllllllllllllllllllllllllllllllll");


        }

        widget.onPressedButton2();

        setState(() {
          isDataReady = true;
        });
      });
    } else {}

    // getColorsIndicator();
  }

  checkIfDecencyExist() async {
   late Map data;

    memeProfileRtd
        .child(widget.mainId)
        .child("MemeDecencyReport")
        .child(widget.profileId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value == null) {
        memeProfileRtd
            .child(widget.mainId)
            .child("MemeDecencyReport")
            .child(widget.profileId)
            .set({
          "numberOfOne": false,
          "numberOfTwo": false,
          "numberOfThree": false,
          "numberOfFour": false,
          "numberOfFive": false,
        });
      } else {
        setState(() {
          data = dataSnapshot.value;
        });
        if (data['numberOfOne'] == true) {
          print("isOne: $isOne");

          setState(() {
            isOne = true;
            isTwo = false;
            isFour = false;
            isThree = false;
            isFive = false;
          });
        } else if (data['numberOfTwo'] == true) {
          setState(() {
            isTwo = true;
            isOne = false;
            isThree = false;
            isFour = false;
            isFive = false;

            print("isOne: $isTwo");
          });
        } else if (data['numberOfThree'] == true) {
          setState(() {
            isTwo = false;
            isOne = false;
            isThree = true;
            isFour = false;
            isFive = false;
            print("isOne: $isThree");
          });
        } else if (data['numberOfFour'] == true) {
          setState(() {
            isFour = true;

            isTwo = false;
            isOne = false;
            isThree = false;
            isFive = false;
            print("isOne: $isFour");
          });
        } else if (data['numberOfFive'] == true) {
          setState(() {
            isFive = true;
            isTwo = false;
            isOne = false;
            isThree = false;
            isFour = false;
            print("isOne: $isFive");
          });
        }
      }
    });
  }

  @override
  void initState() {
    checkIfDecencyExist();
    getDecencyReport();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted)
        setState(() {
          isDataReady = true;
        });
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return isDataReady
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: widget.profileId != widget.mainId
                ? Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Material(
                      elevation: 0,
                      shadowColor: Colors.black54,
                      child: Container(
                        height: 75,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, right: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "Memer Score: ",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'cute',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                                widget.profileId == widget.mainId
                                    ? Container()
                                    : Row(
                                        // shrinkWrap: true,
                                        // scrollDirection: Axis.horizontal,
                                        children: [
                                          MemeButtonForOne(
                                            isFour: isFour,
                                            isOne: isOne,
                                            isTwo: isTwo,
                                            isThree: isThree,
                                            isFive: isFive,
                                            profileId: widget.profileId,
                                            counterForOne: counterForOne,
                                            counterForFive: counterForFive,
                                            counterForFour: counterForFour,
                                            counterForThree: counterForThree,
                                            counterForTwo: counterForTwo,
                                            onPressedButton: getDecencyReport,
                                            checkIfDecencyExist:
                                                checkIfDecencyExist,
                                            mainId: widget.mainId,
                                          ),
                                          MemeButtonForTwo(
                                            isFour: isFour,
                                            isOne: isOne,
                                            isTwo: isTwo,
                                            isThree: isThree,
                                            isFive: isFive,
                                            profileId: widget.profileId,
                                            counterForOne: counterForOne,
                                            counterForFive: counterForFive,
                                            counterForFour: counterForFour,
                                            counterForThree: counterForThree,
                                            counterForTwo: counterForTwo,
                                            onPressedButton: getDecencyReport,
                                            checkIfDecencyExist:
                                                checkIfDecencyExist,
                                            mainId: widget.mainId,
                                          ),
                                          MemeButtonForThree(
                                            isFour: isFour,
                                            isOne: isOne,
                                            isTwo: isTwo,
                                            isThree: isThree,
                                            isFive: isFive,
                                            profileId: widget.profileId,
                                            counterForOne: counterForOne,
                                            counterForFive: counterForFive,
                                            counterForFour: counterForFour,
                                            counterForThree: counterForThree,
                                            counterForTwo: counterForTwo,
                                            onPressedButton: getDecencyReport,
                                            checkIfDecencyExist:
                                                checkIfDecencyExist,
                                            mainId: widget.mainId,
                                          ),
                                          MemeButtonForFour(
                                            isFour: isFour,
                                            isOne: isOne,
                                            isTwo: isTwo,
                                            isThree: isThree,
                                            isFive: isFive,
                                            profileId: widget.profileId,
                                            counterForOne: counterForOne,
                                            counterForFive: counterForFive,
                                            counterForFour: counterForFour,
                                            counterForThree: counterForThree,
                                            counterForTwo: counterForTwo,
                                            onPressedButton: getDecencyReport,
                                            checkIfDecencyExist:
                                                checkIfDecencyExist,
                                            mainId: widget.mainId,
                                          ),
                                          MemeButtonForFive(
                                            isFour: isFour,
                                            isOne: isOne,
                                            isTwo: isTwo,
                                            isThree: isThree,
                                            isFive: isFive,
                                            profileId: widget.profileId,
                                            counterForOne: counterForOne,
                                            counterForFive: counterForFive,
                                            counterForFour: counterForFour,
                                            counterForThree: counterForThree,
                                            counterForTwo: counterForTwo,
                                            onPressedButton: getDecencyReport,
                                            checkIfDecencyExist:
                                                checkIfDecencyExist,
                                            mainId: widget.mainId,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                )
                : SizedBox(),
          )
        : Container(height: 50,
    );
  }
}
