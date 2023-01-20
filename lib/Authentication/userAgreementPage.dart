import 'package:flutter/material.dart';

class UserAgreementPage extends StatefulWidget {
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Terms of use & Privacy Policy",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'cute',
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_sharp,
            size: 16,
            color: Colors.blue,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                child: Center(
                  child: Text(
                    "This is very important that you should know what type of data you can share in this app & what kind of information Switch App collects and where it uses. So, you can Review the key points below. ",
                   textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cutes',  fontWeight: FontWeight.bold,fontSize: 15),
                  ),
                ),
              ),
              SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                        child: Flexible(
                            child: Text(
                      "Terms And Conditions",
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontFamily: 'cute',
                          fontSize: 18),
                    ),)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Well, we do not not allow any user to share any kind of hate speech, racism, bullying, religious hate & any kind of other negative things. If we found or someone reported your these kind of negative actions on this App, we will BAN you from this app.",
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
                    "We only collect the data that you provide us, because we have to store it for your Profile. We collect and save your Email, Photos you shared, Chat, and other Userinfo (Date of birth, username etc).",
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
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                        child: Flexible(
                            child: Text(
                              "Our rights?",
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
                    "Switch dev always has rights to change any type of privacy policy as well as Terms of use. But, we will make sure that all terms and policies will keep 100% of user privacy and security",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cutes', fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
