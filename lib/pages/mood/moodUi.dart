import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/pages/Profile/Panelandbody.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class FrontSlides extends StatefulWidget {
  final User user;

  const FrontSlides({
    required this.user,
  });

  @override
  _FrontSlidesState createState() => _FrontSlidesState();
}

class _FrontSlidesState extends State<FrontSlides> {
  String? mood = "";
  Map? moodData;
  Map? moodLinks;
  Map? topMemer;
  List? memerList = [];
  bool memerLoading = true;
  bool moodLoading = true;
  final _random = new Random();
  late int random = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getMood();
    getMoodLink();
    getTopMemer();

    random = _random.nextInt(2);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted)
        setState(() {
          moodLoading = false;
        });
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted)
        setState(() {
          memerLoading = false;
        });
    });
  }

  getTopMemer() {
    FirebaseDatabase.instance
        .reference()
        .child("TopMemer")
        .once()
        .then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot != null) {
        topMemer = dataSnapshot.value;
        topMemer!
            .forEach((index, data) => memerList!.add({"key": index, ...data}));
        memerList = memerList?.reversed.toList();

        setState(() {});
      } else {
        print("null");
      }
    });
  }

  getMoodLink() {
    switchMoodLinksRTD.once().then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot != null) {
        moodLinks = dataSnapshot.value;
      } else {
        print("null");
      }
    });
  }

  getMood() {
    switchUserMoodsRTD
        .child(widget.user.uid)
        .once()
        .then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot == null) {
        setState(() {
          mood = "happy";
        });
      } else {
        moodData = dataSnapshot.value;
        mood = moodData!['mood'];
        setState(() {
          Constants.mood = mood!;
        });
      }
    });
  }

  Widget moodUI() {
    if (moodLoading) {
      if (mood == "") {
        return Container(
            height: 150,
            width: MediaQuery.of(context).size.width,

            child: Text(""));
      } else {
        return Container(
          height: 150,
          width: MediaQuery.of(context).size.width,

          child: Text(
            "",
            style: TextStyle(fontSize: 20, fontFamily: 'cute'),
          ),
        );
      }
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: mood == "angry"
            ? Image.network(
                moodLinks!['angry'],
                fit: BoxFit.fitHeight,
              )
            : mood == "happy"
                ? Image.network(
                    moodLinks!['happy'],
                    fit: BoxFit.fitHeight,
                  )
                : mood == "romantic"
                    ? Image.network(
                        moodLinks!['romantic'],
                        fit: BoxFit.fitHeight,
                      )
                    : mood == "sad"
                        ? Image.network(
                            moodLinks!['sad'],
                            fit: BoxFit.fitHeight,
                          )
                        : Image.network(
                            moodLinks!['happy'],
                            fit: BoxFit.fitHeight,
                          ),
      );
    }
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

  Widget topMemerUI() {
    if (memerLoading) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.blue,
          highlightColor: Colors.white,
          child: Text(""),
        ),
      );
    } else {
      return Container(
          width: MediaQuery.of(context).size.width / 1.05,
          child: CarouselSlider.builder(
              itemCount: memerList!.length,
              itemBuilder: (BuildContext context, int itemIndex,
                      int pageViewIndex) =>
                  SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () => {
                        setState(() {
                          isLoading = true;
                        }),
                        getUserData(memerList![itemIndex]["uid"]),
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
                                    username: memerList![itemIndex]['username']
                                        .toString(),
                                    isVerified: memerMap['isVerified'],
                                    action: 'memerProfile',
                                    user: widget.user,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        setState(() {
                          isLoading = false;
                        }),
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      "Switch favourites",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'cute',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 30, right: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${memerList![itemIndex]['name'].toString().toUpperCase()}",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'cute',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlue.shade200),
                                      ),
                                      Text(
                                        "Decency " +
                                            memerList![itemIndex]['decency'],
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'cute',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink.shade200),
                                      ),
                                    ],
                                  ),
                                ),
                                isLoading == true
                                    ? SpinKitRipple(
                                        color: Colors.white,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 33,
                                          height: 33,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Colors.lightBlue, width: 2),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                memerList![itemIndex]['url'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                Center(
                                  child: Text(
                                    "Memer #" + "${itemIndex + 1}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'cute',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.greenAccent),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "username: " +
                                        memerList![itemIndex]['username'],
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'cute',
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              options: CarouselOptions(
                height: 350,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(seconds: 4),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,

        child: mainUi());
  }

  Widget mainUi() {
    // if (random == 1) {
    //   return topMemerUI();
    // } else {
    //   return moodUI();
    // }

    return topMemerUI();

  }
}
