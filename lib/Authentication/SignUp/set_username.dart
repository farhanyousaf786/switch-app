import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/Authentication/Auth.dart';
import 'package:switchapp/Authentication/welcomePage/welcomepage.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import '../../Universal/DataBaseRefrences.dart';

class SetUsernameForGoogleSignIn extends StatefulWidget {
  late final User user;

  SetUsernameForGoogleSignIn({required this.user});

  @override
  _SetUsernameForGoogleSignInState createState() =>
      _SetUsernameForGoogleSignInState();
}

class _SetUsernameForGoogleSignInState
    extends State<SetUsernameForGoogleSignIn> {
  TextEditingController userNameTextEditingController = TextEditingController();
  List userList = [];
  List userList2 = [];
  late Map<dynamic, dynamic> values;
  bool userListEmpty = false;
  bool userExists = false;
  bool userNameLengthExceeded = false;
  bool userExistsText = false;

  void formatUsername() {
    userNameTextEditingController.text =
        userNameTextEditingController.text.replaceAll(" ", "");
  }

  @override
  void initState() {
    super.initState();
    getAllUsers();

    print(
      widget.user.displayName!.split(' ')[0],
    );
  }

  getAllUsers() {
    userRefForSearchRtd.once().then((DataSnapshot snapshot) {
      values = snapshot.value;
      List userList = [];
      if (values == null) {
        setState(() {
          userListEmpty = true;
        });
      } else {
        setState(() {
          values
              .forEach((index, data) => userList.add({"user": index, ...data}));
        });
        setState(() {
          this.userList = userList;
        });
      }
    });
  }

  userValidater(String userName) {
    if (userName.isNotEmpty) {
      if (userName.length > 29) {
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
                        color: Colors.blue,
                      ),
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
                          "Username Must be less than 30 characters",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "cutes",
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Back'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            });
      } else {
        setState(() {
          userList2 = userList;
        });
        int trendIndex = userList.indexWhere((f) =>
            f['username'] == userNameTextEditingController.text.toLowerCase());

        if (trendIndex == -1) {
          setState(() {
            userExists = false;
          });
        } else {
          setState(() {
            userExists = true;
          });
        }
      }
    } else {
      print("empty");
    }
  }

  setUserInfo() async {
    formatUsername();

    if (userNameTextEditingController.text.isEmpty ||
        userNameTextEditingController.text.length > 29 ||
        userNameTextEditingController.text.isEmpty ||
        userExists == true) {
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
                      color: Colors.blue,
                    ),
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
                        userExists
                            ? "Username is already Taken"
                            : "All information should be added",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "cutes",
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Back'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      final user = Provider.of<User>(context, listen: false);
      relationShipReferenceRtd.child(user.uid).set({
        "inRelationshipWithId": "",
        "inRelationshipWithSecondName": "",
        "inRelationshipWithFirstName": "",
        "crush": "",
        "closeFriend": "",
        "relationShipStatus": "",
        "inRelationShip": false,
        "pendingRelationShip": false,
        "relationShipRequestSenderSecondName": "",
        "relationShipRequestSenderName": "",
        "relationShipRequestSenderFirstName": "",
        "relationShipRequestSenderId": "",
        "relationShipRequestSendToName": "",
        "relationShipRequestSendToId": "",
      });
      userRefRTD.child(user.uid).set({
        "androidNotificationToken": "",
        "ownerId": user.uid,
        "firstName": widget.user.displayName!.split(' ')[0],
        "secondName": "",
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
        "email": user.email,
        "dob": "01/01/2000",
        "gender": "Not Set Yet",
        "country": "Select Country",
        'url': widget.user.photoURL,
        'isBan': "false",
        'about': "About is Not Set Yet",
        "currentMood": "Happy",
        "username": userNameTextEditingController.text.toLowerCase(),
        "isVerified": "false",
      });
      userProfileDecencyReport.child(user.uid).set({
        "numberOfOne": 0,
        "numberOfTwo": 0,
        "numberOfThree": 0,
        "numberOfFour": 0,
        "numberOfFive": 0,
      });
      userRefForSearchRtd.child(user.uid).set({
        "isVerified": "false",
        "ownerId": user.uid,
        "username": userNameTextEditingController.text.toLowerCase(),
        "firstName": widget.user.displayName!.split(' ')[0],
        "secondName": "",
        "url": widget.user.photoURL,
      });
      userFollowersCountRtd.child(user.uid).set({
        "followerCounter": 0,
        "uid": user.uid,
        "username": userNameTextEditingController.text.toLowerCase(),
        "photoUrl": widget.user.photoURL,
        "about": "not set",
      });
      chatMoodReferenceRtd.child(user.uid).set({
        "mood": "romantic",
        "theme": "romantic",
        "loveNote": "Write Something For Love Of Your Life",
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Provider<AuthBase>(
              create: (context) => Auth(),
              child: WelcomePage(
                user: widget.user,
              )),
        ),
        (route) => false,
      );
    }
  }

  Future<void> signOut() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          elevation: 0,
          actions: [
            Center(
                child: Text(
              "Log Out",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'cute', fontSize: 15),
            )),
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: signOut),
          ],
        ),
        body: Container(
          color: Colors.lightBlue,
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Set Username",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: 15, fontFamily: 'cute'),
                  ),
                ),
                userExistsText
                    ? userExists
                        ? Center(
                            child: Text(
                              "This username Already taken",
                              style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 12,
                                  fontFamily: 'cutes'),
                            ),
                          )
                        : Center(
                            child: Text(
                              userNameTextEditingController.text.isEmpty
                                  ? ""
                                  : "This username is Available",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'cutes',
                                  fontSize: 12),
                            ),
                          )
                    : Text(""),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    // height: 65,
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: TextField(
                      inputFormatters: [],
                      onChanged: (values) {
                        userValidater(
                            userNameTextEditingController.text.toLowerCase());
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      //   maxLength: 30,
                      onTap: () => {
                        setState(() {
                          userExistsText = true;
                        }),
                      },
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "Cute",
                      ),
                      controller: userNameTextEditingController,
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
                        labelText: 'Username',
                        labelStyle: TextStyle(
                            fontFamily: "Cute",
                            color: Colors.white,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: setUserInfo,
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    "Already Done? then check your INTERNET connection and Restart App.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'cutes',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
