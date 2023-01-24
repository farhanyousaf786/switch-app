import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/SwitchImageCache/SwitchImageCache.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import '../../Profile/memeProfile/memerSearch/memerSearch.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

class FirstFollowing extends StatefulWidget {
  late final User user;

  FirstFollowing({required this.user});

  @override
  _FirstFollowingState createState() => _FirstFollowingState();
}

class _FirstFollowingState extends State<FirstFollowing> {
  String postId = Uuid().v4();

  late bool isFollowedByYou = false;
  List allMemerList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _getMemerDetail();
  }

  _getMemerDetail() {
    userFollowersCountRtd
        .limitToFirst(200)
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
        allMemerList.shuffle();
      } else {}
    });
  }

  ranking() {
    return allMemerList.isEmpty
        ? Text("")
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.8,
                      width: 300,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(30, (index) {
                          return GestureDetector(
                              onTap: () {},
                              child: _rankingList(allMemerList, index));
                        }),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: Text(
                    "These are active users of Switch App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "cute",
                        color: Colors.black54,
                       fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

  _rankingList(List rankingData, int index) {
    return GestureDetector(
      onTap: () => {
        getUserData(rankingData[index]['uid']),
        Future.delayed(const Duration(seconds: 1), () {
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
                  username: rankingData[index]['username'].toString(),
                  isVerified: memerMap['isVerified'],
                  action: 'memerProfile',
                  user: widget.user,
                ),
              ),
            ),
          );
        }),
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: 100,
          width: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26, width: 1),
              color: Colors.white24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "# ${index + 1}",
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'cute',
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    child: SwitchImageCache(
                      url: rankingData[index]['photoUrl'],
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    rankingData[index]['username'],
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'cute',
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
                  ),
                ),
                _followingButton(index, rankingData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _followingButton(int index, List memerList) {
    return SizedBox(
        height: 28,
        width: 90,
        child: ElevatedButton(
          child: Text(
            "Follow",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // prefs.setInt("totalFollowing", 0);

            feedRtDatabaseReference
                .child(memerList[index]['uid'])
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
              "ownerId": widget.user.uid,
              "photourl": "",
              "isRead": false,
            });

            //For Realtime DataBase

            userFollowingRtd
                .child(widget.user.uid)
                .child(memerList[index]['uid'])
                .set({
              'timestamp': DateTime.now().millisecondsSinceEpoch,
              'followingId': memerList[index]['uid'],
            });

            userFollowersRtd
                .child(memerList[index]['uid'])
                .child(widget.user.uid)
                .set({
              'timestamp': DateTime.now().millisecondsSinceEpoch,
              'followerId': widget.user.uid,
            });

            Future.delayed(const Duration(milliseconds: 1000), () {
              late Map data;
              userFollowersRtd
                  .child(memerList[index]['uid'])
                  .once()
                  .then((DataSnapshot dataSnapshot) {
                if (dataSnapshot.value != null) {
                  setState(() {
                    data = dataSnapshot.value;
                  });
                  userFollowersCountRtd.child(memerList[index]['uid']).update({
                    "followerCounter": data.length,
                    "uid": memerList[index]['uid'],
                    "username": memerList[index]['username'],
                    "photoUrl": memerList[index]['url'],
                  });
                } else {
                  userFollowersCountRtd.child(memerList[index]['uid']).update({
                    "followerCounter": 0,
                    "uid": memerList[index]['uid'],
                    "username": memerList[index]['username'],
                    "photoUrl": memerList[index]['url'],
                  });
                }
              });

              allMemerList.removeAt(index);

              setState(() {
                postId = Uuid().v4();
              });
            });
          },
          style: ElevatedButton.styleFrom(
              elevation: 2,
              primary: Colors.blue,
              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ));
  }

  // followingCounter(int index, List memerList)  {
  //   late Map data;
  //   userFollowersRtd
  //       .child(memerList[index]["uid"])
  //       .once()
  //       .then((DataSnapshot dataSnapshot) {
  //     if (dataSnapshot.value != null) {
  //       setState(() {
  //         data = dataSnapshot.value;
  //       });
  //
  //       userFollowersCountRtd.child(memerList[index]["uid"]).update({
  //         "followerCounter": data.length,
  //         "uid": memerList[index]["uid"],
  //         "username": memerList[index]["username"],
  //         "photoUrl": memerList[index]["photoUrl"],
  //       });
  //     } else {
  //       userFollowersCountRtd.child(memerList[index]["uid"]).update({
  //         "followerCounter": 0,
  //         "uid": memerList[index]["uid"],
  //         "username": memerList[index]["username"],
  //         "photoUrl": memerList[index]["photoUrl"],
  //       });
  //     }
  //   });
  //
  //   memerList.removeAt(index);
  //
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(
              child: SpinKitCircle(
                color: Colors.lightBlue,
              ),
            ),
          )
        : ranking();
  }
}
