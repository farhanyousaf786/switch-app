// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
//
// class WorldRanking extends StatefulWidget {
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
//   const WorldRanking(
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
//   _WorldRankingState createState() => _WorldRankingState();
// }
//
// class _WorldRankingState extends State<WorldRanking> {
//   Map data;
//   List list = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     _getMemerDetail();
//   }
//
//   _getMemerDetail() {
//     userFollowersCountRtd.once().then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           data = dataSnapshot.value;
//         });
//
//         // print("user::::::::::: ${data[0]['followerCounter']}");
//
//         data.forEach((index, data) => list.add({"key": index, ...data}));
//
//         list.sort((a, b) {
//           return b["followerCounter"].compareTo(a['followerCounter']);
//         });
//
//
//       } else {
//
//       }
//     });
//   }
//
//   _rankingList(List rankingData, int index) {
//     return rankingData[index]['uid'] == widget.profileOwner
//         ? Center(
//             child: Text(
//               "# ${index + 1}",
//               style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//           )
//         : Container(
//             child: Text(
//               "# -",
//               style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//           );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: list.length,
//         itemBuilder: (context, index) {
//           return _rankingList(list, index);
//         });
//
//     // return Center(
//     //   child: Text(
//     //     "#",
//     //     style: TextStyle(
//     //         fontSize: 12,
//     //         color: Colors.blue,
//     //         fontWeight: FontWeight.w500),
//     //   ),
//     // );
//   }
// }

///
///
///

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:switchapp/Universal/UniversalMethods.dart';

class WorldRanking extends StatefulWidget {
  final String profileOwner;
  final String currentUserId;
  final String mainProfileUrl;
  final String mainSecondName;
  final String mainFirstName;
  final String mainGender;
  final String mainEmail;
  final String mainAbout;
  final User user;

  const WorldRanking(
      {required this.profileOwner,
      required this.currentUserId,
      required this.mainProfileUrl,
      required this.mainFirstName,
      required this.mainSecondName,
      required this.mainGender,
      required this.mainEmail,
      required this.mainAbout,
      required this.user});

  @override
  _WorldRankingState createState() => _WorldRankingState();
}

class _WorldRankingState extends State<WorldRanking> {
  late Map data;
  List list = [];

  @override
  void initState() {
    super.initState();
    _getMemerDetail();
  }

  _getMemerDetail() {
    userFollowersCountRtd.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });

        data.forEach((index, data) => list.add({"key": index, ...data}));

        list.sort((a, b) {
          return b["followerCounter"].compareTo(a['followerCounter']);
        });
      } else {}
    });
  }

 UniversalMethods universalMethods = UniversalMethods();
  _rankingList(List rankingData) {
    try {
      for (int i = 0; i <= rankingData.length - 1; i++) {
        if (rankingData[i]['uid'] == widget.profileOwner) {
          String rank = universalMethods.shortNumberGenrator(i);
          return Center(
            child: Text(
              rank,
              style: TextStyle(
                  fontSize: 15,  fontFamily: 'cute'),
            ),
          );
        }

        // else {
        //
        //   return Container(
        //     child: Text(
        //       "# -",
        //       style: TextStyle(
        //           fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        //     ),
        //   );
        // }

      }
    } catch (e) {
      return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return list.isEmpty ? Container(child: Text(""),):   _rankingList(list);


    // return Center(
    //   child: Text(
    //     "#",
    //     style: TextStyle(
    //         fontSize: 12,
    //         color: Colors.blue,
    //         fontWeight: FontWeight.w500),
    //   ),
    // );
  }
}
