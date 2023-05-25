// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:slider_button/slider_button.dart';
// import 'package:switchtofuture/pages/Profile/Panel/EditProfilePic.dart';
// import 'package:switchtofuture/pages/Profile/profileDataBase.dart';
// import 'package:switchtofuture/pages/search/MainSearchPage.dart';
// import 'package:switchtofuture/pages/chat/SwitchChat.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/Models/Marquee.dart';
// import 'package:switchtofuture/Models/showAlertDialogueForSignInPage.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
//
// import '../profilePosts.dart';
//
// class Panel extends StatefulWidget {
//   final String profileOwner;
//   final String currentUserId;
//   final String mainProfileUrl;
//   final String mainSecondName;
//   final String mainFirstName;
//   final String mainGender;
//   final String mainEmail;
//   final String aboutMain;
//
//   const Panel(
//       {Key key,
//       this.profileOwner,
//       this.currentUserId,
//       this.mainProfileUrl,
//       this.mainFirstName,
//       this.mainSecondName,
//       this.mainGender,
//       this.mainEmail,
//       this.aboutMain})
//       : super(key: key);
//
//   @override
//   _PanelState createState() => _PanelState();
// }
//
// class _PanelState extends State<Panel> {
//   int followerCount;
//   int followingCount;
//   String relationShipRequestSenderId;
//   String inRealtionshipWithFirstName;
//   String inRealtionshipWithSecondName;
//   bool visitorIsAlreadyInRelationShip = false;
//   bool isFollowedByYou = false;
//   bool isFollowingYou = false;
//   String inRelationShipWithFirstNameToShow;
//   String inRelationShipWithSecondNameToShow;
//   int crushOnCount = 0;
//   String groupChatId;
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     checkIfThisPersonIsFollowingYou();
//     // getRelationShipStatus();
//     getFollowers();
//     getCrushOnCount();
//     getFollowing();
//     checkIfFollowedByYou();
//     // getRelationShipAcceptance();
//     print("{widget.currentUserId =>>>>${widget.currentUserId}");
//     print("{widget.profileOwener =>>>>${widget.profileOwner}");
//   }
//
//   getCrushOnCount() async {
//     print("getCrushCount run");
//
//     crushOfReferenceRtd
//         .child(widget.currentUserId)
//         .child("crushOfReference")
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
//       } else {
//         crushOnCount = 0;
//       }
//     });
//   }
//
//   getFollowers() async {
//     QuerySnapshot snapshot = await followerReference
//         .doc(widget.profileOwner)
//         .collection("userFollower")
//         .get();
//
//     setState(() {
//       followerCount = snapshot.docs.length;
//       print("followers ====> $followerCount");
//     });
//   }
//
//   checkIfThisPersonIsFollowingYou() async {
//     DocumentSnapshot doc = await followerReference
//         .doc(widget.currentUserId)
//         .collection("userFollower")
//         .doc(widget.profileOwner)
//         .get();
//     if (doc.exists) {
//       setState(() {
//         print("Yes he/She is following you");
//         isFollowingYou = true;
//       });
//     } else {
//       print("she is not following you");
//     }
//   }
//
//   checkIfFollowedByYou() async {
//     DocumentSnapshot doc = await followerReference
//         .doc(widget.profileOwner)
//         .collection("userFollower")
//         .doc(widget.currentUserId)
//         .get();
//     if (doc.exists) {
//       setState(() {
//         print("kk");
//         isFollowedByYou = true;
//       });
//     }
//   }
//
//   getFollowing() async {
//     QuerySnapshot snapshot = await followingReference
//         .doc(widget.profileOwner)
//         .collection("userFollowing")
//         .get();
//
//     setState(() {
//       followingCount = snapshot.docs.length;
//
//       print("following ====> $followingCount");
//     });
//   }
//
//   _profilePicture() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(40),
//                   border: Border.all(color: Colors.black, width: 1),
//                   image: DecorationImage(
//                     image: NetworkImage(widget.mainProfileUrl),
//                   ),
//                 ),
//               ),
//               widget.currentUserId == widget.profileOwner
//                   ? ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           elevation: 0.0,
//                           primary: Colors.white,
//                           textStyle: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.bold)),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Edit",
//                             style: TextStyle(fontSize: 10, color: Colors.lightBlue),
//                           ),
//                           SizedBox(
//                             width: 2,
//                           ),
//                           Icon(
//                             Icons.camera_alt,
//                             size: 13,
//                             color: Colors.lightBlue,
//                           ),
//                         ],
//                       ),
//                       onPressed: () => {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => EditProfilePic(
//                               uid: widget.currentUserId,
//                               profilerUrl: widget.profileOwner,
//                               imgUrl: widget.mainProfileUrl,
//                             ),
//                           ),
//                         ),
//                       },
//                     )
//                   : SizedBox(
//                       height: 10,
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   bool inRelationShip = false;
//   bool pendingRelationShip = false;
//   String relationShipRequestSenderName = "";
//   String relationShipRequestSendToName = "";
//   String relationShipRequestSendToId = "";
//   bool youhaveToAccept = false;
//   String inRelationshipWithFirstName = "";
//   String inRelationshipWithId = "";
//   String inRelationshipWithSecondName = "";
//
//   _bio() {
//     return Container(
//       padding: EdgeInsets.only(top: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Bio",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 30, right: 30),
//             child: Text(
//               widget.aboutMain,
//               style: TextStyle(fontFamily: "Names", color: Colors.grey),
//               textAlign: TextAlign.justify,
//               maxLines: 5,
//               softWrap: false,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   groupIdAndRelationInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       groupChatId = prefs.getString('groupChatId');
//       print("GroupChatId =>>>>>>>>>" + groupChatId);
//     });
//   }
//
//   _conversationBox() {
//     return StreamBuilder(
//       stream: relationShipReferenceRtd.child(widget.currentUserId).onValue,
//       builder: (context, dataSnapShot) {
//         if (dataSnapShot.hasData) {
//           DataSnapshot snapshot = dataSnapShot.data.snapshot;
//           Map relationShipData = snapshot.value;
//
//           if (relationShipData == null) {
//             print("empty data");
//           } else {
//             return SizedBox(
//                 width: 90,
//                 height: 45,
//                 child: FlatButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         side: BorderSide(color: Colors.white)),
//                     color: Colors.lightBlue.withOpacity(0.05),
//                     onPressed: () => {
//                           FirebaseDatabase.instance
//                               .reference()
//                               .child("lastTimeVisit")
//                               .child(widget.profileOwner)
//                               .child(Constants.myId)
//                               .set({
//                             'timeStamp': DateTime.now()
//                                 .millisecondsSinceEpoch
//                                 .toString(),
//                           }),
//                           chatHelper.readLocal(widget.profileOwner),
//                           Future.delayed(const Duration(milliseconds: 300), () {
//                             groupIdAndRelationInfo();
//                           }),
//                           Future.delayed(const Duration(milliseconds: 600), () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SwitchChat(
//                                         receiverId: widget.profileOwner,
//                                         receiverName: widget.mainFirstName,
//                                         receiverEmail: widget.mainEmail,
//                                         receiverAvatar: widget.mainProfileUrl,
//                                         myId: widget.currentUserId,
//                                         groupChatId: groupChatId,
//                                         inRelationShipId: relationShipData[
//                                             'inRelationshipWithId'],
//                                       )),
//                             );
//                           }),
//                         },
//                     child: Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             "Chat  ",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontFamily: "cutes",
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         Icon(
//                           Icons.chat_bubble_outline,
//                           size: 15,
//                         ),
//                       ],
//                     )));
//           }
//         }
//         return Padding(
//           padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
//           child: Center(
//             child: Text(
//               "Error in ChatList Relation",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'cute'),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   _datOfBirth() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Landing day On Earth",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Text(
//               Constants.dob,
//               style: TextStyle(fontFamily: "Names", color: Colors.grey),
//               textAlign: TextAlign.justify,
//               maxLines: 5,
//               softWrap: false,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _country() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Country",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Text(
//               "Pakistan",
//               style: TextStyle(fontFamily: "Names", color: Colors.grey),
//               textAlign: TextAlign.justify,
//               maxLines: 5,
//               softWrap: false,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _gender() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Gender",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             Text(
//               widget.mainGender,
//               style: TextStyle(fontFamily: "Names", color: Colors.grey),
//               textAlign: TextAlign.justify,
//               maxLines: 5,
//               softWrap: false,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _posts() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 10),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 widget.profileOwner == Constants.myId
//                     ? "Your Posts"
//                     : widget.mainFirstName + "'s" + " Posts",
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontFamily: 'cute',
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Icon(Icons.post_add),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           ProfilePosts(
//             profileOwner: widget.profileOwner,
//           ),
//         ],
//       ),
//     );
//   }
//
//   _followingButton() {
//     return SizedBox(
//       height: 45,
//       width: 90,
//       child: isFollowedByYou
//           ? FlatButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   side: BorderSide(color: Colors.white)),
//               color: Colors.lightBlue.withOpacity(0.3),
//               child: Text(
//                 "Following",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () => {
//                 setState(() {
//                   isFollowedByYou = false;
//                 }),
//
//                 // removeFollower
//                 followerReference
//                     .doc(widget.profileOwner)
//                     .collection("userFollower")
//                     .doc(widget.currentUserId)
//                     .get()
//                     .then((value) => {
//                           if (value.exists)
//                             {
//                               value.reference.delete(),
//                             }
//                         }),
//                 // remove Following
//
//                 followingReference
//                     .doc(widget.currentUserId)
//                     .collection("userFollowing")
//                     .doc(widget.profileOwner)
//                     .get()
//                     .then((value) => {
//                           if (value.exists)
//                             {
//                               value.reference.delete(),
//                             }
//                         }),
//
//                 // dl8 updateFeed
//                 // feedRtDatabaseReference
//                 //     .child(widget.profileOwner)
//                 //     .child("feedItems")
//                 //     .remove(),
//               },
//             )
//           : FlatButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   side: BorderSide(color: Colors.white)),
//               color: Colors.lightBlue.withOpacity(0.05),
//               onPressed: () => {
//                 setState(() {
//                   isFollowedByYou = true;
//                 }),
//
//                 // make Auth User follower of Another User (Update Their Follower Collection)
//
//                 ///this is who, who have been followed by other user
//                 ///this code will add a follower to his/her data base
//                 ProfileDataBase.makeFollower(
//                     widget.profileOwner, widget.currentUserId),
//
//                 /// this is who follow other user
//                 /// this code add a Following to his database
//                 ProfileDataBase.addFollowing(
//                     widget.currentUserId, widget.profileOwner),
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
//                 userFollowersRtd
//                     .child(widget.profileOwner)
//                     .child(widget.currentUserId)
//                     .set({
//                   'timestamp': DateTime.now().millisecondsSinceEpoch,
//                   'followerId': widget.currentUserId,
//                 })
//               },
//               child: Text(
//                 "Follow",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontFamily: 'cute',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.profileOwner == widget.currentUserId) {
//       return Column(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.linear_scale_sharp),
//                   ],
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _profilePicture(),
//                   Column(
//                     children: [
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 25),
//                             child: SizedBox(
//                               width: 80,
//                               child: Container(
//                                 padding: EdgeInsets.all(8.0),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Colors.grey.withOpacity(0.05),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       "CrushOn",
//                                       style: TextStyle(
//                                           fontFamily: "cutes",
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.lightBlue,
//                                           fontSize: 12),
//                                     ),
//                                     Text(
//                                       crushOnCount.toString(),
//                                       style: TextStyle(
//                                           fontFamily: "cute", fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 25),
//                             child: SizedBox(
//                               width: 80,
//                               child: Container(
//                                 padding: EdgeInsets.all(8.0),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(
//                                     5,
//                                   ),
//                                   color: Colors.grey.withOpacity(0.05),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       "Following",
//                                       style: TextStyle(
//                                           color: Colors.lightBlue,
//                                           fontFamily: "cutes",
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 12),
//                                     ),
//                                     Text(
//                                       followingCount.toString(),
//                                       style: TextStyle(
//                                           fontFamily: "cute", fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         width: 150,
//                         child: Text(
//                           widget.aboutMain,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontFamily: 'cute',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//
//               /// For Accept RealtionShip
//               SizedBox(
//                 height: 20,
//               ),
//               // toAcceptRelationShip(),
//               // _bio(),
//               // _gender(),
//               // _country(),
//               // _datOfBirth(),
//               _posts()
//             ],
//           ),
//         ],
//       );
//     } else {
//       /// This is For Other's Profile Panel ///
//
//       return Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.linear_scale_sharp),
//                     ],
//                   ),
//                 ),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _followingButton(),
//                     _profilePicture(),
//                     _conversationBox(),
//                   ],
//                 ),
//                 // _bio(),
//                 // _gender(),
//                 // _country(),
//                 // _datOfBirth(),
//                 _posts(),
//               ],
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }

///*****////
///
///
///

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slider_button/slider_button.dart';
import 'package:switchapp/pages/Profile/Panel/EditProfilePic.dart';
import 'package:switchapp/pages/Profile/Panel/followingPage.dart';
import 'package:switchapp/pages/Profile/RecentPosts.dart';
import 'package:switchapp/pages/Profile/body/Edit-Profile/EditProfile.dart';
import 'package:switchapp/pages/Profile/body/closFriendList/bestFriendList.dart';
import 'package:switchapp/pages/Profile/body/profieDecency/Buttons/CrushPage.dart';
import 'package:switchapp/pages/Profile/memeProfile/Meme-profile.dart';
import 'package:switchapp/pages/Profile/profileDataBase.dart';
import 'package:switchapp/pages/search/MainSearchPage.dart';
import 'package:switchapp/pages/chat/SwitchChat.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:switchapp/Universal/UniversalMethods.dart';
import 'package:uuid/uuid.dart';

import '../profilePosts.dart';
import 'CrushOn.dart';

class Panel extends StatefulWidget {
  final String profileOwner;
  final String currentUserId;
  final String mainProfileUrl;
  final String mainSecondName;
  final String mainFirstName;
  final String mainGender;
  final String mainEmail;
  final String aboutMain;
  final User user;
  final String username;

  const Panel(
      {required this.profileOwner,
      required this.currentUserId,
      required this.mainProfileUrl,
      required this.mainFirstName,
      required this.mainSecondName,
      required this.mainGender,
      required this.mainEmail,
      required this.aboutMain,
      required this.user,
      required this.username});

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  late String relationShipRequestSenderId;
  late String inRealtionshipWithFirstName;
  late String inRealtionshipWithSecondName;
  bool visitorIsAlreadyInRelationShip = false;
  bool isFollowedByYou = false;
  bool isFollowingYou = false;
  late String inRelationShipWithFirstNameToShow;
  late String inRelationShipWithSecondNameToShow;
  late String crushOnCount = "";
  late String groupChatId;
  String postId = Uuid().v4();
  UniversalMethods universalMethods = UniversalMethods();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCrushOnCount();
    checkIfFollowedByYou();
    getBestFriends();
  }

  getCrushOnCount() async {
    crushOnRTD
        .child(widget.profileOwner)
        .child("crushOnReference")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;

        data.length;
        String count = universalMethods.shortNumberGenrator(data.length);

        setState(() {
          crushOnCount = count;
        });
      } else {
        crushOnCount = "0";
      }
    });
  }

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

  _profilePicture() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black, width: 1),
        image: DecorationImage(
          image: NetworkImage(widget.mainProfileUrl),
        ),
      ),
    );
  }

  bool inRelationShip = false;
  bool pendingRelationShip = false;
  String relationShipRequestSenderName = "";
  String relationShipRequestSendToName = "";
  String relationShipRequestSendToId = "";
  bool youhaveToAccept = false;
  String inRelationshipWithFirstName = "";
  String inRelationshipWithId = "";
  String inRelationshipWithSecondName = "";

  _bio() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Bio",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              widget.aboutMain,
              style: TextStyle(fontFamily: "Names", color: Colors.grey),
              textAlign: TextAlign.justify,
              maxLines: 5,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  groupIdAndRelationInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      groupChatId = prefs.getString('groupChatId')!;
    });
  }

  _conversationBox() {
    return StreamBuilder(
      stream: relationShipReferenceRtd.child(widget.currentUserId).onValue,
      builder: (context, AsyncSnapshot dataSnapShot) {
        if (dataSnapShot.hasData) {
          DataSnapshot snapshot = dataSnapShot.data.snapshot;
          Map relationShipData = snapshot.value;

          if (relationShipData == null) {
          } else {
            return SizedBox(
                width: 90,
                height: 45,
                child: ElevatedButton(
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(8.0),
                    //     side: BorderSide(color: Colors.white)),
                    // color: Colors.lightBlue.withOpacity(0.05),
                    onPressed: () => {
                          FirebaseDatabase.instance
                              .reference()
                              .child("switchLastVisit-786")
                              .child(widget.profileOwner)
                              .child(Constants.myId)
                              .set({
                            'timeStamp': DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                          }),
                          Future.delayed(const Duration(milliseconds: 300), () {
                            groupIdAndRelationInfo();
                          }),
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
                                        groupChatId: groupChatId,
                                        inRelationShipId: relationShipData[
                                            'inRelationshipWithId'],
                                        listForSendButton: [],
                                        blockBy: '',
                                      )),
                            );
                          }),
                        },
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Chat  ",
                            style: TextStyle(
                               fontWeight: FontWeight.bold,
                              fontFamily: "cute",
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 15,
                        ),
                      ],
                    )));
          }
        }
        return Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.lightBlue,
            ),
          ),
        );
      },
    );
  }

  _posts() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 0),
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

                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.post_add,
                  color: Colors.lightBlue,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
            child: Text(
              "Show All Posts",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'cute',
                fontWeight: FontWeight.bold,

                color: Colors.lightBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _followingButton() {
    return SizedBox(
      height: 45,
      width: 90,
      child: isFollowedByYou
          ? ElevatedButton(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8.0),
              //     side: BorderSide(color: Colors.white)),
              // color: Colors.lightBlue.withOpacity(0.3),
              child: Text(
                "Following",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () => {
                setState(() {
                  isFollowedByYou = false;
                }),

                // removeFollower
                // followerReference
                //     .doc(widget.profileOwner)
                //     .collection("userFollower")
                //     .doc(widget.currentUserId)
                //     .get()
                //     .then((value) => {
                //           if (value.exists)
                //             {
                //               value.reference.delete(),
                //             }
                //         }),
                // remove Following

                // followingReference
                //     .doc(widget.currentUserId)
                //     .collection("userFollowing")
                //     .doc(widget.profileOwner)
                //     .get()
                //     .then((value) => {
                //           if (value.exists)
                //             {
                //               value.reference.delete(),
                //             }
                //         }),

                //Real TimeData Base

                userFollowingRtd
                    .child(widget.currentUserId)
                    .child(widget.profileOwner)
                    .remove(),
                userFollowersRtd
                    .child(widget.profileOwner)
                    .child(widget.currentUserId)
                    .remove()
              },
            )
          : ElevatedButton(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8.0),
              //     side: BorderSide(color: Colors.white)),
              // color: Colors.lightBlue.withOpacity(0.05),
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
                  'followingId': widget.profileOwner
                }),
                userFollowersRtd
                    .child(widget.profileOwner)
                    .child(widget.currentUserId)
                    .set({
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'followerId': widget.currentUserId,
                })
              },
              child: Text(
                "Follow",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'cute',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
    );
  }

  // editMyProfile() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 1.8,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(5.0),
  //       border: Border.all(color: Colors.blue.shade700, width: 1.5),
  //     ),
  //     child: GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => EditMyProfile(
  //               uid: widget.profileOwner,
  //               profileImage: widget.mainProfileUrl,
  //             ),
  //           ),
  //         );
  //       },
  //       child: Container(
  //         padding: EdgeInsets.all(5.0),
  //         child: Center(
  //           child: Text(
  //             "Edit Profile",
  //             style: TextStyle(
  //                 color: Colors.lightBlue.shade700,
  //                 fontFamily: 'cute',
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 12),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.profileOwner == widget.currentUserId) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.linear_scale_sharp),
              //     ],
              //   ),
              // ),

              // editMyProfile(),
              _bestiesList(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width/4.5,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                              padding: EdgeInsets.only(top: 9),
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
                                          color: Colors.lightBlue,
                                           fontWeight: FontWeight.bold,
                                          fontFamily: "cute",
                                          fontSize: 10),
                                    ),
                                    StreamBuilder(
                                      stream: userFollowingRtd
                                          .child(widget.currentUserId)
                                          .onValue,
                                      builder:
                                          (context, AsyncSnapshot dataSnapShot) {
                                        if (dataSnapShot.hasData) {
                                          DataSnapshot snapshot =
                                              dataSnapShot.data.snapshot;

                                          Map data = snapshot.value;

                                          if (data == null) {
                                            return Padding(
                                              padding:
                                              const EdgeInsets.only(top: 4),
                                              child: Text(
                                                "0",
                                                style: TextStyle(
                                                  fontFamily: 'cute',
                                                  color: Colors.lightBlue,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          } else {
                                            String following = universalMethods
                                                .shortNumberGenrator(data.length);
                                            return Padding(
                                              padding:
                                              const EdgeInsets.only(top: 3),
                                              child: Text(
                                                following,
                                                style: TextStyle(
                                                    fontFamily: 'cute',
                                                    fontSize: 12,
                                                    color: Colors.lightBlue
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Padding(
                                            padding:
                                            const EdgeInsets.only(top: 3),
                                            child: Text(
                                              "0",
                                              style: TextStyle(
                                                fontFamily: 'cute',
                                                color: Colors.lightBlue,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }
                                      },),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/4.5,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.lightBlue.withOpacity(0.09),


                          ),
                          height: 50,
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
                              padding: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      "CrushOn",
                                      style: TextStyle(
                                          fontFamily: "cute",
                                           fontWeight: FontWeight.bold,
                                          color: Colors.lightBlue,
                                          fontSize: 10),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        crushOnCount,
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontFamily: 'cute',
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
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
                                    mainAbout: widget.aboutMain,
                                    user: widget.user,
                                    navigateThrough: 'panel',
                                    username: widget.username,
                                  ),
                                ),
                              ),
                            ),
                          },
                          child: Container(

                            width: MediaQuery.of(context).size.width/4,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.lightBlue,


                            ),
                            height: 40,
                            child: Center(
                              child: Text(
                                "Meme Profile >>",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'cute',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              // _posts()
            ],
          ),
        ],
      );
    } else {
      /// This is For Other's Profile Panel ///

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       SizedBox(
                //         width: 70,
                //         child: GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => FollowingPage(
                //                   currentUserId: widget.currentUserId,
                //                   profileOwner: widget.profileOwner,
                //                 ),
                //               ),
                //             );
                //           },
                //           child: Container(
                //             padding: EdgeInsets.all(8.0),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(
                //                 5,
                //               ),
                //             ),
                //             child: Column(
                //               children: [
                //                 Text(
                //                   "Following",
                //                   style: TextStyle(
                //                       color: Colors.lightBlue,
                //                       fontFamily: "cute",
                //                       fontSize: 10),
                //                 ),
                //                 StreamBuilder(
                //                     stream: userFollowingRtd
                //                         .child(widget.profileOwner)
                //                         .onValue,
                //                     builder:
                //                         (context, AsyncSnapshot dataSnapShot) {
                //                       if (dataSnapShot.hasData) {
                //                         DataSnapshot snapshot =
                //                             dataSnapShot.data.snapshot;
                //
                //                         Map data = snapshot.value;
                //
                //                         if (data == null) {
                //                           return Text(
                //                             "0",
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 fontFamily: 'cute'),
                //                           );
                //                         } else {
                //                           return Text(
                //                             data.length.toString(),
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 fontFamily: 'cute'),
                //                           );
                //                         }
                //                       } else {
                //                         return Text(
                //                           "0",
                //                           style: TextStyle(
                //                               fontWeight: FontWeight.bold,
                //                               fontFamily: 'cute'),
                //                         );
                //                       }
                //                     }),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //       SizedBox(
                //         width: 70,
                //         child: GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => CrushOnPage(
                //                   currentUserId: widget.currentUserId,
                //                   profileOwner: widget.profileOwner,
                //                 ),
                //               ),
                //             );
                //           },
                //           child: Container(
                //             padding: EdgeInsets.all(8.0),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(5),
                //             ),
                //             child: Column(
                //               children: [
                //                 Text(
                //                   "CrushOn",
                //                   style: TextStyle(
                //                       fontFamily: "cute",
                //                       color: Colors.lightBlue,
                //                       fontSize: 10),
                //                 ),
                //                 Text(
                //                   crushOnCount,
                //                   style: TextStyle(
                //                       fontWeight: FontWeight.bold,
                //                       fontFamily: 'cute'),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //       // _conversationBox(),
                //     ],
                //   ),
                // ),
                // _memeProfile(),

                SizedBox(
                  height: friendsData == null ? 0 : 20,
                ),
                _bestiesList(),
              ],
            ),
          ),
        ],
      );
    }
  }

  Map? friendsData;
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
        friendsData!
            .forEach((index, data) => friendList.add({"key": index, ...data}));
      } else {
        setState(() {
          isFriendsData = true;
        });
      }
    });
  }

  _bestiesList() {
    return friendsData == null
        ? widget.currentUserId != widget.profileOwner
            ? Container(
                height: 0,
                width: 0,
              )
            // Column(
            //   children: [
            //     Container(
            //       height: 50,
            //       width: 50,
            //       child: Image.asset('images/profile/bestie-image.png'),
            //     ),
            //     Text(
            //       "No Bestie Yet",
            //       style: TextStyle(
            //           fontFamily: 'cute', fontSize: 12, color: Colors.lightBlue),
            //     ),
            //   ],
            // )

            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 20),
                    child: GestureDetector(
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
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.1,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,

                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.lightBlue, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add Bestie",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'cute',
                                  fontSize: 12),
                            ),  Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              )
        : SizedBox(
      width: MediaQuery.of(context).size.width/1.1,
          child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: widget.currentUserId == widget.profileOwner
                              ? EdgeInsets.only(left: 8, bottom: 10)
                              : EdgeInsets.only(left: 0, bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                child: Image.asset('images/profile/bestie-image.png'),
                              ),
                              Text(
                                "Besties",
                                style: TextStyle(
                                    fontFamily: 'cute',
                                    fontSize: 12,
                                    color: Colors.lightBlue),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: friendList.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(top: 15, left: 10),
                                    child: BestFriendList(
                                      index: index,
                                      bestFriendList: friendList,
                                    ),
                                  )),
                        ),
                      ],
                    ),
                  ),
        );
  }
}
