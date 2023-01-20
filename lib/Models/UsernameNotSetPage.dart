import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/Authentication/Auth.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class SimplePageModel extends StatelessWidget {
  final User user;

  const SimplePageModel({required this.user});

  @override
  Widget build(BuildContext context) {


    Future<void> signOut() async {
      userRefRTD.child(user.uid).update({"isOnline": "false"});

      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signOut();
    }

    return Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Center(
                child: Text(
              "Log Out",
              style: TextStyle(
                  color: Colors.blue, fontFamily: 'cute', fontSize: 15),
            )),
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.blue,
                  size: 20,
                ),
                onPressed: signOut),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LandingPage()));
          },
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please set your username to use App",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue, fontSize: 15, fontFamily: 'cute'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightBlue),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Click to Set Username",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'cute'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Already Done? then check your INTERNET connection and Restart App.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontFamily: 'cutes',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
