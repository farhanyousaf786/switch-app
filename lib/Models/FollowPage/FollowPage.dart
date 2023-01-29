import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/MainPages/Profile/memeProfile/rankingHorizontalList/rankingList.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

import '../SwitchCacheImg/SwitchImageCache.dart';

class FollowPage extends StatefulWidget {
  final User user;

  const FollowPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  @override
  void initState() {
    _getMemerDetail();
    super.initState();
  }

  List allMemerList = [];

  _getMemerDetail() {
    userFollowersCountRtd
        .orderByChild('followerCounter')
        .limitToLast(100)
        .once()
        .then((DataSnapshot dataSnapshot) {
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

        setState(() {});
      } else {}
    });
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
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Material(
          elevation: 1,
          color:
              Constants.isDark == "true" ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "# ${index + 1}",
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: 'cute',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: SwitchCacheImage(
                      width: 50,
                      height: 50,
                      url: allMemerList[index]['photoUrl'],
                      boxFit: BoxFit.cover,
                      screen: '',
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //       widget.rankingData[widget.index]['photoUrl']),
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    allMemerList[index]['username'],
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'cute',
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(
                    child: Text('Follow'),
                    onPressed: () {




                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.lightBlue,
                        textStyle: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "This page will show the post of people \nthat you are following.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'cute',
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: GridView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return _rankingList(index, allMemerList);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1),
                      ),
                      // ListView.builder(
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: 100,
                      //     itemBuilder: (context, index) {
                      //       return _rankingList(index, allMemerList);
                      //     }),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => MemerSearch(
                  //           memerList: allMemerList,
                  //           user: widget.user,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(right: 8, left: 2),
                  //     child: Text("View All",
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //           fontFamily: 'cute',
                  //           fontWeight: FontWeight.bold,
                  //         )),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
