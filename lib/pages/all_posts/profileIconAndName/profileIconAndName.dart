// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:switchtofuture/pages/Profile/Profile.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/Models/Marquee.dart';
// import 'package:switchtofuture/Models/UserData.dart';
// import 'package:switchtofuture/SwitchProfile/Panelandbody.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
// import 'package:switchtofuture/UniversalResources/UserProvider.dart';
//
// class ProfileIconAndName extends StatefulWidget {
//   final Key globalKey;
//   final User user;
//
//   ProfileIconAndName({this.globalKey, this.user});
//
//   @override
//   _ProfileIconAndNameState createState() => _ProfileIconAndNameState();
// }
//
// class _ProfileIconAndNameState extends State<ProfileIconAndName> {
//   //greeting messages (to handle days state)
//   String greetings;
//
//   greetingMessage() {
//     var timeNow = DateTime.now().hour;
//
//     if (timeNow <= 12) {
//       greetings = 'Good Morning';
//     } else if ((timeNow > 12) && (timeNow <= 16)) {
//       greetings = 'Good Afternoon';
//     } else if ((timeNow > 16) && (timeNow < 20)) {
//       greetings = 'Good Evening';
//     } else {
//       greetings = 'Good Night';
//     }
//   }
//
//   // UserProvider userProvider;
//   //
//   // Future<dynamic> getProfilePhoto() async {
//   //   return userProvider.getUsers.url;
//   // }
//
//   UserMap userMap;
//
//   // Future<UserMap> getUserData() async {
//   //   return userMap = userProvider.getUsers;
//   // }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     greetingMessage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8, right: 5),
//       child: GestureDetector(
//         onTap: () => {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Provider.value(
//                 value: widget.user,
//                 child: SwitchProfile(
//                   mainProfileUrl: Constants.myPhotoUrl,
//                   profileOwner: Constants.myId,
//                   mainFirstName: Constants.myName,
//                   mainAbout: Constants.about,
//                   mainCountry: Constants.country,
//                   mainSecondName: Constants.mySecondName,
//                   mainEmail: Constants.myEmail,
//                   mainGender: Constants.gender,
//                   currentUserId: Constants.myId,
//                 ),
//               ),
//               //     Provider<User>.value(
//               //   value: user,
//               //   child: MainSearchPage(
//               //     user: user,
//               //     userId: user.uid,
//               //   ),
//               // ),
//             ),
//           )
//         },
//         child: Row(
//           children: [
//             StreamBuilder(
//               stream: userRefRTD.child(Constants.myId).onValue,
//               builder: (context, dataSnapShot) {
//                 if (dataSnapShot.hasData) {
//                   DataSnapshot snapshot = dataSnapShot.data.snapshot;
//                   Map data = snapshot.value;
//                   return     Container(
//                     width: 35,
//                     height: 35,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.lightBlue, width: 2),
//                       image: DecorationImage(
//                         image: NetworkImage(data['url']),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return     Container(
//                     width: 35,
//                     height: 35,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.black, width: 1),
//
//                     ),
//                   );
//                 }
//               },
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 MarqueeWidget(
//                   animationDuration: const Duration(seconds: 1),
//                   backDuration: const Duration(seconds: 3),
//                   pauseDuration: const Duration(milliseconds: 100),
//                   direction: Axis.horizontal,
//                   child: Text(
//                     greetings,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 8,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 // Text(
//                 //   greetings,
//                 //   style: TextStyle(
//                 //       color: Colors.white, fontSize: 10, fontFamily: 'Names',
//                 //   fontWeight: FontWeight.bold),
//                 // ),
//
//                 StreamBuilder(
//                   stream: userRefRTD.child(Constants.myId).onValue,
//                   builder: (context, dataSnapShot) {
//                     if (dataSnapShot.hasData) {
//                       DataSnapshot snapshot = dataSnapShot.data.snapshot;
//                       Map data = snapshot.value;
//                       return Text(
//                         data['gender'] == "male"
//                             ? "Mr. ${data['firstName']}"
//                             : "Miss. ${data['firstName']}",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 9,
//                             fontFamily: 'Names',
//                             fontWeight: FontWeight.w600),
//                       );
//                     } else {
//                       return Container(
//                         child: Text(""),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import '../../Profile/Panelandbody.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class ProfileIconAndName extends StatefulWidget {
  final User user;

  ProfileIconAndName({required this.user});

  @override
  _ProfileIconAndNameState createState() => _ProfileIconAndNameState();
}

class _ProfileIconAndNameState extends State<ProfileIconAndName> {
  late String greetings;

  greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      greetings = 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      greetings = 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      greetings = 'Good Evening';
    } else {
      greetings = 'Good Night';
    }
  }

  @override
  void initState() {
    super.initState();
    greetingMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 5),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: Provider<User>.value(
                  value: widget.user,
                  child: SwitchProfile(
                    mainProfileUrl: Constants.myPhotoUrl,
                    profileOwner: Constants.myId,
                    mainFirstName: Constants.myName,
                    mainAbout: Constants.about,
                    mainCountry: Constants.country,
                    mainSecondName: Constants.mySecondName,
                    mainEmail: Constants.myEmail,
                    mainGender: Constants.gender,
                    currentUserId: Constants.myId,
                    user: widget.user,
                    username: Constants.username,
                    isVerified: Constants.isVerified,
                    action: 'direct',
                    mainDateOfBirth: Constants.dob,
                  ),
                ),
              )),
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreamBuilder(
                stream: userRefRTD.child(Constants.myId).onValue,
                builder: (context, AsyncSnapshot dataSnapShot) {
                  if (dataSnapShot.hasData) {
                    DataSnapshot snapshot = dataSnapShot.data.snapshot;
                    Map data = snapshot.value;
                    return CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      imageUrl: data['url'],
                      errorWidget: (context, url, error) => Icon(
                        Icons.account_circle_outlined,
                        color: Colors.lightBlue,
                      ),
                    );
                  } else {
                    return Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                width: 5,
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MarqueeWidget(
                      animationDuration: const Duration(seconds: 1),
                      backDuration: const Duration(seconds: 3),
                      pauseDuration: const Duration(milliseconds: 100),
                      direction: Axis.horizontal,
                      child: Text(
                        greetings,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: StreamBuilder(
                        stream: userRefRTD.child(Constants.myId).onValue,
                        builder: (context, AsyncSnapshot dataSnapShot) {
                          if (dataSnapShot.hasData) {
                            DataSnapshot snapshot = dataSnapShot.data.snapshot;
                            Map data = snapshot.value;
                            return Container(
                              child: MarqueeWidget(
                                child: Text(
                                  data['gender'] == "Male"
                                      ? "Mr. ${data['firstName']}"
                                      : data['gender'] == "Female"
                                          ? "Miss ${data['firstName']}"
                                          : "${data['firstName']}",
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Names',
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              child: Text(""),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
