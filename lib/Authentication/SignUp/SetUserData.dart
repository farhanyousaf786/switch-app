/*
 * This is very important page of our app
 * this page will load after we verify our
 * email. and will set some defualt values in DB
 * about our user.
 */

import 'package:country_picker/country_picker.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Authentication/Auth/Auth.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'SetProfilePicture.dart';

timeStamp() => DateTime.now().toIso8601String();

class SetUserData extends StatefulWidget {
  final User? user;

  const SetUserData({required this.user});

  @override
  _SetUserDataState createState() => _SetUserDataState();
}

class _SetUserDataState extends State<SetUserData> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  late String dateOfBirth;
  String countryName = 'Select Country';
  final formKey = GlobalKey<FormState>();
  List userList = [];
  List userList2 = [];
  late Map<dynamic, dynamic> values;
  bool userListEmpty = false;
  bool userExists = false;
  bool userNameLengthExceeded = false;
  bool userExistsText = false;
  Map? userMap;

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  void getAllUsers() {
    userRefForSearchRtd.once().then((DataSnapshot snapshot) {
      values = snapshot.value;
      List tempList = [];
      if (values == null) {
        setState(() {
          userListEmpty = true;
        });
      } else {
        if (mounted)
          setState(() {
            values.forEach(
                (index, data) => tempList.add({"user": index, ...data}));
          });
        setState(() {
          this.userList = tempList;
        });
      }
    });
  }

  void setUserInfo() async {
    formatUsername();
    if (firstName.text.isEmpty ||
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
                        userExists
                            ? "Username is already Taken"
                            : "All information should be added",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "cute",
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
      userRefRTD.child(user.uid).update({
        "androidNotificationToken": "",
        "ownerId": user.uid,
        "firstName":
            firstName.text[0].toUpperCase() + firstName.text.substring(1),
        "secondName": lastName.text.isEmpty
            ? ""
            : lastName.text[0].toUpperCase() + lastName.text.substring(1),
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
        "email": user.email,
        "dob": "01/01/2000",
        "gender": "Not Set Yet",
        "country": countryName,
        'url': Constants.switchLogo,
        'isBan': "false",
        "currentMood": "Happy",
        "username": userNameTextEditingController.text.toLowerCase(),
        "isVerified": "false",
        "about": "not set",
      });
      userProfileDecencyReport.child(user.uid).update({
        "numberOfOne": 0,
        "numberOfTwo": 0,
        "numberOfThree": 0,
        "numberOfFour": 0,
        "numberOfFive": 0,
      });
      userRefForSearchRtd.child(user.uid).update({
        "isVerified": "false",
        "ownerId": user.uid,
        "username": userNameTextEditingController.text.toLowerCase(),
        "firstName":
            firstName.text[0].toUpperCase() + firstName.text.substring(1),
        "secondName": lastName.text.isEmpty
            ? ""
            : lastName.text[0].toUpperCase() + lastName.text.substring(1),
        "url": Constants.switchLogo,
      });
      userFollowersCountRtd.child(user.uid).set(
        {
          "followerCounter": 0,
          "uid": user.uid,
          "username": userNameTextEditingController.text.toLowerCase(),
          "photoUrl": Constants.switchLogo,
        },
      );
      setUserData(user);
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Provider<AuthBase>(
              create: (context) => Auth(),
              child: SetProfilePicture(
                user: user.uid,
                email: user.email,
                users: widget.user!,
              ),
            ),
          ),
        );
      });
    }
  }

  setUserData(User user) async {
    print("*****((Set User Data at Bridget To Navigation))*****");
    Map userMap;
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    userRefRTD.child(user.uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userMap = dataSnapshot.value;
        prefs.setString("firstName", userMap['firstName']);
        prefs.setString("ownerId", userMap['ownerId']);
        prefs.setString("url", userMap['url']);
        prefs.setString("secondName", userMap['secondName']);
        prefs.setString("email", userMap['email']);
        prefs.setString("currentMood", userMap['currentMood']);
        prefs.setString("gender", userMap['gender']);
        prefs.setString("country", userMap['country']);
        prefs.setString("dob", userMap['dob']);
        prefs.setString("about", userMap['about']);
        prefs.setString("username", userMap['username']);
        prefs.setString("isVerified", userMap['isVerified']);
        prefs.setString("isBan", userMap['isBan']);
      }
    });
  }

  void formatUsername() {
    userNameTextEditingController.text =
        userNameTextEditingController.text.replaceAll(" ", "");
  }

  void userValidator(String userName) {
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
                          "Username Must be less than 30 characters",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "cute",
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
    }
  }

  void _userNameEditingComplete() {
    formatUsername();
    userValidator(userNameTextEditingController.text.toLowerCase());
    FocusScope.of(context).requestFocus(firstNameFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        leading: Text(""),
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Set Profile",
          style: TextStyle(
            fontFamily: "Cute",
            color: Colors.white,
             fontWeight: FontWeight.bold,

            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.lightBlue,
        child: DelayedDisplay(
          delay: Duration(milliseconds: 500),
          slidingBeginOffset: Offset(0.0, -1),
          child: ListView(
            children: <Widget>[
              Container(
                height: 130,
                width: 100,
                child: RiveAnimation.asset(
                  'images/authLogo.riv',
                ),
              ),

              userExistsText
                  ? userExists
                      ? Center(
                          child: Text(
                            "This username Already taken",
                            style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                                fontFamily: 'cute'),
                          ),
                        )
                      : Center(
                          child: Text(
                            userNameTextEditingController.text.isEmpty
                                ? ""
                                : "This username is Available",
                            style: TextStyle(
                                color: Colors.lightBlue.shade800,
                                fontFamily: 'cute',
                                fontSize: 12),
                          ),
                        )
                  : Text(""),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  // height: 65,
                  padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
                  child: TextField(
                    inputFormatters: [],
                    onEditingComplete: _userNameEditingComplete,
                    onChanged: (values) {
                      userValidator(
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
                      color: Colors.lightBlue.shade900,
                      fontSize: 12,
                      fontFamily: "Cute",
                       fontWeight: FontWeight.bold,

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
                          color: Colors.white70,
                           fontWeight: FontWeight.bold,

                          fontSize: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DelayedDisplay(
                  delay: Duration(seconds: 1),
                  slidingBeginOffset: Offset(-0.5, 0.0),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: Colors.lightBlue.shade900,
                          fontFamily: "Cute",
                           fontWeight: FontWeight.bold,

                          fontSize: 12),
                      controller: firstName,
                      focusNode: firstNameFocusNode,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.transparent,
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
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                            fontFamily: 'cute',
                            color: Colors.white70,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DelayedDisplay(
                  delay: Duration(seconds: 1),
                  slidingBeginOffset: Offset(-0.5, 0.0),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: Colors.lightBlue.shade900,
                          fontFamily: "Cute",
                           fontWeight: FontWeight.bold,

                          fontSize: 12),
                      controller: lastName,
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
                        labelText: 'Last Name (optional)',
                        labelStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'cute'),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   padding: EdgeInsets.only(top: 20),
              //   child: Text(
              //     "Date Of Birth",
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontFamily: "Cute",
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Container(
              //     height: 80,
              //     padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
              //     child: TextFormField(
              //       maxLength: 10,
              //       // maxLengthEnforced: false,
              //       keyboardType: TextInputType.emailAddress,
              //       textInputAction: TextInputAction.next,
              //       style: TextStyle(
              //           color: Colors.lightBlue.shade800,
              //           fontFamily: "Cute",
              //           fontWeight: FontWeight.bold,
              //           fontSize: 12),
              //       onChanged: (value) => {
              //         dateOfBirth = value,
              //       },
              //       decoration: InputDecoration(
              //         fillColor: Colors.transparent,
              //         isDense: true,
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(20)),
              //           borderSide:
              //               new BorderSide(color: Colors.white, width: 2),
              //         ),
              //         filled: true,
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(20)),
              //           borderSide: new BorderSide(
              //             color: Colors.white,
              //             width: 2,
              //           ),
              //         ),
              //         labelText: 'Exp : 12/30/1999',
              //         labelStyle: TextStyle(
              //             color: Colors.lightBlue.shade800,
              //             fontSize: 12,
              //             fontFamily: 'cute'),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20),
              //   child: Center(
              //     child: Text(
              //       "Your Country",
              //       style: TextStyle(
              //         fontFamily: "Cute",
              //         fontSize: 14,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.transparent,
              //         shadowColor: Colors.transparent,
              //         elevation: 0.0,
              //       ),
              //       child: Container(
              //         padding: EdgeInsets.only(
              //             top: 11, left: 8, right: 8, bottom: 10),
              //         height: 40,
              //         decoration: BoxDecoration(
              //           color: Colors.lightBlue.shade50,
              //           border:
              //               Border.all(color: Colors.blue.shade700, width: 1),
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         child: Text(
              //           '$countryName',
              //           style: TextStyle(
              //               color: Colors.lightBlue.shade800,
              //               fontFamily: "Cute",
              //               fontSize: 10),
              //         ),
              //       ),
              //       onPressed: () => {
              //             showCountryPicker(
              //               context: context,
              //               //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
              //               exclude: <String>['KN', 'MF'],
              //               //Optional. Shows phone code before the country name.
              //               showPhoneCode: true,
              //               onSelect: (Country country) {
              //                 setState(() {
              //                   countryName = country.name;
              //                 });
              //               },
              //             ),
              //           }),
              // ),
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: "Cute",
                       fontWeight: FontWeight.bold,

                      fontSize: 16,
                      color: userExists ? Colors.blue.shade200 : Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    setUserInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.lightBlue,
                    backgroundColor: Colors.white,
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: DelayedDisplay(
                  delay: Duration(seconds: 1),
                  slidingBeginOffset: Offset(0.0, -1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "1 of 2 Steps",
                        style: TextStyle(
                          fontFamily: "Cute",
                           fontWeight: FontWeight.bold,

                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
