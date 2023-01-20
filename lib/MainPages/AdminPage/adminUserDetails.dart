import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class AdminUserDetails extends StatefulWidget {
  AdminUserDetails(
      {required this.currentUserId,
      required this.mainProfileUrl,
      required this.mainFirstName,
      required this.profileOwner,
      required this.mainSecondName,
      required this.mainCountry,
      required this.mainDateOfBirth,
      required this.mainAbout,
      required this.mainEmail,
      required this.mainGender,
      required this.user,
      required this.action,
      required this.username,
      required this.isVerified,
      required this.isBan});

  final String currentUserId;
  final String mainGender;
  final String mainProfileUrl;
  final String mainFirstName;
  final String profileOwner;
  final String mainSecondName;
  final String mainCountry;
  final String action;
  final String isVerified;
  final User user;

  //catalog //ranking //
  final String mainDateOfBirth;
  final String mainAbout;
  final String mainEmail;
  final String username;
  final String isBan;

  @override
  _AdminUserDetailsState createState() => _AdminUserDetailsState();
}

class _AdminUserDetailsState extends State<AdminUserDetails> {
  bool isBan = false;
  bool isVerified = false;

  banUser() {
    if (!isBan) {
      userRefRTD.child(widget.profileOwner).update({
        "isBan": "true",
      });

      setState(() {
        isBan = true;
      });
    } else {
      userRefRTD.child(widget.profileOwner).update({
        "isBan": "false",
      });
      setState(() {
        isBan = false;
      });
    }
  }

  String password = "00786F@y786..";
  List userPosts = [];

  deleteAllPostsFunc() {
    postsRtd
        .child(widget.profileOwner)
        .child('usersPost')
        .orderByChild("timestamp")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        Map data2 = dataSnapshot.value;
        data2
            .forEach((index, data2) => userPosts.add({"key": index, ...data2}));
        print("owner: : : : : : : : : ${widget.profileOwner}");

        print("length: : : : : : : : : ${userPosts.length}");

        Future.delayed(const Duration(milliseconds: 500), () {
          for (int i = 0; i <= userPosts.length - 1; i++) {
            print(userPosts[i]['postId']);

            switchAllUserFeedPostsRTD
                .child("UserPosts")
                .child(userPosts[i]['postId'])
                .remove();
          }
        });
      } else {}
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      postsRtd.child(widget.profileOwner).remove();
      setState(() {
        isBan = true;
      });
      Fluttertoast.showToast(
        msg: "Done",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    });
  }

  banUserWithPostDelete() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2.7,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          Icon(Icons.linear_scale_sharp,
                            color: Colors.white,),
                        ],
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Are You Sure?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () => {
                                if (!isBan)
                                  {
                                    userRefRTD
                                        .child(widget.profileOwner)
                                        .update({
                                      "isBan": "true",
                                    }),
                                    deleteAllPostsFunc(),
                                  }
                                else
                                  {
                                    userRefRTD
                                        .child(widget.profileOwner)
                                        .update({
                                      "isBan": "false",
                                    }),
                                    setState(() {
                                      isBan = false;
                                    }),
                                  }
                              },
                          child: Text("Yes")),
                      GestureDetector(
                          onTap: () => {
                                Navigator.pop(context),
                              },
                          child: Text("No"))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  verifyUser() {
    if (!isVerified) {
      userRefRTD.child(widget.profileOwner).update({
        "isVerified": "true",
      });
      setState(() {
        isVerified = true;
      });
    } else {
      userRefRTD.child(widget.profileOwner).update({
        "isVerified": "false",
      });
      setState(() {
        isVerified = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isBan == "true") {
      setState(() {
        isBan = true;
      });
    }

    if (widget.isVerified == "true") {
      setState(() {
        isVerified = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.arrow_back_ios_sharp,
              size: 18,
              color: Colors.black38,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Switch Admin Page",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text("UID: " + widget.profileOwner),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text("username: " + widget.username),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text("name: " + widget.mainFirstName),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => {
                  banUser(),
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color:
                          isBan == false ? Colors.red : Colors.green.shade700,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      isBan == false ? "Ban this user" : "Un Ban",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => {
                  banUserWithPostDelete(),
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color:
                          isBan == false ? Colors.red : Colors.green.shade700,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      isBan == false ? "Ban this user / posts dl8" : "Un Ban",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => {
                  verifyUser(),
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: isVerified == false
                          ? Colors.red
                          : Colors.green.shade700,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      isVerified == false ? "Verify User" : "Un Verify",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
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
