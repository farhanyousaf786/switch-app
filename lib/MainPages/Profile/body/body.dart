// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:countup/countup.dart';
// import 'package:delayed_display/delayed_display.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lottie/lottie.dart';
//
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:rive/rive.dart';
// import 'package:switchtofuture/MainPages/Profile/blockPage.dart';
// import 'package:switchtofuture/MainPages/Profile/body/profieDecency/Buttons/CrushPage.dart';
// import 'package:switchtofuture/MainPages/Profile/body/profieDecency/followerPage.dart';
// import 'Edit-Profile/EditProfile.dart';
// import 'package:switchtofuture/MainPages/Profile/body/closFriendList/addFriendListButton.dart';
// import 'package:switchtofuture/MainPages/Profile/body/profieDecency/Buttons/ButtonForFive.dart';
// import 'package:switchtofuture/MainPages/Profile/body/profieDecency/Buttons/ButtonForFour.dart';
// import 'package:switchtofuture/MainPages/Profile/body/profieDecency/Buttons/ButtonForOne.dart';
// import 'package:switchtofuture/MainPages/Profile/body/profieDecency/Buttons/ButtonForThree.dart';
// import 'package:switchtofuture/MainPages/Profile/body/profieDecency/Buttons/ButtonForTwo.dart';
// import 'package:switchtofuture/MainPages/SearchPages/MainSearchPage.dart';
// import 'closFriendList/bestFriendList.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/Models/showAlertDialogueForSignInPage.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
//
// class Body extends StatefulWidget {
//   final String profileOwner;
//   final String currentUserId;
//   final String mainProfileUrl;
//   final String mainSecondName;
//   final String mainFirstName;
//   final String mainGender;
//   final String mainEmail;
//   final String mainAbout;
//   final User user;
//
//   const Body(
//       {Key key,
//       this.profileOwner,
//       this.currentUserId,
//       this.mainProfileUrl,
//       this.mainFirstName,
//       this.mainSecondName,
//       this.mainGender,
//       this.mainEmail,
//       this.mainAbout,
//       this.user})
//       : super(key: key);
//
//   @override
//   _BodyState createState() => _BodyState();
// }
//
// class _BodyState extends State<Body> {
//   bool youBlockedThisPerson = true;
//   int crushOfCount = 0;
//   int crushOnCount;
//   bool isCrushOn = false;
//   bool isFollowingYou = false;
//   String inRealtionshipWithFirstName;
//   String inRealtionshipWithSecondName;
//   String relationShipRequestSendToId = "";
//   String inRelationshipWithId = "";
//
//   bool inRelationShipForOwnProfile = false;
//   String inRelationShipWithFirstNameToShow;
//   String inRelationShipWithSecondNameToShow;
//   bool visitorIsAlreadyInRelationShip = false;
//   bool inRelationShip = false;
//   bool pendingRelationShip = false;
//   String relationShipRequestSenderId;
//   bool youHaveToAccept = false;
//   String profileOwnerCurrentMood;
//   bool isFollowedByYou = false;
//   Map followersCountMap2;
//
//   int followingsCounter;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCrushOfCount();
//     getCrushOnCount();
//     checkIfIsCrushOn();
//     _followingOrNotForVisitor();
//     getRelationShipStatus();
//     getRelationShipAcceptance();
//     getRelationShipStatusForOwnProfile();
//     getDecencyReport();
//     getBestFriends();
//     checkIfFollowedByYou();
//     followingCounter();
//   }
//
//   followingCounter() {
//     Map data;
//
//     userFollowersRtd
//         .child(widget.profileOwner)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           data = dataSnapshot.value;
//         });
//
//         setState(() {
//           followingsCounter = data.length;
//         });
//         userFollowersCountRtd.child(widget.profileOwner).update({
//           "followerCounter": data.length,
//           "uid": widget.profileOwner,
//
//
//         });
//       }else{
//         userFollowersCountRtd.child(widget.profileOwner).update({
//           "followerCounter": 0,
//           "uid": widget.profileOwner,
//
//
//         });
//
//       }
//     });
//   }
//
//   ///*** This Is Relation Ship Function ***\\\
//   checkIfFollowedByYou() async {
//     userFollowersRtd
//         .child(widget.profileOwner)
//         .child(widget.currentUserId)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         isFollowedByYou = true;
//       } else {
//         isFollowedByYou = false;
//       }
//     });
//   }
//
//   getRelationShipStatus() async {
//     Map data;
//     Map data2;
//
//     relationShipReferenceRtd
//         .child(widget.profileOwner)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           data = dataSnapshot.value;
//         });
//
//         data.length;
//         // print("dsadadssssssssssssssssssssssssssad "  + data['inRelationShip'].toString());
//
//       }
//     });
//
//     ///to checkIf Visitor is Already in relation
//     // DocumentSnapshot snapshot2 =
//     // await relationShipReference.doc(widget.currentUserId).get();
//
//     relationShipReferenceRtd
//         .child(widget.currentUserId)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           data2 = dataSnapshot.value;
//         });
//         print("dsadadssssssssssssssssssssssssssad " +
//             data2['inRelationShip'].toString());
//
//         data2.length;
//       }
//     });
//
//     Future.delayed(const Duration(seconds: 1), () {
//       print("dsadadssssssssssssssssssssssssssad " +
//           data2['inRelationShip'].toString());
//
//       if (data2['inRelationShip'] == true) {
//         visitorIsAlreadyInRelationShip = true;
//
//         print("visiter is already in relation");
//       } else if (data2['inRelationShip'] == false) {
//         visitorIsAlreadyInRelationShip = false;
//         print("visiter is not already in relation");
//       }
//
//       /// Check about profile owner relationship status
//       if (widget.currentUserId != widget.profileOwner) {
//         setState(() {
//           relationShipRequestSenderId = data['relationShipRequestSenderId'];
//         });
//         print("relationShipRequestSenderId = > $relationShipRequestSenderId");
//         print("current Id = > ${widget.currentUserId}");
//         if (data.isNotEmpty && !data['inRelationShip']) {
//           if (data['pendingRelationShip']) {
//             setState(() {
//               pendingRelationShip = true;
//             });
//           }
//         } else if (data['inRelationShip']) {
//           print(" u r in relation ship");
//           inRelationShipWithFirstNameToShow =
//               data['inRelationshipWithFirstName'];
//           inRelationShipWithSecondNameToShow =
//               data['inRelationshipWithSecondName'];
//           print(
//               "inRelationShipWithFirstNameToShow = >>>>>> $inRelationShipWithFirstNameToShow");
//
//           setState(() {
//             inRelationShip = true;
//           });
//         } else {
//           setState(() {
//             pendingRelationShip = false;
//           });
//         }
//       } else {
//         print("u r in ur Profile");
//       }
//     });
//   }
//
//   ///************\\\
//
//   ///init method for Own Id
//   getRelationShipAcceptance() async {
//     print("getRelationShipAcceptance run");
//
//     Map data;
//     // DocumentSnapshot snapshot =
//     // await relationShipReference.doc(widget.profileOwner).get();
//
//     relationShipReferenceRtd
//         .child(widget.currentUserId)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           data = dataSnapshot.value;
//         });
//
//         data.length;
//         // print("dsadadssssssssssssssssssssssssssad "  + data['inRelationShip'].toString());
//
//       }
//     });
//
//     Future.delayed(const Duration(seconds: 1), () {
//       if (widget.profileOwner == widget.currentUserId) {
//         print("widget.profileOwner == widget.currentUserId");
//         if (data.isNotEmpty) {
//           print("snapshot.exists run");
//           if (!data['inRelationShip'] &&
//               data['pendingRelationShip'] &&
//               data['relationShipRequestSenderName'] != Constants.myName) {
//             print("pending & accepter");
//             setState(() {
//               inRealtionshipWithFirstName =
//                   data['relationShipRequestSenderFirstName'];
//               inRealtionshipWithSecondName =
//                   data['relationShipRequestSenderSecondName'];
//
//               relationShipRequestSenderId = data['relationShipRequestSenderId'];
//               pendingRelationShip = true;
//               youHaveToAccept = true;
//             });
//           } else if (data.isNotEmpty &&
//               !data['inRelationShip'] &&
//               data['pendingRelationShip'] &&
//               data['relationShipRequestSenderName'] == Constants.myName) {
//             relationShipRequestSendToId = data['relationShipRequestSendToId'];
//             print("in pending");
//             setState(() {
//               youHaveToAccept = false;
//               pendingRelationShip = true;
//             });
//           } else if (data['inRelationShip']) {
//             inRelationShipWithFirstNameToShow =
//                 data['inRelationshipWithFirstName'];
//             inRelationShipWithSecondNameToShow =
//                 data['inRelationshipWithSecondName'];
//             inRelationshipWithId = data['inRelationshipWithId'];
//
//             print("in relationShip");
//             pendingRelationShip = false;
//             inRelationShip = true;
//           } else {
//             print("nothing Run");
//           }
//         }
//       } else {
//         print("You r on other Profile");
//       }
//     });
//   }
//
//   getRelationShipStatusForOwnProfile() async {
//     Map data;
//
//     relationShipReferenceRtd
//         .child(widget.profileOwner)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           data = dataSnapshot.value;
//         });
//
//         data.length;
//       }
//     });
//
//     Future.delayed(const Duration(seconds: 1), () {
//       if (data.isNotEmpty) {
//         if (data['inRelationShip']) {
//           setState(() {
//             inRelationShipForOwnProfile = true;
//             inRelationShipWithSecondNameToShow =
//                 data['inRelationshipWithSecondName'];
//             inRelationShipWithFirstNameToShow =
//                 data['inRelationshipWithFirstName'];
//           });
//         }
//       }
//     });
//   }
//
//   _acceptProposal() {
//     return showModalBottomSheet(
//         useRootNavigator: true,
//         isScrollControlled: false,
//         isDismissible: false,
//         barrierColor: Colors.pink.withOpacity(0.2),
//         elevation: 0,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         context: context,
//         builder: (context) {
//           return Container(
//             height: MediaQuery.of(context).size.height / 3,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15),
//                     child: Text(
//                       "Are You Sure?",
//                       style: TextStyle(
//                           fontSize: 20, fontFamily: "cute", color: Colors.red),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               elevation: 0.0,
//                               primary: Colors.blueAccent,
//                               textStyle: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.bold)),
//                           child: Text("Confirm"),
//                           onPressed: () {
//                             setState(() {
//                               pendingRelationShip = false;
//                               inRelationShip = true;
//                               print(
//                                   "relationShipRequestSenderId => ${relationShipRequestSenderId.toString()}");
//                             });
//
//                             relationShipReferenceRtd
//                                 .child(widget.profileOwner)
//                                 .update({
//                               "inRelationshipWithId":
//                                   relationShipRequestSenderId,
//                               "inRelationshipWithSecondName":
//                                   inRealtionshipWithSecondName,
//                               "inRelationshipWithFirstName":
//                                   inRealtionshipWithFirstName,
//                               "inRelationShip": true,
//                               "pendingRelationShip": false,
//                             });
//                             relationShipReferenceRtd
//                                 .child(relationShipRequestSenderId)
//                                 .update({
//                               "inRelationshipWithId": widget.profileOwner,
//                               "inRelationshipWithSecondName":
//                                   widget.mainSecondName,
//                               "inRelationshipWithFirstName":
//                                   widget.mainFirstName,
//                               "inRelationShip": true,
//                               "pendingRelationShip": false,
//                               "inRelationshipWith": Constants.myName,
//                             });
//                             feedRtDatabaseReference
//                                 .child(relationShipRequestSenderId)
//                                 .child("feedItems")
//                                 .push()
//                                 .set({
//                               "inRelationshipWithId": "",
//                               "inRelationshipWithSecondName": "",
//                               "inRelationshipWithFirstName": "",
//                               "type": "ConformedAboutRelationShip",
//                               "firstName": Constants.myName,
//                               "secondName": Constants.mySecondName,
//                               "comment": "",
//                               "timestamp":
//                                   DateTime.now().millisecondsSinceEpoch,
//                               "url": Constants.myPhotoUrl,
//                               "postId": "",
//                               "ownerId": widget.currentUserId,
//                               "photourl": "",
//                             });
//                             userRefRTD.child(Constants.myId).update({
//                               'inRelationship': "true",
//                             });
//                             userRefRTD
//                                 .child(relationShipRequestSenderId)
//                                 .update({
//                               'inRelationship': "true",
//                             });
//                             chatMoodReferenceRtd.child(Constants.myId).set({
//                               "mood": "romantic",
//                               "theme": "romantic",
//                               "loveNote":
//                                   "Write Something For Love Of Your Life",
//                             });
//                             chatMoodReferenceRtd
//                                 .child(relationShipRequestSenderId)
//                                 .set({
//                               "mood": "romantic",
//                               "theme": "romantic",
//                               "loveNote":
//                                   "Write Something For Love Of Your Life",
//                             });
//
//                             showModalBottomSheet(
//                                 useRootNavigator: true,
//                                 isScrollControlled: true,
//                                 barrierColor: Colors.red.withOpacity(0.2),
//                                 elevation: 0,
//                                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                                 context: context,
//                                 builder: (context) {
//                                   return Container(
//                                     height:
//                                         MediaQuery.of(context).size.height / 4,
//                                     child: SingleChildScrollView(
//                                       child: Column(
//                                         children: [
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 20),
//                                             child: Text(
//                                               "Done! Now Moving To Home Page",
//                                               style: TextStyle(
//                                                   fontSize: 20,
//                                                   fontFamily: "cutes",
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.blue),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(
//                                               "Please wait..",
//                                               style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontFamily: "cutes",
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.blue),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 });
//
//                             Future.delayed(const Duration(seconds: 3), () {
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                             });
//                           },
//                         ),
//                         ElevatedButton(
//                           child: Text('Back'),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                               elevation: 0.0,
//                               primary: Colors.redAccent,
//                               textStyle: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.bold)),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
//                     child: Center(
//                       child: Text(
//                         "After Confirmation, this person will be add to your Love Chat, Moreover, From now that is your Responsibility to be loyal with him/her. Nature Give us short life and you knew that, true love is Rare :(:",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.grey, fontSize: 15),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   toAcceptRelationShip() {
//     if (!inRelationShip && pendingRelationShip && youHaveToAccept) {
//       return Container(
//         width: 400,
//         alignment: Alignment.center,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "You have Relationship Request",
//                 style: TextStyle(
//                     color: Colors.grey, fontSize: 12, fontFamily: 'cute'),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(
//                     height: 30,
//                     child: FlatButton(
//                       color: Colors.grey.withOpacity(0.1),
//                       child: Text(
//                         "Accept Proposal",
//                         style: TextStyle(
//                           fontSize: 10,
//                         ),
//                       ),
//                       onPressed: () {
//                         _acceptProposal();
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Flexible(
//                     child: SizedBox(
//                       height: 30,
//                       child: FlatButton(
//                           color: Colors.grey.withOpacity(0.1),
//                           child: Text(
//                             "Not Interested",
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.pink,
//                             ),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               pendingRelationShip = false;
//                               inRelationShip = false;
//                               print(
//                                   "relationShipRequestSenderId => ${relationShipRequestSenderId.toString()}");
//                             });
//
//                             relationShipReferenceRtd
//                                 .child(widget.profileOwner)
//                                 .update({
//                               "inRelationShip": false,
//                               "pendingRelationShip": false,
//                               "relationShipRequestSenderName": "",
//                               "relationShipRequestSenderId": "",
//                               "relationShipRequestSendToName": "",
//                               "relationShipRequestSendToId": "",
//                             });
//                             relationShipReferenceRtd
//                                 .child(relationShipRequestSenderId)
//                                 .update({
//                               "inRelationShip": false,
//                               "pendingRelationShip": false,
//                               "relationShipRequestSenderName": "",
//                               "relationShipRequestSenderId": "",
//                               "relationShipRequestSendToName": "",
//                               "relationShipRequestSendToId": "",
//                             });
//                             feedRtDatabaseReference
//                                 .child(relationShipRequestSenderId)
//                                 .child("feedItems")
//                                 .push()
//                                 .set({
//                               "type": "notInterested",
//                               "firstName": Constants.myName,
//                               "secondName": Constants.mySecondName,
//                               "comment": "",
//                               "timestamp":
//                                   DateTime.now().millisecondsSinceEpoch,
//                               "url": Constants.myPhotoUrl,
//                               "postId": "",
//                               "ownerId": widget.currentUserId,
//                               "photourl": "",
//                             });
//                           }),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     } else if (pendingRelationShip) {
//       return Container(
//           child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: Text(
//                   "Proposal is pending",
//                   style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 15,
//                        fontWeight: FontWeight.bold,
//                       fontFamily: 'cute'),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 0),
//                 child: SizedBox(
//                   height: 48,
//                   child: FlatButton(
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           pendingRelationShip = false;
//                           inRelationShip = false;
//                           print(
//                               "relationShipRequestSenderId => ${relationShipRequestSenderId.toString()}");
//                         });
//
//                         relationShipReferenceRtd
//                             .child(widget.profileOwner)
//                             .update({
//                           "inRelationShip": false,
//                           "pendingRelationShip": false,
//                           "relationShipRequestSenderName": "",
//                           "relationShipRequestSenderId": "",
//                           "relationShipRequestSendToName": "",
//                           "relationShipRequestSendToId": "",
//                         });
//                         relationShipReferenceRtd
//                             .child(relationShipRequestSendToId)
//                             .update({
//                           "inRelationShip": false,
//                           "pendingRelationShip": false,
//                           "relationShipRequestSenderName": "",
//                           "relationShipRequestSenderId": "",
//                           "relationShipRequestSendToName": "",
//                           "relationShipRequestSendToId": "",
//                         });
//                         feedRtDatabaseReference
//                             .child(relationShipRequestSendToId)
//                             .child("feedItems")
//                             .push()
//                             .set({
//                           "type": "cancelRequest",
//                           "firstName": Constants.myName,
//                           "secondName": Constants.mySecondName,
//                           "comment": "",
//                           "timestamp": DateTime.now().millisecondsSinceEpoch,
//                           "url": Constants.myPhotoUrl,
//                           "postId": "",
//                           "ownerId": widget.currentUserId,
//                           "photourl": "",
//                         });
//                       }),
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             height: 20,
//             color: Colors.white,
//           ),
//         ],
//       ));
//     } else {
//       return Container(
//         height: 0,
//         child: Text(
//           "",
//         ),
//       );
//     }
//   }
//
//   getCrushOfCount() async {
//     print("getCrushCount run");
//
//     crushOfRTD
//         .child(widget.profileOwner)
//         .child("crushOfReference")
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         Map data = dataSnapshot.value;
//
//         data.length;
//
//         setState(() {
//           crushOfCount = data.length;
//         });
//       }
//     });
//   }
//
//   checkIfIsCrushOn() async {
//     print("checkIfIsCrushOn run");
//
//     crushOnRTD
//         .child(widget.currentUserId)
//         .child("crushOnReference")
//         .child(widget.profileOwner)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         Map data = dataSnapshot.value;
//
//         data.length;
//
//         setState(() {
//           isCrushOn = true;
//         });
//       }
//     });
//   }
//
//   getCrushOnCount() async {
//     print("getCrushCount run");
//
//     crushOnRTD
//         .child(widget.currentUserId)
//         .child("crushOnReference")
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         Map data = dataSnapshot.value;
//
//         data.length;
//         setState(() {
//           crushOnCount = data.length;
//         });
//         print("crushOfRef = = = = ${data.length}");
//       }
//     });
//   }
//
//   _followingOrNotForVisitor() {
//     return isFollowingYou
//         ? Padding(
//             padding: const EdgeInsets.only(top: 20),
//             child: Text("${widget.mainFirstName} He is Following you :)",
//                 style: TextStyle(
//                     fontFamily: "Names", color: Colors.blue, fontSize: 10),
//                 maxLines: 3,
//                 softWrap: true,
//                 overflow: TextOverflow.ellipsis),
//           )
//         : Padding(
//             padding: const EdgeInsets.only(top: 20),
//             child: Text(
//               "${widget.mainFirstName} is not following you :(",
//               maxLines: 3,
//               softWrap: true,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   fontFamily: "Names", color: Colors.black, fontSize: 10),
//             ),
//           );
//   }
//
//   appBar() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Padding(
//         padding:
//             const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Row(
//                 children: [
//                   Container(
//                     width: 33,
//                     height: 33,
//                     child: Center(
//                         child: Icon(
//                       Icons.arrow_back_ios_rounded,
//                       size: 18,
//                     )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8),
//                     child: Text(
//                       widget.mainFirstName + " " + widget.mainSecondName,
//                       style: TextStyle(
//                         fontFamily: "Cute",
//                         color: Colors.black,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Row(
//               children: [
//                 Container(
//                   width: 33,
//                   height: 33,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.black, width: 2),
//                     image: DecorationImage(
//                       image: NetworkImage(widget.mainProfileUrl),
//                     ),
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(left: 8),
//                 //   child: GestureDetector(
//                 //     onTap: () {
//                 //       Navigator.push(
//                 //           context,
//                 //           MaterialPageRoute(
//                 //               builder: (context) => MemeProfile(
//                 //                   profileOwner: widget.profileOwner,
//                 //                   currentUserId: widget.currentUserId,
//                 //                   mainProfileUrl: widget.mainProfileUrl,
//                 //                   mainSecondName: widget.mainSecondName,
//                 //                   mainFirstName: widget.mainFirstName,
//                 //                   mainGender: widget.mainGender,
//                 //                   mainEmail: widget.mainEmail,
//                 //                   mainAbout: widget.mainAbout,
//                 //                   user: widget.user)));
//                 //     },
//                 //     child: Padding(
//                 //       padding: const EdgeInsets.only(top: 3),
//                 //       child: Text(
//                 //         "Meme Profile >",
//                 //         style: TextStyle(
//                 //           fontFamily: "Cute",
//                 //           color: Colors.black,
//                 //           fontSize: 14,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             )
//
//             // widget.currentUserId == widget.profileOwner
//             //     ? IconButton(
//             //         icon: Icon(Icons.edit),
//             //         onPressed: () {
//             //           Navigator.push(
//             //               context,
//             //               MaterialPageRoute(
//             //                   builder: (context) => EditMyProfile(
//             //                         uid: widget.profileOwner,
//             //                         profileImage: widget.mainProfileUrl,
//             //                       )));
//             //         },
//             //       )
//             //     : IconButton(
//             //         icon: Icon(Icons.info_outline),
//             //       ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _crushOfAndFollowersButton() {
//     return Container(
//       height: 115,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 20, left: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 45,
//                   child: ElevatedButton(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4),
//                             child: Container(
//                               child: Text(
//                                 "Followers",
//                                 style: TextStyle(
//                                     fontFamily: "cutes",
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.blue,
//                                     fontSize: 12),
//                               ),
//                             ),
//                           ),
//                           StreamBuilder(
//                               stream: userFollowersRtd
//                                   .child(widget.currentUserId)
//                                   .onValue,
//                               builder: (context, dataSnapShot) {
//                                 if (dataSnapShot.hasData) {
//                                   DataSnapshot snapshot =
//                                       dataSnapShot.data.snapshot;
//
//                                   Map data = snapshot.value;
//
//                                   if (data == null) {
//                                     return Text(
//                                       "0",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontFamily: 'cutes',
//                                           fontSize: 14,
//                                           color: Colors.black),
//                                     );
//                                   } else {
//                                     return Text(
//                                       data.length.toString(),
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black),
//                                     );
//                                   }
//                                 } else {
//                                   return Text(
//                                     "0",
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold),
//                                   );
//                                 }
//                               }),
//                         ],
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FollowerPage(
//                             currentUserId: widget.currentUserId,
//                             profileOwner: widget.profileOwner,
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                         elevation: 0.0,
//                         primary: Colors.white,
//                         textStyle: TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 20,
//             ),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 45,
//                   child: ElevatedButton(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Crush ",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.blue,
//                                     fontFamily: "cutes",
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.favorite_border,
//                                   size: 12,
//                                   color: Colors.blue,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             child: Text(
//                               crushOfCount.toString(),
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'cutes',
//                                   fontSize: 14,
//                                   color: Colors.black),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CrushOfPage(
//                             currentUserId: widget.currentUserId,
//                             profileOwner: widget.profileOwner,
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                         elevation: 0.0,
//                         primary: Colors.white,
//                         textStyle: TextStyle(
//                             fontSize: 12, fontWeight: FontWeight.bold)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: _decencyMeter(),
//           )
//         ],
//       ),
//     );
//   }
//
//   _relationshipStatusForOwnProfile(int index) {
//     return Container(
//       color: Colors.grey.withOpacity(0.03),
//       child: Column(
//         children: [
//           inRelationShipForOwnProfile
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 23,
//                         top: 10,
//                         bottom: 15,
//                       ),
//                       child: Text(
//                         "In Love with",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 14,
//                           fontFamily: 'cute',
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 25),
//                       child: Text(
//                         "$inRelationShipWithFirstNameToShow "
//                         "$inRelationShipWithSecondNameToShow",
//                         maxLines: 3,
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.pink,
//                           fontFamily: 'cute',
//                            fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : GestureDetector(
//                   onTap: () => print("Tapped"),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       bottom: 10.0,
//                       top: 10,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 20),
//                           child: Text(
//                             "Not In Relationship",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontFamily: 'cute',
//                                 fontSize: 14,
//                                  fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(right: 15),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Search for one ",
//                                 style: TextStyle(
//                                     color: Colors.grey,
//                                     fontFamily: 'cute',
//                                     fontSize: 15,
//                                      fontWeight: FontWeight.bold),
//                               ),
//                               Icon(
//                                 Icons.search,
//                                 color: Colors.grey,
//                                 size: 20,
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//           SizedBox(
//             height: 10,
//             child: Container(
//               color: Colors.white,
//             ),
//           ),
//           _breakUpOption(),
//           SizedBox(
//             height: 10,
//             child: Container(
//               color: Colors.white,
//             ),
//           ),
//           toAcceptRelationShip(),
//           !inRelationShip && pendingRelationShip && youHaveToAccept
//               ? SizedBox(
//                   height: 20,
//                   child: Container(
//                     color: Colors.white,
//                   ),
//                 )
//               : SizedBox(
//                   height: 0,
//                 ),
//         ],
//       ),
//     );
//   }
//
//   relationShipRequestSendButton() {
//     if (inRelationShip) {
//       return Container(
//         height: 40,
//         color: Colors.blue.withOpacity(0.03),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Text(
//                 "Already In RelationShip",
//                 style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 14.0,
//                      fontWeight: FontWeight.bold,
//                     fontFamily: 'cute'),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 15),
//               child: Container(
//                 height: 40,
//                 width: 40,
//                 child: RiveAnimation.asset(
//                   'images/profile/inRelation-emoji.riv',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else if (!inRelationShip && !pendingRelationShip) {
//       return Container(
//         height: 40,
//         color: Colors.blue.withOpacity(0.03),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Text(
//                 "Click To Send RelationShip Request",
//                 style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 12.0,
//                      fontWeight: FontWeight.bold,
//                     fontFamily: 'cute'),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: GestureDetector(
//                   onTap: () {
//                     if (visitorIsAlreadyInRelationShip) {
//                       showAlertDialogeForAlreadyInRelationship(context,
//                           title: "Loyalty Is everything 😡",
//                           content:
//                               "You are Already Into Relationship with someone. We cannot let you do his 📣 ",
//                           defaultActionText: "OK");
//                     } else {
//                       setState(() {
//                         pendingRelationShip = true;
//                       });
//
//                       relationShipReferenceRtd.child(widget.profileOwner).set({
//                         "inRelationshipWithId": "",
//                         "inRelationshipWithSecondName": "",
//                         "inRelationshipWithFirstName": "",
//                         "crush": "",
//                         "closeFriend": "",
//                         "relationShipStatus": "",
//                         "inRelationShip": false,
//                         "pendingRelationShip": true,
//                         "relationShipRequestSenderSecondName":
//                             Constants.mySecondName,
//                         "relationShipRequestSenderName": Constants.myName,
//                         "relationShipRequestSenderFirstName": Constants.myName,
//                         "relationShipRequestSenderId": widget.currentUserId,
//                         "relationShipRequestSendToName": widget.mainFirstName,
//                         "relationShipRequestSendToId": widget.profileOwner,
//                       });
//                       relationShipReferenceRtd.child(widget.currentUserId).set({
//                         "inRelationshipWithId": "",
//                         "inRelationshipWithSecondName": "",
//                         "inRelationshipWithFirstName": "",
//                         "crush": "",
//                         "closeFriend": "",
//                         "relationShipStatus": "",
//                         "inRelationShip": false,
//                         "pendingRelationShip": true,
//                         "relationShipRequestSenderSecondName":
//                             Constants.mySecondName,
//                         "relationShipRequestSenderName": Constants.myName,
//                         "relationShipRequestSenderFirstName": Constants.myName,
//                         "relationShipRequestSenderId": widget.currentUserId,
//                         "relationShipRequestSendToName": widget.mainFirstName,
//                         "relationShipRequestSendToId": widget.profileOwner,
//                       });
//                       feedRtDatabaseReference
//                           .child(widget.profileOwner)
//                           .child("feedItems")
//                           .push()
//                           .set({
//                         "inRelationshipWithId": "",
//                         "inRelationshipWithSecondName": "",
//                         "inRelationshipWithFirstName": "",
//                         "type": "sendRequestToConformRelationShip",
//                         "firstName": Constants.myName,
//                         "secondName": Constants.mySecondName,
//                         "comment": "",
//                         "timestamp": DateTime.now().millisecondsSinceEpoch,
//                         "url": Constants.myPhotoUrl,
//                         "postId": "",
//                         "ownerId": widget.currentUserId,
//                         "photourl": "",
//                       });
//                     }
//                   },
//                   child: Icon(Icons.favorite_border_outlined,
//                       size: 30, color: Colors.blue)),
//             ),
//           ],
//         ),
//       );
//     } else if (pendingRelationShip) {
//       return relationShipRequestSendToId == widget.currentUserId
//           ? Text("Swipe To Cancel")
//           : GestureDetector(
//               onTap: () {
//                 Fluttertoast.showToast(
//                   msg: "Visit Your Profile To Cancel Request",
//                   toastLength: Toast.LENGTH_LONG,
//                   gravity: ToastGravity.TOP,
//                   timeInSecForIosWeb: 3,
//                   backgroundColor: Colors.blue.withOpacity(0.8),
//                   textColor: Colors.white,
//                   fontSize: 16.0,
//                 );
//               },
//               child: Container(
//                 height: 40,
//                 color: Colors.blue.withOpacity(0.03),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Center(
//                         child: Text(
//                           "Relationship Status Is Pending",
//                           style: TextStyle(
//                               color: Colors.purpleAccent,
//                               fontSize: 15,
//                               fontFamily: 'cutes',
//                               fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.only(right: 20),
//                         child: Icon(Icons.favorite,
//                             size: 30, color: Colors.purpleAccent)),
//                   ],
//                 ),
//               ),
//             );
//     }
//   }
//
//   _followersCountAndCrushCountButtonForVisitor() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         bottom: 15,
//                       ),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 50,
//                             child: RaisedButton(
//                                 highlightColor: Colors.white,
//                                 elevation: 0.0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     side: BorderSide(color: Colors.white)),
//                                 color: Colors.white,
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   FollowerPage(
//                                                 currentUserId:
//                                                     widget.currentUserId,
//                                                 profileOwner:
//                                                     widget.profileOwner,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text(
//                                             "Followers",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               fontFamily: "cutes",
//                                               color: Colors.blue,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       StreamBuilder(
//                                           stream: userFollowersRtd
//                                               .child(widget.profileOwner)
//                                               .onValue,
//                                           builder: (context, dataSnapShot) {
//                                             if (dataSnapShot.hasData) {
//                                               DataSnapshot
//                                                   snapshotForFollowerCounter =
//                                                   dataSnapShot.data.snapshot;
//
//                                               Map followersCountMap =
//                                                   snapshotForFollowerCounter
//                                                       .value;
//                                               followersCountMap2 =
//                                                   snapshotForFollowerCounter
//                                                       .value;
//
//                                               if (followersCountMap == null) {
//                                                 return Text(
//                                                   "0",
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontFamily: 'cutes'),
//                                                 );
//                                               } else {
//                                                 return Text(
//                                                   followersCountMap.length
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontFamily: 'cutes'),
//                                                 );
//                                               }
//                                             } else {
//                                               return Text(
//                                                 "0",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontFamily: 'cutes'),
//                                               );
//                                             }
//                                           }),
//                                     ],
//                                   ),
//                                 ),
//                                 onPressed: () {}),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         bottom: 15,
//                       ),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 50,
//                             child: RaisedButton(
//                                 highlightColor: Colors.white,
//                                 elevation: 0.0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     side: BorderSide(color: Colors.white)),
//                                 color: Colors.white,
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(4.0),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               "Crush ",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontFamily: 'cutes',
//                                                 color: Colors.blue,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Icon(
//                                               Icons.favorite_border_outlined,
//                                               size: 14,
//                                               color: Colors.blue,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: EdgeInsets.only(bottom: 4),
//                                         child: Text(
//                                           crushOfCount.toString(),
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontFamily: 'cutes'),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CrushOfPage(
//                                         currentUserId: widget.currentUserId,
//                                         profileOwner: widget.profileOwner,
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 _followingButton(),
//               ],
//             ),
//             _decencyMeter(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _followingButton() {
//     return SizedBox(
//       height: 25,
//       width: 80,
//       child: isFollowedByYou
//           ? ElevatedButton(
//               child: Text(
//                 "Following",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 setState(() {
//                   isFollowedByYou = false;
//                 });
//
//                 userFollowingRtd
//                     .child(widget.currentUserId)
//                     .child(widget.profileOwner)
//                     .remove();
//                 userFollowersRtd
//                     .child(widget.profileOwner)
//                     .child(widget.currentUserId)
//                     .remove();
//
//                 followingCounter();
//
//               },
//               style: ElevatedButton.styleFrom(
//                   primary: Colors.blue,
//                   textStyle:
//                       TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//             )
//           : ElevatedButton(
//               onPressed: () => {
//                 setState(() {
//                   isFollowedByYou = true;
//                 }),
//
//                 // make Auth User follower of Another User (Update Their Follower Collection)
//
//                 ///this is who, who have been followed by other user
//                 ///this code will add a follower to his/her data base
//                 // ProfileDataBase.makeFollower(
//                 //     widget.profileOwner, widget.currentUserId),
//
//                 /// this is who follow other user
//                 /// this code add a Following to his database
//                 // ProfileDataBase.addFollowing(
//                 //     widget.currentUserId, widget.profileOwner),
//
//                 /// this code will add notification to the use that have been followed
//                 feedRtDatabaseReference
//                     .child(widget.profileOwner)
//                     .child("feedItems")
//                     .push()
//                     .set({
//                   "type": "follow",
//                   "firstName": Constants.myName,
//                   "secondName": Constants.mySecondName,
//                   "comment": "",
//                   "timestamp": DateTime.now().millisecondsSinceEpoch,
//                   "url": Constants.myPhotoUrl,
//                   "postId": "",
//                   "ownerId": widget.currentUserId,
//                   "photourl": "",
//                 }),
//
//                 //For Realtime DataBase
//
//                 userFollowingRtd
//                     .child(widget.currentUserId)
//                     .child(widget.profileOwner)
//                     .set({
//                   'timestamp': DateTime.now().millisecondsSinceEpoch,
//                   'followingId': widget.profileOwner
//                 }),
//
//                 userFollowersRtd
//                     .child(widget.profileOwner)
//                     .child(widget.currentUserId)
//                     .set({
//                   'timestamp': DateTime.now().millisecondsSinceEpoch,
//                   'followerId': widget.currentUserId,
//                 }),
//
//                 followingCounter(),
//
//
//               },
//               child: Text(
//                 "Follow",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'cutes',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.blue.shade200,
//                 textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               ),
//             ),
//     );
//   }
//
//   _decencyMeter() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           CircularPercentIndicator(
//             radius: 75.0,
//             lineWidth: 6,
//             percent: userPercentageDecency.toStringAsPrecision(3) == "NaN"
//                 ? 0
//                 : userPercentageDecency / 100,
//             animation: true,
//             animationDuration: 2000,
//             startAngle: 180,
//             center: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Countup(
//                   duration: Duration(milliseconds: 2000),
//                   begin: 0,
//                   end: userPercentageDecency.toStringAsPrecision(3) == "NaN"
//                       ? 0
//                       : userPercentageDecency,
//                   style: TextStyle(
//                       color: Colors.blue,
//                       fontSize:
//                           userPercentageDecency.toStringAsPrecision(3) == "NaN"
//                               ? 12
//                               : 14,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   "%",
//                   style: TextStyle(
//                       color: Colors.blue,
//                       fontSize:
//                           userPercentageDecency.toStringAsPrecision(3) == "NaN"
//                               ? 13
//                               : 11,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//             progressColor: Colors.blue,
//             circularStrokeCap: CircularStrokeCap.round,
//             backgroundColor:
//                 userPercentageDecency.toStringAsPrecision(3) == "NaN"
//                     ? Colors.blue
//                     : Colors.grey.shade200,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 5, right: 1),
//             child: Text(
//               "Profile Decency",
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'cutes',
//               ),
//             ),
//           ),
//           userPercentageDecency.toStringAsPrecision(3) == "NaN"
//               ? Text(
//                   "Not Rated Yet",
//                   style: TextStyle(
//                       fontSize: 10, color: Colors.blue, fontFamily: 'cutes'),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.only(top: 3, right: 6),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8),
//                         child: Row(
//                           children: [
//                             new Text(
//                               userPercentageDecency.toStringAsPrecision(1) ==
//                                       "NaN"
//                                   ? "Not Rated"
//                                   : "${userDecency.toStringAsPrecision(1)}",
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: userPercentageDecency
//                                               .toStringAsPrecision(3) ==
//                                           "NaN"
//                                       ? 10
//                                       : 12,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               " / 5",
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: userPercentageDecency
//                                               .toStringAsPrecision(3) ==
//                                           "NaN"
//                                       ? 10
//                                       : 12,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
//
//   _breakUpOption() {
//     if (inRelationShip) {
//       return Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Text(
//                 "Relationship Option",
//                 style: TextStyle(
//                     color: Colors.blue,
//                      fontWeight: FontWeight.bold,
//                     fontFamily: 'cute'),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: TextButton(
//                 child: Text(
//                   "BreakUp",
//                   style: TextStyle(
//                     fontFamily: 'cute',
//                     color: Colors.red,
//                     fontSize: 13,
//                   ),
//                 ),
//                 onPressed: () {
//                   showModalBottomSheet(
//                       useRootNavigator: true,
//                       isScrollControlled: true,
//                       barrierColor: Colors.red.withOpacity(0.2),
//                       elevation: 0,
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       context: context,
//                       builder: (context) {
//                         return Container(
//                           height: MediaQuery.of(context).size.height / 3.5,
//                           child: SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 20),
//                                   child: Text(
//                                     "Confirmation",
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontFamily: "cute",
//                                         color: Colors.red),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     "Are You Sure To Broke Up This Person?",
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontFamily: "cute",
//                                         color: Colors.blueAccent),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 20),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 8, right: 8),
//                                         child: ElevatedButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               inRelationShip = false;
//                                               pendingRelationShip = false;
//                                             });
//
//                                             relationShipReferenceRtd
//                                                 .child(widget.profileOwner)
//                                                 .update({
//                                               "inRelationshipWithId": "",
//                                               "inRelationshipWithSecondName":
//                                                   "",
//                                               "inRelationshipWithFirstName": "",
//                                               "inRelationShip": false,
//                                               "pendingRelationShip": false,
//                                             });
//                                             relationShipReferenceRtd
//                                                 .child(inRelationshipWithId)
//                                                 .update({
//                                               "inRelationshipWithId": "",
//                                               "inRelationshipWithSecondName":
//                                                   "",
//                                               "inRelationshipWithFirstName": "",
//                                               "inRelationShip": false,
//                                               "pendingRelationShip": false,
//                                               "inRelationshipWith": "",
//                                             });
//
//                                             feedRtDatabaseReference
//                                                 .child(inRelationshipWithId)
//                                                 .child("feedItems")
//                                                 .push()
//                                                 .set({
//                                               "type": "breakUp",
//                                               "firstName": Constants.myName,
//                                               "secondName":
//                                                   Constants.mySecondName,
//                                               "timestamp": DateTime.now()
//                                                   .millisecondsSinceEpoch,
//                                               "url": Constants.myPhotoUrl,
//                                               "ownerId": widget.currentUserId,
//                                             });
//                                             userRefRTD
//                                                 .child(Constants.myId)
//                                                 .update({
//                                               'inRelationship': "false",
//                                             });
//                                             userRefRTD
//                                                 .child(inRelationshipWithId)
//                                                 .update({
//                                               'inRelationship': "false",
//                                             });
//
//                                             showModalBottomSheet(
//                                                 useRootNavigator: true,
//                                                 isScrollControlled: true,
//                                                 barrierColor:
//                                                     Colors.red.withOpacity(0.2),
//                                                 elevation: 0,
//                                                 clipBehavior:
//                                                     Clip.antiAliasWithSaveLayer,
//                                                 context: context,
//                                                 builder: (context) {
//                                                   return Container(
//                                                     height:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .height /
//                                                             4,
//                                                     child:
//                                                         SingleChildScrollView(
//                                                       child: Column(
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     top: 20),
//                                                             child: Text(
//                                                               "Done! Now Moving To Home Page",
//                                                               style: TextStyle(
//                                                                   fontSize: 20,
//                                                                   fontFamily:
//                                                                       "cutes",
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   color: Colors
//                                                                       .blue),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(8.0),
//                                                             child: Text(
//                                                               "Please wait..",
//                                                               style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   fontFamily:
//                                                                       "cutes",
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   color: Colors
//                                                                       .blue),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//
//                                             Future.delayed(
//                                                 const Duration(seconds: 3), () {
//                                               Navigator.pop(context);
//                                               Navigator.pop(context);
//                                               Navigator.pop(context);
//                                             });
//                                           },
//                                           child: Text('Confirm'),
//                                           style: ElevatedButton.styleFrom(
//                                               elevation: 0.0,
//                                               primary: Colors.blueAccent,
//                                               textStyle: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold)),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text('Cancel'),
//                                           style: ElevatedButton.styleFrom(
//                                               elevation: 0.0,
//                                               primary: Colors.redAccent,
//                                               textStyle: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold)),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Center(
//                                     child: Text(
//                                       "Kindly think again. Love is rare :(:, Life is short.",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           fontFamily: "cute",
//                                           color: Colors.grey),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       });
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
//
//   _relationShipStatusForVisitor() {
//     return Center(
//       child: Container(
//         height: 40,
//         color: Colors.blue.withOpacity(0.03),
//         width: MediaQuery.of(context).size.width,
//         child: inRelationShipForOwnProfile
//             ? Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Flexible(
//                         child: Text(
//                       "In Love️ with",
//                       style: TextStyle(
//                           color: Colors.blue,
//                           fontFamily: 'cute',
//                            fontWeight: FontWeight.bold),
//                     )),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       "$inRelationShipWithFirstNameToShow "
//                       "$inRelationShipWithSecondNameToShow",
//                       maxLines: 3,
//                       // softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontFamily: 'cute',
//                         color: Colors.pink,
//                          fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : GestureDetector(
//                 onTap: () => print("Tapped"),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: Container(
//                     height: 40,
//                     width: MediaQuery.of(context).size.width,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0, top: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Not in Relationship",
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                                  fontWeight: FontWeight.bold,
//                                 fontFamily: 'cute'),
//                           ),
//                           widget.profileOwner == widget.currentUserId
//                               ? Image.asset(
//                                   "images/editIcon.png",
//                                   scale: 25,
//                                 )
//                               : Icon(
//                                   Icons.all_inclusive,
//                                   color: Colors.grey,
//                                 )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
//
//   _crushButtonForVisitor() {
//     if (isCrushOn) {
//       return Padding(
//         padding: const EdgeInsets.only(
//           right: 15.5,
//         ),
//         child: GestureDetector(
//           onTap: () {
//             setState(() {
//               isCrushOn = false;
//               getCrushOfCount();
//             });
//
//             // removeFollower
//             crushOfRTD
//                 .child(widget.profileOwner)
//                 .child("crushOfReference")
//                 .child(widget.currentUserId)
//                 .remove();
//             // remove Following
//
//             crushOnRTD
//                 .child(widget.currentUserId)
//                 .child("crushOnReference")
//                 .child(widget.profileOwner)
//                 .remove();
//
//             // dl8 updateFeed
//             // feedRtDatabaseReference
//             //     .child(widget.profileOwner)
//             //     .child("feedItems")
//             //     .remove();
//           },
//           child: Container(
//             height: 40,
//             width: 40,
//             child: RiveAnimation.asset(
//               'images/profile/crush-glow.riv',
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.only(right: 20),
//         child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 isCrushOn = true;
//                 getCrushOfCount();
//               });
// // make Auth User follower of Another User (Update Their Follower Collection)
//               crushOfRTD
//                   .child(widget.profileOwner)
//                   .child("crushOfReference")
//                   .child(widget.currentUserId)
//                   .set({
//                 "timestamp": DateTime.now().millisecondsSinceEpoch,
//                 'crushOfId': widget.currentUserId
//               });
// // update our Profile by adding following collection
//
//               crushOnRTD
//                   .child(widget.currentUserId)
//                   .child("crushOnReference")
//                   .child(widget.profileOwner)
//                   .set({
//                 "timestamp": DateTime.now().millisecondsSinceEpoch,
//                 'crushOnId': widget.profileOwner
//               });
//
// // updateFeed
//               feedRtDatabaseReference
//                   .child(widget.profileOwner)
//                   .child("feedItems")
//                   .push()
//                   .set({
//                 "type": "crushOnReference",
//                 "firstName": Constants.myName,
//                 "secondName": Constants.mySecondName,
//                 "comment": "",
//                 "timestamp": DateTime.now().millisecondsSinceEpoch,
//                 "url": Constants.myPhotoUrl,
//                 "postId": "",
//                 "ownerId": widget.currentUserId,
//                 "photourl": "",
//               });
//             },
//             child: Icon(Icons.favorite_border_outlined,
//                 size: 30, color: Colors.pink)),
//       );
//     }
//   }
//
//   currentMood() {
//     return Container(
//       child: Text(
//         "Mood Will Be Here",
//         style: TextStyle(
//           color: Constants.mainPrimaryColor,
//           fontFamily: "Cute",
//           fontSize: 8,
//         ),
//       ),
//     );
//   }
//
//   otherInfo() {
//     return Column(
//       children: [
//         Container(
//           height: 40,
//           color: Colors.grey.withOpacity(0.03),
//           padding: EdgeInsets.only(left: 23, right: 26),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Landing Day On Earth",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontFamily: 'cute',
//                 ),
//               ),
//               Text(
//                 Constants.dob,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontFamily: 'cute',
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           height: 40,
//           color: Colors.grey.withOpacity(0.03),
//           padding: EdgeInsets.only(left: 23, right: 25),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Gender",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontFamily: 'cute',
//                 ),
//               ),
//               Text(
//                 widget.mainGender,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontFamily: 'cute',
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           height: 40,
//           color: Colors.grey.withOpacity(0.03),
//           padding: EdgeInsets.only(left: 23, right: 25),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Country",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontFamily: 'cute',
//                 ),
//               ),
//               Text(
//                 Constants.country,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontFamily: 'cute',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   _crushButtonControllerForVisitor() {
//     return Container(
//       height: 40,
//       color: Colors.blue.withOpacity(0.03),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: isCrushOn
//                 ? Text(
//                     widget.mainGender == "Male"
//                         ? "Crush on Him"
//                         : "Crush on Her",
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontFamily: 'cute',
//                       fontSize: 14,
//                        fontWeight: FontWeight.bold,
//                     ),
//                   )
//                 : Text(
//                     widget.mainGender == "Male"
//                         ? "Tap Heart if Crush on Him"
//                         : "Tap Heart if Crush on Her",
//                     style: TextStyle(
//                       fontFamily: 'cute',
//                       color: Colors.blue,
//                       fontSize: 14,
//                        fontWeight: FontWeight.bold,
//                     ),
//                   ),
//           ),
//           _crushButtonForVisitor(),
//         ],
//       ),
//     );
//   }
//
//   Map friendsData;
//   bool isFriendsData = false;
//   List friendList = [];
//
//   getBestFriends() {
//     bestFriendsRtd
//         .child(widget.profileOwner)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           friendsData = dataSnapshot.value;
//         });
//         friendsData
//             .forEach((index, data) => friendList.add({"key": index, ...data}));
//       } else {
//         setState(() {
//           isFriendsData = true;
//         });
//       }
//     });
//   }
//
//   _bestiesList() {
//     return Padding(
//       padding: isFriendsData == true
//           ? EdgeInsets.only(bottom: 10, left: 1, top: 20)
//           : EdgeInsets.only(bottom: 10, left: 1, top: 0),
//       child: Container(
//         color: friendsData == null
//             ? Colors.grey.shade100.withOpacity(0.45)
//             : Colors.transparent,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 23, right: 0),
//           child: SizedBox(
//             height: friendsData == null
//                 ? widget.currentUserId != widget.profileOwner
//                     ? 0
//                     : 40
//                 : 100,
//             child: friendsData == null
//                 ? widget.currentUserId != widget.profileOwner
//                     ? Container()
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Bestie",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontFamily: 'cute',
//                                 fontSize: 15),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => Provider<User>.value(
//                                     value: widget.user,
//                                     child: MainSearchPage(
//                                       user: widget.user,
//                                       userId: Constants.myId,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Search",
//                               style: TextStyle(
//                                   color: Colors.grey,
//                                   fontFamily: 'cute',
//                                   fontSize: 15),
//                             ),
//                           )
//                         ],
//                       )
//                 : Row(
//                     children: [
//                       Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15),
//                             child: Container(
//                               height: 50,
//                               width: 50,
//                               child: Image.asset(
//                                   'images/profile/bestie-image.png'),
//                             ),
//                           ),
//                           Text(
//                             "Besties",
//                             style: TextStyle(
//                                 fontFamily: 'cute',
//                                 fontSize: 12,
//                                 color: Colors.blue),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Container(
//                         height: 100,
//                         width: MediaQuery.of(context).size.width / 1.5,
//                         child: ListView.builder(
//                             shrinkWrap: true,
//                             scrollDirection: Axis.horizontal,
//                             itemCount: friendList.length,
//                             itemBuilder: (context, index) => Padding(
//                                   padding:
//                                       const EdgeInsets.only(top: 15, left: 10),
//                                   child: BestFriendList(
//                                     index: index,
//                                     bestFriendList: friendList,
//                                   ),
//                                 )),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _addBestieButton() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Container(
//         height: 40,
//         color: Colors.blue.shade100.withOpacity(0.1),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 23, right: 23),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Bestie",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontFamily: 'cute',
//                 ),
//               ),
//               AddFriendListButton(
//                 profileOwner: widget.profileOwner,
//                 currentUserId: widget.currentUserId,
//                 mainFirstName: widget.mainFirstName,
//                 mainProfileUrl: widget.mainProfileUrl,
//                 gender: widget.mainGender,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _editProfile() {
//     return widget.currentUserId == widget.profileOwner
//         ? Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EditMyProfile(
//                           uid: widget.profileOwner,
//                           profileImage: widget.mainProfileUrl,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     "Edit Profile",
//                     style: TextStyle(color: Colors.black, fontFamily: 'cute'),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Block Profile",
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontFamily: 'cute',
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Icon(
//                     Icons.block_sharp,
//                     size: 20,
//                     color: Colors.red,
//                   ),
//                 )
//               ],
//             ),
//           );
//   }
//
//   _aboutAndMinor() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8, left: 23, right: 25),
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 11),
//                 child: Icon(
//                   Icons.edit_outlined,
//                   size: 17,
//                 ),
//               ),
//               Flexible(
//                 child: Text(
//                   widget.mainAbout,
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontFamily: 'cutes',
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8, left: 23),
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 11),
//                 child: Icon(
//                   Icons.link,
//                   size: 17,
//                 ),
//               ),
//               Text(
//                 "www.switch.com",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontFamily: 'cutes',
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8, left: 23),
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 11),
//                 child: Icon(
//                   Icons.perm_identity,
//                   size: 17,
//                 ),
//               ),
//               Text(
//                 widget.profileOwner,
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontFamily: 'cutes',
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       color: Colors.white,
//       child: widget.currentUserId == widget.profileOwner
//           ? DelayedDisplay(
//               delay: Duration(milliseconds: 222),
//               slidingBeginOffset: Offset(0, -0.35),
//               child: Container(
//                 child: ListView.builder(
//                   itemCount: 1,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       children: [
//                         appBar(),
//                         _crushOfAndFollowersButton(),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         _aboutAndMinor(),
//                         SizedBox(
//                           height: 40,
//                         ),
//                         _relationshipStatusForOwnProfile(index),
//                         otherInfo(),
//                         _editProfile(),
//                       ],
//                     );
//                   },
//                   shrinkWrap: true,
//                 ),
//               ),
//             )
//           : DelayedDisplay(
//               fadeIn: true,
//               slidingCurve: Curves.easeInOutSine,
//               delay: Duration(milliseconds: 222),
//               slidingBeginOffset: Offset(0, -0.35),
//               child: Container(
//                 color: Colors.white,
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: [
//                     appBar(),
//                     _followersCountAndCrushCountButtonForVisitor(),
//                     // _bestiesList(),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     _aboutAndMinor(),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     _addBestieButton(),
//                     _crushButtonControllerForVisitor(),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     relationShipRequestSendButton(),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     _relationShipStatusForVisitor(),
//                     ProfileDecency(
//                       mainId: widget.currentUserId,
//                       profileId: widget.profileOwner,
//                       onPressedButton2: getDecencyReport,
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     otherInfo(),
//                     _editProfile(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
//
//   double userPercentageDecency = 0;
//
//   double userDecency = 0;
//   int counterForTwo = 0;
//   int counterForOne = 0;
//   int counterForThree = 0;
//   int counterForFour = 0;
//   int counterForFive = 0;
//   bool isOne = false;
//   bool isTwo = false;
//   bool isThree = false;
//   bool isFour = false;
//   bool isFive = false;
//
//   getDecencyReport() {
//     Map data;
//
//     userProfileDecencyReport
//         .child(widget.profileOwner)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           data = dataSnapshot.value;
//         });
//
//         setState(() {
//           counterForFour = data['numberOfFour'];
//           counterForFive = data['numberOfFive'];
//           counterForThree = data['numberOfThree'];
//           counterForTwo = data['numberOfTwo'];
//           counterForOne = data['numberOfOne'];
//         });
//
//         userDecency = ((5 * counterForFive +
//                 4 * counterForFour +
//                 3 * counterForThree +
//                 2 * counterForTwo +
//                 1 * counterForOne) /
//             (counterForTwo +
//                 counterForOne +
//                 counterForThree +
//                 counterForFour +
//                 counterForFive));
//
//         userPercentageDecency = (userDecency / 5) * 100;
//         print("decency >>> $userPercentageDecency");
//       }
//     });
//   }
// }
//
// class ProfileDecency extends StatefulWidget {
//   final VoidCallback onPressedButton2;
//
//   final String mainId;
//   final String profileId;
//
//   const ProfileDecency(
//       {Key key, this.mainId, this.profileId, this.onPressedButton2})
//       : super(key: key);
//
//   @override
//   _ProfileDecencyState createState() => _ProfileDecencyState();
// }
//
// class _ProfileDecencyState extends State<ProfileDecency> {
//   ///5 star - 252
//   /// 4 star - 124
//   /// 3 star - 40
//   /// 2 star - 29
//   /// 1 star - 33
//   /// (5*252 + 4*124 + 3*40 + 2*29 + 1*33) / (252+124+40+29+33) = 4.11 and change
//
//   double userPercentageDecency = 0;
//   double userDecency = 0;
//   int counterForTwo = 0;
//   int counterForOne = 0;
//   int counterForThree = 0;
//   int counterForFour = 0;
//   int counterForFive = 0;
//   bool isOne = false;
//   bool isTwo = false;
//   bool isThree = false;
//   bool isFour = false;
//   bool isFive = false;
//   Color indicatorColor = Colors.blue;
//
//   getDecencyReport() async {
//     if (widget.mainId != widget.profileId) {
//       Map data;
//
//       userProfileDecencyReport
//           .child(widget.profileId)
//           .once()
//           .then((DataSnapshot dataSnapshot) {
//         if (dataSnapshot.value != null) {
//           setState(() {
//             data = dataSnapshot.value;
//           });
//           print(
//               "dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${data["numberOfFour"]}");
//
//           setState(() {
//             counterForFour = data['numberOfFour'];
//             counterForFive = data['numberOfFive'];
//             counterForThree = data['numberOfThree'];
//             counterForTwo = data['numberOfTwo'];
//             counterForOne = data['numberOfOne'];
//           });
//
//           userDecency = ((5 * counterForFive +
//                   4 * counterForFour +
//                   3 * counterForThree +
//                   2 * counterForTwo +
//                   1 * counterForOne) /
//               (counterForTwo +
//                   counterForOne +
//                   counterForThree +
//                   counterForFour +
//                   counterForFive));
//
//           userPercentageDecency = (userDecency / 5) * 100;
//         }
//
//         widget.onPressedButton2();
//       });
//     } else {}
//
//     // getColorsIndicator();
//   }
//
//   checkIfDecencyExist() async {
//     Map data;
//
//     userProfileDecencyReport
//         .child(widget.mainId)
//         .child("DecencyReport")
//         .child(widget.profileId)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value == null) {
//         userProfileDecencyReport
//             .child(widget.mainId)
//             .child("DecencyReport")
//             .child(widget.profileId)
//             .set({
//           "numberOfOne": false,
//           "numberOfTwo": false,
//           "numberOfThree": false,
//           "numberOfFour": false,
//           "numberOfFive": false,
//         });
//       } else {
//         setState(() {
//           data = dataSnapshot.value;
//         });
//         if (data['numberOfOne'] == true) {
//           print("isOne: $isOne");
//
//           setState(() {
//             isOne = true;
//             isTwo = false;
//             isFour = false;
//             isThree = false;
//             isFive = false;
//           });
//         } else if (data['numberOfTwo'] == true) {
//           setState(() {
//             isTwo = true;
//             isOne = false;
//             isThree = false;
//             isFour = false;
//             isFive = false;
//
//             print("isOne: $isTwo");
//           });
//         } else if (data['numberOfThree'] == true) {
//           setState(() {
//             isTwo = false;
//             isOne = false;
//             isThree = true;
//             isFour = false;
//             isFive = false;
//             print("isOne: $isThree");
//           });
//         } else if (data['numberOfFour'] == true) {
//           setState(() {
//             isFour = true;
//
//             isTwo = false;
//             isOne = false;
//             isThree = false;
//             isFive = false;
//             print("isOne: $isFour");
//           });
//         } else if (data['numberOfFive'] == true) {
//           setState(() {
//             isFive = true;
//             isTwo = false;
//             isOne = false;
//             isThree = false;
//             isFour = false;
//             print("isOne: $isFive");
//           });
//         }
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkIfDecencyExist();
//     getDecencyReport();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Column(
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           widget.profileId != widget.mainId
//               ? Container(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width,
//                   color: Colors.blue.withOpacity(0.05),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18, right: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           child: Text(
//                             "Your Rating: ",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontFamily: 'cute',
//                                 fontSize: 15,
//                                  fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         widget.profileId == widget.mainId
//                             ? Container()
//                             : SingleChildScrollView(
//                                 child: Row(
//                                   // shrinkWrap: true,
//                                   // scrollDirection: Axis.horizontal,
//                                   children: [
//                                     ButtonForOne(
//                                       isFour: isFour,
//                                       isOne: isOne,
//                                       isTwo: isTwo,
//                                       isThree: isThree,
//                                       isFive: isFive,
//                                       profileId: widget.profileId,
//                                       counterForOne: counterForOne,
//                                       counterForFive: counterForFive,
//                                       counterForFour: counterForFour,
//                                       counterForThree: counterForThree,
//                                       counterForTwo: counterForTwo,
//                                       onPressedButton: getDecencyReport,
//                                       checkIfDecencyExist: checkIfDecencyExist,
//                                       mainId: widget.mainId,
//                                     ),
//                                     ButtonForTwo(
//                                       isFour: isFour,
//                                       isOne: isOne,
//                                       isTwo: isTwo,
//                                       isThree: isThree,
//                                       isFive: isFive,
//                                       profileId: widget.profileId,
//                                       counterForOne: counterForOne,
//                                       counterForFive: counterForFive,
//                                       counterForFour: counterForFour,
//                                       counterForThree: counterForThree,
//                                       counterForTwo: counterForTwo,
//                                       onPressedButton: getDecencyReport,
//                                       checkIfDecencyExist: checkIfDecencyExist,
//                                       mainId: widget.mainId,
//                                     ),
//                                     ButtonForThree(
//                                       isFour: isFour,
//                                       isOne: isOne,
//                                       isTwo: isTwo,
//                                       isThree: isThree,
//                                       isFive: isFive,
//                                       profileId: widget.profileId,
//                                       counterForOne: counterForOne,
//                                       counterForFive: counterForFive,
//                                       counterForFour: counterForFour,
//                                       counterForThree: counterForThree,
//                                       counterForTwo: counterForTwo,
//                                       onPressedButton: getDecencyReport,
//                                       checkIfDecencyExist: checkIfDecencyExist,
//                                       mainId: widget.mainId,
//                                     ),
//                                     ButtonForFour(
//                                       isFour: isFour,
//                                       isOne: isOne,
//                                       isTwo: isTwo,
//                                       isThree: isThree,
//                                       isFive: isFive,
//                                       profileId: widget.profileId,
//                                       counterForOne: counterForOne,
//                                       counterForFive: counterForFive,
//                                       counterForFour: counterForFour,
//                                       counterForThree: counterForThree,
//                                       counterForTwo: counterForTwo,
//                                       onPressedButton: getDecencyReport,
//                                       checkIfDecencyExist: checkIfDecencyExist,
//                                       mainId: widget.mainId,
//                                     ),
//                                     ButtonForFive(
//                                       isFour: isFour,
//                                       isOne: isOne,
//                                       isTwo: isTwo,
//                                       isThree: isThree,
//                                       isFive: isFive,
//                                       profileId: widget.profileId,
//                                       counterForOne: counterForOne,
//                                       counterForFive: counterForFive,
//                                       counterForFour: counterForFour,
//                                       counterForThree: counterForThree,
//                                       counterForTwo: counterForTwo,
//                                       onPressedButton: getDecencyReport,
//                                       checkIfDecencyExist: checkIfDecencyExist,
//                                       mainId: widget.mainId,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 )
//               : SizedBox(),
//         ],
//       ),
//     );
//   }
// }
///
///
///

import 'package:countup/countup.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/MainPages/Profile/Panel/followingPage.dart';
import 'package:switchapp/MainPages/Profile/Panel/panel.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/MainPages/Profile/RecentPosts.dart';
import 'package:switchapp/MainPages/Profile/body/profieDecency/Buttons/CrushPage.dart';
import 'package:switchapp/MainPages/Profile/body/profieDecency/followerPage.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/reportId.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChat.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/UniversalMethods.dart';
import 'package:uuid/uuid.dart';
import '../Panel/CrushOn.dart';
import '../memeProfile/Meme-profile.dart';
import '../profilePosts.dart';
import 'Edit-Profile/EditProfile.dart';
import 'package:switchapp/MainPages/Profile/body/closFriendList/addFriendListButton.dart';
import 'package:switchapp/MainPages/Profile/body/profieDecency/Buttons/ButtonForFive.dart';
import 'package:switchapp/MainPages/Profile/body/profieDecency/Buttons/ButtonForFour.dart';
import 'package:switchapp/MainPages/Profile/body/profieDecency/Buttons/ButtonForOne.dart';
import 'package:switchapp/MainPages/Profile/body/profieDecency/Buttons/ButtonForThree.dart';
import 'package:switchapp/MainPages/Profile/body/profieDecency/Buttons/ButtonForTwo.dart';
import 'package:switchapp/MainPages/SearchPages/MainSearchPage.dart';
import 'closFriendList/bestFriendList.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class Body extends StatefulWidget {
  final String profileOwner;
  final String currentUserId;
  final String mainProfileUrl;
  final String mainSecondName;
  final String mainFirstName;
  final String mainGender;
  final String mainEmail;
  final String mainAbout;
  final User user;
  final String username;
  final String isVerified;
  final String country;
  final String dob;

  const Body({
    required this.profileOwner,
    required this.currentUserId,
    required this.mainProfileUrl,
    required this.mainFirstName,
    required this.mainSecondName,
    required this.mainGender,
    required this.mainEmail,
    required this.mainAbout,
    required this.user,
    required this.username,
    required this.isVerified,
    required this.country,
    required this.dob,
  });

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool youBlockedThisPerson = true;
  late String crushOfCount = "";
  late int crushOnCount = 0;
  bool isCrushOn = false;
  bool isFollowingYou = false;
  late String inRealtionshipWithFirstName;
  late String inRealtionshipWithSecondName;

  bool inRelationShipForOwnProfile = false;
  late String inRelationShipWithFirstNameToShow = "";
  late String inRelationShipWithSecondNameToShow = "";
  late String relationShipRequestSenderId = "";
  late String profileOwnerCurrentMood = "";
  late String relationShipRequestSendToId = "";
  late String inRelationshipWithId = "";
  late String inRelationShipWitId;

  bool visitorIsAlreadyInRelationShip = false;
  bool visitorIsAlreadyInRelationShipPending = false;

  bool inRelationShip = false;
  bool pendingRelationShip = false;

  bool youHaveToAccept = false;
  bool isFollowedByYou = false;
  late Map followersCountMap2;
  bool isBlock = false;
  bool loading = false;
  late int followingsCounter;

  UniversalMethods universalMethods = UniversalMethods();

  @override
  void initState() {
    super.initState();
    getCrushOfCount();
    getCrushOnCount();
    checkIfIsCrushOn();
    _followingOrNotForVisitor();
    getRelationShipStatus();
    getRelationShipAcceptance();
    getRelationShipStatusForOwnProfile();
    getDecencyReport();
    getBestFriends();
    checkIfFollowedByYou();
    checkIfBlockByYou();
    print("url>>>>>>>>>>> ${widget.mainProfileUrl}");
    Future.delayed(const Duration(milliseconds: 300), () {
      followingCounter();
    });
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

  checkIfBlockByYou() {
    blockListRTD
        .child(widget.currentUserId)
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          isBlock = true;
        });
        print("this person is block by you");
      } else {}
    });
  }

  followingCounter() {
    late Map data;
    userFollowersRtd
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });

        setState(() {
          followingsCounter = data.length;
        });

        userFollowersCountRtd.child(widget.profileOwner).update({
          "followerCounter": data.length,
          "uid": widget.profileOwner,
          "username": widget.username,
          "photoUrl": widget.mainProfileUrl,
        });
        if (data.length == 100) {
          feedRtDatabaseReference
              .child(widget.profileOwner)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "planetLevel",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "postId": postId,
            "ownerId": widget.currentUserId,
            "photourl": "",
            "isRead": false,
          });
        } else if (data.length == 1000) {
          feedRtDatabaseReference
              .child(widget.profileOwner)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "solarLevel",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "postId": postId,
            "ownerId": widget.currentUserId,
            "photourl": "",
            "isRead": false,
          });
        } else if (data.length == 10000) {
          feedRtDatabaseReference
              .child(widget.profileOwner)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "galaxyLevel",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "postId": postId,
            "ownerId": widget.currentUserId,
            "photourl": "",
            "isRead": false,
          });
        }
        print("yesssssssssssssssssssssss");
      } else {
        print("nooooooooooooooooooooooooooo");
        userFollowersCountRtd.child(widget.profileOwner).update({
          "followerCounter": 0,
          "uid": widget.profileOwner,
          "username": widget.username,
          "photoUrl": widget.mainProfileUrl,
        });
      }
    });
  }

  ///*** This Is Relation Ship Function ***\\\
  checkIfFollowedByYou() async {
    userFollowersRtd
        .child(widget.profileOwner)
        .child(widget.currentUserId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        isFollowedByYou = true;
      } else {
        isFollowedByYou = false;
      }
    });
  }

  getRelationShipStatus() async {
    late Map data;
    late Map data2;

    relationShipReferenceRtd
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });

        data.length;
      }
    });

    ///to checkIf Visitor is Already in relation
    // DocumentSnapshot snapshot2 =
    // await relationShipReference.doc(widget.currentUserId).get();

    relationShipReferenceRtd
        .child(widget.currentUserId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data2 = dataSnapshot.value;
        });
        print("dsadadssssssssssssssssssssssssssad " +
            data2['inRelationShip'].toString());

        data2.length;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      print("dsadadssssssssssssssssssssssssssad " +
          data2['inRelationShip'].toString());

      if (data2['inRelationShip'] == true) {
        visitorIsAlreadyInRelationShip = true;

        print("visiter is already in relation");
      } else if (data2['inRelationShip'] == false) {
        visitorIsAlreadyInRelationShip = false;
        print("visiter is not already in relation");
      }

      if (data2['pendingRelationShip'] == true) {
        visitorIsAlreadyInRelationShipPending = true;
      }

      /// Check about profile owner relationship status
      if (widget.currentUserId != widget.profileOwner) {
        setState(() {
          relationShipRequestSenderId = data['relationShipRequestSenderId'];
        });
        print("relationShipRequestSenderId = > $relationShipRequestSenderId");
        print("current Id = > ${widget.currentUserId}");
        if (data.isNotEmpty && !data['inRelationShip']) {
          if (data['pendingRelationShip']) {
            setState(() {
              pendingRelationShip = true;
            });
          }
        } else if (data['inRelationShip']) {
          print(" u r in relation ship");
          inRelationShipWithFirstNameToShow =
              data['inRelationshipWithFirstName'];
          inRelationShipWithSecondNameToShow =
              data['inRelationshipWithSecondName'];

          inRelationshipWithId = data['inRelationshipWithId'];

          print(
              "inRelationShipWithFirstNameToShow = >>>>>> $inRelationShipWithFirstNameToShow");

          setState(() {
            inRelationShip = true;
          });
        } else {
          setState(() {
            pendingRelationShip = false;
          });
        }
      } else {
        print("u r in ur Profile");
      }
    });
  }

  ///************\\\

  ///init method for Own Id
  getRelationShipAcceptance() async {
    print("getRelationShipAcceptance run");

    late Map data;
    // DocumentSnapshot snapshot =
    // await relationShipReference.doc(widget.profileOwner).get();

    relationShipReferenceRtd
        .child(widget.currentUserId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });

        data.length;
        // print("dsadadssssssssssssssssssssssssssad "  + data['inRelationShip'].toString());

      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (widget.profileOwner == widget.currentUserId) {
        print("widget.profileOwner == widget.currentUserId");
        if (data.isNotEmpty) {
          print("snapshot.exists run");
          if (!data['inRelationShip'] &&
              data['pendingRelationShip'] &&
              data['relationShipRequestSenderName'] != Constants.myName) {
            print("pending & accepter");
            setState(() {
              inRealtionshipWithFirstName =
                  data['relationShipRequestSenderFirstName'];
              inRealtionshipWithSecondName =
                  data['relationShipRequestSenderSecondName'];

              relationShipRequestSenderId = data['relationShipRequestSenderId'];
              pendingRelationShip = true;
              youHaveToAccept = true;
            });
          } else if (data.isNotEmpty &&
              !data['inRelationShip'] &&
              data['pendingRelationShip'] &&
              data['relationShipRequestSenderName'] == Constants.myName) {
            relationShipRequestSendToId = data['relationShipRequestSendToId'];
            print("in pending");
            setState(() {
              youHaveToAccept = false;
              pendingRelationShip = true;
            });
          } else if (data['inRelationShip']) {
            inRelationShipWithFirstNameToShow =
                data['inRelationshipWithFirstName'];
            inRelationShipWithSecondNameToShow =
                data['inRelationshipWithSecondName'];
            inRelationshipWithId = data['inRelationshipWithId'];

            print("in relationShip");
            pendingRelationShip = false;
            inRelationShip = true;
          } else {
            print("nothing Run");
          }
        }
      } else {
        print("You r on other Profile");
      }
    });
  }

  getRelationShipStatusForOwnProfile() async {
    late Map data;

    relationShipReferenceRtd
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });

        data.length;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (data.isNotEmpty) {
        if (data['inRelationShip']) {
          setState(() {
            inRelationShipForOwnProfile = true;
            inRelationShipWithSecondNameToShow =
                data['inRelationshipWithSecondName'];
            inRelationShipWithFirstNameToShow =
                data['inRelationshipWithFirstName'];
          });
        }
      }
    });
  }

  String postId = Uuid().v4();

  _acceptProposal() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: false,
        isDismissible: false,
        barrierColor: Colors.pink.withOpacity(0.2),
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
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Are You Sure?",
                      style: TextStyle(
                           fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "cute",
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.lightBlue,
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          child: Text("Confirm"),
                          onPressed: () {
                            setState(() {
                              pendingRelationShip = false;
                              inRelationShip = true;
                              print(
                                  "relationShipRequestSenderId => ${relationShipRequestSenderId.toString()}");
                            });

                            relationShipReferenceRtd
                                .child(widget.profileOwner)
                                .update({
                              "inRelationshipWithId":
                                  relationShipRequestSenderId,
                              "inRelationshipWithSecondName":
                                  inRealtionshipWithSecondName,
                              "inRelationshipWithFirstName":
                                  inRealtionshipWithFirstName,
                              "inRelationShip": true,
                              "pendingRelationShip": false,
                            });
                            relationShipReferenceRtd
                                .child(relationShipRequestSenderId)
                                .update({
                              "inRelationshipWithId": widget.profileOwner,
                              "inRelationshipWithSecondName":
                                  widget.mainSecondName,
                              "inRelationshipWithFirstName":
                                  widget.mainFirstName,
                              "inRelationShip": true,
                              "pendingRelationShip": false,
                              "inRelationshipWith": Constants.myName,
                            });
                            feedRtDatabaseReference
                                .child(relationShipRequestSenderId)
                                .child("feedItems")
                                .child(postId)
                                .set({
                              "inRelationshipWithId": "",
                              "inRelationshipWithSecondName": "",
                              "inRelationshipWithFirstName": "",
                              "type": "ConformedAboutRelationShip",
                              "firstName": Constants.myName,
                              "secondName": Constants.mySecondName,
                              "comment": "",
                              "timestamp":
                                  DateTime.now().millisecondsSinceEpoch,
                              "url": Constants.myPhotoUrl,
                              "postId": postId,
                              "ownerId": widget.currentUserId,
                              "photourl": "",
                              "isRead": false,
                            });

                            chatMoodReferenceRtd.child(Constants.myId).set({
                              "mood": "romantic",
                              "theme": "romantic",
                              "loveNote":
                                  "Write Something For Love Of Your Life",
                            });
                            chatMoodReferenceRtd
                                .child(relationShipRequestSenderId)
                                .set({
                              "mood": "romantic",
                              "theme": "romantic",
                              "loveNote":
                                  "Write Something For Love Of Your Life",
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
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              "Done! Now Moving To Home Page",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "cutes",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Please wait..",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "cutes",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });

                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ElevatedButton(
                          child: Text('Back'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.redAccent,
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
                    child: Center(
                      child: Text(
                        "After Confirmation, this person will be add to your Love Chat, Moreover, From now that is your Responsibility to be loyal with him/her. Nature Give us short life and you knew that, true love is Rare :(:",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  toAcceptRelationShip() {
    if (!inRelationShip && pendingRelationShip && youHaveToAccept) {
      return Container(
        width: 400,
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You have Relationship Request",
                style: TextStyle(
                    color: Colors.grey, fontSize: 12, fontFamily: 'cute'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      // color: Colors.grey.withOpacity(0.1),
                      child: Text(
                        "Accept Proposal",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      onPressed: () {
                        _acceptProposal();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          // color: Colors.grey.withOpacity(0.1),
                          child: Text(
                            "Not Interested",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pendingRelationShip = false;
                              inRelationShip = false;
                              print(
                                  "relationShipRequestSenderId => ${relationShipRequestSenderId.toString()}");
                            });

                            relationShipReferenceRtd
                                .child(widget.profileOwner)
                                .update({
                              "inRelationShip": false,
                              "pendingRelationShip": false,
                              "relationShipRequestSenderName": "",
                              "relationShipRequestSenderId": "",
                              "relationShipRequestSendToName": "",
                              "relationShipRequestSendToId": "",
                            });
                            relationShipReferenceRtd
                                .child(relationShipRequestSenderId)
                                .update({
                              "inRelationShip": false,
                              "pendingRelationShip": false,
                              "relationShipRequestSenderName": "",
                              "relationShipRequestSenderId": "",
                              "relationShipRequestSendToName": "",
                              "relationShipRequestSendToId": "",
                            });
                            feedRtDatabaseReference
                                .child(relationShipRequestSenderId)
                                .child("feedItems")
                                .child(postId)
                                .set({
                              "type": "notInterested",
                              "firstName": Constants.myName,
                              "secondName": Constants.mySecondName,
                              "comment": "",
                              "timestamp":
                                  DateTime.now().millisecondsSinceEpoch,
                              "url": Constants.myPhotoUrl,
                              "postId": postId,
                              "ownerId": widget.currentUserId,
                              "photourl": "",
                              "isRead": false,
                            });
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else if (pendingRelationShip) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
            color: Colors.blue.withOpacity(0.09),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                      child: Text(
                        "Proposal is pending",
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 12,
                             fontWeight: FontWeight.bold,
                            fontFamily: 'cute'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        height: 24,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              elevation: 0.0,
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                pendingRelationShip = false;
                                inRelationShip = false;
                                print(
                                    "relationShipRequestSenderId => ${relationShipRequestSenderId.toString()}");
                              });

                              relationShipReferenceRtd
                                  .child(widget.profileOwner)
                                  .update({
                                "inRelationShip": false,
                                "pendingRelationShip": false,
                                "relationShipRequestSenderName": "",
                                "relationShipRequestSenderId": "",
                                "relationShipRequestSendToName": "",
                                "relationShipRequestSendToId": "",
                              });
                              relationShipReferenceRtd
                                  .child(relationShipRequestSendToId)
                                  .update({
                                "inRelationShip": false,
                                "pendingRelationShip": false,
                                "relationShipRequestSenderName": "",
                                "relationShipRequestSenderId": "",
                                "relationShipRequestSendToName": "",
                                "relationShipRequestSendToId": "",
                              });
                              feedRtDatabaseReference
                                  .child(relationShipRequestSendToId)
                                  .child("feedItems")
                                  .child(postId)
                                  .set({
                                "type": "cancelRequest",
                                "firstName": Constants.myName,
                                "secondName": Constants.mySecondName,
                                "comment": "",
                                "timestamp":
                                    DateTime.now().millisecondsSinceEpoch,
                                "url": Constants.myPhotoUrl,
                                "postId": postId,
                                "ownerId": widget.currentUserId,
                                "photourl": "",
                                "isRead": false,
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      );
    } else {
      return Container(
        height: 0,
        child: Text(
          "",
        ),
      );
    }
  }

  getCrushOfCount() async {
    print("getCrushCount run");

    crushOfRTD
        .child(widget.profileOwner)
        .child("crushOfReference")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;

        data.length;

        String crush = universalMethods.shortNumberGenrator(data.length);

        setState(() {
          crushOfCount = crush;
        });
      } else {
        crushOfCount = "0";
      }
    });
  }

  checkIfIsCrushOn() async {
    print("checkIfIsCrushOn run");

    crushOnRTD
        .child(widget.currentUserId)
        .child("crushOnReference")
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;

        data.length;

        setState(() {
          isCrushOn = true;
        });
      }
    });
  }

  getCrushOnCount() async {
    print("getCrushCount run");

    crushOnRTD
        .child(widget.profileOwner)
        .child("crushOnReference")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;

        data.length;
        setState(() {
          crushOnCount = data.length;
        });
        print("crushOfRef = = = = ${data.length}");
      }
    });
  }

  _followingOrNotForVisitor() {
    return isFollowingYou
        ? Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("${widget.mainFirstName} He is Following you :)",
                style: TextStyle(
                    fontFamily: "Names", color: Colors.blue, fontSize: 10),
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "${widget.mainFirstName} is not following you :(",
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: "Names", color: Colors.black, fontSize: 10),
            ),
          );
  }

  _blockFunction() {
    if (!isBlock) {
      blockListRTD.child(widget.currentUserId).child(widget.profileOwner).set({
        "username": widget.username,
      });

      setState(() {
        isFollowedByYou = false;
      });
      userFollowingRtd
          .child(widget.currentUserId)
          .child(widget.profileOwner)
          .remove();
      userFollowersRtd
          .child(widget.profileOwner)
          .child(widget.currentUserId)
          .remove();
      userFollowersRtd
          .child(widget.currentUserId)
          .child(widget.profileOwner)
          .remove();
      userFollowingRtd
          .child(widget.profileOwner)
          .child(widget.currentUserId)
          .remove();
      bestFriendsRtd
          .child(widget.profileOwner)
          .child(widget.currentUserId)
          .remove();
      chatListRtDatabaseReference
          .child(Constants.myId)
          .child(widget.profileOwner)
          .update({"blockBy": Constants.myId});
      chatListRtDatabaseReference
          .child(widget.profileOwner)
          .child(Constants.myId)
          .update({"blockBy": Constants.myId});
      followingCounter();
    } else {
      blockListRTD
          .child(widget.currentUserId)
          .child(widget.profileOwner)
          .remove();

      chatListRtDatabaseReference
          .child(Constants.myId)
          .child(widget.profileOwner)
          .update({"blockBy": null});
      chatListRtDatabaseReference
          .child(widget.profileOwner)
          .child(Constants.myId)
          .update({"blockBy": null});
    }

    if (isBlock) {
      setState(() {
        isBlock = false;
      });
    } else {
      setState(() {
        isBlock = true;
      });
    }

    Fluttertoast.showToast(
      msg: "Done!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.white,
      textColor: Colors.blue,
      fontSize: 16.0,
    );

    Navigator.pop(context);
    Navigator.pop(context);
  }

  editMyProfile() {
    return widget.profileOwner == Constants.myId
        ? Padding(
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: TextButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditMyProfile(
                      uid: widget.profileOwner,
                      profileImage: widget.mainProfileUrl,
                    ),
                  ),
                ),
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.blue.shade700, width: 1.5),
                ),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontFamily: 'cutes',
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: 0,
            width: 0,
          );
  }

  _blockOption() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.6,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Profile Picture",
                      style: TextStyle(
                           fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "cute",
                          color: Colors.blue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        image: DecorationImage(
                            image: NetworkImage(widget.mainProfileUrl),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  widget.currentUserId == widget.profileOwner
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      barrierColor: Colors.red.withOpacity(0.2),
                                      elevation: 0,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons
                                                          .linear_scale_sharp),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Text(
                                                    "Are you sure?",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "cutes",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  "cutes",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        onTap: () {
                                                          _blockFunction();
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  "cutes",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.blue
                                                                  .shade700),
                                                        ),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        isBlock ? "Unblock" : "Block",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "cutes",
                                            fontWeight: FontWeight.bold,
                                            color: isBlock
                                                ? Colors.green.shade700
                                                : Colors.red),
                                      ),
                                      Icon(
                                        isBlock
                                            ? Icons.bubble_chart_outlined
                                            : Icons.block,
                                        color:
                                            isBlock ? Colors.green : Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReportId(
                                                  profileId:
                                                      widget.profileOwner,
                                                )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Report",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'cutes',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              Icons
                                                  .admin_panel_settings_outlined,
                                              color: Colors.red,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  editMyProfile(),
                ],
              ),
            ),
          );
        });
  }

  appBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 3, right: 0),
                  child: Row(
                    children: [
                      Center(
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 16,
                          color: Colors.lightBlue,
                        ),
                      ),
                      Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 10, left: 5, right: 11),
                          child: Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: Colors.lightBlue, width: 1),
                              image: DecorationImage(
                                image: NetworkImage(widget.mainProfileUrl),
                              ),
                            ),
                          ),
                        ),
                        widget.isVerified == "true"
                            ? Positioned(
                                top: 22,
                                left: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                  height: 15,
                                  width: 15,
                                  child: Container(
                                      height: 14,
                                      width: 14,
                                      child:
                                          Image.asset("images/blueTick.png")),
                                ),
                              )
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ])
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 25, bottom: 5, top: 5),
                child: MarqueeWidget(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                      onTap: () => {
                        widget.profileOwner == widget.currentUserId
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMyProfile(
                                    uid: widget.profileOwner,
                                    profileImage: widget.mainProfileUrl,
                                  ),
                                ),
                              )
                            : null,
                      },
                      child: Text(
                        widget.mainFirstName + " " + widget.mainSecondName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Cute",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  _blockOption();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 35,
                    width: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          widget.currentUserId == widget.profileOwner
                              ? Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontFamily: "cute",
                                     fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.lightBlue,
                                  ),
                                )
                              : Icon(Icons.more_vert),
                        ],
                      ),
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

  _crushOfAndFollowersButton() {
    return Container(
      height: 115,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                child: Text(
                                  "Followers",
                                  style: TextStyle(
                                      fontFamily: "cute",
                                       fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            StreamBuilder(
                                stream: userFollowersRtd
                                    .child(widget.currentUserId)
                                    .onValue,
                                builder: (context, AsyncSnapshot dataSnapShot) {
                                  if (dataSnapShot.hasData) {
                                    DataSnapshot snapshot =
                                        dataSnapShot.data.snapshot;
                                    Map data = snapshot.value;
                                    if (data == null) {
                                      return Text(
                                        "0",
                                        style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                          fontFamily: 'cute',
                                          fontSize: 12,
                                        ),
                                      );
                                    } else {
                                      String followers = universalMethods
                                          .shortNumberGenrator(data.length);
                                      return Text(
                                        followers,
                                        style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                          fontFamily: 'cute',
                                          fontSize: 12,
                                        ),
                                      );
                                    }
                                  } else {
                                    return Text(
                                      "0",
                                      style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                        fontFamily: 'cute',
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowerPage(
                              currentUserId: widget.currentUserId,
                              profileOwner: widget.profileOwner,
                            ),
                          ),
                        ),
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          elevation: 0.0,
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowerPage(
                          currentUserId: widget.currentUserId,
                          profileOwner: widget.profileOwner,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Crush ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "cute",
                                     fontWeight: FontWeight.bold,

                                  ),
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Text(
                              crushOfCount.toString(),
                              style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                fontFamily: 'cute',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CrushOfPage(
                            currentUserId: widget.currentUserId,
                            profileOwner: widget.profileOwner,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: Colors.lightBlue,
                        textStyle: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _decencyMeter(),
          )
        ],
      ),
    );
  }

  late Map memerMap;

  getUserData(String uid) async {
    await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          memerMap = dataSnapshot.value;

          print(uid);
        });
      }
    });
  }

  _relationshipStatusForOwnProfile() {
    return Container(
      child: Column(
        children: [
          inRelationShipForOwnProfile
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      loading = true;
                    });

                    getUserData(inRelationshipWithId);
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Provider<User>.value(
                            value: widget.user,
                            child: SwitchProfile(
                              currentUserId: widget.user.uid,
                              mainProfileUrl: memerMap['url'],
                              mainFirstName: memerMap['firstName'],
                              profileOwner: memerMap['ownerId'],
                              mainSecondName: memerMap['secondName'],
                              mainCountry: memerMap['country'],
                              mainDateOfBirth: memerMap['dob'],
                              mainAbout: memerMap['about'],
                              mainEmail: memerMap['email'],
                              mainGender: memerMap['gender'],
                              username: memerMap['username'],
                              isVerified: memerMap['isVerified'],
                              action: 'profile',
                              user: widget.user,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 23,
                          top: 10,
                          bottom: 15,
                        ),
                        child: Text(
                          "In Love with",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontFamily: 'cute',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Text(
                          "$inRelationShipWithFirstNameToShow "
                          "$inRelationShipWithSecondNameToShow",
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pink,
                            fontFamily: 'cute',
                             fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () => print("Tapped"),
                  child: Container(
                    color: Colors.blue.withOpacity(0.09),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Not In Relationship",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontFamily: 'cute',
                                  fontSize: 12,
                                   fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(
                              children: [
                                Text(
                                  "Search for one ",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'cute',
                                      fontSize: 14,
                                       fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
          _breakUpOption(),
          SizedBox(
            height: 10,
            child: Container(),
          ),
          toAcceptRelationShip(),
          !inRelationShip && pendingRelationShip && youHaveToAccept
              ? SizedBox(
                  height: 20,
                  child: Container(),
                )
              : SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }

  relationShipRequestSendButton() {
    if (inRelationShip) {
      return Container(
        height: 40,
        color: Colors.blue.withOpacity(0.09),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Already In RelationShip",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12.0,
                     fontWeight: FontWeight.bold,
                    fontFamily: 'cute'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                height: 40,
                width: 40,
                child: RiveAnimation.asset(
                  'images/profile/inRelation-emoji.riv',
                ),
              ),
            ),
          ],
        ),
      );
    } else if (!inRelationShip && !pendingRelationShip) {
      return Container(
        height: 40,
        color: Colors.blue.withOpacity(0.09),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Click To Send RelationShip Request",
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 12.0,
                     fontWeight: FontWeight.bold,
                    fontFamily: 'cute'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    if (visitorIsAlreadyInRelationShip) {
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                        child: Text("Loyalty Is everything 😡",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "cute",
                                                color: Colors.red))),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "You are Already in Relationship or may be you already have sent a Relationship request. First cancel that request or Breakup by visit your Profile. Which we do not recommenced. But choice is yours",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "cutes",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else if (visitorIsAlreadyInRelationShipPending) {
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                        child: Text("Loyalty Is everything 😡",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "cute",
                                                color: Colors.red))),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "You are Already in Relationship or may be you already have sent a Relationship request. First cancel that request or Breakup by visit your Profile. Which we do not recommenced. But choice is yours",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "cutes",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      setState(() {
                        pendingRelationShip = true;
                      });

                      relationShipReferenceRtd.child(widget.profileOwner).set({
                        "inRelationshipWithId": "",
                        "inRelationshipWithSecondName": "",
                        "inRelationshipWithFirstName": "",
                        "crush": "",
                        "closeFriend": "",
                        "relationShipStatus": "",
                        "inRelationShip": false,
                        "pendingRelationShip": true,
                        "relationShipRequestSenderSecondName":
                            Constants.mySecondName,
                        "relationShipRequestSenderName": Constants.myName,
                        "relationShipRequestSenderFirstName": Constants.myName,
                        "relationShipRequestSenderId": widget.currentUserId,
                        "relationShipRequestSendToName": widget.mainFirstName,
                        "relationShipRequestSendToId": widget.profileOwner,
                      });
                      relationShipReferenceRtd.child(widget.currentUserId).set({
                        "inRelationshipWithId": "",
                        "inRelationshipWithSecondName": "",
                        "inRelationshipWithFirstName": "",
                        "crush": "",
                        "closeFriend": "",
                        "relationShipStatus": "",
                        "inRelationShip": false,
                        "pendingRelationShip": true,
                        "relationShipRequestSenderSecondName":
                            Constants.mySecondName,
                        "relationShipRequestSenderName": Constants.myName,
                        "relationShipRequestSenderFirstName": Constants.myName,
                        "relationShipRequestSenderId": widget.currentUserId,
                        "relationShipRequestSendToName": widget.mainFirstName,
                        "relationShipRequestSendToId": widget.profileOwner,
                      });
                      feedRtDatabaseReference
                          .child(widget.profileOwner)
                          .child("feedItems")
                          .child(postId)
                          .set({
                        "inRelationshipWithId": "",
                        "inRelationshipWithSecondName": "",
                        "inRelationshipWithFirstName": "",
                        "type": "sendRequestToConformRelationShip",
                        "firstName": Constants.myName,
                        "secondName": Constants.mySecondName,
                        "comment": "",
                        "timestamp": DateTime.now().millisecondsSinceEpoch,
                        "url": Constants.myPhotoUrl,
                        "postId": postId,
                        "ownerId": widget.currentUserId,
                        "photourl": "",
                        "isRead": false,
                      });
                    }
                  },
                  child: Icon(Icons.favorite_border_outlined,
                      size: 30, color: Colors.blue)),
            ),
          ],
        ),
      );
    } else if (pendingRelationShip) {
      return relationShipRequestSendToId == widget.currentUserId
          ? Text("Cancel It")
          : GestureDetector(
              onTap: () {
                _bottomSheetForRelationShipPending();
              },
              child: Container(
                height: 40,
                color: Colors.blue.withOpacity(0.09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Center(
                        child: Text(
                          "Relationship Status Is Pending",
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 12,
                              fontFamily: 'cutes',
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.favorite,
                            size: 30, color: Colors.purpleAccent)),
                  ],
                ),
              ),
            );
    }
  }

  _followersCountAndCrushCountButtonForVisitor() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Followers",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: "cutes",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: userFollowersRtd
                                          .child(widget.profileOwner)
                                          .onValue,
                                      builder: (context,
                                          AsyncSnapshot dataSnapShot) {
                                        if (dataSnapShot.hasData) {
                                          DataSnapshot
                                              snapshotForFollowerCounter =
                                              dataSnapShot.data.snapshot;

                                          Map followersCountMap =
                                              snapshotForFollowerCounter.value;
                                          followersCountMap2 =
                                              snapshotForFollowerCounter.value;

                                          if (followersCountMap == null) {
                                            return Text(
                                              "0",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'cutes',
                                                fontSize: 12,
                                              ),
                                            );
                                          } else {
                                            String followers = universalMethods
                                                .shortNumberGenrator(
                                                    followersCountMap.length);

                                            return Text(
                                              followers,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'cutes',
                                                fontSize: 12,
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                            "0",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'cutes',
                                              fontSize: 12,
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowerPage(
                                    currentUserId: widget.currentUserId,
                                    profileOwner: widget.profileOwner,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              elevation: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                elevation: 0.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Crush ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'cutes',
                                              fontSize: 12,
                                            ),
                                          ),
                                          Icon(
                                            Icons.favorite_border_outlined,
                                            size: 14,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        crushOfCount.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'cutes',
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CrushOfPage(
                                      currentUserId: widget.currentUserId,
                                      profileOwner: widget.profileOwner,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          _decencyMeter(),
        ],
      ),
    );
  }

  _followingButton() {
    return SizedBox(
      height: 28,
      width: MediaQuery.of(context).size.width / 4,
      child: isFollowedByYou
          ? ElevatedButton(
              child: Text(
                "Following",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  isFollowedByYou = false;
                });

                userFollowingRtd
                    .child(widget.currentUserId)
                    .child(widget.profileOwner)
                    .remove();
                userFollowersRtd
                    .child(widget.profileOwner)
                    .child(widget.currentUserId)
                    .remove();

                followingCounter();
              },
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  primary: Colors.blue,
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            )
          : ElevatedButton(
              onPressed: () => {
                setState(() {
                  isFollowedByYou = true;
                }),

                // make Auth User follower of Another User (Update Their Follower Collection)

                ///this is who, who have been followed by other user
                ///this code will add a follower to his/her data base
                // ProfileDataBase.makeFollower(
                //     widget.profileOwner, widget.currentUserId),

                /// this is who follow other user
                /// this code add a Following to his database
                // ProfileDataBase.addFollowing(
                //     widget.currentUserId, widget.profileOwner),

                /// this code will add notification to the use that have been followed
                feedRtDatabaseReference
                    .child(widget.profileOwner)
                    .child("feedItems")
                    .child(postId)
                    .set({
                  "type": "follow",
                  "firstName": Constants.myName,
                  "secondName": Constants.mySecondName,
                  "comment": "",
                  "timestamp": DateTime.now().millisecondsSinceEpoch,
                  "url": Constants.myPhotoUrl,
                  "postId": postId,
                  "ownerId": widget.currentUserId,
                  "photourl": "",
                  "isRead": false,
                }),

                //For Realtime DataBase

                userFollowingRtd
                    .child(widget.currentUserId)
                    .child(widget.profileOwner)
                    .set({
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'followingId': widget.profileOwner,
                  'token': Constants.token,
                }),

                userFollowersRtd
                    .child(widget.profileOwner)
                    .child(widget.currentUserId)
                    .set({
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'followerId': widget.currentUserId,
                  'token': Constants.token,
                }),

                followingCounter(),
              },
              child: Text(
                "Follow",
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'cutes',
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 2,
                primary: Colors.grey.shade200,
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  _decencyMeter() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 5,
              percent: userPercentageDecency.toStringAsPrecision(3) == "NaN"
                  ? 0
                  : userPercentageDecency / 100,
              animation: true,
              animationDuration: 2000,
              startAngle: 180,
              center: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Countup(
                    duration: Duration(milliseconds: 2000),
                    begin: 0,
                    end: userPercentageDecency.toStringAsPrecision(3) == "NaN"
                        ? 0
                        : userPercentageDecency,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            userPercentageDecency.toStringAsPrecision(3) ==
                                    "NaN"
                                ? 12
                                : 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "%",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            userPercentageDecency.toStringAsPrecision(3) ==
                                    "NaN"
                                ? 13
                                : 11,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              progressColor: Colors.lightBlue,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor:
                  userPercentageDecency.toStringAsPrecision(3) == "NaN"
                      ? Colors.lightBlue
                      : Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 1),
              child: Text(
                "Profile Decency",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'cutes',
                ),
              ),
            ),
            userPercentageDecency.toStringAsPrecision(3) == "NaN"
                ? Text(
                    "Not Rated Yet",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.lightBlue,
                        fontFamily: 'cutes'),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 3, right: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              new Text(
                                userPercentageDecency.toStringAsPrecision(1) ==
                                        "NaN"
                                    ? "Not Rated"
                                    : "${userDecency.toStringAsPrecision(1)}",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: userPercentageDecency
                                                .toStringAsPrecision(3) ==
                                            "NaN"
                                        ? 10
                                        : 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " / 5",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: userPercentageDecency
                                                .toStringAsPrecision(3) ==
                                            "NaN"
                                        ? 10
                                        : 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _breakUpOption() {
    if (inRelationShip) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Relationship Option",
                style: TextStyle(
                    color: Colors.blue,
                     fontWeight: FontWeight.bold,
                    fontFamily: 'cute'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                child: Text(
                  "BreakUp",
                  style: TextStyle(
                    fontFamily: 'cute',
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      useRootNavigator: true,
                      isScrollControlled: true,
                      barrierColor: Colors.red.withOpacity(0.2),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: SingleChildScrollView(
                            child: Column(
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
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "Confirmation",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "cute",
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Are You Sure To Broke Up This Person?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "cute",
                                        color: Colors.lightBlue),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              inRelationShip = false;
                                              pendingRelationShip = false;
                                            });

                                            relationShipReferenceRtd
                                                .child(widget.profileOwner)
                                                .update({
                                              "inRelationshipWithId": "",
                                              "inRelationshipWithSecondName":
                                                  "",
                                              "inRelationshipWithFirstName": "",
                                              "inRelationShip": false,
                                              "pendingRelationShip": false,
                                            });
                                            relationShipReferenceRtd
                                                .child(inRelationshipWithId)
                                                .update({
                                              "inRelationshipWithId": "",
                                              "inRelationshipWithSecondName":
                                                  "",
                                              "inRelationshipWithFirstName": "",
                                              "inRelationShip": false,
                                              "pendingRelationShip": false,
                                              "inRelationshipWith": "",
                                            });

                                            feedRtDatabaseReference
                                                .child(inRelationshipWithId)
                                                .child("feedItems")
                                                .child(postId)
                                                .set({
                                              "type": "breakUp",
                                              "firstName": Constants.myName,
                                              "secondName":
                                                  Constants.mySecondName,
                                              "postId": postId,
                                              "timestamp": DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              "url": Constants.myPhotoUrl,
                                              "ownerId": widget.currentUserId,
                                              "isRead": false,
                                            });
                                            // userRefRTD
                                            //     .child(Constants.myId)
                                            //     .update({
                                            //   'inRelationship': "false",
                                            // });
                                            // userRefRTD
                                            //     .child(inRelationshipWithId)
                                            //     .update({
                                            //   'inRelationship': "false",
                                            // });

                                            showModalBottomSheet(
                                                useRootNavigator: true,
                                                isScrollControlled: true,
                                                barrierColor:
                                                    Colors.red.withOpacity(0.2),
                                                elevation: 0,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            4,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(Icons
                                                                    .linear_scale_sharp),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20),
                                                            child: Text(
                                                              "Done! Now Moving To Home Page",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "cutes",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Please wait..",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "cutes",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });

                                            Future.delayed(
                                                const Duration(seconds: 3), () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text('Confirm'),
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              primary: Colors.lightBlue,
                                              textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              primary: Colors.redAccent,
                                              textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Kindly think again. Love is rare :(:, Life is short.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "cute",
                                          color: Colors.grey),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  _relationShipStatusForVisitor() {
    return Center(
      child: Container(
        height: 40,
        color: Colors.blue.withOpacity(0.09),
        width: MediaQuery.of(context).size.width,
        child: inRelationShipForOwnProfile
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  getUserData(inRelationshipWithId);
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Provider<User>.value(
                          value: widget.user,
                          child: SwitchProfile(
                            currentUserId: widget.user.uid,
                            mainProfileUrl: memerMap['url'],
                            mainFirstName: memerMap['firstName'],
                            profileOwner: memerMap['ownerId'],
                            mainSecondName: memerMap['secondName'],
                            mainCountry: memerMap['country'],
                            mainDateOfBirth: memerMap['dob'],
                            mainAbout: memerMap['about'],
                            mainEmail: memerMap['email'],
                            mainGender: memerMap['gender'],
                            username: memerMap['username'],
                            isVerified: memerMap['isVerified'],
                            action: 'profile',
                            user: widget.user,
                          ),
                        ),
                      ),
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Text(
                        "In Love️ with",
                        style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'cute',
                             fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "$inRelationShipWithFirstNameToShow "
                        "$inRelationShipWithSecondNameToShow",
                        maxLines: 3,
                        // softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'cute',
                          color: Colors.pink,
                           fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => print("Tapped"),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Not in Relationship",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.lightBlue,
                                 fontWeight: FontWeight.bold,
                                fontFamily: 'cute'),
                          ),
                          widget.profileOwner == widget.currentUserId
                              ? Image.asset(
                                  "images/editIcon.png",
                                  scale: 25,
                                )
                              : Icon(
                                  Icons.all_inclusive,
                                  color: Colors.grey,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  _crushButtonForVisitor() {
    if (isCrushOn) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 15.5,
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isCrushOn = false;
              getCrushOfCount();
            });

            // removeFollower
            crushOfRTD
                .child(widget.profileOwner)
                .child("crushOfReference")
                .child(widget.currentUserId)
                .remove();
            // remove Following

            crushOnRTD
                .child(widget.currentUserId)
                .child("crushOnReference")
                .child(widget.profileOwner)
                .remove();

            // dl8 updateFeed
            // feedRtDatabaseReference
            //     .child(widget.profileOwner)
            //     .child("feedItems")
            //     .remove();
          },
          child: Container(
            height: 40,
            width: 40,
            child: RiveAnimation.asset(
              'images/profile/crush-glow.riv',
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: GestureDetector(
            onTap: () {
              setState(() {
                isCrushOn = true;
                getCrushOfCount();
              });
// make Auth User follower of Another User (Update Their Follower Collection)
              crushOfRTD
                  .child(widget.profileOwner)
                  .child("crushOfReference")
                  .child(widget.currentUserId)
                  .set({
                "timestamp": DateTime.now().millisecondsSinceEpoch,
                'crushOfId': widget.currentUserId
              });
// update our Profile by adding following collection

              crushOnRTD
                  .child(widget.currentUserId)
                  .child("crushOnReference")
                  .child(widget.profileOwner)
                  .set({
                "timestamp": DateTime.now().millisecondsSinceEpoch,
                'crushOnId': widget.profileOwner
              });

// updateFeed
              feedRtDatabaseReference
                  .child(widget.profileOwner)
                  .child("feedItems")
                  .child(postId)
                  .set({
                "type": "crushOnReference",
                "firstName": Constants.myName,
                "secondName": Constants.mySecondName,
                "comment": "",
                "timestamp": DateTime.now().millisecondsSinceEpoch,
                "url": Constants.myPhotoUrl,
                "postId": postId,
                "ownerId": widget.currentUserId,
                "photourl": "",
                "isRead": false,
              });
            },
            child: Icon(Icons.favorite_border_outlined,
                size: 30, color: Colors.pink)),
      );
    }
  }

  otherInfo() {
    return Column(
      children: [
        Container(
          height: 40,
          color: Colors.blue.withOpacity(0.09),
          padding: EdgeInsets.only(left: 23, right: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Landing Day On Earth",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontFamily: 'cute',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,

                ),
              ),
              Text(
                widget.dob,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,

                  fontFamily: 'cute',
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          color: Colors.blue.withOpacity(0.09),
          padding: EdgeInsets.only(left: 23, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gender",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,

                  fontFamily: 'cute',
                  fontSize: 12,
                ),
              ),
              Text(
                widget.mainGender,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,

                  fontFamily: 'cute',
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          color: Colors.blue.withOpacity(0.09),
          padding: EdgeInsets.only(left: 23, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Country",
                style: TextStyle(
                    fontWeight: FontWeight.bold,

                    color: Colors.lightBlue, fontFamily: 'cute', fontSize: 12),
              ),
              Text(
                widget.country,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,

                  fontFamily: 'cute',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _crushButtonControllerForVisitor() {
    return Container(
      height: 40,
      color: Colors.blue.withOpacity(0.09),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: isCrushOn
                ? Text(
                    widget.mainGender == "Male"
                        ? "Crush on Him"
                        : "Crush on Her",
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'cute',
                      fontSize: 12,
                       fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    widget.mainGender == "Male"
                        ? "Tap Heart if Crush on Him"
                        : "Tap Heart if Crush on Her",
                    style: TextStyle(
                      fontFamily: 'cute',
                      color: Colors.lightBlue,
                      fontSize: 12,
                       fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          _crushButtonForVisitor(),
        ],
      ),
    );
  }

  late Map friendsData;
  bool isFriendsData = false;
  List friendList = [];

  getBestFriends() {
    bestFriendsRtd
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          friendsData = dataSnapshot.value;
        });
        friendsData
            .forEach((index, data) => friendList.add({"key": index, ...data}));
      } else {
        setState(() {
          isFriendsData = true;
        });
      }
    });
  }

  _bestiesList() {
    return Padding(
      padding: isFriendsData == true
          ? EdgeInsets.only(bottom: 10, left: 1, top: 20)
          : EdgeInsets.only(bottom: 10, left: 1, top: 0),
      child: Container(
        color: friendsData == null
            ? Colors.grey.shade100.withOpacity(0.45)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 23, right: 0),
          child: SizedBox(
            height: friendsData == null
                ? widget.currentUserId != widget.profileOwner
                    ? 0
                    : 40
                : 100,
            child: friendsData == null
                ? widget.currentUserId != widget.profileOwner
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bestie",
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'cute',
                                fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Provider<User>.value(
                                    value: widget.user,
                                    child: MainSearchPage(
                                      navigateThrough: "",
                                      user: widget.user,
                                      userId: Constants.myId,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Search",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'cute',
                                  fontSize: 15),
                            ),
                          )
                        ],
                      )
                : Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                  'images/profile/bestie-image.png'),
                            ),
                          ),
                          Text(
                            "Besties",
                            style: TextStyle(
                                fontFamily: 'cute',
                                fontSize: 12,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: friendList.length,
                            itemBuilder: (context, index) => Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, left: 10),
                                  child: BestFriendList(
                                    index: index,
                                    bestFriendList: friendList,
                                  ),
                                )),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _addBestieButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 40,
        color: Colors.blue.withOpacity(0.09),
        child: Padding(
          padding: const EdgeInsets.only(left: 23, right: 23),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bestie",
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'cute',
                  fontSize: 12,
                ),
              ),
              AddFriendListButton(
                profileOwner: widget.profileOwner,
                currentUserId: widget.currentUserId,
                mainFirstName: widget.mainFirstName,
                mainProfileUrl: widget.mainProfileUrl,
                gender: widget.mainGender,
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isRecent = true;

  _posts() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 5, right: 5, bottom: 0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Recent Posts",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'cute',
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.post_add,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: RecentProfilePosts(
              profileOwner: widget.profileOwner,
              user: widget.user,
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider<User>.value(
                    value: widget.user,
                    child: ProfilePosts(
                      profileOwner: widget.profileOwner,
                      user: widget.user,
                    ),
                  ),
                ),
              )
            },
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    "Show All Posts ",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'cute',
                      fontWeight: FontWeight.bold,

                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.lightBlue,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  editandBlockOption() {
    return widget.currentUserId == widget.profileOwner
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => EditMyProfile(
                //           uid: widget.profileOwner,
                //           profileImage: widget.mainProfileUrl,
                //         ),
                //       ),
                //     );
                //   },
                //   child: Text(
                //     "Edit Profile",
                //     style: TextStyle(color: Colors.black, fontFamily: 'cute'),
                //   ),
                // ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportId(
                            profileId: widget.profileOwner,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Report User",
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'cutes',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _aboutAndMinor() {
    return GestureDetector(
      onTap: () => {
        widget.profileOwner == widget.currentUserId
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMyProfile(
                    uid: widget.profileOwner,
                    profileImage: widget.mainProfileUrl,
                  ),
                ),
              )
            : null,
      },
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8, left: 23, right: 25, top: 15),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 11),
                  child: Row(
                    children: [
                      Text(
                        "Note",
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'cutes',
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Icon(
                        Icons.notes,
                        size: 14,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                widget.mainAbout.length > 30
                    ? Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: 20,
                        child: Marquee(
                          scrollAxis: Axis.horizontal,
                          numberOfRounds: 3,
                          pauseAfterRound: Duration(seconds: 3),
                          startAfter: Duration(seconds: 3),
                          text: "${widget.mainAbout}   ",
                          style: TextStyle(
                            fontFamily: 'cutes',
                            fontSize: 11,
                          ),
                        ),
                      )
                    : Flexible(
                        child: Text(
                          widget.mainAbout,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'cutes',
                            fontSize: 11,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0, left: 23),
            child: Row(
              children: [
                Text(
                  "username",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'cutes',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 11),
                  child: Icon(
                    Icons.perm_identity,
                    size: 14,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  widget.username.toString(),
                  style: TextStyle(
                    fontFamily: 'cutes',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0,
          ),
        ],
      ),
    );
  }

  String? groupChatId = "";

  groupIdAndRelationInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      groupChatId = prefs.getString('groupChatId');
      print("GroupChatId =>>>>>>>>>" + groupChatId!);
    });
  }

  ///****\\\\\\
  Future<void> getGroupChatId(String receiverId) async {
    if (widget.currentUserId.hashCode <= receiverId.hashCode) {
      groupChatId = '${widget.currentUserId}-$receiverId';
    } else {
      groupChatId = '$receiverId-${widget.currentUserId}';
    }
  }

  ///********\\\\
  _conversationBox() {
    return StreamBuilder(
      stream: relationShipReferenceRtd.child(widget.currentUserId).onValue,
      builder: (context, AsyncSnapshot dataSnapShot) {
        if (dataSnapShot.hasData) {
          DataSnapshot snapshot = dataSnapShot.data.snapshot;
          Map? relationShipData = snapshot.value;

          if (relationShipData == null) {
            print("empty data");
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              height: 28,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 3,
                    primary: Colors.green.shade300,
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                onPressed: () => {
                  FirebaseDatabase.instance
                      .reference()
                      .child("switchLastVisit-786")
                      .child(widget.profileOwner)
                      .child(Constants.myId)
                      .set({
                    'timeStamp':
                        DateTime.now().millisecondsSinceEpoch.toString(),
                  }),
                  print("profile Owner = ${widget.profileOwner}"),
                  print("My Id = ${widget.currentUserId}"),
                  getGroupChatId(widget.profileOwner),
                  print("profile Owner = ${widget.profileOwner}"),
                  print("My Id = ${widget.currentUserId}"),
                  print("Group chat = ${groupChatId!}"),
                  Future.delayed(const Duration(milliseconds: 600), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwitchChat(
                                receiverId: widget.profileOwner,
                                receiverName: widget.mainFirstName,
                                receiverEmail: widget.mainEmail,
                                receiverAvatar: widget.mainProfileUrl,
                                myId: widget.currentUserId,
                                groupChatId: groupChatId!,
                                inRelationShipId:
                                    relationShipData['inRelationshipWithId'],
                                listForSendButton: [],
                                blockBy: "",
                              )),
                    );
                  }),
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Chat  ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "cutes",
                          fontSize: 9,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 13,
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Center(
          child: Text(""),
        );
      },
    );
  }

  _memeProfile() {
    return SizedBox(
      height: 28,
      width: MediaQuery.of(context).size.width / 3.8,
      child: ElevatedButton(
        child: Text(
          "Meme Profile",
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider<User>.value(
                value: widget.user,
                child: MemeProfile(
                  profileOwner: widget.profileOwner,
                  currentUserId: widget.currentUserId,
                  mainProfileUrl: widget.mainProfileUrl,
                  mainSecondName: widget.mainSecondName,
                  mainFirstName: widget.mainFirstName,
                  mainGender: widget.mainGender,
                  mainEmail: widget.mainEmail,
                  mainAbout: widget.mainAbout,
                  user: widget.user,
                  navigateThrough: 'panel',
                  username: widget.username,
                ),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
            elevation: 2,
            primary: Colors.purple,
            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: widget.currentUserId == widget.profileOwner
          ? DelayedDisplay(
              delay: Duration(milliseconds: 100),
              slidingBeginOffset: Offset(0, -0.35),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SafeArea(
                      child: Material(
                        color: Colors.white,
                        elevation: 0.0,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: Column(
                          children: [
                            loading
                                ? LinearProgressIndicator()
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            appBar(),
                            _crushOfAndFollowersButton(),
                            _aboutAndMinor(),
                            editandBlockOption(),
                          ],
                        ),
                      ),
                    ),
                    Panel(
                      aboutMain: widget.mainAbout,
                      profileOwner: widget.profileOwner,
                      currentUserId: widget.currentUserId,
                      mainProfileUrl: widget.mainProfileUrl,
                      mainFirstName: widget.mainFirstName,
                      mainSecondName: widget.mainSecondName,
                      mainGender: widget.mainGender,
                      mainEmail: widget.mainEmail,
                      user: widget.user,
                      username: widget.username,
                    ),
                    _relationshipStatusForOwnProfile(),
                    otherInfo(),
                    _posts(),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            )
          : DelayedDisplay(
              fadeIn: true,
              slidingCurve: Curves.easeInOutSine,
              delay: Duration(milliseconds: 222),
              slidingBeginOffset: Offset(0, -0.35),
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: Column(
                        children: [
                          loading
                              ? LinearProgressIndicator()
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                          appBar(),
                          _followersCountAndCrushCountButtonForVisitor(),
                          _aboutAndMinor(),
                          SizedBox(
                            height: 20,
                          ),
                          isBlock
                              ? Center(
                                  child: Container(
                                    child: Text(
                                      "You blocked ${widget.mainFirstName}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'cutes'),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 12, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _followingButton(),
                                      _conversationBox(),
                                      _memeProfile(),
                                    ],
                                  ),
                                ),
                          isBlock
                              ? GestureDetector(
                                  onTap: () => _blockOption(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Container(
                                        child: Text(
                                          "click here to unblock",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'cutes'),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowingPage(
                                      currentUserId: widget.currentUserId,
                                      profileOwner: widget.profileOwner,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Following",
                                        style: TextStyle(
                                            fontFamily: "cute", fontSize: 9),
                                      ),
                                      StreamBuilder(
                                          stream: userFollowingRtd
                                              .child(widget.profileOwner)
                                              .onValue,
                                          builder: (context,
                                              AsyncSnapshot dataSnapShot) {
                                            if (dataSnapShot.hasData) {
                                              DataSnapshot snapshot =
                                                  dataSnapShot.data.snapshot;

                                              Map data = snapshot.value;

                                              if (data == null) {
                                                return Text(
                                                  "0",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'cutes',
                                                    fontSize: 12,
                                                  ),
                                                );
                                              } else {
                                                return Text(
                                                  data.length.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'cutes',
                                                    fontSize: 12,
                                                  ),
                                                );
                                              }
                                            } else {
                                              return Text(
                                                "0",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'cutes',
                                                  fontSize: 12,
                                                ),
                                              );
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 100,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CrushOnPage(
                                      currentUserId: widget.currentUserId,
                                      profileOwner: widget.profileOwner,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        "CrushOn",
                                        style: TextStyle(
                                            fontFamily: "cute", fontSize: 9),
                                      ),
                                      Text(
                                        crushOnCount.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'cutes',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // _conversationBox(),
                        ],
                      ),
                    ),
                    // _memeProfile(),
                    isBlock
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Panel(
                            aboutMain: widget.mainAbout,
                            profileOwner: widget.profileOwner,
                            currentUserId: widget.currentUserId,
                            mainProfileUrl: widget.mainProfileUrl,
                            mainFirstName: widget.mainFirstName,
                            mainSecondName: widget.mainSecondName,
                            mainGender: widget.mainGender,
                            mainEmail: widget.mainEmail,
                            user: widget.user,
                            username: widget.username,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    isBlock
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : ProfileDecency(
                            mainId: widget.currentUserId,
                            profileId: widget.profileOwner,
                            onPressedButton2: getDecencyReport,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    _addBestieButton(),
                    _crushButtonControllerForVisitor(),
                    SizedBox(
                      height: 10,
                    ),
                    relationShipRequestSendButton(),
                    SizedBox(
                      height: 10,
                    ),
                    _relationShipStatusForVisitor(),
                    SizedBox(
                      height: 15,
                    ),
                    otherInfo(),
                    //   editandBlockOption(),
                    _posts(),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  double userPercentageDecency = 0;

  double userDecency = 0;
  int counterForTwo = 0;
  int counterForOne = 0;
  int counterForThree = 0;
  int counterForFour = 0;
  int counterForFive = 0;
  bool isOne = false;
  bool isTwo = false;
  bool isThree = false;
  bool isFour = false;
  bool isFive = false;

  getDecencyReport() {
    late Map data;

    userProfileDecencyReport
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });

        setState(() {
          counterForFour = data['numberOfFour'];
          counterForFive = data['numberOfFive'];
          counterForThree = data['numberOfThree'];
          counterForTwo = data['numberOfTwo'];
          counterForOne = data['numberOfOne'];
        });

        userDecency = ((5 * counterForFive +
                4 * counterForFour +
                3 * counterForThree +
                2 * counterForTwo +
                1 * counterForOne) /
            (counterForTwo +
                counterForOne +
                counterForThree +
                counterForFour +
                counterForFive));

        userPercentageDecency = (userDecency / 5) * 100;
        print("decency >>> $userPercentageDecency");
      }
    });
  }

  _bottomSheetForRelationShipPending() {
    return showModalBottomSheet(
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Relationship Request has already been sent by some other Person, If you want to be in relationship with this person or you knew that person tell him/her to cancel the previous request by visit her/his Profile.",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ProfileDecency extends StatefulWidget {
  final VoidCallback onPressedButton2;

  final String mainId;
  final String profileId;

  const ProfileDecency(
      {required this.mainId,
      required this.profileId,
      required this.onPressedButton2});

  @override
  _ProfileDecencyState createState() => _ProfileDecencyState();
}

class _ProfileDecencyState extends State<ProfileDecency> {
  ///5 star - 252
  /// 4 star - 124
  /// 3 star - 40
  /// 2 star - 29
  /// 1 star - 33
  /// (5*252 + 4*124 + 3*40 + 2*29 + 1*33) / (252+124+40+29+33) = 4.11 and change

  double userPercentageDecency = 0;
  double userDecency = 0;
  int counterForTwo = 0;
  int counterForOne = 0;
  int counterForThree = 0;
  int counterForFour = 0;
  int counterForFive = 0;
  bool isOne = false;
  bool isTwo = false;
  bool isThree = false;
  bool isFour = false;
  bool isFive = false;
  Color indicatorColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    checkIfDecencyExist();
    getDecencyReport();
  }

  getDecencyReport() async {
    if (widget.mainId != widget.profileId) {
      late Map data;

      userProfileDecencyReport
          .child(widget.profileId)
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          setState(() {
            data = dataSnapshot.value;
          });

          setState(() {
            counterForFour = data['numberOfFour'];
            counterForFive = data['numberOfFive'];
            counterForThree = data['numberOfThree'];
            counterForTwo = data['numberOfTwo'];
            counterForOne = data['numberOfOne'];
          });

          // AR = 1*a+2*b+3*c+4*d+5*e/(R)
          //--
          //Where AR is the average rating
          //a is the number of 1-star ratings
          //b is the number of 2-star ratings
          //c is the number of 3-star ratings
          //d is the number of 4-star ratings
          //e is the number of 5-star ratings
          //R is the total number of ratings

          userDecency = ((5 * counterForFive +
                  4 * counterForFour +
                  3 * counterForThree +
                  2 * counterForTwo +
                  1 * counterForOne) /
              (counterForTwo +
                  counterForOne +
                  counterForThree +
                  counterForFour +
                  counterForFive));

          userPercentageDecency = (userDecency / 5) * 100;
        }

        widget.onPressedButton2();
      });
    } else {}

    // getColorsIndicator();
  }

  checkIfDecencyExist() async {
    late Map data;

    userProfileDecencyReport
        .child(widget.mainId)
        .child("DecencyReport")
        .child(widget.profileId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value == null) {
        userProfileDecencyReport
            .child(widget.mainId)
            .child("DecencyReport")
            .child(widget.profileId)
            .set({
          "numberOfOne": false,
          "numberOfTwo": false,
          "numberOfThree": false,
          "numberOfFour": false,
          "numberOfFive": false,
        });
      } else {
        setState(() {
          data = dataSnapshot.value;
        });
        if (data['numberOfOne'] == true) {
          print("isOne: $isOne");

          setState(() {
            isOne = true;
            isTwo = false;
            isFour = false;
            isThree = false;
            isFive = false;
          });
        } else if (data['numberOfTwo'] == true) {
          setState(() {
            isTwo = true;
            isOne = false;
            isThree = false;
            isFour = false;
            isFive = false;

            print("isOne: $isTwo");
          });
        } else if (data['numberOfThree'] == true) {
          setState(() {
            isTwo = false;
            isOne = false;
            isThree = true;
            isFour = false;
            isFive = false;
            print("isOne: $isThree");
          });
        } else if (data['numberOfFour'] == true) {
          setState(() {
            isFour = true;

            isTwo = false;
            isOne = false;
            isThree = false;
            isFive = false;
            print("isOne: $isFour");
          });
        } else if (data['numberOfFive'] == true) {
          setState(() {
            isFive = true;
            isTwo = false;
            isOne = false;
            isThree = false;
            isFour = false;
            print("isOne: $isFive");
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          widget.profileId != widget.mainId
              ? Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue.withOpacity(0.09),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Your Rating: ",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontFamily: 'cute',
                                fontSize: 12,
                                 fontWeight: FontWeight.bold),
                          ),
                        ),
                        widget.profileId == widget.mainId
                            ? Container()
                            : SingleChildScrollView(
                                child: Row(
                                  // shrinkWrap: true,
                                  // scrollDirection: Axis.horizontal,
                                  children: [
                                    ButtonForOne(
                                      isFour: isFour,
                                      isOne: isOne,
                                      isTwo: isTwo,
                                      isThree: isThree,
                                      isFive: isFive,
                                      profileId: widget.profileId,
                                      counterForOne: counterForOne,
                                      counterForFive: counterForFive,
                                      counterForFour: counterForFour,
                                      counterForThree: counterForThree,
                                      counterForTwo: counterForTwo,
                                      onPressedButton: getDecencyReport,
                                      checkIfDecencyExist: checkIfDecencyExist,
                                      mainId: widget.mainId,
                                    ),
                                    ButtonForTwo(
                                      isFour: isFour,
                                      isOne: isOne,
                                      isTwo: isTwo,
                                      isThree: isThree,
                                      isFive: isFive,
                                      profileId: widget.profileId,
                                      counterForOne: counterForOne,
                                      counterForFive: counterForFive,
                                      counterForFour: counterForFour,
                                      counterForThree: counterForThree,
                                      counterForTwo: counterForTwo,
                                      onPressedButton: getDecencyReport,
                                      checkIfDecencyExist: checkIfDecencyExist,
                                      mainId: widget.mainId,
                                    ),
                                    ButtonForThree(
                                      isFour: isFour,
                                      isOne: isOne,
                                      isTwo: isTwo,
                                      isThree: isThree,
                                      isFive: isFive,
                                      profileId: widget.profileId,
                                      counterForOne: counterForOne,
                                      counterForFive: counterForFive,
                                      counterForFour: counterForFour,
                                      counterForThree: counterForThree,
                                      counterForTwo: counterForTwo,
                                      onPressedButton: getDecencyReport,
                                      checkIfDecencyExist: checkIfDecencyExist,
                                      mainId: widget.mainId,
                                    ),
                                    ButtonForFour(
                                      isFour: isFour,
                                      isOne: isOne,
                                      isTwo: isTwo,
                                      isThree: isThree,
                                      isFive: isFive,
                                      profileId: widget.profileId,
                                      counterForOne: counterForOne,
                                      counterForFive: counterForFive,
                                      counterForFour: counterForFour,
                                      counterForThree: counterForThree,
                                      counterForTwo: counterForTwo,
                                      onPressedButton: getDecencyReport,
                                      checkIfDecencyExist: checkIfDecencyExist,
                                      mainId: widget.mainId,
                                    ),
                                    ButtonForFive(
                                      isFour: isFour,
                                      isOne: isOne,
                                      isTwo: isTwo,
                                      isThree: isThree,
                                      isFive: isFive,
                                      profileId: widget.profileId,
                                      counterForOne: counterForOne,
                                      counterForFive: counterForFive,
                                      counterForFour: counterForFour,
                                      counterForThree: counterForThree,
                                      counterForTwo: counterForTwo,
                                      onPressedButton: getDecencyReport,
                                      checkIfDecencyExist: checkIfDecencyExist,
                                      mainId: widget.mainId,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
