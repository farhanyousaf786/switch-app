// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
//
// class MemeProfile extends StatefulWidget {
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
//   const MemeProfile(
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
//   _MemeProfileState createState() => _MemeProfileState();
// }
//
// class _MemeProfileState extends State<MemeProfile> {
//   @override
//   Widget build(BuildContext context) {
//     appBar() {
//       return Padding(
//         padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => {
//                     Navigator.pop(context),
//                   },
//                   child: Icon(
//                     Icons.arrow_back_outlined,
//                   ),
//                 ),
//                 Container(
//                   width: 33,
//                   height: 33,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     border: Border.all(color: Colors.black, width: 1),
//                     image: DecorationImage(
//                       image: NetworkImage(widget.mainProfileUrl),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height / 5,
//                     color: Colors.black12,
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height / 12,
//                   ),
//                   Text(
//                     "Meme Decency",
//                     style: TextStyle(
//                       fontFamily: "Cute",
//                       color: Colors.black,
//                       fontSize: 12,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text(
//                       widget.mainFirstName + " " + widget.mainSecondName,
//                       style: TextStyle(
//                         fontFamily: "Cute",
//                         color: Colors.black,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Stack(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 20),
//                               child: Container(
//                                 width: 140,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                     color: Colors.lightBlue),
//                                 child: Center(
//                                   child: Text(
//                                     "Memer Ranking: #20",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontFamily: 'cute',
//                                         fontSize: 12),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                                 top: 30,
//                                 left: 60,
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         color: Colors.lightBlue.shade100,
//                                         border: Border.all(color: Colors.blue)),
//                                     height: 23,
//                                     width: 23,
//                                     child: Center(
//                                         child: Text(
//                                       "🌍",
//                                       style: TextStyle(fontSize: 12),
//                                     ))))
//                           ],
//                         ),
//                         Stack(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 20),
//                               child: Container(
//                                 width: 140,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                     color: Colors.lightBlue),
//                                 child: Center(
//                                   child: Text(
//                                     "Memer Ranking: #20",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontFamily: 'cute',
//                                         fontSize: 12),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                                 top: 30,
//                                 left: 60,
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         border: Border.all(color: Colors.blue),
//                                         color: Colors.lightBlue.shade100),
//                                     height: 23,
//                                     width: 23,
//                                     child: Center(
//                                         child: Text(
//                                       "🇵🇰",
//                                       style: TextStyle(fontSize: 12),
//                                     ))))
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               height: 60,
//               color: Colors.transparent,
//               child: Column(
//                 children: [
//                   appBar(),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 2.5,
//                 ),
//                 Stack(
//                   children: [
//                     Positioned(
//                       child: Container(
//                         width: 130,
//                         height: 130,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(72),
//                             border:
//                                 Border.all(color: Colors.transparent, width: 1),
//                             color: Colors.white),
//                       ),
//                     ),
//                     CircularPercentIndicator(
//                       radius: 130.0,
//                       lineWidth: 6,
//                       percent: 1,
//                       animation: true,
//                       animationDuration: 2000,
//                       startAngle: 180,
//                       center: new Text(
//                         "Not Rated",
//                         style:
//                             TextStyle(color: Colors.blue, fontFamily: 'cute'),
//                       ),
//                       progressColor: Colors.blue,
//                       circularStrokeCap: CircularStrokeCap.round,
//                       backgroundColor: Colors.white,
//                     ),
//                     Positioned(
//                       top: 85,
//                       left: 85,
//                       child: Container(
//                         width: 38,
//                         height: 38,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(40),
//                             border:
//                                 Border.all(color: Colors.blueAccent, width: 2),
//                             color: Colors.lightBlue),
//                         child: Center(
//                           child: Text(
//                             "50%",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: 'cute',
//                                 fontSize: 10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:ffi';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:rive/rive.dart';
// import 'package:switchtofuture/MainPages/Profile/memeProfile/AllShotMemes.dart';
// import 'package:switchtofuture/MainPages/Profile/memeProfile/wwRanking.dart';
// import 'package:switchtofuture/MainPages/TimeLine/timelinePosts.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
//
// import '../profilePosts.dart';
// import 'memeDecency.dart';
//
// class MemeProfile extends StatefulWidget {
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
//   const MemeProfile(
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
//   _MemeProfileState createState() => _MemeProfileState();
// }
//
// class _MemeProfileState extends State<MemeProfile> {
//   bool isMemer = false;
//   double profileRating = 0.0;
//   bool isFollowedByYou = false;
//   List posts = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkIfMemer();
//     checkIfFollowedByYou();
//     getMemeDecencyReport();
//
//     print("postsssss::::: >>>>> ${Constants.allMemes.length}");
//
//     // _getAllMeme();
//   }
//
// //   ProfilePosts profilePosts = ProfilePosts();
// //   _getAllMeme(){
// //
// // setState(() {
// //   posts = profilePosts.createState().posts;
// //
// // });
// // Future.delayed(const Duration(seconds: 2), () {
// //
// //     print("postsssss::::: >>>>> ${profilePosts.createState().posts.length}");
// //
// // });
// //
// //   }
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
//   checkIfMemer() async {
//     memeProfileRtd
//         .child(widget.profileOwner)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           isMemer = true;
//         });
//       } else {
//         setState(() {
//           isMemer = false;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     appBar() {
//       return Padding(
//         padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.black26),
//               child: Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => {
//                         Navigator.pop(context),
//                       },
//                       child: Icon(
//                         Icons.arrow_back_outlined,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Container(
//                         width: 33,
//                         height: 33,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(40),
//                           border: Border.all(color: Colors.white, width: 1),
//                           image: DecorationImage(
//                             image: NetworkImage(widget.mainProfileUrl),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     _decencyMeter() {
//       return Stack(
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(72),
//                 border: Border.all(color: Colors.transparent, width: 1),
//                 color: Colors.white),
//           ),
//           CircularPercentIndicator(
//             radius: 120.0,
//             lineWidth: 6,
//             percent: userMemePercentageDecency.toStringAsPrecision(3) == "NaN"
//                 ? 0
//                 : userMemePercentageDecency / 100,
//             animation: true,
//             animationDuration: 2000,
//             startAngle: 180,
//             center: new Text(
//               userMemeDecency.toString() == "NaN"
//                   ? "Not Rated"
//                   : userMemeDecency.toString() + " / 5",
//               style: TextStyle(
//                 color: Colors.lightBlue,
//                 fontFamily: 'cute',
//               ),
//             ),
//             progressColor: Colors.blue,
//             circularStrokeCap: CircularStrokeCap.round,
//             backgroundColor: userMemeDecency.toString() == "NaN"
//                 ? Colors.black54
//                 : Colors.white,
//           ),
//           Positioned(
//             top: 83,
//             left: 83,
//             child: Container(
//               width: 35,
//               height: 35,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(40),
//                   border: Border.all(color: Colors.blueAccent, width: 2),
//                   color: Colors.white),
//               child: Center(
//                 child: Text(
//                   userMemePercentageDecency.toString() == "NaN"
//                       ? "0%"
//                       : userMemePercentageDecency
//                               .toStringAsPrecision(3)
//                               .toString() +
//                           "%",
//                   style: TextStyle(
//                       color: Colors.lightBlue, fontFamily: 'cute', fontSize: 9),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//
//     _upperPage() {
//       return Column(
//         children: [
//           appBar(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [_decencyMeter()],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Meme Decency",
//               style: TextStyle(
//                 fontFamily: "Cute",
//                 color: Colors.white,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               widget.mainFirstName + " " + widget.mainSecondName,
//               style: TextStyle(
//                 fontFamily: "Cute",
//                 color: Colors.white,
//                 fontSize: 23,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 widget.currentUserId == widget.profileOwner
//                     ? _addMeme()
//                     : Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: _followingButton(),
//                       ),
//                 Container(
//                   width: 80,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(5)),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 8, right: 8, top: 5, bottom: 5),
//                     child: Column(
//                       children: [
//                         Text(
//                           "Followers",
//                           style: TextStyle(
//                               color: Colors.lightBlue,
//                               fontFamily: 'cute',
//                               fontSize: 11),
//                         ),
//                         StreamBuilder(
//                             stream: userFollowersRtd
//                                 .child(widget.profileOwner)
//                                 .onValue,
//                             builder: (context, dataSnapShot) {
//                               if (dataSnapShot.hasData) {
//                                 DataSnapshot snapshot =
//                                     dataSnapShot.data.snapshot;
//
//                                 Map data = snapshot.value;
//
//                                 if (data == null) {
//                                   return Text(
//                                     "0",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: 'cute',
//                                         color: Colors.lightBlue),
//                                   );
//                                 } else {
//                                   return Text(
//                                     data.length.toString(),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: 'cute',
//                                         color: Colors.lightBlue),
//                                   );
//                                 }
//                               } else {
//                                 return Text(
//                                   "0",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: 'cute',
//                                       color: Colors.lightBlue),
//                                 );
//                               }
//                             }),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Container(
//                     width: 80,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 8, right: 8, top: 5, bottom: 5),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Following",
//                             style: TextStyle(
//                                 color: Colors.lightBlue,
//                                 fontFamily: 'cute',
//                                 fontSize: 11),
//                           ),
//                           StreamBuilder(
//                               stream: userFollowingRtd
//                                   .child(widget.profileOwner)
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
//                                           fontFamily: 'cute',
//                                           color: Colors.lightBlue),
//                                     );
//                                   } else {
//                                     return Text(
//                                       data.length.toString(),
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontFamily: 'cute',
//                                           color: Colors.lightBlue),
//                                     );
//                                   }
//                                 } else {
//                                   return Text(
//                                     "0",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: 'cute',
//                                         color: Colors.lightBlue),
//                                   );
//                                 }
//                               }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }
//
//     _lowerPage() {
//       return Column(
//         children: [
//           Padding(
//             padding: widget.profileOwner == widget.currentUserId
//                 ? EdgeInsets.only(top: 10)
//                 : EdgeInsets.only(top: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 20),
//                       child: Material(
//                         elevation: 10,
//                         borderRadius: BorderRadius.circular(15),
//                         child: Container(
//                           width: 140,
//                           height: 40,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.lightBlue),
//                           child: Center(
//                             child: Text(
//                               "World Ranking",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontFamily: 'cute',
//                                   fontSize: 12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 30,
//                       left: 55,
//                       child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.blue, width: 3)),
//                           height: 25,
//                           width: 35,
//                           child: WorldRanking(
//                               profileOwner: widget.profileOwner,
//                               currentUserId: widget.currentUserId,
//                               mainProfileUrl: widget.mainProfileUrl,
//                               mainSecondName: widget.mainSecondName,
//                               mainFirstName: widget.mainFirstName,
//                               mainGender: widget.mainGender,
//                               mainEmail: widget.mainEmail,
//                               mainAbout: widget.mainAbout,
//                               user: widget.user)),
//                     )
//                   ],
//                 ),
//                 Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 20),
//                       child: Material(
//                         elevation: 10,
//                         borderRadius: BorderRadius.circular(15),
//                         child: Container(
//                           width: 140,
//                           height: 40,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.lightBlue),
//                           child: Center(
//                             child: Text(
//                               "Country Ranking",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontFamily: 'cute',
//                                   fontSize: 12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                         top: 30,
//                         left: 55,
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.white,
//                                 border:
//                                     Border.all(color: Colors.blue, width: 3)),
//                             height: 25,
//                             width: 35,
//                             child: Center(
//                                 child: Text(
//                               "#10",
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.lightBlue,
//                                   fontWeight: FontWeight.w500),
//                             ))))
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 50, bottom: 20),
//             child: Text(
//               "Memes By ${widget.mainFirstName}",
//               style: TextStyle(
//                 color: Colors.lightBlue,
//                 fontFamily: 'cute',
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           allMeme(),
//         ],
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: widget.profileOwner == widget.currentUserId
//             ? SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height / 2.5,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage("images/memeProfile/memeBg.png"),
//                             fit: BoxFit.cover),
//                       ),
//                       child: Container(
//                         child: _upperPage(),
//                       ),
//                     ),
//                     _lowerPage(),
//                   ],
//                 ),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height / 2.5,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage("images/memeProfile/memeBg.png"),
//                             fit: BoxFit.cover),
//                       ),
//                       child: Container(
//                         child: _upperPage(),
//                       ),
//                     ),
//                     MemeDecency(
//                       mainId: widget.currentUserId,
//                       profileId: widget.profileOwner,
//                       onPressedButton2: getMemeDecencyReport,
//                     ),
//                     _lowerPage(),
//                   ],
//                 ),
//               ),
//       ),
//     );
//     // : Scaffold(
//     //     body: SafeArea(
//     //       child: Container(
//     //         color: Colors.white,
//     //         child: Column(
//     //           children: [
//     //             appBar(),
//     //             SizedBox(
//     //               height: 10,
//     //             ),
//     //             Stack(
//     //               children: [
//     //                 Container(
//     //                   height: 200,
//     //                   width: 200,
//     //                   child: RiveAnimation.asset(
//     //                       "images/memeProfile/memeC1.riv"),
//     //                 ),
//     //                 Positioned(
//     //                   top: MediaQuery.of(context).size.height / 21,
//     //                   left: MediaQuery.of(context).size.width / 23,
//     //                   child: Column(
//     //                     children: [
//     //                       Text(
//     //                         "Yo!",
//     //                         style: TextStyle(
//     //                             color: Colors.white,
//     //                             fontSize: 10,
//     //                             fontFamily: 'cute'),
//     //                       ),
//     //                       Text(
//     //                         "Welcome",
//     //                         style: TextStyle(
//     //                             color: Colors.white,
//     //                             fontSize: 10,
//     //                             fontFamily: 'cute'),
//     //                       ),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),
//     //             Padding(
//     //               padding: const EdgeInsets.all(8.0),
//     //               child: Padding(
//     //                 padding: const EdgeInsets.all(8.0),
//     //                 child: Text(
//     //                   "This is a meme checking point. BTW, Welcome to Memevers",
//     //                   textAlign: TextAlign.center,
//     //                   style: TextStyle(
//     //                       color: Colors.black87,
//     //                       fontSize: 20,
//     //                       fontFamily: 'cute'),
//     //                 ),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: const EdgeInsets.all(8.0),
//     //               child: Padding(
//     //                 padding: const EdgeInsets.all(8.0),
//     //                 child: GestureDetector(
//     //                   onTap: () {
//     //                     setState(() {
//     //                       isMemer = true;
//     //                     });
//     //                     memeProfileRtd.child(widget.profileOwner).update({
//     //                       "isMemer": "Yes",
//     //                     });
//     //                   },
//     //                   child: Container(
//     //                     height: 75,
//     //                     width: 100,
//     //                     decoration: BoxDecoration(
//     //                       color: Colors.grey,
//     //                       borderRadius: BorderRadius.circular(10),
//     //                     ),
//     //                     child: Center(
//     //                       child: Text(
//     //                         "OK",
//     //                         textAlign: TextAlign.center,
//     //                         style: TextStyle(
//     //                             color: Colors.black87,
//     //                             fontSize: 20,
//     //                             fontFamily: 'cute'),
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   );
//   }
//
//   _addMeme() {
//     return SizedBox(
//         height: 35,
//         width: 90,
//         child: ElevatedButton(
//           child: Text(
//             "Upload",
//             style: TextStyle(
//                 color: Colors.lightBlue, fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//               primary: Colors.white,
//               textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//         ));
//   }
//
//   _followingButton() {
//     return SizedBox(
//       height: 30,
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
//                   color: Colors.lightBlue,
//                   fontFamily: 'cute',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.white,
//                 textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               ),
//             ),
//     );
//   }
//
//   double userMemePercentageDecency = 0;
//
//   double userMemeDecency = 0;
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
//   getMemeDecencyReport() {
//     Map data;
//
//     memeProfileRtd
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
//         userMemeDecency = ((5 * counterForFive +
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
//         userMemePercentageDecency = (userMemeDecency / 5) * 100;
//
//         widget.profileOwner == widget.currentUserId
//             ? upDateOwnDecency()
//             : upDateProfileDecency();
//       }
//     });
//   }
//
//   upDateOwnDecency() {
//
//
//     memerPercentageDecencyRtd.child(widget.currentUserId).update({
//       "PercentageDecency": userMemePercentageDecency,
//     });
//   }
//
//   upDateProfileDecency() {
//     memerPercentageDecencyRtd.child(widget.profileOwner).update({
//       "PercentageDecency": userMemePercentageDecency,
//     });
//   }
//
//   allMeme() {
//     return Constants.allMemes.length == 0
//         ? Padding(
//             padding: const EdgeInsets.only(top: 30),
//             child: Text(
//               "There is no Meme Create by ${widget.mainFirstName} yet",
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontFamily: 'cute',
//               ),
//             ),
//           )
//         : ListView.builder(
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             reverse: true,
//             itemCount: Constants.allMemes.length,
//             itemBuilder: (context, index) => Provider<User>.value(
//               value: widget.user,
//               child: TimelinePosts(
//                 index: index,
//                 posts: Constants.allMemes,
//                 type: "meme",
//               ),
//             ),
//           );
//   }
// }

///
///
///

/// code 2065 error
import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/MainPages/Profile/MemePosts/MemePosts.dart';
import 'package:switchapp/MainPages/Profile/memeProfile/rankingHorizontalList/rankingList.dart';
import 'package:switchapp/MainPages/TimeLineSwitch/MainFeed/MainFeed.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:switchapp/Models/surpriseMeme.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:uuid/uuid.dart';

import '../../../Universal/Constans.dart';
import '../../../Universal/DataBaseRefrences.dart';
import '../../../Universal/UniversalMethods.dart';
import '../../Upload/addStatuse.dart';
import '../../Upload/videoStatus.dart';
import '../Panelandbody.dart';
import 'memeShowCase/memeShowCase.dart';
import 'memerRanking/memeDecency.dart';
import 'memerRanking/wwRanking.dart';
import 'memerSearch/memerSearch.dart';
import '../../TimeLineSwitch/MemeAndStuff/memeCompetition/memeComp.dart';

UniversalMethods universalMethods = UniversalMethods();

class MemeProfile extends StatefulWidget {
  final String profileOwner;
  final String currentUserId;
  final String mainProfileUrl;
  final String mainSecondName;
  final String mainFirstName;
  final String mainGender;
  final String mainEmail;
  final String mainAbout;
  final User user;
  final navigateThrough;
  final String username;

  const MemeProfile(
      {required this.profileOwner,
      required this.currentUserId,
      required this.mainProfileUrl,
      required this.mainFirstName,
      required this.mainSecondName,
      required this.mainGender,
      required this.mainEmail,
      required this.mainAbout,
      required this.user,
      required this.navigateThrough,
      required this.username});

  @override
  _MemeProfileState createState() => _MemeProfileState();
}

class _MemeProfileState extends State<MemeProfile> {
  bool isMemer = false;
  double profileRating = 0.0;
  bool isFollowedByYou = false;
  late int followingsCounter;
  bool isLoading = true;
  int takePart = 0;
  int slits = 0;
  String shortSlit = "0";
  int withdrawnSlits = 0;
  int availible = 0;
  String levelLink = "";
  String levelLogo = "";
  String postId = Uuid().v4();

  UniversalMethods universalMethods = UniversalMethods();
  late Map slitData;
  late Map compData;

  @override
  void initState() {
    super.initState();

    checkIfFollowedByYou();

    getMemeDecencyReport();

    _getMemerDetail();

    controlNotificationToastForMessages();

    _getMemerLevel();

    ///Slit is here
    // checkMemeCompAndSlits();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (Constants.isIntroForMemeProfile == "true") {
        showIntro();
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  _getMemerLevel() {
    userFollowersRtd
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map followerCount = dataSnapshot.value;

      if (dataSnapshot.exists) {
        print(
            " followers.................................. ${followerCount.length}");

        if (followerCount.length >= 0 && followerCount.length < 100) {
          setState(() {
            levelLink =
                "https://switchappimages.nyc3.digitaloceanspaces.com/MemerTags/levelZero.png";
            levelLogo = "images/level_images/level_zero.json";
          });
        } else if (followerCount.length >= 100 && followerCount.length < 1000) {
          setState(() {
            levelLink =
                "https://switchappimages.nyc3.digitaloceanspaces.com/MemerTags/levelPlanet.png";
            levelLogo = "images/level_images/level_planet.json";
          });
        } else if (followerCount.length >= 1000 &&
            followerCount.length < 10000) {
          setState(() {
            levelLink =
                "https://switchappimages.nyc3.digitaloceanspaces.com/MemerTags/levelSolar.png";
            levelLogo = "images/level_images/level_solar.json";
          });
        } else if (followerCount.length >= 10000) {
          setState(() {
            levelLink =
                "https://switchappimages.nyc3.digitaloceanspaces.com/MemerTags/levelGalaxy.png";
            levelLogo = "images/level_images/level_galaxy.json";
          });
        }
      } else {
        setState(() {
          levelLink =
              "https://switchappimages.nyc3.digitaloceanspaces.com/MemerTags/levelZero.png";
          levelLogo = "images/level_images/level_zero.json";
        });
      }
    });
  }

  ///Slit is here
  // checkMemeCompAndSlits() {
  //   switchMemerSlitsRTD
  //       .child(widget.profileOwner)
  //       .once()
  //       .then((DataSnapshot dataSnapshot) {
  //     if (dataSnapshot.exists) {
  //       switchMemerSlitsRTD
  //           .child(widget.profileOwner)
  //           .once()
  //           .then((DataSnapshot dataSnapshot) {
  //         slitData = dataSnapshot.value;
  //         slits = slitData['totalSlits'];
  //
  //         shortSlit =
  //             universalMethods.shortNumberGenrator(slitData['totalSlits']);
  //
  //         if (slitData['withdrawn'] == null) {
  //           switchMemerSlitsRTD.child(widget.profileOwner).update({
  //             'withdrawn': 0,
  //           });
  //         } else {
  //           withdrawnSlits = slitData['withdrawn'];
  //         }
  //
  //         setState(() {});
  //       });
  //
  //       switchMemeCompRTD
  //           .child(widget.profileOwner)
  //           .once()
  //           .then((DataSnapshot dataSnapshot) {
  //         if (dataSnapshot.exists) {
  //           compData = dataSnapshot.value;
  //           takePart = compData['takePart'];
  //           setState(() {
  //             takePart = takePart;
  //           });
  //         }
  //       });
  //
  //       Future.delayed(const Duration(milliseconds: 1000), () {
  //         setState(() {
  //           availible = slits - withdrawnSlits;
  //           print("availible : : : : : :  $availible");
  //         });
  //       });
  //     } else {
  //       switchMemerSlitsRTD.child(widget.profileOwner).set({
  //         'withdrawn': 0,
  //         'totalSlits': 0,
  //       });
  //     }
  //   });
  // }

  controlNotificationToastForMessages() {
    setState(() {
      Constants.notifyCounter = 1;
    });
  }

  List allMemerList = [];

  _getMemerDetail() {
    userFollowersCountRtd.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        late Map data;

        setState(() {
          data = dataSnapshot.value;
        });

        data.forEach(
            (index, data) => allMemerList.add({"key": index, ...data}));

        allMemerList.sort((a, b) {
          return b["followerCounter"].compareTo(a['followerCounter']);
        });

        Random random = new Random();
        int limitForUser = random.nextInt(100);
        if (Constants.switchId == allMemerList[0]['uid']) {
          allMemerList.removeAt(0);
        }

        setState(() {});
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
      } else {
        userFollowersCountRtd.child(widget.profileOwner).update({
          "followerCounter": 0,
          "uid": widget.profileOwner,
          "username": widget.username,
          "photoUrl": widget.mainProfileUrl,
        });
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

  checkIfMemer() async {
    memeProfileRtd
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          isMemer = true;
        });
      } else {
        setState(() {
          isMemer = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appBar() {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 8, bottom: 0, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlue.shade400),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.pop(context),
                      },
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white, width: 1),
                          image: DecorationImage(
                            image: NetworkImage(widget.mainProfileUrl != null
                                ? widget.mainProfileUrl
                                : "https://switchappimages.nyc3.digitaloceanspaces.com/StaticUse/1646080905939.jpg"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => {
                    _whatIf(),
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "What If?",
                      style: TextStyle(
                          color: Colors.lightBlue, fontSize: 16, fontFamily: 'cute'),
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 10, bottom: 10),
            //   child: Text(
            //     "Art of ${widget.mainFirstName}",
            //     style: TextStyle(
            //       color: Colors.lightBlue,
            //       fontFamily: 'cute',
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    }

    _decencyMeter() {
      return Stack(
        children: [
          CircularPercentIndicator(
            radius: 90.0,
            lineWidth: 6,
            percent: userMemePercentageDecency.toStringAsPrecision(2) == "NaN"
                ? 0
                : userMemePercentageDecency / 100,
            animation: true,
            animationDuration: 1800,
            startAngle: 180,
            center: new Text(
              userMemeDecency.toString() == "NaN"
                  ? "Not Rated"
                  : userMemeDecency.toStringAsPrecision(3) + " / 5.0",
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 8,
                fontFamily: 'cute',
              ),
            ),
            progressColor: Colors.blue,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: userMemeDecency.toString() == "NaN"
                ? Colors.blue.shade300
                : Colors.black12,
          ),
          Positioned(
            top: 60,
            left: 60,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: userMemePercentageDecency.toString() == "NaN"
                          ? Colors.blue.shade300
                          : Colors.blue,
                      width: 2),
                  color: Colors.white),
              child: Center(
                child: Text(
                  userMemePercentageDecency.toString() == "NaN"
                      ? "0%"
                      : userMemePercentageDecency
                              .toStringAsPrecision(3)
                              .toString() +
                          "%",
                  style: TextStyle(
                      color: Colors.lightBlue, fontFamily: 'cute', fontSize: 6),
                ),
              ),
            ),
          ),
        ],
      );
    }

    _upperPage() {
      return Material(
        elevation: 10,
        color: Constants.isDark == "true" ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            widget.navigateThrough == "direct"
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : appBar(),
            SizedBox(
              height: 20,
            ),
            Row(
              key: memeDecencyIntro,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_decencyMeter()],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Text(
                "Meme Decency",
                style: TextStyle(
                   fontWeight: FontWeight.bold,

                  fontFamily: "Cute",
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.currentUserId == widget.profileOwner
                      ? _addMeme()
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: _followingButton(),
                        ),
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    elevation: 2,
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        child: Column(
                          children: [
                            Text(
                              "Followers",
                              style: TextStyle(fontFamily: 'cute', fontSize: 8),
                            ),
                            StreamBuilder(
                                stream: userFollowersRtd
                                    .child(widget.profileOwner)
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
                                            fontSize: 10),
                                      );
                                    } else {
                                      String followers = universalMethods
                                          .shortNumberGenrator(data.length);

                                      return Text(
                                        followers,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'cute',
                                            fontSize: 10),
                                      );
                                    }
                                  } else {
                                    return Text(
                                      "0",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'cute',
                                          fontSize: 12),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () => {
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
                                    MediaQuery.of(context).size.height / 1.3,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      BarTop(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Monthly Prize",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.lightBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Monthly prize will be distribute to only TOP 3 memers on day 10 of every month.",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'cute',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      universalMethods.prizeDistribution(),

                                      ///

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Divider(
                                          thickness: 2,
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Competition Prize",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.lightBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Weekly prize will be distribute to those 2 memer who get more reacts on their memes through meme competition.",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'cute',
                                            fontWeight: FontWeight.bold,
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
                                                  "Prize for winner # 1  = 1500 pkr",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'cute',
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                                child: Flexible(
                                                    child: Text(
                                              "Prize for winner # 2  = 1000 pkr",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'cute',
                                                  fontSize: 18),
                                            ))),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Note: Currently, Memers can withdraw prize money through JAZZCASH. Winners will be announce at the end of competition.",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'cute',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          })
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      elevation: 2,
                      child: Container(
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue.shade100.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 5, bottom: 5),
                          child: Column(
                            children: [
                              Text(
                                "Memers",
                                style:
                                    TextStyle(fontFamily: 'cute', fontSize: 9),
                              ),
                              Text(
                                "Prize",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'cute',
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///This is slit button
                  // TextButton(
                  //   onPressed: () => {
                  //     widget.user.uid == widget.profileOwner
                  //         ? showModalBottomSheet(
                  //             useRootNavigator: true,
                  //             isScrollControlled: true,
                  //             barrierColor: Colors.red.withOpacity(0.2),
                  //             elevation: 0,
                  //             clipBehavior: Clip.antiAliasWithSaveLayer,
                  //             context: context,
                  //             builder: (context) {
                  //               return Container(
                  //                   height: MediaQuery.of(context).size.height /
                  //                       1.5,
                  //                   child: SingleChildScrollView(
                  //                     child: Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                         children: [
                  //                           Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(5.0),
                  //                             child: Row(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.center,
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.center,
                  //                               children: [
                  //                                 Icon(
                  //                                     Icons.linear_scale_sharp),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(8.0),
                  //                             child: Column(
                  //                               children: [
                  //                                 Row(
                  //                                   children: [
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(8.0),
                  //                                       child: Text(
                  //                                         "Total Slits: ",
                  //                                         style: TextStyle(
                  //                                           fontSize: 18,
                  //                                           fontFamily: 'cute',
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(8.0),
                  //                                       child: Text(
                  //                                         slits.toString(),
                  //                                         style: TextStyle(
                  //                                             fontFamily:
                  //                                                 'cute',
                  //                                             fontSize: 15),
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(8.0),
                  //                                       child: Text(
                  //                                         "Withdrawn: ",
                  //                                         style: TextStyle(
                  //                                           fontSize: 18,
                  //                                           fontFamily: 'cute',
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(8.0),
                  //                                       child: Text(
                  //                                         withdrawnSlits
                  //                                             .toString(),
                  //                                         style: TextStyle(
                  //                                             fontFamily:
                  //                                                 'cute',
                  //                                             fontSize: 15),
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(8.0),
                  //                                       child: Text(
                  //                                         "Available: ",
                  //                                         style: TextStyle(
                  //                                           fontSize: 18,
                  //                                           fontFamily: 'cute',
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(8.0),
                  //                                       child: Text(
                  //                                         availible.toString(),
                  //                                         style: TextStyle(
                  //                                             fontFamily:
                  //                                                 'cute',
                  //                                             fontSize: 15),
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 )
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Center(
                  //                               child: TextButton(
                  //                                   onPressed: () => {
                  //                                         bottomSheetForWithdraw(),
                  //                                       },
                  //                                   child: Text(
                  //                                     "Tap to Withdraw",
                  //                                     style: TextStyle(
                  //                                         fontFamily: 'cute',
                  //                                         color: Colors
                  //                                             .green.shade700,
                  //                                         fontSize: 16),
                  //                                   ))),
                  //                           Divider(
                  //                             thickness: 1,
                  //                           ),
                  //                           Padding(
                  //                             padding: const EdgeInsets.only(
                  //                                 left: 20, top: 8),
                  //                             child: Row(
                  //                               children: [
                  //                                 Text(
                  //                                   "Important:",
                  //                                   style: TextStyle(
                  //                                       fontFamily: 'cute',
                  //                                       color: Colors.lightBlue,
                  //                                       fontSize: 20),
                  //                                 )
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(8.0),
                  //                             child: SingleChildScrollView(
                  //                               scrollDirection:
                  //                                   Axis.horizontal,
                  //                               child: Row(
                  //                                 children: [
                  //                                   Container(
                  //                                     child: Center(
                  //                                         child: Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(8.0),
                  //                                       child: Text(
                  //                                         "1) 100 Slits = 1 PKR.\n\n"
                  //                                         "2) Minimum Withdrawal will be 10,000 Slits.\n\n"
                  //                                         "3) 1 post on Meme competition = 1000 slit.\n\n"
                  //                                         "4) 1 up react on meme post = 1 slit.\n\n"
                  //                                         "5) Down react will not count for slit.\n\n"
                  //                                         "6) If You delete any Meme after post, it may cause -10 slits.\n\n"
                  //
                  //                                         //"6) Read Al-Quran verse = 10 slits, in Islam Section.\n\n"
                  //                                         "7) Slits conversion to pkr can vary according to scenarios.\n\n"
                  //                                         "8) Switch team will verify through our super database and user activity if it has legal slits or just user tricked to earn slits.\n\n"
                  //                                         "9) If we catch any user, playing any trick to earn Slits, will Ban permanently.\n\n"
                  //                                         "10) Switch App has rights to make changes in Slit policy anytime.\n\n",
                  //                                         softWrap: true,
                  //                                         textAlign:
                  //                                             TextAlign.left,
                  //                                         style: TextStyle(
                  //                                           fontSize: 12,
                  //                                           fontFamily: 'cute',
                  //                                         ),
                  //                                       ),
                  //                                     )),
                  //                                     width:
                  //                                         MediaQuery.of(context)
                  //                                             .size
                  //                                             .width,
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ]),
                  //                   ));
                  //             })
                  //         : Container(
                  //             height: 0,
                  //             width: 0,
                  //           ),
                  //   },
                  //   child: Material(
                  //     key: slitsIntro,
                  //     borderRadius: BorderRadius.circular(5),
                  //     elevation: 2,
                  //     child: Container(
                  //       width: 90,
                  //       decoration: BoxDecoration(
                  //           color: Colors.lightBlue.shade100.withOpacity(0.4),
                  //           borderRadius: BorderRadius.circular(5)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(
                  //             left: 8, right: 8, top: 5, bottom: 5),
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               "Total Slits",
                  //               style: TextStyle(
                  //                   fontFamily: 'cute',
                  //                   fontSize: 8),
                  //             ),
                  //             Text(
                  //               shortSlit,
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontFamily: 'cute',
                  //                   fontSize: 10),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: TextButton(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 3,
                  key: memeCompetitionIntro,
                  color: Constants.isDark == "true"
                      ? Colors.grey.shade800
                      : Colors.blue,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 38,
                    width: MediaQuery.of(context).size.width / 1.35,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                        child: Text(
                          "<< Memes Competition >>",
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'cute',
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<User>.value(
                        value: widget.user,
                        child: MemeComp(
                          user: widget.user,
                        ),
                      ),
                    ),
                  ),
                },
              ),
            ),
            TextButton(
              onPressed: () => {
                bottomSheetForMemerLevels(),
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  levelLink == ""
                      ? Text("")
                      : Shimmer.fromColors(
                          baseColor: Colors.purpleAccent.shade200,
                          highlightColor: Colors.purple.shade700,
                          child: CachedNetworkImage(
                            key: levelIntro,
                            imageUrl: levelLink,
                            placeholder: (context, url) => Container(
                              child: Text(""),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            height: 60,
                            width: 100,
                          ),
                        ),
                  levelLogo == ""
                      ? Text("")
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: SizedBox(
                            child: Lottie.asset(
                              levelLogo,
                            ),
                            height: 70,
                            width: 70,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    _lowerPage() {
      return Column(
        children: [

          // Padding(
          //   padding: const EdgeInsets.only(top: 20, bottom: 0),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Material(
          //           borderRadius: BorderRadius.circular(15),
          //           elevation: 2,
          //           shadowColor: Colors.grey,
          //           child: GestureDetector(
          //             onTap: () => {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => MemeComp(
          //                             user: widget.user,
          //                           ))),
          //             },
          //             child: Container(
          //               padding: EdgeInsets.all(4),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(8),
          //                 color: Colors.lightBlue,
          //               ),
          //               height: 40,
          //               width: MediaQuery.of(context).size.width / 2.5,
          //               child: Padding(
          //                 padding: const EdgeInsets.all(6.0),
          //                 child: Center(
          //                   child: Text(
          //                     "Meme Competition",
          //                     style: TextStyle(
          //                         fontSize: 12,
          //                         fontFamily: 'cute',
          //                         color: Colors.white),
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 20,
          //         ),
          //         Material(
          //           borderRadius: BorderRadius.circular(15),
          //           elevation: 2,
          //           shadowColor: Colors.grey,
          //           child: GestureDetector(
          //             onTap: () => {
          //               showModalBottomSheet(
          //                   useRootNavigator: true,
          //                   isScrollControlled: true,
          //                   barrierColor: Colors.red.withOpacity(0.2),
          //                   elevation: 0,
          //                   clipBehavior: Clip.antiAliasWithSaveLayer,
          //                   context: context,
          //                   builder: (context) {
          //                     return Container(
          //                       height: MediaQuery.of(context).size.height / 3,
          //                       child: SingleChildScrollView(
          //                         child: Column(
          //                           children: [
          //                             Padding(
          //                               padding: const EdgeInsets.all(5.0),
          //                               child: Row(
          //                                 crossAxisAlignment:
          //                                     CrossAxisAlignment.center,
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                 children: [
          //                                   Icon(Icons.linear_scale_sharp),
          //                                 ],
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Text(
          //                                 "Meme Crown will open when we reach 5000+ user in Switch App & Participant must have 100+ follower.",
          //                                 textAlign: TextAlign.center,
          //                                 style: TextStyle(
          //                                     fontSize: 15,
          //                                     fontFamily: "cutes",
          //                                     fontWeight: FontWeight.bold,
          //                                     color: Colors.lightBlue),
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Text(
          //                                 "What is Meme Crown?",
          //                                 textAlign: TextAlign.center,
          //                                 style: TextStyle(
          //                                     fontSize: 15,
          //                                     fontFamily: "cutes",
          //                                     fontWeight: FontWeight.bold,
          //                                     color: Colors.green),
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Text(
          //                                 "Meme Crow will Show the activity of Switch App Memers, For Example: Top Memers, Memer of the week, Pro Tags etc",
          //                                 textAlign: TextAlign.center,
          //                                 style: TextStyle(
          //                                     fontSize: 15,
          //                                     fontFamily: "cutes",
          //                                     fontWeight: FontWeight.bold,
          //                                     color: Colors.grey),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   }),
          //             },
          //             child: Container(
          //               padding: EdgeInsets.all(4),
          //               height: 40,
          //               width: MediaQuery.of(context).size.width / 2.5,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(8),
          //                 color: Colors.lightBlue,
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(6.0),
          //                 child: Center(
          //                   child: Text(
          //                     "Meme Crown",
          //                     style: TextStyle(
          //                         fontSize: 12,
          //                         fontFamily: 'cute',
          //                         color: Colors.white),
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          SizedBox(
            height: 10,
          ),
          widget.navigateThrough == "direct"
              ? Padding(
                  key: topMemersIntro,
                  padding: const EdgeInsets.only(
                      bottom: 8, right: 5, left: 5, top: 10),
                  child: Text(
                    "Top 100 Memer",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'cute',
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
          widget.navigateThrough == "direct"
              ? top100Memers()
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
          widget.profileOwner == widget.currentUserId
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(
                  height: 0,
                ),

          // Padding(
          //   padding: widget.profileOwner == widget.currentUserId
          //       ? EdgeInsets.only(top: 8)
          //       : EdgeInsets.only(top: 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       widget.profileOwner == widget.currentUserId
          //           ? Container(
          //               width: MediaQuery.of(context).size.width,
          //               height: 50,
          //               color: Colors.lightBlue,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(bottom: 1),
          //                     child: Text(
          //                       "Memers Ranking # ",
          //                       style: TextStyle(
          //                           color: Colors.white,
          //                           fontFamily: 'cute',
          //                           fontSize: 15),
          //                     ),
          //                   ),
          //                   Container(
          //                     decoration: BoxDecoration(
          //                         color: Colors.white,
          //                         borderRadius: BorderRadius.circular(12)),
          //                     height: 30,
          //                     width: 75,
          //                     child: WorldRanking(
          //                         profileOwner: widget.profileOwner,
          //                         currentUserId: widget.currentUserId,
          //                         mainProfileUrl: widget.mainProfileUrl,
          //                         mainSecondName: widget.mainSecondName,
          //                         mainFirstName: widget.mainFirstName,
          //                         mainGender: widget.mainGender,
          //                         mainEmail: widget.mainEmail,
          //                         mainAbout: widget.mainAbout,
          //                         user: widget.user),
          //                   )
          //                 ],
          //               ),
          //             )
          //           : Container(),
          //     ],
          //   ),
          // ),
          widget.navigateThrough == "direct"
              ? Container(
                  height: 0,
                  color: Colors.grey.shade100,
                )
              : SizedBox(
                  height: 0,
                ),
          memeGallery(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Memes by ${widget.mainFirstName}",
                      style: TextStyle(
                          color: Colors.lightBlue, fontFamily: 'cute', fontSize: 17),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandingPage(),
                    ),
                  ),
                },
                child: Row(
                  children: [
                    Text(
                      "Refresh ",
                      style: TextStyle(
                          color: Colors.lightBlue, fontFamily: 'cute', fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.refresh_sharp,
                        color: Colors.lightBlue,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              height: MediaQuery.of(context).size.height / 1.3,
              child:
                  AllMemePosts(user: widget.user, UserId: widget.profileOwner)),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SafeArea(
                child: widget.profileOwner == widget.currentUserId
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            isLoading
                                ? LinearProgressIndicator()
                                : SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            _upperPage(),
                            _lowerPage(),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // appBar(),
                            SizedBox(
                              height: 20,
                            ),
                            _upperPage(),
                            SizedBox(
                              height: 8,
                            ),
                            MemeDecency(
                              mainId: widget.currentUserId,
                              profileId: widget.profileOwner,
                              onPressedButton2: getMemeDecencyReport,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10),
                            //   child: Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 50,
                            //     color: Colors.lightBlue,
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.only(bottom: 2),
                            //           child: Text(
                            //             "Memers Ranking #",
                            //             style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontFamily: 'cute',
                            //                 fontSize: 18),
                            //           ),
                            //         ),
                            //         Padding(
                            //           padding: const EdgeInsets.all(4.0),
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //                 color: Colors.white,
                            //                 borderRadius:
                            //                     BorderRadius.circular(12)),
                            //             height: 35,
                            //             width: 80,
                            //             child: WorldRanking(
                            //                 profileOwner: widget.profileOwner,
                            //                 currentUserId: widget.currentUserId,
                            //                 mainProfileUrl:
                            //                     widget.mainProfileUrl,
                            //                 mainSecondName:
                            //                     widget.mainSecondName,
                            //                 mainFirstName: widget.mainFirstName,
                            //                 mainGender: widget.mainGender,
                            //                 mainEmail: widget.mainEmail,
                            //                 mainAbout: widget.mainAbout,
                            //                 user: widget.user),
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // MemeDecency(
                            //   mainId: widget.currentUserId,
                            //   profileId: widget.profileOwner,
                            //   onPressedButton2: getMemeDecencyReport,
                            // ),
                            _lowerPage(),
                          ],
                        ),
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Constants.isDark == "true"
                    ? Colors.grey.shade900
                    : Colors.blue,
                child: Row(
                  key: rankingIntro,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        "Memers Ranking #",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'cute',
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Constants.isDark == "true"
                                ? Colors.grey.shade900
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            border: Border.all(color: Colors.grey.shade800)),
                        height: 35,
                        width: 80,
                        child: WorldRanking(
                            profileOwner: widget.profileOwner,
                            currentUserId: widget.currentUserId,
                            mainProfileUrl: widget.mainProfileUrl,
                            mainSecondName: widget.mainSecondName,
                            mainFirstName: widget.mainFirstName,
                            mainGender: widget.mainGender,
                            mainEmail: widget.mainEmail,
                            mainAbout: widget.mainAbout,
                            user: widget.user),
                      ),
                    )
                  ],
                ),
              ),

              // Positioned(
              //   bottom: 0.0,
              //   left: 0.0,
              //   right: 0.0,
              //   child: Column(
              //     children: [
              //       Material(
              //         borderRadius: BorderRadius.circular(15),
              //         elevation: 2,
              //         shadowColor: Colors.grey,
              //         child: GestureDetector(
              //           onTap: () => {
              //             if (widget.profileOwner == widget.currentUserId)
              //               {
              //                 setState(() {
              //                   isLoading = true;
              //                 }),
              //                 postsRtd
              //                     .child(widget.profileOwner)
              //                     .child("usersPost")
              //                     .once()
              //                     .then((DataSnapshot dataSnapshot) {
              //                   if (dataSnapshot.value != null) {
              //                     data = dataSnapshot.value;
              //
              //                     data.forEach((index, data) =>
              //                         posts.add({"key": index, ...data}));
              //                     posts.sort((a, b) {
              //                       return b["timestamp"]
              //                           .compareTo(a["timestamp"]);
              //                     });
              //                   }
              //                 }),
              //                 Constants.allMemes = posts,
              //                 Future.delayed(const Duration(milliseconds: 500),
              //                     () {
              //                   setState(() {
              //                     isLoading = false;
              //                   });
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) => Provider<User>.value(
              //                           value: widget.user,
              //                           child: MemePageForCurrentUser(
              //                             user: widget.user,
              //                             navigateThrough: widget.navigateThrough,
              //                             mainFirstName: widget.mainFirstName,
              //                             posts: Constants.allMemes,
              //                           )),
              //                     ),
              //                   );
              //                 }),
              //               }
              //             else
              //               {
              //                 setState(() {
              //                   isLoading = true;
              //                 }),
              //                 postsRtd
              //                     .child(widget.profileOwner)
              //                     .child("usersPost")
              //                     .once()
              //                     .then((DataSnapshot dataSnapshot) {
              //                   if (dataSnapshot.value != null) {
              //                     data = dataSnapshot.value;
              //
              //                     data.forEach((index, data) =>
              //                         posts.add({"key": index, ...data}));
              //                     posts.sort((a, b) {
              //                       return b["timestamp"]
              //                           .compareTo(a["timestamp"]);
              //                     });
              //                   }
              //                 }),
              //                 Future.delayed(const Duration(milliseconds: 500),
              //                     () {
              //                   setState(() {
              //                     isLoading = false;
              //                   });
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) => Provider<User>.value(
              //                           value: widget.user,
              //                           child: MemePageForCurrentUser(
              //                             user: widget.user,
              //                             navigateThrough: widget.navigateThrough,
              //                             mainFirstName: widget.mainFirstName,
              //                             posts: posts,
              //                           )),
              //                     ),
              //                   );
              //                 }),
              //               },
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //               color: Colors.lightBlue,
              //             ),
              //             height: 40,
              //             child: Padding(
              //               padding: const EdgeInsets.all(6.0),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(
              //                     widget.profileOwner == widget.currentUserId
              //                         ? "Your Shot Meme"
              //                         : "${widget.mainFirstName + "'s Shot Meme"}",
              //                     style: TextStyle(
              //                         fontSize: 16,
              //                         fontFamily: 'cute',
              //                         color: Colors.white),
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   Icon(
              //                     Icons.navigate_next_outlined,
              //                     size: 26,
              //                     color: Colors.white,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 8,
              //       ),
              //       Material(
              //         borderRadius: BorderRadius.circular(15),
              //         elevation: 2,
              //         shadowColor: Colors.grey,
              //         child: GestureDetector(
              //           onTap: () => {
              //             if (widget.profileOwner == widget.currentUserId)
              //               {
              //                 setState(() {
              //                   isLoading = true;
              //                 }),
              //                 // postsRtd
              //                 //     .child(widget.profileOwner)
              //                 //     .child("usersPost")
              //                 //     .once()
              //                 //     .then((DataSnapshot dataSnapshot) {
              //                 //   if (dataSnapshot.value != null) {
              //                 //     data = dataSnapshot.value;
              //                 //
              //                 //     data.forEach((index, data) =>
              //                 //         posts.add({"key": index, ...data}));
              //                 //     posts.sort((a, b) {
              //                 //       return b["timestamp"].compareTo(a["timestamp"]);
              //                 //     });
              //                 //   }
              //                 // }),
              //                 // Constants.allMemes = posts,
              //                 Future.delayed(const Duration(milliseconds: 500),
              //                     () {
              //                   setState(() {
              //                     isLoading = false;
              //                   });
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) => Provider<User>.value(
              //                         value: widget.user,
              //                         child: UserFlickMeme(
              //                           user: widget.user,
              //                           navigateThrough: 'profile',
              //                           profileId: widget.profileOwner,
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 }),
              //               }
              //             else
              //               {
              //                 setState(() {
              //                   isLoading = true;
              //                 }),
              //                 postsRtd
              //                     .child(widget.profileOwner)
              //                     .child("usersPost")
              //                     .once()
              //                     .then((DataSnapshot dataSnapshot) {
              //                   if (dataSnapshot.value != null) {
              //                     data = dataSnapshot.value;
              //
              //                     data.forEach((index, data) =>
              //                         posts.add({"key": index, ...data}));
              //                     posts.sort((a, b) {
              //                       return b["timestamp"]
              //                           .compareTo(a["timestamp"]);
              //                     });
              //                   }
              //                 }),
              //                 Future.delayed(const Duration(milliseconds: 500),
              //                     () {
              //                   setState(() {
              //                     isLoading = false;
              //                   });
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) => Provider<User>.value(
              //                         value: widget.user,
              //                         child: UserFlickMeme(
              //                           profileId: widget.profileOwner,
              //                           user: widget.user,
              //                           navigateThrough: 'profile',
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 }),
              //               },
              //           },
              //           child: Container(
              //             height: 40,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //               color: Colors.lightBlue,
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.all(6.0),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(
              //                     widget.profileOwner == widget.currentUserId
              //                         ? "Your Flick Meme"
              //                         : "${widget.mainFirstName + "'s Flick Meme"}",
              //                     style: TextStyle(
              //                         fontSize: 16,
              //                         fontFamily: 'cute',
              //                         color: Colors.white),
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   Icon(
              //                     Icons.navigate_next_outlined,
              //                     size: 26,
              //                     color: Colors.white,
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _statusPage(User user) {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.blue,
                  elevation: 2.0,
                  title: Text(
                    "Add Your MEME",
                    style: TextStyle(
                        color: Colors.white, fontSize: 20, fontFamily: 'cute'),
                  ),
                  centerTitle: true,
                  leading: Text("")),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 35,
                              ),
                              TextButton(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Provider<User>.value(
                                        value: user,
                                        child: AddStatus(
                                          type: "meme",
                                          uid: widget.user.uid,
                                        ),
                                      ),
                                    ),
                                  ),
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green.shade400,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Shot Meme",
                                              style: TextStyle(
                                                  fontFamily: 'cute',
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .fiber_smart_record_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => {
                                  // showModalBottomSheet(
                                  //     useRootNavigator: true,
                                  //     isScrollControlled: true,
                                  //     barrierColor: Colors.red.withOpacity(0.2),
                                  //     elevation: 0,
                                  //     clipBehavior: Clip.antiAliasWithSaveLayer,
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return Container(
                                  //         height: MediaQuery.of(context)
                                  //                 .size
                                  //                 .height /
                                  //             3,
                                  //         child: SingleChildScrollView(
                                  //           child: Column(
                                  //             children: [
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(5.0),
                                  //                 child: Row(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .center,
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .center,
                                  //                   children: [
                                  //                     Icon(Icons
                                  //                         .linear_scale_sharp),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(8.0),
                                  //                 child: Text(
                                  //                   "Video Meme only available in Meme competition. If this Switch App will perform well, we will allow this option here too.",
                                  //                   textAlign: TextAlign.center,
                                  //                   style: TextStyle(
                                  //                       fontSize: 15,
                                  //                       fontFamily: "cutes",
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                       color: Colors.lightBlue),
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(8.0),
                                  //                 child: Text(
                                  //                   "Why?",
                                  //                   textAlign: TextAlign.center,
                                  //                   style: TextStyle(
                                  //                       fontSize: 15,
                                  //                       fontFamily: "cutes",
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                       color: Colors
                                  //                           .red.shade700),
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(8.0),
                                  //                 child: Text(
                                  //                   "Database for videos is very Expensive. And our budget is not enough to bear the cost yet. Hope we will allow it in future, very soon. ",
                                  //                   textAlign: TextAlign.center,
                                  //                   style: TextStyle(
                                  //                       fontSize: 15,
                                  //                       fontFamily: "cutes",
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                       color: Colors.grey),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }),

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Provider<User>.value(
                                        value: user,
                                        child: VideoStatus(
                                          type: "videoMeme",
                                          user: widget.user,
                                        ),
                                      ),
                                    ),
                                  ),
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green.shade400,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Video Meme",
                                              style: TextStyle(
                                                  fontFamily: 'cute',
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.slow_motion_video,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Our Goal?",
                                      style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 20),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 2),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Hi Memers! Our goal is to make this platform a top meme generator platform. Original memes, memes template should create from this app and then spread out to other social media platforms.",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "What is Photo Meme:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "This is simple Meme that represent through Photo.",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "What is Video Meme:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "This is simple Meme that represent through Video.",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Where to find my uploaded MEME/STATUS?",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          "Your uploaded Memes are in Meme Profile. Open App > Click on Meme on bottom bar > There will be two options at the bottom (One for Flick Meme / One for Shot Meme).",
                                          style: TextStyle(
                                              color: Colors.lightBlue.shade700,
                                              fontFamily: 'cute',
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          "Where to find other user's uploaded MEME/STATUS?",
                                          style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontFamily: 'cute',
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          "Click on any user's Profile > Slide up to see their Shot Meme OR > Click on Meme Profile option > There will be two options at the bottom (One for Flick Meme / One for Shot Meme).",
                                          style: TextStyle(
                                              color: Colors.lightBlue.shade700,
                                              fontFamily: 'cute',
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "How it works?",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          "Uploaded Meme will be appear on every user's timeline, while Uploaded Photo OR Thoughts will only appear on timeline section and only appear to the user, who is following you.",
                                          style: TextStyle(
                                              color: Colors.lightBlue.shade700,
                                              fontFamily: 'cute',
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "How Ranking Works:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Memers will be rank according to total number of following. But in near future, we will also Rank them according to their MEME decency on the basis of profile.",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Stealing Other's Meme:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Well, we will generate a special code with each post. So when a user claim to us that someone stole his/her MEME, we will delete that user's MEME & will BAN that user ",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Limitations for MEMER:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "1) A meme profile with copied meme will not be ranked on TOP MEMERS. 2) Original Meme Content will be appreciated separably in this app. 3) If a meme being reported (copied meme), then the reported profile will be deleted after 1 or 2 warnings."
                                      "4) Such Meme Profile that disrespect any Religion, will be terminated w/o any warning.",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Meme Decency:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "In Future Updates, We will Rank Profiles with respect to (Meme Decency + Total Following).",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _addMeme() {
    return Container(
      key: uploadMemeIntro,
      height: 28,
      child: ElevatedButton(
        child: Text(
          "Upload Meme",
          softWrap: true,
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _statusPage(widget.user);
        },
        style: ElevatedButton.styleFrom(
            elevation: 2,
            textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  _followingButton() {
    return SizedBox(
      height: 27,
      width: 75,
      child: isFollowedByYou
          ? ElevatedButton(
              child: Text(
                "Following",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
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
                  'followingId': widget.profileOwner
                }),
                userFollowersRtd
                    .child(widget.profileOwner)
                    .child(widget.currentUserId)
                    .set({
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'followerId': widget.currentUserId,
                }),
                followingCounter(),
              },
              child: Text(
                "Follow",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontFamily: 'cute',
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  late double userMemePercentageDecency = 0;

  late double userMemeDecency = 0;
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

  getMemeDecencyReport() {
    late Map data;

    memeProfileRtd
        .child(widget.profileOwner)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });

        print(
            "not nulllllllllllllllllllllllllllllllllllllllllllllll ${dataSnapshot.value}");

        setState(() {
          counterForFour = data['numberOfFour'];
          counterForFive = data['numberOfFive'];
          counterForThree = data['numberOfThree'];
          counterForTwo = data['numberOfTwo'];
          counterForOne = data['numberOfOne'];
        });

        userMemeDecency = ((5 * counterForFive +
                4 * counterForFour +
                3 * counterForThree +
                2 * counterForTwo +
                1 * counterForOne) /
            (counterForTwo +
                counterForOne +
                counterForThree +
                counterForFour +
                counterForFive));

        userMemePercentageDecency = (userMemeDecency / 5) * 100;

        widget.profileOwner == widget.currentUserId
            ? upDateOwnDecency()
            : upDateProfileDecency();
      } else {}
    });
  }

  upDateOwnDecency() {
    memerPercentageDecencyRtd.child(widget.currentUserId).update({
      "PercentageDecency": userMemePercentageDecency,
    });
  }

  upDateProfileDecency() {
    memerPercentageDecencyRtd.child(widget.profileOwner).update({
      "PercentageDecency": userMemePercentageDecency,
    });
  }

  memeGallery() {
    return Padding(
      key: memeShowCaseIntro,
      padding: const EdgeInsets.all(8.0),
      child: MemeShowCase(
        user: widget.user,
        profileOwnerId: widget.profileOwner,
      ),
    );
  }

  // // ProfilePosts profilePosts = ProfilePosts();
  // allMeme() {
  //   return Constants.allMemes.length == 0
  //       ? Padding(
  //           padding: const EdgeInsets.only(top: 100),
  //           child: Text(
  //             "There is no Meme Create by ${widget.mainFirstName} yet",
  //             style: TextStyle(
  //               color: Colors.grey,
  //               fontFamily: 'cute',
  //             ),
  //           ),
  //         )
  //       : Padding(
  //           padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
  //           child: ListView.builder(
  //             physics: NeverScrollableScrollPhysics(),
  //             shrinkWrap: true,
  //             reverse: true,
  //             itemCount: Constants.allMemes.length,
  //             itemBuilder: (context, index) => Provider<User>.value(
  //               value: widget.user,
  //               child: TimelinePosts(
  //                 index: index,
  //                 posts: Constants.allMemes,
  //                 navigatorType: "meme",
  //                 navigateThrough: widget.navigateThrough,
  //                 user: widget.user,
  //               ),
  //             ),
  //           ),
  //         );
  // }

  top100Memers() {
    return allMemerList.isEmpty
        ? Text("")
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return _rankingList(index, allMemerList);
                        }),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemerSearch(
                          memerList: allMemerList,
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 2),
                    child: Text("View All",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'cute',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
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

  _rankingList(int index, List allMemerList) {
    return GestureDetector(
      onTap: () => {
        getUserData(allMemerList[index]['uid']),
        Future.delayed(
          const Duration(seconds: 1),
          () {
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
                    username: allMemerList[index]['username'],
                    isVerified: memerMap['isVerified'],
                    action: 'memerProfile',
                    user: widget.user,
                  ),
                ),
              ),
            );
          },
        ),
      },
      child: RankingList(
        index: index,
        rankingData: allMemerList,
        user: widget.user,
      ),
    );
  }

  bottomSheetForWithdraw() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 4.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BarTop(),
                  availible >= 10000
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Go to Switch App chat room and send S.S along with your username.",
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontFamily: 'cute',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Available Balance is not 10,000 or above 10,000 slits. You can only Withdraw when available balance will cross 10,000 slits.",
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontFamily: 'cute',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                ],
              ),
            ),
          );
        });
  }

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey rankingIntro = GlobalKey();
  GlobalKey memeDecencyIntro = GlobalKey();
  GlobalKey uploadMemeIntro = GlobalKey();
  GlobalKey levelIntro = GlobalKey();
  GlobalKey memeCompetitionIntro = GlobalKey();
  GlobalKey topMemersIntro = GlobalKey();
  GlobalKey memeShowCaseIntro = GlobalKey();
  final surpriseMeme = new SurpriseMeme(url: "", play: false, miliSec: 0);

  void showIntro() {
    initTargets();

    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.blue,
      textSkip: "Skip",
      paddingFocus: 4,
      pulseAnimationDuration: Duration(milliseconds: 1000),
      focusAnimationDuration: Duration(milliseconds: 500),
      opacityShadow: 0.9,
      textStyleSkip:
          TextStyle(fontFamily: 'cute', fontSize: 20, color: Colors.white),
      onFinish: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("introForMemeProfile", 1);
        if (mounted)
          setState(() {
            Constants.isIntroForMemeProfile = "";
          });

        surpriseMeme.createState().bottomSheetToShowMeme(
            context,
            "https://c.tenor.com/DZJacvvBw7EAAAAd/paisa-hi-paisa-hoga-excited.gif",
            "Le Top 3 Memers:");
      },
      onClickTarget: (target) {
        print('onClickTarget: ${target.keyTarget}');
      },
      onSkip: () {
        appIntro.createState().bottomSheetForMemeProfileSkipButton(context);
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "Target2",
        keyTarget: rankingIntro,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "This is your ranking as a Memer.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'cute',
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15,
      ),
    );

    targets.add(TargetFocus(
        identify: "Target",
        keyTarget: memeDecencyIntro,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Your rating out of 5 and % decency as a Memer will show here.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15));

    targets.add(
      TargetFocus(
          identify: "Target",
          keyTarget: uploadMemeIntro,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Upload your meme through this button.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          shape: ShapeLightFocus.RRect,
          radius: 15),
    );
    targets.add(TargetFocus(
        identify: "Target",
        keyTarget: levelIntro,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "This is memer tag. Click here for more information.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15));
    targets.add(TargetFocus(
        identify: "Target",
        keyTarget: memeCompetitionIntro,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Button that will lead you towards meme competition page. You can visit this page and watch if competition is live or not.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15));
    targets.add(TargetFocus(
        identify: "Target",
        keyTarget: topMemersIntro,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Section that tells you about top 100 memers of Switch App. These memers are Ranked according to their following counts. Get more following to reach top ranking.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Note: top 3 memers will get up to 500-1000 pkr per month",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15));
    targets.add(TargetFocus(
        identify: "Target",
        keyTarget: memeShowCaseIntro,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "You can pin your favourites memes and posts here. To pin here, you just have to click the right corner of any post and select (add/remove from showCase) button.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15));
  }

  _whatIf() {
    return showModalBottomSheet<void>(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.blue,
                  elevation: 2.0,
                  title: Text(
                    "What if.",
                    style: TextStyle(
                        color: Colors.white, fontSize: 20, fontFamily: 'cute'),
                  ),
                  centerTitle: true,
                  leading: Text("")),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "What if my Meme is not showing after Post it?",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "If your Meme is not showing after posting it, You may visit your Meme Profile through, Timeline > Profile Picture > Meme Profile.",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Limitations for MEMER:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "1) A meme profile with copied meme will not be ranked on TOP MEMERS. 2) Original Meme Content will be appreciated separably in this app. 3) If a meme being reported (copied meme), then the reported profile will be deleted after 1 or 2 warnings."
                                      "4) Such Meme Profile that disrespect any Religion, will be terminated w/o any warning.",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 5, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "Meme Decency:",
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontFamily: 'cute',
                                          fontSize: 17),
                                    ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Flexible(
                                            child: Text(
                                      "In Future Updates, We will Rank Profiles with respect to (Meme Decency + Total Following).",
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade700,
                                          fontFamily: 'cute',
                                          fontSize: 13),
                                    ))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bottomSheetForMemerLevels() {
    universalMethods.bottomSheetForMemerLevel(context);
  }
}
