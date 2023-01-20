// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:delayed_display/delayed_display.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sliding_panel/sliding_panel.dart';
// import 'package:switchapp/MainPages/Profile/Panel/panel.dart';
// import 'package:switchapp/UniversalResources/DataBaseRefrences.dart';
// import 'body/Edit-Profile/EditProfile.dart';
// import 'package:switchapp/MainPages/Profile/body/body.dart';
//
// class SwitchProfile extends StatefulWidget {
//   SwitchProfile({required this.currentUserId,
//     required  this.mainProfileUrl,
//     required  this.mainFirstName,
//     required  this.profileOwner,
//     required  this.mainSecondName,
//     required this.mainCountry,
//     required  this.mainDateOfBirth,
//     required  this.mainAbout,
//     required  this.mainEmail,
//     required  this.mainGender,
//     required  this.user,
//     required  this.action,
//     required  this.username,
//     required  this.isVerified});
//
//   final String currentUserId;
//   final String mainGender;
//   final String mainProfileUrl;
//   final String mainFirstName;
//   final String profileOwner;
//   final String mainSecondName;
//   final String mainCountry;
//   final String action;
//   final String isVerified;
//
//   final User user;
//
//   //catalog //ranking //
//   final String mainDateOfBirth;
//   final String mainAbout;
//   final String mainEmail;
//   final String username;
//
//   @override
//   _SwitchProfileState createState() => _SwitchProfileState();
// }
//
// class _SwitchProfileState extends State<SwitchProfile>
//     with SingleTickerProviderStateMixin {
//   late PanelController pc;
//
//   bool safe = true;
//   bool isBlock = false;
//   late AnimationController animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     checkIfYouBlock();
//     pc = PanelController();
//
//     Future.delayed(const Duration(microseconds: 1), () {
//       setState(() {
//         pc.collapse();
//       });
//     });
//
//     animationController = AnimationController(vsync: this);
//   }
//
//   checkIfYouBlock() {
//     blockListRTD
//         .child(widget.profileOwner)
//         .child(widget.currentUserId)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           isBlock = true;
//         });
//       } else {}
//     });
//   }
//
//   // @override
//   // void dispose() {
//   //   animationController?.dispose();
//   //   super.dispose();
//   // }
//
//   List<Widget> get _content =>
//       [
//         DelayedDisplay(
//           slidingCurve: Curves.easeInOutSine,
//           delay: Duration(milliseconds: 200),
//           slidingBeginOffset: Offset(0, 0.35),
//           child: Panel(
//             aboutMain: widget.mainAbout,
//             profileOwner: widget.profileOwner,
//             currentUserId: widget.currentUserId,
//             mainProfileUrl: widget.mainProfileUrl,
//             mainFirstName: widget.mainFirstName,
//             mainSecondName: widget.mainSecondName,
//             mainGender: widget.mainGender,
//             mainEmail: widget.mainEmail,
//             user: widget.user,
//             username: widget.username,
//           ),
//         ),
//       ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isBlock
//           ? Center(
//         child: Column(
//           children: [
//             SizedBox(height: MediaQuery
//                 .of(context)
//                 .size
//                 .height / 3,),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "You are blocked By ${widget.username}",
//                 style: TextStyle(color: Colors.red,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: "cutes",),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Back",
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//           : SafeArea(
//         child: SlidingPanel(
//           panelController: pc,
//           safeAreaConfig: safe
//               ? SafeAreaConfig.all(removePaddingFromContent: true)
//               : SafeAreaConfig(removePaddingFromContent: false),
//           backdropConfig:
//           BackdropConfig(enabled: false, shadowColor: Colors.white),
//           size: PanelSize(
//               closedHeight: 0.05,
//               collapsedHeight: 0.3,
//               expandedHeight: .9),
//           decoration: PanelDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//               backgroundColor: Colors.white),
//           content: PanelContent(
//             panelContent: _content,
//             bodyContent: Provider.value(
//               value: widget.profileOwner,
//               child: Body(
//                 profileOwner: widget.profileOwner,
//                 currentUserId: widget.currentUserId,
//                 mainProfileUrl: widget.mainProfileUrl,
//                 mainSecondName: widget.mainSecondName,
//                 mainFirstName: widget.mainFirstName,
//                 mainGender: widget.mainGender,
//                 mainEmail: widget.mainEmail,
//                 mainAbout: widget.mainAbout,
//                 user: widget.user,
//                 username: widget.username,
//                 isVerified: widget.isVerified,
//               ),
//             ),
//
//             // Stack(
//             //   children: <Widget>[
//             //     Container(
//             //       decoration: BoxDecoration(
//             //         gradient: LinearGradient(
//             //           colors: [
//             //             Color.fromRGBO(74, 118, 129, 0.9),
//             //             Color.fromRGBO(63, 96, 127, 0.9),
//             //           ],
//             //           begin: Alignment.bottomLeft,
//             //           end: Alignment.topRight,
//             //         ),
//             //       ),
//             //     ),
//             //     Center(
//             //       // Wrapping the content in SafeArea is up to you.
//             //       child: SafeArea(
//             //         child: ListView(
//             //           shrinkWrap: true,
//             //           padding: EdgeInsets.all(0),
//             //           children: <Widget>[
//             //             Padding(
//             //               padding: const EdgeInsets.only(
//             //                   top: 48, bottom: 8.0, left: 8.0, right: 8.0),
//             //               child: Text(
//             //                 'This example uses `safeAreaConfig` in the panel.',
//             //                 style: textStyleSubHead,
//             //               ),
//             //             ),
//             //             Padding(
//             //               padding: const EdgeInsets.all(8.0),
//             //               child: Text(
//             //                 'So, intrusions like notch, nav-bar, status bar, etc. will be ignored by the panel and padded.',
//             //                 style: textStyleSubHead,
//             //               ),
//             //             ),
//             //             Padding(
//             //               padding: const EdgeInsets.all(8.0),
//             //               child: Text(
//             //                 '`bodyContent` and `backdropConfig` are not padded. They still get full screen height-width. Only header, content and footer are padded.',
//             //                 style: textStyleSubHead,
//             //               ),
//             //             ),
//             //             Padding(
//             //               padding: const EdgeInsets.all(8.0),
//             //               child: Text(
//             //                 'Also notice the use of `primary: true` in `PanelHeaderOptions` here.',
//             //                 style: textStyleSubHead,
//             //               ),
//             //             ),
//             //             Container(
//             //               margin: EdgeInsets.only(top: 16),
//             //               padding: const EdgeInsets.all(6.0),
//             //               child: RaisedButton(
//             //                 onPressed: pc.collapse,
//             //                 padding: EdgeInsets.all(16),
//             //                 child: Text('Open panel'),
//             //               ),
//             //             ),
//             //             Padding(
//             //               padding: const EdgeInsets.all(6.0),
//             //               child: RaisedButton(
//             //                 onPressed: () {
//             //                   Navigator.of(context).pop();
//             //                 },
//             //                 padding: EdgeInsets.all(16),
//             //                 child: Text('Go back'),
//             //               ),
//             //             ),
//             //             SizedBox(height: 150),
//             //           ],
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//           ),
//           onPanelSlide: (x) {
//             animationController.value = pc.percentPosition(
//                 pc.sizeData.closedHeight, pc.sizeData.expandedHeight);
//           },
//           parallaxSlideAmount: 0.0,
//           snapping: PanelSnapping.forced,
//           duration: Duration(milliseconds: 300),
//           dragMultiplier: 1.5,
//         ),
//       ),
//     );
//   }
// }

///
///
///
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_panel/sliding_panel.dart';
import 'package:switchapp/MainPages/Profile/Panel/panel.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'body/Edit-Profile/EditProfile.dart';
import 'package:switchapp/MainPages/Profile/body/body.dart';

class SwitchProfile extends StatefulWidget {
  SwitchProfile(
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
      });

  final String currentUserId;
  final String mainGender;
  final String mainProfileUrl;
  final String mainFirstName;
  final String profileOwner;
  final String mainSecondName;
  final String mainCountry;
  final String action;
  final String isVerified;
  late Map? controlData;


  final User user;

  //catalog //ranking //
  final String mainDateOfBirth;
  final String mainAbout;
  final String mainEmail;
  final String username;

  @override
  _SwitchProfileState createState() => _SwitchProfileState();
}

class _SwitchProfileState extends State<SwitchProfile> {
  bool isBlock = false;

  @override
  void initState() {
    super.initState();
    checkIfYouBlock();
  }

  checkIfYouBlock() {
    blockListRTD
        .child(widget.profileOwner)
        .child(widget.currentUserId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          isBlock = true;
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isBlock
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You are blocked By ${widget.username}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontFamily: "cutes",
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Back",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Provider.value(
                value: widget.profileOwner,
                child: Body(
                  profileOwner: widget.profileOwner,
                  currentUserId: widget.currentUserId,
                  mainProfileUrl: widget.mainProfileUrl,
                  mainSecondName: widget.mainSecondName,
                  mainFirstName: widget.mainFirstName,
                  mainGender: widget.mainGender,
                  mainEmail: widget.mainEmail,
                  mainAbout: widget.mainAbout,
                  user: widget.user,
                  username: widget.username,
                  isVerified: widget.isVerified,
                  dob: widget.mainDateOfBirth,
                  country: widget.mainCountry,
                ),
              ));
  }
}
