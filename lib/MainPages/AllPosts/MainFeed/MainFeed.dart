import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/MainPages/AdminPage/adminPage.dart';
import 'package:switchapp/MainPages/AllPosts/MainFeed/FollowBottonUi.dart';
import 'package:switchapp/MainPages/AllPosts/MainFeed/OptionBottomBar.dart';
import 'package:switchapp/MainPages/FrontSlide/MainiaTopic.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/MainPages/AllPosts/memeOnly/memes_Only.dart';
import 'package:switchapp/MainPages/notificationPage/BottomBarNotify.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Models/SwitchCacheImg/SwitchImageCache.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/UniversalMethods.dart';
import '../../../Models/appIntro.dart';
import 'package:switchapp/Models/postModel/CommentsPage.dart';
import 'package:switchapp/Models/postModel/PostsReactCounters.dart';
import 'package:switchapp/Models/postModel/TextStatus.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:switchapp/Models/VideoWidget/video_widget.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Authentication/UserAgreement/userAgreementPage.dart';
import '../MemeAndStuff/memeCompetition/memeComp.dart';
import '../YourFeed/YourFeed.dart';
import '../profileIconAndName/profileIconAndName.dart';
import '../../ReportAndComplaints/postReportPage.dart';
import '../../ReportAndComplaints/reportId.dart';
import 'FollowBotton.dart';
import 'FollowBottonUi.dart';

UniversalMethods universalMethods = UniversalMethods();
final appIntro = new AppIntro();

// ignore: must_be_immutable
class MainFeed extends StatefulWidget {
  late User user;
  late Map? controlData;
  late List finalFollowingList;

  MainFeed(
      {required this.user,
      required this.controlData,
      required this.finalFollowingList});

  @override
  State<MainFeed> createState() => _MainFeedState();
}

class _MainFeedState extends State<MainFeed> {
  late bool _visible = false; // Variable to to hide switch trend
  int videoMeme = 0;
  late Map allPostMap;
  late Map store;
  bool isLoading = true;
  List allPostList = [];
  List limitedPostList = [];
  final _random = new Random();
  List reactorList = [];
  bool _hasMore = false;
  late int startAt = 0;
  late int endAt = 4;
  final ScrollController listScrollController = ScrollController();
  double? _scrollPosition;
  bool loadingRecentPosts = false;
  late int randomNotify = 100;
  int like = 0;
  int disLike = 0;
  int heartReact = 0;
  int total = 0;
  bool isNotification = false;
  int jumpStart = 5;
  int jumpEndAt = 5;
  GlobalKey key = new GlobalKey();
  int currentLine = 1;
  late bool _isHide = false; // Variable to to hide switch trend
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey nameAndStuffIntro = GlobalKey();
  GlobalKey jumpToNextIntro = GlobalKey();
  GlobalKey frontSlidIntro = GlobalKey();
  GlobalKey addPostIntro = GlobalKey();
  GlobalKey memeProfileIntro = GlobalKey();
  GlobalKey clustyChatIntro = GlobalKey();
  GlobalKey recentPostsIntro = GlobalKey();
  GlobalKey yourFeedsIntro = GlobalKey();
  GlobalKey switchUpdatesIntro = GlobalKey();
  GlobalKey bottomAllIntro = GlobalKey();

  @override
  void initState() {
    if (Constants.isIntro == "true") {
      showIntro();
    } else {}
    getFirstPostList();
    listScrollController.addListener(_scrollListener);
    randomNotify = _random.nextInt(80) + 20; // 100-200
    checkIfNotification();
    super.initState();
  }

  void checkIfNotification() {
    feedRtDatabaseReference
        .child(Constants.myId)
        .child("feedItems")
        .orderByChild("timestamp")
        .limitToLast(2)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        Map notifyMap = dataSnapshot.value;
        List notifyList = [];
        notifyMap
            .forEach((index, data) => notifyList.add({"key": index, ...data}));

        if (notifyList[0]['isRead'] == false ||
            notifyList[1]['isRead'] == false) {
          setState(() {
            isNotification = true;
          });

          print(
              "Notification : : : : : : : : : : : >><><><><><><<><><><><><><>< $isNotification");
        }
      } else {}
    });
  }

  void getFirstPostList() async {
    allPostList.clear();
    limitedPostList.clear();
    switchAllUserFeedPostsRTD
        .child("UserPosts")
        .orderByChild('timestamp')
        .limitToLast(150)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        allPostMap = dataSnapshot.value;
        allPostMap.forEach(
            (index, data2) => allPostList.add({"key": index, ...data2}));
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      allPostList.sort((a, b) {
        return b["timestamp"].compareTo(a["timestamp"]);
      });
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      print("Length: : : : : : : ${allPostList.length}");

      if (allPostList.isEmpty) {
        getFirstPostList();
      } else {
        limitedPostList = allPostList.getRange(startAt, endAt).toList();
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });
  }

  void _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _hasMore = true;
      });
      print(
          "************************************* <<<<<<<<<<<< Has More >>>>>>>>>>>> *************************************");
      getNextPosts();
    }
    setState(() {
      _scrollPosition = listScrollController.position.pixels;
    });
    if (_scrollPosition! > 50.0) {
      setState(() {
        _isHide = true;
      });
    }
    if (_scrollPosition! < 50.0) {
      setState(() {
        _isHide = false;
      });
    }
  }

  isHide(isHide) {
    setState(() {
      _isHide = isHide;
    });
  }

  void getNextPosts() {
    if (endAt > 142) {
      print("***************** list Ended *****************");
      Fluttertoast.showToast(
        msg: "150+ posts has been seen",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      endAt = endAt + 5;
      print(
          "Has More >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $startAt");
      print("End At >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $endAt");

      limitedPostList = allPostList.getRange(startAt, endAt).toList();
      setState(() {});
      // Future.delayed(const Duration(seconds: 12), () {
      //   setState(() {
      //     _hasMore = false;
      //   });
      // });
    }
  }

  jumpToPosts() {
    if (jumpEndAt > 142) {
      Fluttertoast.showToast(
        msg: "Last 150+ posts has been seen",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      return currentLine == 1
          ? SizedBox(
              height: 28,
              child: DelayedDisplay(
                delay: Duration(milliseconds: 600),
                slidingBeginOffset: Offset(0.0, 1),
                child: TextButton(
                  onPressed: () {
                    if (allPostList.length < endAt) {
                      print("***************** list Ended *****************");
                    } else {
                      limitedPostList.clear();
                      jumpStart = jumpEndAt;
                      jumpEndAt = jumpEndAt + 5;
                      startAt = jumpStart;
                      endAt = jumpEndAt;

                      print(
                          "End At >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $endAt");

                      limitedPostList =
                          allPostList.getRange(jumpStart, jumpEndAt).toList();
                      setState(() {});
                      // Future.delayed(const Duration(seconds: 12), () {
                      //   setState(() {
                      //     _hasMore = false;
                      //   });
                      // });
                    }
                  },
                  child: Row(
                    key: jumpToNextIntro,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Jump to next ",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.skip_next_outlined,
                        color: Colors.lightBlue,
                        size: 12,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    backgroundColor: MaterialStateColor.resolveWith((states) =>
                        Constants.isDark == "true"
                            ? Colors.grey.shade900
                            : Colors.white),
                  ),
                ),
              ))
          : SizedBox(
              height: 0,
              width: 0,
            );
    }
  }

  void _blockFunction(String profileOwner, String currentUserId) async {
    Map? userMap;
    late String username;
    late String url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("followList");
    userRefRTD.child(widget.user.uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userMap = dataSnapshot.value;

        username = userMap?['username'];
        url = userMap?['url'];
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      blockListRTD.child(Constants.myId).child(profileOwner).set({
        "username": username,
      });
      userFollowingRtd.child(currentUserId).child(profileOwner).remove();
      userFollowersRtd.child(profileOwner).child(currentUserId).remove();
      userFollowersRtd.child(currentUserId).child(profileOwner).remove();
      userFollowingRtd.child(profileOwner).child(currentUserId).remove();
      bestFriendsRtd.child(profileOwner).child(currentUserId).remove();
      chatListRtDatabaseReference
          .child(Constants.myId)
          .child(profileOwner)
          .update({"blockBy": Constants.myId});
      chatListRtDatabaseReference
          .child(profileOwner)
          .child(Constants.myId)
          .update({"blockBy": Constants.myId});

      /// user follower recounting
      late Map data;
      userFollowersRtd
          .child(profileOwner)
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          setState(() {
            data = dataSnapshot.value;
          });

          userFollowersCountRtd.child(profileOwner).update({
            "followerCounter": data.length,
            "uid": profileOwner,
            "username": username,
            "photoUrl": url,
          });
          print("yesssssssssssssssssssssss");
        } else {
          print("nooooooooooooooooooooooooooo");
          userFollowersCountRtd.child(profileOwner).update({
            "followerCounter": 0,
            "uid": profileOwner,
            "username": username,
            "photoUrl": url,
          });
        }
      });

      Fluttertoast.showToast(
        msg: "Blocked, Restart App!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.white,
        textColor: Colors.lightBlue,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    });
  }

  _getUserDetail(String ownerId) {
    User user = Provider.of<User>(context, listen: false);

    userRefRTD.child(ownerId).once().then((DataSnapshot dataSnapshot) {
      Map data = dataSnapshot.value;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Provider<User>.value(
            value: widget.user,
            child: SwitchProfile(
              mainProfileUrl: data['url'],
              profileOwner: data['ownerId'],
              mainFirstName: data['firstName'],
              mainAbout: data['about'],
              mainCountry: data['country'],
              mainSecondName: data['secondName'],
              mainEmail: data['email'],
              mainGender: data['gender'],
              currentUserId: Constants.myId,
              user: user,
              action: "fromTimeLine",
              username: data['username'],
              isVerified: data['isVerified'],
              mainDateOfBirth: data['dob'],
            ),
          ),
          //     Provider<User>.value(
          //   value: user,
          //   child: MainSearchPage(
          //     user: user,
          //     userId: user.uid,
          //   ),
          // ),
        ),
      );
    });
  }

  memeCompetition() {
    if (!_isHide) {
      if (widget.controlData!['compStatus'] == 'live' ||
          widget.controlData!['compStatus'] == "end") {
        return Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: DelayedDisplay(
            delay: Duration(milliseconds: 600),
            slidingBeginOffset: Offset(0.0, 1),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: TextButton(
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
                          child: Center(
                            child: isLoading
                                ? SpinKitThreeBounce(
                                    color: Colors.lightBlue,
                                    size: 13,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.controlData!['compStatus'] ==
                                                "live"
                                            ? 'Meme Competition is Live'
                                            : "Winners are announced",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'cute',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SpinKitPulse(
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return SizedBox(
          height: 0,
          width: 0,
        );
      }
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

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
        prefs.setInt("intro", 1);
        if (mounted)
          setState(() {
            Constants.isIntro = "";
          });

        userAgreement("no");
        Future.delayed(const Duration(seconds: 2), () {
          widget.user.uid == Constants.switchIdLaaSY
              ? SizedBox(
                  width: 0,
                  height: 0,
                )
              : whatsNew();
        });
      },
      onClickTarget: (target) {
        print('onClickTarget: ${target.keyTarget}');
      },
      onSkip: () {
        userAgreement("yes");
        Future.delayed(const Duration(seconds: 2), () {
          widget.user.uid == Constants.switchIdLaaSY
              ? SizedBox(
                  width: 0,
                  height: 0,
                )
              : whatsNew();
        });

        appIntro.createState().bottomSheetForSkipButton(context);
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
        identify: "Target",
        keyTarget: nameAndStuffIntro,
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
                      "You Have to Click here to visit your Profile.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'cute',
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "اپنی پروفائل پر جانے کے لیے یہاں پر کلک کرنا ہوگا",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "1 of 3",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
        keyTarget: jumpToNextIntro,
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
                      "By clicking this button you can skip recent posts that you already seen.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "اس حصے پر کلک کر کے آپ وہ پوسٹس چھوڑ سکتے ہیں جو آپ پہلے سے ہی دیکھ چکے ہیں",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "2 of 3",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
        keyTarget: frontSlidIntro,
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
                      "This is (News & Trend) function, this slide will show you latest updates about Switch App and Trends.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "یہ حصہ آپکو ٹرینڈاور سوئچ ایپ کے بارے میں اپڈیٹ کرے گا",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "3 of 3",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
        keyTarget: addPostIntro,
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
                      "You can upload posts and memes by clicking this button",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "اس بٹن سے آپ پوسٹ کر سکتے ہیں",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "4 of 10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
    // targets.add(TargetFocus(
    //     identify: "Target",
    //     keyTarget: memeProfileIntro,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.bottom,
    //         builder: (context, controller) {
    //           return Container(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Text(
    //                   "This is for memers profile. This section will show your latest meme posts by you and your Slit points.",
    //                   textAlign: TextAlign.left,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.white,
    //                       fontSize: 18.0),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(top: 10.0),
    //                   child: Text(
    //                     "یہ میمرز کی پروفل ہے جو تازہ ممیز اور سلیٹ پوائنٹس کو الگ سے دیکھاے گی",
    //                     textAlign: TextAlign.right,
    //                     style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                 ),
    //                 Center(
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(top: 20.0),
    //                     child: Text(
    //                       "5 of 10",
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 20,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     ],
    //     shape: ShapeLightFocus.RRect,
    //     radius: 15));
    targets.add(TargetFocus(
        identify: "Target",
        keyTarget: clustyChatIntro,
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
                      "This is for memers profile. This section will show your latest posts on meme topic and your Slit points.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "یہ حصہ سب لوگوں کے میسج دیکھاے گا",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "6 of 10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
        keyTarget: recentPostsIntro,
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
                      "This section will show you the latest posts of all the users.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "یہ حصہ آپ کو تازہ ترین کی گئی پوسٹس دیکھاے گا",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "7 of 10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
        keyTarget: switchUpdatesIntro,
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
                      "This section will show you the latest updates from switch app.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "یہ حصہ آپ کو سوئچ ایپ کے بارے میں تازہ اپ ڈیٹ دیکھاے گا",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "8 of 10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
        keyTarget: bottomAllIntro,
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
                      "This will show you recent posts.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "یہ حصہ آپ کو سب سے تازہ ترین کی گئی پوسٹس کو دیکھاے گا",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "9 of 10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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

  @override
  void dispose() {
    allPostList.clear();
    limitedPostList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                nameAndStuff(),
                frontSlide(),
                // tabBar(
                //   widget.user,
                // ),
                allLine(),
                // memeCompetition(),
                // Padding(
                //   padding: EdgeInsets.all(!_isHide ? 6 : 0),
                //   child: !_isHide ? jumpToPosts() : SizedBox(),
                // ),
                isLoading
                    ? SizedBox(
                        height: 100,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                isLoading
                    ? Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SpinKitThreeBounce(
                              color: Colors.lightBlue,
                              size: 15,
                            ),
                          ),
                        ),
                      )
                    : currentLine == 1
                        ? Expanded(
                            key: bottomAllIntro,
                            child: Stack(
                              children: [
                                NotificationListener<UserScrollNotification>(
                                  onNotification: (notification) {
                                    final ScrollDirection direction =
                                        notification.direction;
                                    setState(() {
                                      if (direction ==
                                          ScrollDirection.reverse) {
                                        _visible = false;

                                        print("visible: $_visible");
                                      } else if (direction ==
                                          ScrollDirection.forward) {
                                        _visible = true;
                                        print("visible: $_visible");
                                      }
                                    });
                                    return true;
                                  },
                                  child: InViewNotifierList(
                                    controller: listScrollController,
                                    scrollDirection: Axis.vertical,
                                    initialInViewIds: ['0'],
                                    isInViewPortCondition: (double deltaTop,
                                        double deltaBottom,
                                        double viewPortDimension) {
                                      return deltaTop <
                                              (0.5 * viewPortDimension) &&
                                          deltaBottom >
                                              (0.4 * viewPortDimension);
                                    },
                                    itemCount: _hasMore
                                        ? limitedPostList.length + 1
                                        : limitedPostList.length,
                                    builder: (BuildContext context, int index) {
                                      if (index >= limitedPostList.length) {
                                        // Don't trigger if one async loading is already under way
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, top: 3),
                                            child: SizedBox(
                                              child: Column(
                                                children: [
                                                  SpinKitThreeBounce(
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                              height: 100,
                                              width: 120,
                                            ),
                                          ),
                                        );
                                      } else {
                                        final user = Provider.of<User>(context,
                                            listen: false);
                                        String url =
                                            limitedPostList[index]['url'];
                                        int timestamp =
                                            limitedPostList[index]['timestamp'];
                                        String postId =
                                            limitedPostList[index]['postId'];
                                        String ownerId =
                                            limitedPostList[index]['ownerId'];
                                        String description =
                                            limitedPostList[index]
                                                ['description'];
                                        String type =
                                            limitedPostList[index]['type'];
                                        String postTheme =
                                            limitedPostList[index]
                                                ['statusTheme'];
                                        String time = formatTime(timestamp);

                                        bool isFollowing = widget
                                            .finalFollowingList
                                            .contains(limitedPostList[index]
                                                ['ownerId']);

                                        return Column(
                                          children: [
                                            _isHide
                                                ? Container(
                                                    height: index == 0 ? 80 : 0,
                                                  )
                                                : Container(
                                                    height: 0,
                                                  ),

                                            GestureDetector(
                                              onTap: () {
                                                _getUserDetail(ownerId);
                                              },
                                              child: _showProfilePicAndName(
                                                  ownerId,
                                                  time,
                                                  postId,
                                                  postTheme == ""
                                                      ? "photo"
                                                      : postTheme,
                                                  type,
                                                  description,
                                                  url,
                                                  isFollowing,
                                                  index),
                                            ),

                                            type == "thoughts"
                                                ? TextStatus(
                                                    description: description)
                                                : type == "videoMeme" ||
                                                        type == "videoMemeT"
                                                    ? videoPosts(index)
                                                    : imagePosts(index),

                                            type == "thoughts"
                                                ? Container(
                                                    height: 10.0,
                                                  )
                                                : Container(
                                                    height: 5,
                                                  ),
                                            _postFooter(user, postId, ownerId,
                                                url, postTheme, index, type),
                                            Container(
                                              height: 10,
                                            ),

                                            type != "thoughts"
                                                ? _description(description)
                                                : Container(
                                                    height: 0,
                                                    width: 0,
                                                  ),
                                            // creatPostFooter(),

                                            Container(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                                _visible
                                    ? DelayedDisplay(
                                        delay: Duration(milliseconds: 200),
                                        slidingBeginOffset: Offset(0.0, 1),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (listScrollController
                                                .hasClients) {
                                              final position =
                                                  listScrollController
                                                      .position.minScrollExtent;
                                              listScrollController.animateTo(
                                                position,
                                                duration: Duration(seconds: 1),
                                                curve: Curves.easeOut,
                                              );
                                            }
                                          },
                                          child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 40, left: 20),
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Container(
                                                        child: Icon(
                                                      Icons.arrow_upward_sharp,
                                                      size: 15,
                                                      color: Colors.blueAccent,
                                                    )),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      )
                                    : Container(
                                        height: 0.0,
                                        width: 0.0,
                                      ),
                              ],
                            ),
                          )
                        : currentLine == 2
                            ? yourFeed()
                            : memesOnly()
              ],
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                child: jumpToPosts(),
              ),
            )

            // Container(
            //   height: isHide ? 50 : MediaQuery.of(context).size.height / 3.3,
            //   color: Colors.white,
            //   alignment: Alignment.topCenter,
            //   //BoxDecoration
            //   child: Column(
            //     children: [
            //       nameAndStuff(),
            //       frontSlide(),
            //       tabBar(
            //         widget.user,
            //       ),
            //     ],
            //   ),
            //   //Text
            // ),
          ],
        ),
      ),
    );
  }

  List followedIndex = [];
  late List<FollowButtonUi> followButtonUi;
  late bool isFollowTap = false;

  void removeServiceCard(String ownerId) {
    setState(() {
      followedIndex.add(ownerId);
    });
  }

  _showProfilePicAndName(
      String ownerId,
      String timeStamp,
      String postId,
      String postTheme,
      String type,
      String description,
      String url,
      bool isFollowing,
      int index) {
    followButtonUi =
        List.generate(limitedPostList.length, (index) => FollowButtonUi());
    return StreamBuilder(
        stream: userRefRTD.child(ownerId).onValue,
        builder: (context, AsyncSnapshot dataSnapShot) {
          if (dataSnapShot.hasData) {
            DataSnapshot snapshot = dataSnapShot.data.snapshot;
            Map data = snapshot.value;
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                trailing: SizedBox(
                  width: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      followedIndex.contains(ownerId) && isFollowTap
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: SpinKitThreeBounce(
                                    color: Colors.lightBlue,
                                    size: 11,
                                  ),
                                )
                              ],
                            )
                          : !isFollowing
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFollowTap = true;
                                    });
                                    removeServiceCard(ownerId);
                                    FollowButtonMainPage fb =
                                        FollowButtonMainPage();
                                    fb.getFollowingUsers(
                                      widget.user.uid,
                                      ownerId,
                                      data['username'],
                                      data['url'],
                                      index,
                                    );
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      setState(() {
                                        isFollowTap = false;
                                      });
                                      Fluttertoast.showToast(
                                        msg:
                                            "You are now Following ${data['firstName']}",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.lightBlue,
                                        fontSize: 10.0,
                                      );
                                    });
                                  },
                                  child: followedIndex.contains(ownerId)
                                      ? SizedBox(
                                          height: 0,
                                        )
                                      : followButtonUi[index])
                              : SizedBox(
                                  height: 0,
                                ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          OptionBottomBar ob = OptionBottomBar();
                          ob.optionBottomBar(
                              context,
                              type,
                              widget.user.uid,
                              postId,
                              url,
                              ownerId,
                              index,
                              deleteFunc,
                              _blockFunction);
                        },
                        child: Icon(
                          Icons.more_vert,
                          // color: selectedIndex == index
                          //     ? Colors.pink
                          //     : selectedIndex == 121212
                          //         ? Colors.grey
                          //         : Colors.teal,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                title: Transform(
                  transform: Matrix4.translationValues(-1, 5.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                            image: DecorationImage(
                              image: NetworkImage(data['url'] == null
                                  ? "https://switchappimages.nyc3.digitaloceanspaces.com/StaticUse/1646080905939.jpg"
                                  : data['url']),
                            ),
                          ),
                        ),
                        // CircleAvatar(
                        //   child: CircleAvatar(
                        //     radius: 22,
                        //     backgroundColor: Colors.grey,
                        //     backgroundImage:
                        //         CachedNetworkImageProvider(snapShot.data['url']),
                        //   ),
                        //   radius: 23.5,
                        //   backgroundColor: Colors.grey,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "  " +
                                        data['firstName'] +
                                        " " +
                                        data['secondName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  data['isVerified'] == "true"
                                      ? Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Container(
                                              height: 15,
                                              width: 15,
                                              child: Image.asset(
                                                  "images/blueTick.png")),
                                        )
                                      : SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                  Text(
                                    type == "meme"
                                        ? "  share meme"
                                        : "  share $postTheme",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 0),
                                child: MarqueeWidget(
                                  animationDuration: const Duration(seconds: 1),
                                  backDuration: const Duration(seconds: 3),
                                  pauseDuration:
                                      const Duration(milliseconds: 100),
                                  child: Text(
                                    timeStamp,
                                    style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey,
                                        fontFamily: 'cute'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

//                    subtitle: Text(description),
              ),
            );
          } else {
            return Container(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
          }
        });
  }

  blockUser(String profileOwner, String currentUserId) {
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
                  BarTop(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Are you sure?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cute",
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "cute",
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          onTap: () {
                            _blockFunction(profileOwner, currentUserId);
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "cute",
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "To see immediate effect, Restart your app. After restart, you will not see any posts and comments from this person. And this person will not be able to see your profile and posts.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: "cute",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _postFooter(User user, String postId, String ownerId, String url,
      String postTheme, int index, String type) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 17,
                  ),
                  PostReactCounter(
                    postId: postId,
                    ownerId: ownerId,
                    type: type,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            barrierColor: Colors.red.withOpacity(0.2),
                            elevation: 0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            context: context,
                            builder: (context) {
                              return Provider<User>.value(
                                value: widget.user,
                                child: CommentsPage(
                                    postId: postId,
                                    ownerId: ownerId,
                                    photoUrl: url),
                              );
                            });
                      },
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Icon(
                                Icons.messenger_outline_rounded,
                                color: Colors.grey,
                                size: 20,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              StreamBuilder(
                                stream: commentRtDatabaseReference
                                    .child(postId)
                                    .onValue,
                                builder: (context, AsyncSnapshot dataSnapShot) {
                                  if (!dataSnapShot.hasData) {
                                    return Text(
                                      "0",
                                      style: TextStyle(
                                          fontFamily: 'cute',
                                          color: Colors.grey.shade600,
                                          fontSize: 10),
                                    );
                                  } else {
                                    DataSnapshot snapshot =
                                        dataSnapShot.data.snapshot;
                                    Map data = snapshot.value;
                                    List item = [];
                                    if (data == null) {
                                      return Text(
                                        "0",
                                        style: TextStyle(
                                            fontFamily: 'cute',
                                            color: Colors.grey.shade600,
                                            fontSize: 10),
                                      );
                                    } else {
                                      data.forEach((index, data) =>
                                          item.add({"key": index, ...data}));
                                    }

                                    return dataSnapShot.data.snapshot.value ==
                                            null
                                        ? SizedBox()
                                        : Text(
                                            data.length.toString(),
                                            style: TextStyle(
                                                fontFamily: 'cute',
                                                color: Colors.grey.shade600,
                                                fontSize: 10),
                                          );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => {
                      reactorList.clear(),
                      getPostDetail(postId),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Reactors",
                        style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'cute',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          loadingRecentPosts
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    color: Colors.lightBlue,
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }

  _recentPosts(String ownerId, List posts) {
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Recent Memes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "cutes",
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget textControl(String description) {
    return GestureDetector(
      onLongPress: () => {
        Clipboard.setData(ClipboardData(text: description)),
        Fluttertoast.showToast(
          msg: "Copy",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blue.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0,
        ),
      },
      child: Linkify(
        onOpen: (link) async {
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
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "This link (${link.url}) will lead you out of the Switch App.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "cutes",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              child: Text(
                                "Ok Continue",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "cutes",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        text: description,
        linkStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
    );

    // return LinkifyText(
    // widget.description,
    // textAlign: TextAlign.left,
    // linkTypes: [
    // LinkType.url,
    // LinkType.hashTag,
    // ],
    // linkStyle: TextStyle(
    // fontSize: 13,
    // fontFamily: "cutes",
    // fontWeight: FontWeight.bold,
    // color: Colors.lightBlue),
    // onTap: (link) => {
    // url = link.value.toString(),
    // },
    // );
  }

  _description(String description) {
    return description.length == 0
        ? Container(
            height: 0,
            width: 0,
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          if (description.length > 34)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    "Caption:  ",
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 15,
                                        fontFamily: 'cute'),
                                  ),
                                ),
                                textControl(description.substring(0, 20)),
                                TextButton(
                                  onPressed: () {
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
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3.5,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Text(
                                                        'Caption',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.lightBlue,
                                                          fontFamily: 'cute',
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: textControl(
                                                          description),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Read More...",
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 12,
                                        fontFamily: 'cute'),
                                  ),
                                ),
                              ],
                            )
                          // GestureDetector(
                          //   onTap: () => {
                          //     showModalBottomSheet(
                          //         useRootNavigator: true,
                          //         isScrollControlled: true,
                          //         barrierColor: Colors.red.withOpacity(0.2),
                          //         elevation: 0,
                          //         clipBehavior: Clip.antiAliasWithSaveLayer,
                          //         context: context,
                          //         builder: (context) {
                          //           return Container(
                          //             height:
                          //                 MediaQuery.of(context).size.height /
                          //                     2,
                          //             child: SingleChildScrollView(
                          //               child: Column(
                          //                 children: [
                          //                   Padding(
                          //                     padding:
                          //                         const EdgeInsets.all(8.0),
                          //                     child: Row(
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.center,
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.center,
                          //                       children: [
                          //                         Icon(Icons
                          //                             .linear_scale_sharp),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                   Padding(
                          //                     padding:
                          //                         const EdgeInsets.all(8.0),
                          //                     child: LinkifyText(
                          //                       description,
                          //                       textAlign: TextAlign.left,
                          //                       linkTypes: [
                          //                         LinkType.email,
                          //                         LinkType.url,
                          //                         LinkType.hashTag,
                          //                         LinkType.userTag,
                          //                       ],
                          //                       linkStyle: TextStyle(
                          //                           fontSize: 13,
                          //                           fontFamily: "cutes",
                          //                           fontWeight:
                          //                               FontWeight.bold,
                          //                           color: Colors.lightBlue),
                          //                       onTap: (link) => {
                          //                         // url = link.value.toString(),
                          //                         // _launchURL('http://$url'),
                          //                       },
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           );
                          //         }),
                          //   },
                          //   child: LinkifyText(
                          //     "@Caption: " +
                          //         description.substring(0, 30) +
                          //         " ...(readMore)",
                          //     textAlign: TextAlign.left,
                          //     linkTypes: [
                          //       LinkType.email,
                          //       LinkType.url,
                          //       LinkType.hashTag,
                          //       LinkType.userTag,
                          //     ],
                          //     linkStyle: TextStyle(
                          //         fontSize: 13,
                          //         fontFamily: "cutes",
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.lightBlue),
                          //     onTap: (link) => {
                          //       // url = link.value.toString(),
                          //       // _launchURL('http://$url'),
                          //     },
                          //   ),
                          // )
                          else
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.5),
                                  child: Text(
                                    "Caption:  ",
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 15,
                                        fontFamily: 'cute'),
                                  ),
                                ),
                                textControl(description),
                              ],
                            )
                          // GestureDetector(
                          //   onTap: () => {
                          //     bottomSheetForCommentSection(description),
                          //   },
                          //   child: LinkifyText(
                          //     "@Caption: " + description,
                          //     textAlign: TextAlign.left,
                          //     linkTypes: [
                          //       LinkType.email,
                          //       LinkType.url,
                          //       LinkType.hashTag,
                          //       LinkType.userTag,
                          //     ],
                          //     linkStyle: TextStyle(
                          //         fontSize: 13,
                          //         fontFamily: "cutes",
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.lightBlue),
                          //     onTap: (link) => {
                          //       // url = link.value.toString(),
                          //       // _launchURL('http://$url'),
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future bottomSheetForCommentSection(String description) {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 3.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BarTop(),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                    child: ElevatedButton(
                      child: Row(
                        children: [
                          Text(
                            'Copy ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'cute',
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.copy,
                            color: Colors.black,
                            size: 17,
                          ),
                        ],
                      ),
                      onPressed: () => {
                        Clipboard.setData(ClipboardData(text: description)),
                        Fluttertoast.showToast(
                          msg: "Copied",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.blue.withOpacity(0.8),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        ),
                        Navigator.pop(context),
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: Colors.white,
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  userAgreement(String isSkip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("agreement") == null) {
      prefs.setInt("agreement", 0);
      print("agreement: ${prefs.getInt("agreement")}");

      bottomSheetForAgreement();
    } else {
      if (prefs.getInt("agreement")! > 0) {
        print("agreement: ${prefs.getInt("agreement")}");
        if (isSkip == "yes") {
        } else {
          surpriseMeme.createState().bottomSheetToShowMeme(
              context,
              "https://switchappimages.nyc3.digitaloceanspaces.com/appMemes/switchMeme2.jpg",
              "");
        }
      } else {
        print("agreement: ${prefs.getInt("agreement")}");

        bottomSheetForAgreement();
      }
      //  followSwitchId();
      // bottomSheetForFollowing();
    }
  }

  bottomSheetForAgreement() {
    return showModalBottomSheet(
        useRootNavigator: true,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        barrierColor: Colors.blue.withOpacity(0.4),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BarTop(),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserAgreementPage(),
                          ),
                        ),
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            child: Center(
                              child: Text(
                                "Terms of use & Privacy Policy",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'cute',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            height: 38,
                            width: MediaQuery.of(context).size.width / 1.2,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserAgreementPage(),
                          ),
                        ),
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "Do you agree ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'cute',
                                    )),
                                TextSpan(
                                  text: 'Switch App ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue.shade900,
                                    fontFamily: 'cute',
                                  ),
                                ),
                                TextSpan(
                                    text: 'Terms of use & ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'cute',
                                    )),
                                TextSpan(
                                  text: 'Privacy Policy.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'cute',
                                    color: Colors.lightBlue.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt("agreement", 2);
                        if (prefs.getInt("intro") == 0) {
                          Navigator.pop(context);

                          print("00000000000000000000000");
                        } else {
                          // print("11111111111111111111111");
                          //
                          // surpriseMeme.createState().bottomSheetToShowMeme(
                          //     context,
                          //     "https://switchappimages.nyc3.digitaloceanspaces.com/appMemes/switchMeme2.jpg",
                          //     "");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LandingPage()),
                                (Route<dynamic> route) => false,
                          );                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 45,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Agree and Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  getPostDetail(String postId) {
    User user = Provider.of<User>(context, listen: false);

    reactRtDatabaseReference
        .child('reactors')
        .child(postId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        Map data = dataSnapshot.value;
        data.forEach((index, data) => reactorList.add({"key": index, ...data}));

        showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            barrierColor: Colors.red.withOpacity(0.2),
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Reactors",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "cute",
                                  color: Colors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 1.6,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: reactorList.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              _getUserDetail(reactorList[index]['reactorId']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      reactorList[index]['reactorPhoto'],
                                      height: 25.0,
                                      width: 25.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4, left: 8),
                                    child: Text(
                                      "${reactorList[index]['reactorName']}",
                                      style: TextStyle(
                                          fontFamily: 'cute', fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      } else {
        Fluttertoast.showToast(
          msg: "There are 0 reactors",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blue.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  deleteFunc(String postId, String ownerId, String type, int index) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) if (type ==
              'meme' ||
          type == "memeT" ||
          type == "videoMeme" ||
          type == "videoMemeT") {
        reactRtDatabaseReference
            .child(postId)
            .once()
            .then((DataSnapshot dataSnapshot) {
          if (dataSnapshot.value != null) {
            Map data = dataSnapshot.value;

            if (mounted)
              setState(() {
                like = data['like'];
                disLike = data['disLike'];
                heartReact = data['heartReact'];
              });

            total = (like + disLike + heartReact) * 1;
          } else {
            print("there is no react on this post");
          }
        });
      } else {
        print("Not a mememmmmmmmmmmmmmmmmmmmmmmmmmm");
      }

      postsRtd.child(ownerId).child("usersPost").child(postId).remove();
      switchAllUserFeedPostsRTD.child("UserPosts").child(postId).remove();

      setState(() {
        limitedPostList.removeAt(index);
      });
      switchMemeCompRTD
          .child('live')
          .child(ownerId)
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.exists) {
          ///Slit is here
          // switchMemerSlitsRTD
          //     .child(ownerId)
          //     .once()
          //     .then((DataSnapshot dataSnapshot) {
          //   Map data = dataSnapshot.value;
          //   int slits = data['totalSlits'];
          //   setState(() {
          //     slits = slits - (1000 + total);
          //   });
          //   Future.delayed(const Duration(milliseconds: 100), () {
          //     switchMemerSlitsRTD.child(ownerId).update({
          //       'totalSlits': slits,
          //     });
          //   });
          // });

          switchMemeCompRTD
              .child(ownerId)
              .once()
              .then((DataSnapshot dataSnapshot) {
            Map data = dataSnapshot.value;
            int takePart = data['takePart'];
            setState(() {
              takePart = takePart - 1;
            });

            Future.delayed(const Duration(milliseconds: 200), () {
              switchMemeCompRTD.child(ownerId).update({
                'takePart': takePart,
              });
            });
          });
          Future.delayed(const Duration(milliseconds: 400), () {
            switchMemeCompRTD.child('live').child(ownerId).remove();

            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: "Deleted! Refresh App :)",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              fontSize: 16.0,
            );
          });
        } else {
          if (type == 'meme' ||
              type == "memeT" ||
              type == "videoMeme" ||
              type == "videoMemeT") {
            ///Slit is here
            // switchMemerSlitsRTD
            //     .child(ownerId)
            //     .once()
            //     .then((DataSnapshot dataSnapshot) {
            //   Map data = dataSnapshot.value;
            //   int slits = data['totalSlits'];
            //   setState(() {
            //     slits = slits - (20 + total);
            //   });
            //   Future.delayed(const Duration(milliseconds: 100), () {
            //     switchMemerSlitsRTD.child(ownerId).update({
            //       'totalSlits': slits,
            //     });
            //
            //     Navigator.pop(context);
            //     Fluttertoast.showToast(
            //       msg: "Deleted! Refresh App :)",
            //       toastLength: Toast.LENGTH_LONG,
            //       gravity: ToastGravity.SNACKBAR,
            //       timeInSecForIosWeb: 5,
            //       backgroundColor: Colors.white,
            //       textColor: Colors.blue,
            //       fontSize: 16.0,
            //     );
            //   });
            // });
          } else {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: "Deleted! Refresh App :)",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              fontSize: 16.0,
            );
          }
        }
      });
    } on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: "Wifi/Data not connected",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  whatsNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("whatsNew") == null) {
      prefs.setInt("whatsNew", 0);
      print("whatsNew: ${prefs.getInt("whatsNew")}");

      universalMethods.whatsNew(context);
    } else {
      if (prefs.getInt("whatsNew")! > 1) {
        print("whatsNew: ${prefs.getInt("whatsNew")}");
      } else {
        print("whatsNew: ${prefs.getInt("whatsNew")}");

        universalMethods.whatsNew(context);
      }
      //  followSwitchId();
      // bottomSheetForFollowing();
    }
  }

  Widget yourFeed() {
    return Provider<User>.value(
      value: widget.user,
      child: YourFeed(
        user: widget.user,
        isHide: isHide,
      ),
    );
  }

  Widget memesOnly() {
    return Provider<User>.value(
      value: widget.user,
      child: MemesOnly(
        user: widget.user,
        isHide: isHide,
        allPostMap: allPostMap,
      ),
    );
  }

  Widget nameAndStuff() {
    if (!_isHide) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Provider.value(
                key: nameAndStuffIntro,
                value: widget.user,
                child: DelayedDisplay(
                  delay: Duration(microseconds: 500),
                  slidingBeginOffset: Offset(-1, 0.0),
                  child: ProfileIconAndName(
                    user: widget.user,
                  ),
                ),
              ),
              Row(
                children: [
                  DelayedDisplay(
                    delay: Duration(microseconds: 500),
                    slidingBeginOffset: Offset(1, 0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: GestureDetector(
                        onLongPress: () {
                          if (widget.user.uid == Constants.switchId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Provider<User>.value(
                                  value: widget.user,
                                  child: AdminPage(
                                    user: widget.user,
                                    controlData: widget.controlData,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Constants.messageIconActive
                            ? GestureDetector(
                                onTap: () {
                                  Fluttertoast.showToast(
                                    msg: "Click on Chat Icon :/",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                                child: Text(
                                  "Unread Message",
                                  style: TextStyle(
                                      color: Colors.lightBlue.shade700,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                      fontFamily: 'cute'),
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    "Switch ",
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'cute'),
                                    textAlign: TextAlign.center,
                                  ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(8)),
                                  //   height: 40,
                                  //   width: 40,
                                  //   child: RiveAnimation.asset(
                                  //     'images/switchLogoBlue1.riv',
                                  //   ),
                                  // ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 200),
                    slidingBeginOffset: Offset(1, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 8, top: 8),
                            child: GestureDetector(
                              child: isNotification
                                  ? Stack(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Icon(
                                            Icons.notifications_active_rounded,
                                            color: Colors.lightBlue,
                                            size: 25,
                                          ),
                                        ),
                                        Positioned(
                                            left: 5,
                                            bottom: 2,
                                            child: SpinKitPulse(
                                              color: Colors.red,
                                              size: 15,
                                            )),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 7),
                                      child: Icon(
                                        Icons.notifications_none_sharp,
                                        size: 25,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                              onTap: () {
                                NotifyBottomBar nb = new NotifyBottomBar();
                                nb.bottomSheetForNotify(context, widget.user);

                                Future.delayed(const Duration(seconds: 2), () {
                                  if (mounted)
                                    setState(() {
                                      isNotification = false;
                                    });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  Widget frontSlide() {
    if (!_isHide) {
      return Container(
        key: frontSlidIntro,
        height: 100,
        child: DelayedDisplay(
          delay: Duration(milliseconds: 600),
          slidingBeginOffset: Offset(0.0, 1),
          child: FrontSlide(),
        ),
      );
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  Widget tabBar(User user) {
    return !_isHide
        ? Container(
            height: 75,
            alignment: Alignment.center,
            //Set container alignment  then wrap the column with singleChildScrollView
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 200),
                  //   slidingBeginOffset: Offset(1, 0.0),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         "Add Post",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.w700,
                  //           fontSize: 10.0,
                  //         ),
                  //       ),
                  //       ElevatedButton(
                  //         key: addPostIntro,
                  //         child: Icon(
                  //           Icons.add_box_outlined,
                  //           size: 25,
                  //           color: Colors.lightBlue,
                  //         ),
                  //         onPressed: () {
                  //           simpleStatusPage(user);
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //             primary: Colors.transparent,
                  //             elevation: 0.0,
                  //             textStyle: TextStyle(
                  //                 fontSize: 15, fontWeight: FontWeight.bold)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 400),
                  //   slidingBeginOffset: Offset(1, 0.0),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         "Mood",
                  //         style: TextStyle(
                  //             fontSize: 10.0, fontWeight: FontWeight.w700),
                  //       ),
                  //       ElevatedButton(
                  //         child: Icon(
                  //           Icons.stream,
                  //           size: 25,
                  //           color: Colors.lightBlue,
                  //         ),
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               PageTransition(
                  //                 type: PageTransitionType.bottomToTop,
                  //                 child: Provider<User>.value(
                  //                   value: user,
                  //                   child: Mood(
                  //                     user: user,
                  //                   ),
                  //                 ),
                  //               ));
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //             elevation: 0.0,
                  //             primary: Colors.transparent,
                  //             textStyle: TextStyle(
                  //                 fontSize: 15, fontWeight: FontWeight.bold)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 550),
                  //   slidingBeginOffset: Offset(1, 0.0),
                  //   child: SingleChildScrollView(
                  //     child: Column(
                  //       children: [
                  //         Text(
                  //           "Notify",
                  //           key: key,
                  //           style: TextStyle(
                  //               fontSize: 10.0, fontWeight: FontWeight.w700),
                  //         ),
                  //         ElevatedButton(
                  //           child: isNotification
                  //               ? Stack(
                  //                   children: [
                  //                     Padding(
                  //                       padding:
                  //                           const EdgeInsets.only(bottom: 8),
                  //                       child: Icon(
                  //                         Icons.notifications_active_rounded,
                  //                         color: Colors.lightBlue,
                  //                         size: 22,
                  //                       ),
                  //                     ),
                  //                     Positioned(
                  //                         left: 5,
                  //                         bottom: 2,
                  //                         child: SpinKitPulse(
                  //                           color: Colors.red,
                  //                           size: 19,
                  //                         )),
                  //                   ],
                  //                 )
                  //               : Padding(
                  //                   padding: const EdgeInsets.only(bottom: 7),
                  //                   child: Icon(
                  //                     Icons.notifications_none_sharp,
                  //                     size: 22,
                  //                     color: Colors.lightBlue,
                  //                   ),
                  //                 ),
                  //           onPressed: () {
                  //             // bottomSheetForNotify();
                  //
                  //             Future.delayed(const Duration(seconds: 2), () {
                  //               if (mounted)
                  //                 setState(() {
                  //                   isNotification = false;
                  //                 });
                  //             });
                  //           },
                  //           style: ElevatedButton.styleFrom(
                  //               elevation: 0.0,
                  //               primary: Colors.transparent,
                  //               textStyle: TextStyle(
                  //                   fontSize: 15, fontWeight: FontWeight.bold)),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 750),
                  //   slidingBeginOffset: Offset(1, 0.0),
                  //   child: Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(bottom: 2),
                  //         child: Text(
                  //           "Clusty Chat ",
                  //           style: TextStyle(
                  //               fontSize: 10.0, fontWeight: FontWeight.w700),
                  //         ),
                  //       ),
                  //       Stack(
                  //         key: clustyChatIntro,
                  //         children: [
                  //           ElevatedButton(
                  //             child: Icon(
                  //               Icons.mark_chat_unread_outlined,
                  //               color: Colors.lightBlue,
                  //               size: 24,
                  //             ),
                  //             onPressed: () {
                  //               Navigator.push(
                  //                   context,
                  //                   PageTransition(
                  //                     type: PageTransitionType.bottomToTop,
                  //                     child: Provider<User>.value(
                  //                       value: user,
                  //                       child: WorldChat(
                  //                         user: user,
                  //                         userId: user.uid,
                  //                       ),
                  //                     ),
                  //                   ));
                  //             },
                  //             style: ElevatedButton.styleFrom(
                  //                 elevation: 0.0,
                  //                 primary: Colors.transparent,
                  //                 textStyle: TextStyle(
                  //                     fontSize: 15,
                  //                     fontWeight: FontWeight.bold)),
                  //           ),
                  //           // Positioned(left: 6.2,
                  //           //   child: Container(
                  //           //     height: 50,
                  //           //     width: 50,
                  //           //     child: SpinKitRipple(
                  //           //       color: Colors.lightBlue,
                  //           //     ),
                  //           //   ),
                  //           // ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 700),
                  //   slidingBeginOffset: Offset(1, 0.0),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         "Search",
                  //         style: TextStyle(
                  //             fontSize: 10.0, fontWeight: FontWeight.w700),
                  //       ),
                  //       ElevatedButton(
                  //         child: Icon(
                  //           Icons.search_rounded,
                  //           color: Colors.lightBlue,
                  //           size: 25,
                  //         ),
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               PageTransition(
                  //                 type: PageTransitionType.bottomToTop,
                  //                 child: Provider<User>.value(
                  //                   value: user,
                  //                   child: MainSearchPage(
                  //                     navigateThrough: "",
                  //                     user: user,
                  //                     userId: user.uid,
                  //                   ),
                  //                 ),
                  //               ));
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //             elevation: 0.0,
                  //             primary: Colors.transparent,
                  //             textStyle: TextStyle(
                  //                 fontSize: 15, fontWeight: FontWeight.bold)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 1000),
                  //   slidingBeginOffset: Offset(1, 0.0),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         "Edit D.P",
                  //         style: TextStyle(
                  //             fontSize: 10.0, fontWeight: FontWeight.w700),
                  //       ),
                  //       ElevatedButton(
                  //         child: Icon(
                  //           Icons.account_circle_outlined,
                  //           color: Colors.lightBlue,
                  //           size: 25,
                  //         ),
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               PageTransition(
                  //                 type: PageTransitionType.bottomToTop,
                  //                 child: EditProfilePic(
                  //                   uid: Constants.myId,
                  //                   imgUrl: Constants.myPhotoUrl,
                  //                 ),
                  //               ));
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //             elevation: 0.0,
                  //             primary: Colors.transparent,
                  //             textStyle: TextStyle(
                  //                 fontSize: 15, fontWeight: FontWeight.bold)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        : Container(
            height: 0,
            width: 0,
          );
  }

  Widget allLine() {
    return DelayedDisplay(
      delay: Duration(milliseconds: _isHide ? 100 : 600),
      slidingBeginOffset: Offset(0.0, 0.40),
      child: Padding(
        padding: EdgeInsets.only(top: _isHide ? 8 : 0),
        child: Container(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    key: recentPostsIntro,
                    onTap: () {
                      setState(() {
                        currentLine = 1;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      padding: EdgeInsets.all(5),
                      // decoration: BoxDecoration(
                      //     color: currentLine == 1
                      //         ? Colors.lightBlue
                      //         : Constants.isDark == "true"
                      //         ? Colors.grey.shade800
                      //         : Colors.white,
                      //     border: Border.all(
                      //       color: Colors.lightBlue,
                      //     ),
                      //     borderRadius: BorderRadius.circular(5.5)),
                      child: Container(
                        height: 40,
                        child: Column(
                          children: [
                            Center(
                              child: MarqueeWidget(
                                child: Text(
                                  "Recent",
                                  style: TextStyle(
                                    color: currentLine == 1
                                        ? Colors.lightBlue
                                        : Constants.isDark == "true"
                                            ? Colors.white
                                            : Colors.lightBlue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    fontFamily: 'cute',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              padding: EdgeInsets.all(5),
                              height: 2,
                              color: currentLine == 1
                                  ? Colors.lightBlue
                                  : Constants.isDark == "true"
                                      ? Colors.transparent
                                      : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      height: 35,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentLine = 2;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      padding: EdgeInsets.all(5.0),
                      // decoration: BoxDecoration(
                      //     color: currentLine == 2
                      //         ? Colors.lightBlue
                      //         : Constants.isDark == "true"
                      //             ? Colors.grey.shade800
                      //             : Colors.white,
                      //     border: Border.all(
                      //       color: Colors.lightBlue,
                      //     ),
                      //     borderRadius: BorderRadius.circular(5.5)),
                      child: Column(
                        children: [
                          Center(
                            child: MarqueeWidget(
                              child: Text(
                                "Following",
                                style: TextStyle(
                                  color: currentLine == 2
                                      ? Colors.lightBlue
                                      : Constants.isDark == "true"
                                          ? Colors.white
                                          : Colors.lightBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  fontFamily: 'cute',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3.5,
                            padding: EdgeInsets.all(5),
                            height: 2,
                            color: currentLine == 2
                                ? Colors.lightBlue
                                : Constants.isDark == "true"
                                ? Colors.transparent
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      height: 35,
                    ),
                  ),
                  GestureDetector(
                    key: switchUpdatesIntro,
                    onTap: () {
                      setState(() {
                        currentLine = 3;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      padding: EdgeInsets.all(5.0),
                      // decoration: BoxDecoration(
                      //     color: currentLine == 3
                      //         ? Colors.lightBlue
                      //         : Constants.isDark == "true"
                      //             ? Colors.grey.shade800
                      //             : Colors.white,
                      //     border: Border.all(
                      //       color: Colors.lightBlue,
                      //     ),
                      //     borderRadius: BorderRadius.circular(5.5)),
                      child: Column(
                        children: [
                          Center(
                            child: MarqueeWidget(
                              child: Text(
                                "Memes",
                                style: TextStyle(
                                  color: currentLine == 3
                                      ? Colors.lightBlue
                                      : Constants.isDark == "true"
                                          ? Colors.white
                                          : Colors.lightBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  fontFamily: 'cute',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3.5,
                            padding: EdgeInsets.all(5),
                            height: 2,
                            color: currentLine == 3
                                ? Colors.lightBlue
                                : Constants.isDark == "true"
                                ? Colors.transparent
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      height: 35,
                    ),
                  ),
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 200),
                  //   slidingBeginOffset: Offset(1, 0.0),
                  //   child: SingleChildScrollView(
                  //     child: Container(
                  //       width: 60,
                  //       child: Column(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(right: 12, top: 8),
                  //             child: GestureDetector(
                  //               child: isNotification
                  //                   ? Stack(
                  //                       children: [
                  //                         Padding(
                  //                           padding:
                  //                               const EdgeInsets.only(bottom: 8),
                  //                           child: Icon(
                  //                             Icons.notifications_active_rounded,
                  //                             color: Colors.lightBlue,
                  //                             size: 25,
                  //                           ),
                  //                         ),
                  //                         Positioned(
                  //                             left: 5,
                  //                             bottom: 2,
                  //                             child: SpinKitPulse(
                  //                               color: Colors.red,
                  //                               size: 15,
                  //                             )),
                  //                       ],
                  //                     )
                  //                   : Padding(
                  //                       padding: const EdgeInsets.only(bottom: 7),
                  //                       child: Icon(
                  //                         Icons.notifications_none_sharp,
                  //                         size: 25,
                  //                         color: Colors.lightBlue,
                  //                       ),
                  //                     ),
                  //               onTap: () {
                  //                 NotifyBottomBar nb = new NotifyBottomBar();
                  //                 nb.bottomSheetForNotify(context, widget.user);
                  //
                  //                 Future.delayed(const Duration(seconds: 2), () {
                  //                   if (mounted)
                  //                     setState(() {
                  //                       isNotification = false;
                  //                     });
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  videoPosts(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return InViewNotifierWidget(
            id: '$index',
            builder: (BuildContext context, bool isInView, Widget? child) {
              return VideoWidget(
                // remove (== true ? false :false,) to make it in-view
                play: isInView == true ? false : false,
                url: limitedPostList[index]['url'],
                time: limitedPostList[index]['timestamp'],
              );
            },
          );
        },
      ),
    );
  }

  imagePosts(int index) {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SwitchCacheImage(
              url: limitedPostList[index]['url'],
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              boxFit: BoxFit.fill,
              screen: 'mainFeed',
            )),
      ),
    );
  }
}
