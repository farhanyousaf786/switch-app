
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/Authentication/Auth.dart';
import 'package:switchapp/Authentication/SignUp/signUpPage.dart';

import '../../Bridges/landingPage.dart';
import '../../Models/need_help/need_help_page.dart';
import '../SignIn/SignInPage.dart';
import '../userAgreementPage.dart';

///***** Sign in and Sign up page option *****///

/*
 * this class will show us option of sign in and sign up
 * like sign in with google OR email
 */
class HomeLanding extends StatefulWidget {
  @override
  _HomeLandingState createState() => _HomeLandingState();
}

class _HomeLandingState extends State<HomeLanding> {


  void signOption(){



    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.linear_scale_sharp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    color: Colors.lightBlue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Please chose an option",
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'cute',
                          fontSize: 17),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                        child: TextButton(

                          onPressed: () =>{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            ),
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'cute',
                                fontSize: 17),
                          ),

                        ),
                      ),

                      Material(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                        child: TextButton(
                          onPressed: () =>{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            ),
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'cute',
                                fontSize: 17),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          );
        });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      backgroundColor: Colors.lightBlue,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.lightBlue,
        child: DelayedDisplay(
          delay: Duration(microseconds: 100),
          slidingBeginOffset: Offset(0, 1),
          child: SingleChildScrollView(
            child: Center(
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
                      "Double Slit World",
                      style: TextStyle(
                        fontFamily: "Cute",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        elevation: 0,
                        child: TextButton(
                          onPressed: () => _signInWithGoogle(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login with Google ",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'cute',
                                    fontSize: 17),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22)),
                                child: Lottie.asset(
                                  "images/googleLogo.json",
                                ),
                                height: 32,
                                width: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'cute',
                          fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Material(
                        color: Colors.white,
                        elevation: 0,
                        borderRadius: BorderRadius.circular(10),
                        child: TextButton(
                          onPressed: () => {
                            signOption()
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login with email ",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'cute',
                                    fontSize: 17),
                              ),
                              SizedBox(
                                child: Lottie.asset(
                                  "images/emailLogo.json",
                                ),
                                height: 32,
                                width: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NeedHelpPageForSigninPage(),
                          ),
                        ),
                      },
                      child: Text(
                        "Need Help?",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'cute',
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInWithGoogle();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LandingPage(),
        ),
            (route) => false,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
