/*

This class will control the flow if
user forgot his/her password


 */

import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  // here wew create the object of firebase class to access our firebase
  // that we have connected to our application
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // This is a variable (String type) to store the email that user
  // will put in text field
  TextEditingController emailTextEditingController = TextEditingController();

  // this variable will control the flow of screen, before and after the press button
  // for forget password
  bool isSent = false;

  // this function will run every time, when user tap on switch button
  // this function is to remove any type of space from user input
  void formatNickname() {
    emailTextEditingController.text =
        emailTextEditingController.text.replaceAll(" ", "");
  }

  // this function will be responsible to execute upper function as soon
  // user complete the input

  // This is the function to send request to firebase to reset password
  resetPassword() async {
    formatNickname();

    print(emailTextEditingController.text);

    Future.delayed(const Duration(milliseconds: 100), () async {
      try {
        await _firebaseAuth.sendPasswordResetEmail(
            email: emailTextEditingController.text);
        setState(() {
          isSent = true;
        });

        showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            barrierColor: Colors.red.withOpacity(0.2),
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height / 2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BarTop(),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "Open your ${emailTextEditingController.text} email account to reset password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "cute",
                              color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      } catch (e) {
        // This is bottom sheet will pop up is any error occurs
        showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            barrierColor: Colors.red.withOpacity(0.2),
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BarTop(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                            height: 150,
                            width: 150,
                            child: Lottie.asset("images/error.json")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "This email is incorrect or did not exist",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "cutes",
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This is our main widget of every screen we displayed to the user
    // it has whole screen. Inside this widget we create all widget of the
    // screen

    return Scaffold(
      // simple appBar
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => {Navigator.pop(context)},
          child: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Recovery Mood",
          style: TextStyle(
            fontFamily: "Cute",
            fontSize: 20,
          ),
        ),
      ),
      body: !isSent
          ? Column(
              children: [
                SizedBox(
                  height: 0,
                ),
                Container(
                  height: 200,
                  width: 200,
                  child: RiveAnimation.asset(
                    'images/authLogo.riv',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enter Email for reset password",
                    style: TextStyle(
                      fontFamily: "Cute",
                      color: Constants.isDark == 'true'
                          ? Colors.white
                          : Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: Constants.isDark == 'true'
                            ? Colors.white
                            : Colors.white,
                        fontSize: 12,
                        fontFamily: "Cute",
                      ),
                      controller: emailTextEditingController,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: new BorderSide(
                            width: 2,
                            color: Constants.isDark == 'true'
                                ? Colors.white
                                : Colors.white,
                          ),
                        ),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: new BorderSide(
                            width: 2,
                            color: Constants.isDark == 'true'
                                ? Colors.white
                                : Colors.white,
                          ),
                        ),
                        labelText: ' Email',
                        labelStyle: TextStyle(
                          fontFamily: "Cute",
                          color: Constants.isDark == 'true'
                              ? Colors.white
                              : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => resetPassword(),
                  child: Container(
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: Constants.isDark == 'true'
                            ? Colors.white
                            : Colors.white,
                        fontFamily: "Cute",
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    child: RiveAnimation.asset(
                      'images/authLogo.riv',
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Text(
                      "Note: If email does not receive within 1 minute, then please check your email spam folder.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Cute",
                        fontSize: 20,
                        color: Constants.isDark == 'true'
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage())),
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 80,
                      height: 45,
                      child: Center(
                        child: Text(
                          "Got It",
                          style: TextStyle(
                            color: Constants.isDark == 'true'
                                ? Colors.white
                                : Colors.white,
                            fontFamily: "Cute",
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DelayedDisplay(
                        delay: Duration(seconds: 1),
                        slidingBeginOffset: Offset(0.0, -1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LandingPage(),
                                  ),
                                  (route) => false,
                                ),
                              },
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  fontFamily: "Cute",
                                  fontSize: 16,
                                  color: Constants.isDark == 'true'
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TextButton(
                              child: Text(
                                'Need Help',
                                style: TextStyle(
                                  fontFamily: "Cute",
                                  fontSize: 16,
                                  color: Constants.isDark == 'true'
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                              onPressed: () {},
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
