// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:delayed_display/delayed_display.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/Models/UserData.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
//
// timeStamp() => DateTime.now().toIso8601String();
// DateTime _selectedDate;
// Timestamp date ;
//
// class EditMyProfile extends StatefulWidget {
//   final String uid;
//
//   const EditMyProfile({Key key, this.uid}) : super(key: key);
//
//   @override
//   _EditProfileState createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditMyProfile> {
//   String firstName;
//   String secondName = "";
//   String dateOfBirth;
//   String country = "";
//   String bio = "";
//   String gender = "";
//   String countryName = 'Select Country';
//   final formKey = GlobalKey<FormState>();
//
//   _saveData() async {
//     print("name: $firstName");
//     print("dob: $_selectedDate");
//
//     await usersReference.doc(Constants.myId).get();
//
//     usersReference.doc(Constants.myId).update({
//       "firstName": firstName == null
//           ? Constants.myName
//           : firstName[0].toUpperCase() + firstName.substring(1),
//       "secondName": secondName.length == 0
//           ? Constants.mySecondName
//           : secondName[0].toUpperCase() + secondName.substring(1),
//       "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
//       "dateOfBirth": _selectedDate,
//       "country": countryName.isEmpty ? Constants.country : countryName,
//     });
//   }
//
//   DocumentSnapshot snapshot;
//   getDob() async {
//     print("jjjjj");
//
//     usersReference.doc(widget.uid).get();
//     final data = await usersReference.doc(widget.uid).get();
//
//     snapshot = data;
//     ///      UserMap userMap = UserMap.fromMap(snapshot.data());
//     ///      this can also be used to get user values
//     UserMap userMap = UserMap.fromMap(snapshot.data());
//
//     /// unUsed for Now we can user UserMap2 userMap2 for this
//     UserMap2 userMap2 = UserMap2.fromDocument(snapshot);
//
//     date = userMap2.dateOfBirth;
//
//     print("date" + date.toString());
//
//
//
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getDob();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Edit Profile",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xff21254A),
//         elevation: 0.0,
//         leading: Center(
//           child: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//             onPressed: () => {
//               Navigator.pop(context),
//             },
//           ),
//         ),
//       ),
//       body: Container(
//         color: Color(0xff21254A),
//         child: ListView(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(40),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       ":)",
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Text(
//                     " Set Basic Information",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: DelayedDisplay(
//                 delay: Duration(seconds: 1),
//                 slidingBeginOffset: Offset(-0.5, 0.0),
//                 child: Container(
//                   height: 50,
//                   padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
//                   child: TextFormField(
//                     initialValue: Constants.myName,
//                     onChanged: (value) => {
//                       firstName = value,
//                     },
//                     keyboardType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.next,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       isDense: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                         borderSide:
//                             new BorderSide(color: Colors.white, width: 2),
//                       ),
//                       filled: true,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                         borderSide:
//                             new BorderSide(color: Colors.white, width: 2),
//                       ),
//                       labelText: 'First Name',
//                       labelStyle: TextStyle(color: Colors.white, fontSize: 11),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: DelayedDisplay(
//                 delay: Duration(seconds: 1),
//                 slidingBeginOffset: Offset(-0.5, 0.0),
//                 child: Container(
//                   height: 50,
//                   padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
//                   child: TextFormField(
//                     initialValue: Constants.mySecondName,
//                     onChanged: (value) => {
//                       secondName = value,
//                     },
//                     keyboardType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.next,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       isDense: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                         borderSide:
//                             new BorderSide(color: Colors.white, width: 2),
//                       ),
//                       filled: true,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                         borderSide:
//                             new BorderSide(color: Colors.white, width: 2),
//                       ),
//                       labelText: 'Last Name',
//                       labelStyle: TextStyle(color: Colors.white, fontSize: 11),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             DelayedDisplay(
//               delay: Duration(seconds: 1),
//               slidingBeginOffset: Offset(0.0, -1),
//               child: Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.only(top: 20),
//                 child: Text(
//                   "Date Of Birth",
//                   style: GoogleFonts.actor(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white10,
//                     borderRadius: BorderRadius.circular(20)),
//                 height: 150,
//                 child: CupertinoDatePicker (
//                   mode: CupertinoDatePickerMode.date,
//                   initialDateTime: date.toDate(),
//                   onDateTimeChanged: (DateTime newDateTime) {
//                     _selectedDate = newDateTime;
//                     print(_selectedDate);
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Current Country: ",
//                     style: GoogleFonts.actor(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey),
//                   ),
//                   Text(
//                     Constants.country,
//                     style: GoogleFonts.actor(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.lightBlue),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: RaisedButton(
//                   elevation: 0.0,
//                   color: Color(0xff21254A),
//                   // shape: RoundedRectangleBorder(
//                   //     borderRadius: BorderRadius.circular(15.0),
//                   //     side: BorderSide(color: Colors.grey, width: 2)),
//                   child: Container(
//                     padding: EdgeInsets.only(
//                         top: 11, left: 10, right: 10, bottom: 10),
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Color(0xff21254A),
//                       border: Border.all(color: Colors.grey.shade50, width: 1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Text(
//                       '$countryName',
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                   onPressed: () => {
//                         showCountryPicker(
//                           context: context,
//                           //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
//                           exclude: <String>['KN', 'MF'],
//                           //Optional. Shows phone code before the country name.
//                           showPhoneCode: true,
//                           onSelect: (Country country) {
//                             setState(() {
//                               countryName = country.name;
//                             });
//                             print('Select country: ${country.displayName}');
//                           },
//                         )
//                       }),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 60, left: 100, right: 100),
//               child: RaisedButton(
//                 textColor: Colors.white,
//                 color: Color(0xff21254A),
//                 child: Text(
//                   'Save',
//                   style: GoogleFonts.actor(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 onPressed: () {
//                   _saveData();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///
///
///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/MainPages/Profile/Panel/EditProfilePic.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

timeStamp() => DateTime.now().toIso8601String();
Timestamp date = Timestamp.now();

class EditMyProfile extends StatefulWidget {
  final String uid;
  final String profileImage;

  const EditMyProfile({required this.uid, required this.profileImage});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditMyProfile> {
  late String? firstName = "";
  String about = "";
  late String? secondName = "";
  late String dateOfBirth;
  String country = "";
  String bio = "";
  String countryName = '';
  bool isMale = false;
  bool isFemale = false;
  bool others = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController dob = TextEditingController();

  _saveData() async {
    userRefRTD.child(Constants.myId).update({
      "firstName": firstName == ""
          ? Constants.myName
          : firstName![0].toUpperCase() + firstName!.substring(1),
      "secondName": secondName == ""
          ? Constants.mySecondName
          : secondName![0].toUpperCase() + secondName!.substring(1),
      "updateProfile": DateTime.now().millisecondsSinceEpoch.toString(),
      "dob": dateOfBirth,
      "country": countryName,
      "gender": Constants.gender,
      'about': about == "" ? Constants.about : about
    });
    userRefForSearchRtd.child(Constants.myId).update({
      "firstName": firstName == ""
          ? Constants.myName
          : firstName![0].toUpperCase() + firstName!.substring(1),
      "secondName": secondName == ""
          ? Constants.mySecondName
          : secondName![0].toUpperCase() + secondName!.substring(1),
      'about': about.length > 0 ? about : Constants.about
    });

    SharedPreferences? prefs = await SharedPreferences.getInstance();
    Map userMap;
    userRefRTD.child(widget.uid).once().then((DataSnapshot dataSnapshot) {
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
                        height: 100,
                        width: 200,
                        child: Lottie.asset("images/update.json")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Restart application for quick update",
                      style: TextStyle(
                           fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "cute",
                          color: Colors.lightBlue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Got it!'),
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: Colors.red,
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });

    // Provider<AuthBase>(create: (_) => Auth(), child: LandingPage());
  }

  late DocumentSnapshot snapshot;

  getDob() async {
    setState(() {
      dateOfBirth = Constants.dob;
      countryName = Constants.country;
    });

    print("date" + date.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constants.gender == 'Male'
        ? isMale = true
        : Constants.gender == 'Female'
            ? isFemale = true
            : others = true;
    getDob();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "cute",
             fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.transparent,
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: "Cute",
                   fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () => {_saveData()}),
        ],
        leading: Center(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              size: 18,
              color: Colors.white,
            ),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
        ),
      ),
      body: dateOfBirth == null
          ? Container(
              color: Colors.lightBlue,
              child: Center(child: CircularProgressIndicator()))
          : Container(
              color: Colors.lightBlue,
              child: DelayedDisplay(
                delay: Duration(milliseconds: 50),
                slidingBeginOffset: Offset(0.0, -1),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CircleAvatar(
                                      radius: 55,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                          radius: 53,
                                          backgroundColor: Colors.black12,
                                          backgroundImage: NetworkImage(
                                              widget.profileImage)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 80, top: 80),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: FloatingActionButton(
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfilePic(
                                                uid: widget.uid,
                                                imgUrl: widget.profileImage,
                                              ),
                                            ),
                                          ),
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30, left: 15, right: 15, bottom: 15),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                        child: TextFormField(
                          initialValue: Constants.myName,
                          onChanged: (value) => {
                            firstName = value,
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              color: Colors.lightBlue.shade900, fontFamily: 'cute'),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            labelText: 'First Name',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                        child: TextFormField(
                          initialValue: Constants.mySecondName,
                          onChanged: (value) => {
                            secondName = value,
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              color: Colors.lightBlue.shade900, fontFamily: 'cute'),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            labelText: 'Last Name',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Date Of Birth",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'cute',
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 80,
                        padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                        child: TextFormField(
                          initialValue: dateOfBirth,
                          maxLength: 10,
                          // maxLengthEnforced: false,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              color: Colors.lightBlue.shade900,
                              fontFamily: "Cute",
                               fontWeight: FontWeight.bold,
                              fontSize: 12),
                          onChanged: (value) => {
                            dateOfBirth = value,
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            labelText: 'Current Date Of Birth',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              // color:
                              //     isMale ? Colors.lightBlue : Colors.white,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(15.0),
                              //     side: BorderSide(
                              //       color: Colors.lightBlue,
                              //     )),
                              onPressed: () {
                                setState(() {
                                  isMale = true;
                                  isFemale = false;
                                  others = false;
                                  Constants.gender = "Male";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  backgroundColor:
                                      isMale ? Colors.blue : Colors.white,
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              child: Text(
                                "Male",
                                style: TextStyle(
                                    color: isMale
                                        ? Colors.white
                                        : Colors.lightBlue,
                                    fontFamily: "Cute",
                                     fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              )),
                          ElevatedButton(
                              // color: isFemale
                              //     ? Colors.lightBlue
                              //     : Colors.white,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(15.0),
                              //     side: BorderSide(
                              //       color: Colors.lightBlue,
                              //     )),
                              onPressed: () {
                                setState(() {
                                  isFemale = true;
                                  isMale = false;
                                  others = false;
                                  Constants.gender = "Female";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  backgroundColor:
                                      isFemale ? Colors.blue : Colors.white,
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              child: Text(
                                "Female",
                                style: TextStyle(
                                    color: isFemale
                                        ? Colors.white
                                        : Colors.lightBlue,
                                    fontFamily: "Cute",
                                     fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              )),
                          ElevatedButton(
                            // color: others ? Colors.blue : Colors.white,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(15.0),
                            //     side: BorderSide(
                            //       color: Colors.lightBlue,
                            //     )),
                            onPressed: () {
                              setState(() {
                                others = true;
                                isFemale = false;
                                isMale = false;
                                Constants.gender = "Others";
                              });
                            },
                            child: Text(
                              "Others",
                              style: TextStyle(
                                  color:
                                      others ? Colors.white : Colors.lightBlue,
                                  fontFamily: "Cute",
                                   fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),

                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor:
                                    others ? Colors.blue : Colors.white,
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30, left: 15, right: 15, bottom: 5),
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                        child: TextFormField(
                          initialValue: Constants.about,
                          maxLength: 90,
                          onChanged: (value) => {
                            about = value,
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              color: Colors.lightBlue.shade900, fontFamily: 'cute'),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  new BorderSide(color: Colors.white, width: 2),
                            ),
                            labelText: 'About',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          "Select Country",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.transparent,
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(15.0),
                          //     side: BorderSide(color: Colors.grey, width: 2)),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 11, left: 10, right: 10, bottom: 10),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade50,
                              border: Border.all(
                                  color: Colors.lightBlue.shade700, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '$countryName',
                              style: TextStyle(
                                  color: Color(0xff21254A), fontSize: 12),
                            ),
                          ),
                          onPressed: () => {
                                showCountryPicker(
                                  context: context,
                                  //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                  exclude: <String>['KN', 'MF'],
                                  //Optional. Shows phone code before the country name.
                                  showPhoneCode: true,
                                  onSelect: (Country country) {
                                    setState(() {
                                      countryName = country.name;
                                    });
                                    print('Select country: ${country.name}');
                                  },
                                )
                              }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
