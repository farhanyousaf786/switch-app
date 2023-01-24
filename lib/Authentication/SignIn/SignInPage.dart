/*

This is simple SignIn class. It will be display to our user
if there is no active signed in user.

 */

import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/Authentication/Auth/Auth.dart';
import 'package:switchapp/Authentication/SignIn/ForgotPass.dart';
import 'package:switchapp/Authentication/SignUp/signUpPage.dart';
import 'package:switchapp/Authentication/UserAgreement/userAgreementPage.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // It will control the indicator if our user tap the sign in button
  // and after pressing button a circular progressive indicator will
  // be shown to user
  bool isLoading = false;

  // this variable is for hide password
  bool _isHidden = true;

  // simple password taker string
  TextEditingController passwordTextEditingController = TextEditingController();

  // simple email taker String
  TextEditingController emailTextEditingController = TextEditingController();

  // this is a special object of FocusNode class that
  // is builtin class of flutter, It will move the cursor or
  // action toward password text field
  FocusNode _passFocusNode = FocusNode();

  // simple toggle to change the state of our hidden variable
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  // this function will run every time, when user tap on switch button
  // this function is to remove any type of space from user input
  void formatNickname() {
    emailTextEditingController.text =
        emailTextEditingController.text.replaceAll(" ", "");
  }

  // this function will be responsible to execute upper function as soon
  // user complete the input

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passFocusNode);
    formatNickname();
  }

  // simple sign in function
  Future<void> signIn() async {
    setState(() {
      Constants.pass = passwordTextEditingController.text;
    });

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text);

      setState(() {
        Constants.pass = passwordTextEditingController.text;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LandingPage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          barrierColor: Colors.red.withOpacity(0.2),
          elevation: 0,
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        "Email or password is incorrect, or already been taken",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "cutes",
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Note:  Check your internet too.",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: "cutes",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => {Navigator.pop(context)},
          child: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      // backgroundColor: Colors.blue.shade100,
      body: Container(
        // color: Colors.blue.shade100,
        height: MediaQuery.of(context).size.height,
        color: Colors.lightBlue,
        child: DelayedDisplay(
          delay: Duration(microseconds: 100),
          slidingBeginOffset: Offset(-1, 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 200,
                  child: RiveAnimation.asset(
                    'images/authLogo.riv',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25, top: 0),
                  child: Text(
                    "Hi, Please Sign In",
                    style: TextStyle(
                      fontFamily: "Cute",
                      fontSize: 18,
                      color: Colors.white,
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
                      onEditingComplete: _emailEditingComplete,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 12,
                        fontFamily: "Cute",
                      ),
                      controller: emailTextEditingController,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              new BorderSide(color: Colors.white, width: 2),
                        ),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              new BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: ' Email',
                        labelStyle: TextStyle(
                          fontFamily: "Cute",
                          color: Colors.blue.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: TextField(
                      obscureText: _isHidden,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _passFocusNode,
                      style: TextStyle(
                        fontFamily: "Cute",
                        color: Colors.blue.shade900,
                        fontSize: 12,
                      ),
                      controller: passwordTextEditingController,
                      onEditingComplete: signIn,
                      decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: _togglePasswordView,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        fillColor: Colors.transparent,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              new BorderSide(color: Colors.white, width: 2),
                        ),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              new BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: ' Password',
                        labelStyle: TextStyle(
                          fontFamily: "Cute",
                          color: Colors.blue.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserAgreementPage(),
                      ),
                    ),
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: "By signing in you agree to our ",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontFamily: 'cutes',
                                )),
                            TextSpan(
                              text: 'Terms & Conditions.',
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'cutes',
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 35,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                      child: isLoading
                          ? SpinKitFadingCircle(
                              color: Colors.blue.shade700,
                              size: 18,
                            )
                          : Text(
                              'Switch',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontFamily: "Cute",
                              ),
                            ),
                      onPressed: () => {
                        if (emailTextEditingController.text.isEmpty ||
                            passwordTextEditingController.text.isEmpty)
                          {
                            showModalBottomSheet(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                barrierColor: Colors.red.withOpacity(0.2),
                                elevation: 0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          BarTop(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                                height: 150,
                                                width: 150,
                                                child: Lottie.asset(
                                                    "images/error.json")),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Email or password can\'t be empty',
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
                                }),
                          }
                        else
                          {
                            setState(() {
                              isLoading = true;
                            }),
                            signIn(),
                          }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPass(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontFamily: "Cute",
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontFamily: "Cute",
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0.0,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: "Cute",
                            fontSize: 20,
                            color: Colors.greenAccent,
                          ),
                        ),
                        onPressed: () => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          ),
                        },
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
