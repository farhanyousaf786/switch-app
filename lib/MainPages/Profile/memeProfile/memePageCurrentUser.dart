import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/Universal/Constans.dart';

class MemePageForCurrentUser extends StatefulWidget {
  final User user;
  final navigateThrough;
  final String mainFirstName;
   final List posts;


  const MemePageForCurrentUser(
      {required this.user, this.navigateThrough, required this.mainFirstName, required this.posts})
      ;

  @override
  _MemePageForCurrentUserState createState() => _MemePageForCurrentUserState();
}

class _MemePageForCurrentUserState extends State<MemePageForCurrentUser> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.navigate_before,
              color: Colors.lightBlue,)),
          title: Text(
            "Photo Memes",
            style: TextStyle(
              color: Colors.lightBlue,
              fontFamily: 'cute',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: widget.posts.length == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "There is no Meme Create by ${widget.mainFirstName} yet",
                    style: TextStyle(
                      fontFamily: "Cute",
                      fontSize: 16,
                       fontWeight: FontWeight.bold,

                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                reverse: false,

                itemCount: widget.posts.length,
                itemBuilder: (context, index) => Provider<User>.value(
                  value: widget.user,
                  child: Text(""),
                ),
              ));
  }
}
