// import 'package:flushbar/flushbar.dart';
//
// /// Thyis class will handle Block and unblock Users, This class can be reach by clicking User Profile
// /// if one user Block other one then This page will not be shown to Blocked person. Moreover, I did not
// /// implement the hiding method in this class, I just made a condition(True) in Firebase so that we can
// /// get that value in anywhere in this app
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'file:///D:/IT/switchtofuture/lib/UniversalResources/DataBaseRefrences.dart';
//
// class ProfileOptionPage extends StatefulWidget {
//   ProfileOptionPage({this.profileOwner, this.currentUserId});
//
//   String currentUserId;
//   String profileOwner;
//
//   @override
//   _ProfileOptionPageState createState() => _ProfileOptionPageState();
// }
//
// class _ProfileOptionPageState extends State<ProfileOptionPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   int count = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isBlocked = true;
//     bool youBlockedThisPerson = true;
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.grey,
//         title: Text(
//           "Block The User",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.red,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(
//                     5,
//                   )),
//               child: FlatButton(
//                   child: Text("Block"),
//                   onPressed: () {
//                     blockReference
//                         .doc(widget.profileOwner)
//                         .collection("blockUsers")
//                         .doc(widget.currentUserId)
//                         .set({
//                       "youBlockedThisPerson": youBlockedThisPerson == false,
//                       "isBlocked": isBlocked,
//                     });
//
//                     blockReference
//                         .doc(widget.currentUserId)
//                         .collection("blockUsers")
//                         .doc(widget.profileOwner)
//                         .set({
//                       "youBlockedThisPerson": youBlockedThisPerson,
//                       "isBlocked": isBlocked,
//                     });
//                     showDialog(
//                       barrierDismissible: false,
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text(
//                           "You have Blocked This Person ✔️",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 14,
//                           ),
//                         ),
//                         content: Text(
//                           "You can unblock any time",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         actions: <Widget>[
//                           FlatButton(
//                               child: Text("OK"),
//                               onPressed: () => {
//                                     Navigator.of(context)
//                                         .popUntil((_) => count++ >= 3),
//                                   }),
//                         ],
//                       ),
//                     );
//
//                     print("pressed");
//                   }),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(
//                     5,
//                   )),
//               child: FlatButton(
//                   child: Text("Unblock"),
//                   onPressed: () {
//                     blockReference
//                         .doc(widget.profileOwner)
//                         .collection("blockUsers")
//                         .doc(widget.currentUserId)
//                         .set({
//                       "youBlockedThisPerson": youBlockedThisPerson == true,
//                       "isBlocked": isBlocked == false,
//                     });
//
//                     ///
//
//                     blockReference
//                         .doc(widget.currentUserId)
//                         .collection("blockUsers")
//                         .doc(widget.profileOwner)
//                         .set({
//                       "youBlockedThisPerson": youBlockedThisPerson == true,
//                       "isBlocked": isBlocked == false,
//                     });
//                     showDialog(
//                       barrierDismissible: false,
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text(
//                           "You have unblocked this Person ✔️",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 14,
//                           ),
//                         ),
//                         content: Text(
//                           "You Can Block Any Time",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         actions: <Widget>[
//                           FlatButton(
//                               child: Text("OK"),
//                               onPressed: () => {
//                                     Navigator.of(context)
//                                         .popUntil((_) => count++ >= 3),
//                                   }),
//                         ],
//                       ),
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
