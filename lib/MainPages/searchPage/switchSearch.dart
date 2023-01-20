// import 'dart:math';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
// import 'package:switchapp/MainPages/Profile/memeProfile/memerSearch/memerProfileList.dart';
// import 'package:switchapp/Models/Constans.dart';
// import 'package:switchapp/Models/Marquee.dart';
// import 'package:switchapp/UniversalResources/DataBaseRefrences.dart';
//
// class SwitchSearch extends StatefulWidget {
//   final User user;
//
//   const SwitchSearch({required this.user});
//
//   @override
//   _SwitchSearchState createState() => _SwitchSearchState();
// }
//
// class _SwitchSearchState extends State<SwitchSearch> {
//   TextEditingController editingController = TextEditingController();
//
//   List _foundUsers = [];
//   bool uploading = false;
// bool isLoading = true;
//   @override
//   void initState() {
//     _getMemerDetail();
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//     super.initState();
//   }
//
//   List allMemerList = [];
//
//   _getMemerDetail() {
//     userFollowersCountRtd.once().then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         late Map data;
//
//         setState(() {
//           data = dataSnapshot.value;
//         });
//
//         data.forEach(
//             (index, data) => allMemerList.add({"key": index, ...data}));
//
//         allMemerList.sort((a, b) {
//           return b["followerCounter"].compareTo(a['followerCounter']);
//         });
//
//         Random random = new Random();
//         int limitForUser = random.nextInt(100);
//
//         allMemerList.shuffle();
//         print("Nameeeeeeeeeeeeeeee" + allMemerList[limitForUser]['username']);
//
//         _foundUsers = allMemerList;
//
//         setState(() {});
//       } else {}
//     });
//   }
//
//   searchAgain() {
//     setState(() {
//       _foundUsers = allMemerList;
//     });
//   }
//
//   // This function is called whenever the text field changes
//   void _runFilter(String enteredKeyword) {
//     List results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = allMemerList;
//     } else {
//       results = allMemerList
//           .where((user) => user["username"]
//               .toLowerCase()
//               .contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//
//     // Refresh the UI
//     setState(() {
//       _foundUsers = results;
//     });
//   }
//
//   late Map memerMap;
//
//   getUserData(String uid) async {
//     await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           memerMap = dataSnapshot.value;
//
//           print(uid);
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _foundUsers.isNotEmpty
//           ? SafeArea(
//               child: Stack(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Material(
//                             color: Colors.white,
//                             elevation: 5,
//                             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),
//                             bottomRight: Radius.circular(12)),
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 2),
//                               child: Container(
//                                 height: 400,
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 90),
//                                   child: Container(
//                                     height: MediaQuery.of(context).size.height,
//                                     child: ListView.builder(
//                                         scrollDirection: Axis.vertical,
//                                         itemCount: _foundUsers.length,
//                                         itemBuilder: (context, index) =>
//                                             memerList(index, _foundUsers)),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: const Text(
//                                   'Trending Area',
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontFamily: 'cute',
//                                     color: Colors.grey
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 6),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: const Text(
//                                   'will available soon',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: 'cute',
//                                     color: Colors.grey
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   Container(
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         onChanged: (value) => _runFilter(value),
//                         decoration: const InputDecoration(
//                             labelText: 'Search here',
//                             suffixIcon: Icon(Icons.search),
//                             labelStyle: TextStyle(
//                                 color: Colors.black54,
//                                 fontFamily: "cutes",
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                   ),
//                   uploading
//                       ? LinearProgressIndicator()
//                       : Container(
//                           height: 0,
//                           width: 0,
//                         ),
//                 ],
//               ),
//             )
//           : isLoading ? Text(""): SafeArea(
//               child: Scaffold(
//                 backgroundColor: Colors.white,
//                 body: SingleChildScrollView(
//                   child: Center(
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: const Text(
//                             'No User found',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: 'cute',
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () => {
//                             searchAgain(),
//                           },
//                           child: Material(
//                             elevation: 1,
//                             borderRadius: BorderRadius.circular(10),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: const Text(
//                                 'Search Again',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontFamily: 'cute',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
//
//   Widget _rankingList(List rankingData, int index) {
//     return Padding(
//       padding: const EdgeInsets.all(5),
//       child: SingleChildScrollView(
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Text(
//                 "# ${index + 1}",
//                 style: TextStyle(
//                     fontSize: 10,
//                     fontFamily: 'cutes',
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(40),
//                   border: Border.all(color: Colors.white, width: 1),
//                   image: DecorationImage(
//                     image: NetworkImage(rankingData[index]['photoUrl']),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Text(
//                 rankingData[index]['username'],
//                 style: TextStyle(
//                     fontSize: 10,
//                     fontFamily: 'cutes',
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   memerList(int index, List _foundUsers) {
//     return GestureDetector(
//       onTap: () => {
//         setState(() {
//           uploading = true;
//         }),
//         getUserData(_foundUsers[index]["uid"]),
//         Future.delayed(const Duration(seconds: 1), () {
//           setState(() {
//             uploading = false;
//           });
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Provider<User>.value(
//                 value: widget.user,
//                 child: SwitchProfile(
//                   currentUserId: widget.user.uid,
//                   mainProfileUrl: memerMap['url'],
//                   mainFirstName: memerMap['firstName'],
//                   profileOwner: memerMap['ownerId'],
//                   mainSecondName: memerMap['secondName'],
//                   mainCountry: memerMap['country'],
//                   mainDateOfBirth: memerMap['dob'],
//                   mainAbout: memerMap['about'],
//                   mainEmail: memerMap['email'],
//                   mainGender: memerMap['gender'],
//                   username: _foundUsers[index]['username'],
//                   isVerified: memerMap['isVerified'],
//                   action: 'memerSearch',
//                   user: widget.user,
//                 ),
//               ),
//             ),
//           );
//         }),
//       },
//       child: MemerProfileList(
//         index: index,
//         foundUsers: _foundUsers,
//       ),
//     );
//   }
// }
