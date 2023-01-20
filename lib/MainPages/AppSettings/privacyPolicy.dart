import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {


  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url}';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            GestureDetector(onTap: ()=> _launchURL('http://switchapp.live/#/privacy-policy'),
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.info_outline),
              ),
            )
          ],
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
              size: 20,
            ),
          ),
          elevation: 0,
          title: Text(
            "Switch",
            style: TextStyle(
                color: Colors.white, fontFamily: 'cute', fontSize: 21),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                child: RiveAnimation.asset(
                  'images/authLogo.riv',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(
                        color: Colors.green, fontFamily: 'cute', fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Welcome To Switch",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cute', fontSize: 22),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 8,
                    ),
                    child: Text(
                      "Introduction:",
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontFamily: 'cute',
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "We provide People to connect with each other through SWITCH. This app will focus to manage a user's personal profile as well as Users MEME profile too. In this app we will provide user A secure connection through chat option.",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cutes', fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                        child: Flexible(
                            child: Text(
                      "Terms And Condition",
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontFamily: 'cute',
                          fontSize: 18),
                    ))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Well, we can not allow any kind of hate speech, racism, bullying, religious hate & any kind of other negative things. If we found or someone reported your these kind of negative actions on this App, we will BAN you from this app.",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cutes', fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                        child: Flexible(
                            child: Text(
                      "Do we share your data?",
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontFamily: 'cute',
                          fontSize: 18),
                    ))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "No, we does not share your data. Not a single bit of it.",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cutes', fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                        child: Flexible(
                            child: Text(
                      "What type of information we collect from users?",
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontFamily: 'cute',
                          fontSize: 18),
                    ))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "We only collect that kind of data which you provide us, because we have to store it for your Profile. We collect and save your Email, Photos you shared, Chat, and other Userinfo (Date of birth, username etc).",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cutes', fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                        child: Flexible(
                            child: Text(
                      "Is your data secure?",
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontFamily: 'cute',
                          fontSize: 18),
                    ))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Yes, your data is 100% secure, because our database is host with one of the top Company of the world.",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cutes', fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
