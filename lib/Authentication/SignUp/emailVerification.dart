/*
 *This class will handle user to get
 * their email verification.
 */

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/Authentication/Auth/Auth.dart';
import 'package:switchapp/Authentication/SignIn/SignInPage.dart';
import 'package:switchapp/Authentication/SignOut/SignOut.dart';
import 'package:switchapp/Authentication/SignUp/SetUserData.dart';
import 'package:switchapp/Bridges/bridgeToSetEmailVerification.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/SwitchTimer.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class EmailVerification extends StatefulWidget {
  // This is object of class User and we passed it as parameter, it has basic info of our user
  final User user;

  EmailVerification({
    required this.user,
  });

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  // Firebase auth instant object to check
  // if user verified by email or not
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  String countryName = 'Select Country';
  bool isVerified = false;
  SignOut signOut = new SignOut();

  // this function will always run one time
  // when we came to this class
  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();
    defaultUserInfo();
    Timer.periodic(Duration(seconds: 1), (t) {
      checkEmailVerified();
      var timerInfo = Provider.of<SwitchTimer>(context, listen: false);
      timerInfo.updateRemainingTime();
    });
    super.initState();
  }

  /*
   * this information will store to firebase as soon as a user tap our Switch button from sign up page
   * after tap our app lead our user to this page and for security we will store this info at very first
   * moment as default info. We did it because may be user exit the app or may be he close app accidently
   * after tap on switch button from signup class. So we make sure that the user with that email has his
   * store in database. So we can use this and make our decision on the basis of this info so that user
   * can set his/her own info when he start application
   */

  defaultUserInfo() async {
    final user = Provider.of<User>(context, listen: false);
    print(user.uid);
    userRefRTD.child(user.uid).set({
      "username": "",
      "androidNotificationToken": "",
      "ownerId": user.uid,
      "firstName": "",
      "secondName": "",
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "email": user.email,
      "dob": "01/01/2000",
      "country": countryName,
      'isBan': "false",
      'postId': "N/A",
      'url': Constants.switchLogo,
      "currentMood": "Happy",
      "about": "notSet",
      'gender': "notSet",
      "isVerified": "false",
      "password": Constants.pass,
    });
    userProfileDecencyReport.child(user.uid).update({
      "numberOfOne": 0,
      "numberOfTwo": 0,
      "numberOfThree": 0,
      "numberOfFour": 0,
      "numberOfFive": 0,
    });
    memeProfileRtd.child(user.uid).set({
      "isMemer": "Yes",
      "totalMemes": 0,
      "numberOfOne": 0,
      "numberOfTwo": 0,
      "numberOfThree": 0,
      "numberOfFour": 0,
      "numberOfFive": 0,
    });
    memerPercentageDecencyRtd.child(user.uid).set({
      "PercentageDecency": 0,
      'uid': user.uid,
    });
    relationShipReferenceRtd.child(user.uid).set({
      "inRelationshipWithId": "",
      "inRelationshipWithSecondName": "",
      "inRelationshipWithFirstName": "",
      "inRelationShip": false,
      "pendingRelationShip": false,
      "inRelationshipWith": "",
    });
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      print("verifided");
      setState(() {
        isVerified = true;
      });
    } else {
      print(" Notverifided");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () => signOut.signOut(widget.user.uid, context)),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: Text(
          "Verification",
          style: TextStyle(
            fontSize: 22,
            fontFamily: "cute",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: isVerified
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 180,
                        width: 180,
                        child: RiveAnimation.asset(
                          'images/authLogo.riv',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Verified Successfully",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'cute',
                              color: Colors.green.shade700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Provider<User>.value(
                                value: widget.user,
                                child: SetUserData(
                                  user: widget.user,
                                ),
                              ),
                            ),
                          ),
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "Click here to proceed >>",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'cute',
                              color: Colors.blue.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      child: RiveAnimation.asset(
                        'images/authLogo.riv',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        widget.user.email.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'cutes',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        "A Link sent to your email, kindly open that email and click on link to verify.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'cute',
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Verifying  ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'cute',
                                color: Colors.greenAccent,
                                fontSize: 20,
                              ),
                            ),
                            SpinKitCircle(
                              color: Colors.greenAccent,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Consumer<SwitchTimer>(
                        builder: (context, data, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  data.getRemainingTime() < 1
                                      ? user.sendEmailVerification()
                                      : null,
                                  data.getRemainingTime() < 1
                                      ? data.reset()
                                      : null,
                                  // setState(() {
                                  //
                                  // }),
                                },
                                child: Text(
                                  data.getRemainingTime() < 1
                                      ? "Click to Resend Link"
                                      : "Click to Resend in  ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'cute',
                                    color: Colors.lightBlue,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              data.getRemainingTime() < 1
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Text(
                                      data.getRemainingTime()?.toString() ?? '',
                                      style: TextStyle(
                                        fontFamily: 'cute',
                                        color: Colors.lightBlue,
                                        fontSize: 15,
                                      ),
                                    ),
                              data.getRemainingTime() < 1
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Text(
                                      "s",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'cute',
                                        color: Colors.lightBlue,
                                        fontSize: 15,
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5.5,
                    ),
                    Text(
                      "Did not get email?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'cutes',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => checkEmailVerified(),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Kindly check your email Spam Folder.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'cutes',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            barrierColor: Colors.red.withOpacity(0.2),
                            elevation: 0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: MediaQuery.of(context).size.height / 4,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.linear_scale_sharp,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Colors.blue,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Kindly Review the below Lines",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "cutes",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "* Check that, the email you put is correct? \n"
                                          "* Check your internet connection. \n",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "cutes",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Need Help!",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'cute',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
