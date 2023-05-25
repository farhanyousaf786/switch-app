/*
 * This will be the first page that user see
 * after login or may be after signUp successfully.
 */

import 'dart:convert';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/pages/sign_up/SetUserData.dart';
import 'package:switchapp/pages/app_settings/settings.dart';
import 'package:switchapp/pages/Profile/memeProfile/Meme-profile.dart';
import 'package:switchapp/pages/all_posts/MainFeed/MainFeed.dart';
import 'package:switchapp/pages/Upload/addStatuse.dart';
import 'package:switchapp/pages/Upload/videoStatus.dart';
import 'package:switchapp/pages/chat/SwitchChatList.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/UsernameNotSetPage.dart';
import 'package:switchapp/Models/inAppNotificationModel.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import '../search/MainSearchPage.dart';

class NavigationPage extends StatefulWidget {
  final User user;
  final Map? controlData;
  final String appVersion;

  const NavigationPage(
      {required this.user,
      required this.controlData,
      required this.appVersion});

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  bool isNotification = false;
  late int limitForUser = 400;
  late int limitForPosts = 6;
  List chatList = [];
  bool unread = false;
  List userLists = [];
  List followingList = [];
  Map? inRelationShipData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late String notificationContent;
  late String type;
  late PageController pageController;
  List posts = [];
  int _selectedIndex = 0;
  final player = AudioPlayer();
  List finalFollowingList = [];

  @override
  void initState() {
    super.initState();
    additionalInitialization();
    getRelationShipStatus();
    configNotification();
    getInAppAllNotification();
    checkUnreadMessages();
    getFollowingUsers();
  }

  additionalInitialization() {
    Constants.pass = "";
    pageController = PageController();
    Constants.myId = widget.user.uid;
    WidgetsBinding.instance!.addObserver(this);
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted)
        setState(() {
          Constants.notifyCounter = 1;
        });
    });
  }

  getFollowingUsers() async {
    List followingList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("followList")) {
      finalFollowingList =
          json.decode(prefs.getString('followList').toString());
      print("><><>>>>>>>>>>>>>>>>>>> ${finalFollowingList}");
    } else {
      userFollowingRtd
          .child(widget.user.uid)
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          Map data = dataSnapshot.value;
          data.forEach(
              (index, data) => followingList.add({"key": index, ...data}));
          for (int i = 0; i <= data.length - 1; i++) {
            finalFollowingList.add(followingList[i]['followingId']);
          }
          prefs.setString('followList', jsonEncode(finalFollowingList));
          var s = jsonEncode(finalFollowingList);
          finalFollowingList = json.decode(s);
        } else {
          print("FollowerList 0 = = = = = = = = > $followingList");
        }
      });
    }
  }

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
    print(message.data);
    flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            //  channel.description,
          ),
        ));
  }

  Future<dynamic> onSelectNotification(payLoad) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Provider<User>.value(
          value: widget.user,
          child: SwitchChatList(
            user: widget.user,
            isInRelationShipMap: inRelationShipData,
          ),
        ),
      ),
    );
  }

  configNotification() async {
    final user = Provider.of<User>(context, listen: false);

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      Map<String, dynamic> dataValue = message.data;
      String screen = dataValue['screen'].toString();
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              //channel.description,
              icon: android.smallIcon,
            ),
          ),
          payload: screen,
        );
      }
    });
    FirebaseMessaging.instance.getToken().then((token) {
      userRefRTD.child(user.uid).update({"androidNotificationToken": token});
    });
  }

  getRelationShipStatus() async {
    relationShipReferenceRtd
        .child(widget.user.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        if (mounted)
          setState(() {
            inRelationShipData = dataSnapshot.value;
          });
      }
    });
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launchCount + 1);
    if (launchCount == 0) {
    } else {}
  }

  void setStatus(String status) {
    userRefRTD.child(widget.user.uid).update({"isOnline": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("true");
    } else {
      setStatus("false");
    }
  }

  getInAppAllNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRefRTD.child(Constants.myId).update({"isOnline": "true"});
    feedRtDatabaseReference
        .child(Constants.myId)
        .child("feedItems")
        .orderByChild("timestamp")
        .limitToLast(1)
        .onChildAdded
        .listen((data) {
      Map item = data.snapshot.value;
      if (Constants.notifyCounter == 1) {
        Constants.notificationType = "Notification";
        if (item['type'] == "comment") {
          Constants.notificationContent = "Comment :${item['comment']}";
        } else if (item['type'] == "follow") {
          Constants.notificationContent =
              "${item['firstName']} is Following You";
        } else if (item['type'] == "sendRequestToConformRelationShip") {
          Constants.notificationContent =
              " ${item['firstName']} wants to be in relationship with you";
        } else if (item['type'] == "ConformedAboutRelationShip") {
          Constants.notificationContent =
              "You are in relationship with ${item['firstName']}";
        } else if (item['type'] == "crushOnReference") {
          Constants.notificationContent =
              " ${item['firstName']} has Crush On You 💝";
        } else if (item['type'] == 'notInterested') {
          Constants.notificationContent =
              " ${item['firstName']} person is not interested in you.";
        } else if (item['type'] == 'cancelRequest') {
          Constants.notificationContent =
              " ${item['firstName']} sent you relationship request and then cancel it too.";
        } else if (item['type'] == 'breakUp') {
          Constants.notificationContent =
              " ${item['firstName']} Broken Up with you.";
        } else if (item['type'] == 'disLike' ||
            item['type'] == 'loveIt' ||
            item['type'] == 'like') {
          Constants.notificationContent =
              " ${item['firstName']} reacted to your Post";
        } else if (item['type'] == 'profileRating') {
          Constants.notificationContent =
              " ${item['firstName']} Rated your Profile";
        } else if (item['type'] == 'memeProfileRating') {
          Constants.notificationContent =
              " ${item['firstName']} Rated your MEME Profile";
        } else if (item['type'] == 'Friend') {
          Constants.notificationContent =
              "${item['firstName']} add you As Bestie";
        } else if (item['type'] == 'unFriend') {
          Constants.notificationContent =
              "Sorry, But  ${item['firstName']} remove you from Bestie";
        }

        if (prefs.getString("notifyCounter") == "0") {
          userRefRTD.child(Constants.myId).update({"isOnline": "true"});
          prefs.setString("notifyCounter", "1");
        } else {
          if (mounted)
            setState(() {
              isNotification = true;
            });
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted)
              setState(() {
                isNotification = false;
              });
          });
          player.setAsset('assets/inAppNotification.mp3');
          player.play();
        }
      }
    });
  }

  getInAppNotification() {
    if (Constants.notifyCounter == 1) {
      if (mounted)
        setState(() {
          isNotification = true;
        });
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted)
          setState(() {
            isNotification = false;
          });
      });
    }
  }

  /// NavigationBar
  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  // getFollowingUsers(String uid) async {
  //   userFollowingRtd.child(uid).once().then((DataSnapshot dataSnapshot) {
  //     if (dataSnapshot.value != null) {
  //       Map data = dataSnapshot.value;
  //       data.forEach(
  //           (index, data) => followingList.add({"key": index, ...data}));
  //       followingList.shuffle();
  //       if (mounted) setState(() {});
  //     } else {
  //       print("There is no post");
  //     }
  //   });
  // }

  simpleStatusPage(User user) {
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
                  backgroundColor: Colors.lightBlue,
                  elevation: 0.0,
                  title: Text(
                    "Add to Timeline",
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
                                height: 150,
                                width: 150,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Lottie.asset(
                                    'images/StatusUpload.json',
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 20),
                                  child: Text(
                                    "You can Upload any image that's not suits your mood. After All this is Parallel Universe, Isn't? :):",
                                    style: TextStyle(
                                      fontFamily: 'cute',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1,
                                  ),
                                ),
                                onTap: () {},
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              child: Provider<User>.value(
                                                value: user,
                                                child: AddStatus(
                                                  type: "thoughts",
                                                  uid: user.uid,
                                                ),
                                              ),
                                            )),
                                      },
                                      child: Center(
                                          child: Column(
                                        children: [
                                          Text(
                                            "Share Thoughts",
                                            style: TextStyle(
                                                fontFamily: 'cute',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.lightBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.all_inclusive,
                                              color: Colors.lightBlue,
                                            ),
                                          )
                                        ],
                                      )),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              child: Provider<User>.value(
                                                value: user,
                                                child: AddStatus(
                                                  type: "photo",
                                                  uid: user.uid,
                                                ),
                                              ),
                                            )),
                                      },
                                      child: Center(
                                          child: Column(
                                        children: [
                                          Text(
                                            "Upload Photo",
                                            style: TextStyle(
                                                fontFamily: 'cute',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.lightBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.insert_photo_outlined,
                                              color: Colors.lightBlue,
                                            ),
                                          )
                                        ],
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontFamily: 'cute'),
                                ),
                              ),
                              TextButton(
                                onPressed: () => {
                                  memeUploadPage(user),
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
                                          color: Colors.lightBlue.shade400,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Upload Meme",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 500),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 5),
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
                    ),
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 600),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Padding(
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
                    ),
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 500),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 5),
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
                    ),
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 600),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Padding(
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
                    ),
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 600),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 5),
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
                    ),
                    DelayedDisplay(
                      fadeIn: true,
                      delay: Duration(milliseconds: 600),
                      slidingBeginOffset: Offset(0.0, 0.40),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 10),
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
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  memeUploadPage(User user) {
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
                  backgroundColor: Colors.lightBlue,
                  elevation: 0.0,
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
                                          uid: user.uid,
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
                                              "Photo Meme",
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Provider<User>.value(
                                        value: user,
                                        child: VideoStatus(
                                          type: "videoMeme",
                                          user: user,
                                        ),
                                      ),
                                    ),
                                  )

                                  ///**********  Following code can restrict user to upload Video meme   **********///
                                  // widget.user.uid == Constants.switchId ||
                                  //     widget.user.uid ==
                                  //         Constants.switchIdFarhan
                                  //     ? Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //     Provider<User>.value(
                                  //       value: user,
                                  //       child: VideoStatus(
                                  //         type: "videoMeme",
                                  //         user: user,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                  //     : showModalBottomSheet(
                                  //     useRootNavigator: true,
                                  //     isScrollControlled: true,
                                  //     barrierColor:
                                  //     Colors.red.withOpacity(0.2),
                                  //     elevation: 0,
                                  //     clipBehavior:
                                  //     Clip.antiAliasWithSaveLayer,
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return Container(
                                  //         height: MediaQuery
                                  //             .of(context)
                                  //             .size
                                  //             .height /
                                  //             3,
                                  //         child: SingleChildScrollView(
                                  //           child: Column(
                                  //             children: [
                                  //               Padding(
                                  //                 padding:
                                  //                 const EdgeInsets.all(
                                  //                     5.0),
                                  //                 child: Row(
                                  //                   crossAxisAlignment:
                                  //                   CrossAxisAlignment
                                  //                       .center,
                                  //                   mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .center,
                                  //                   children: [
                                  //                     Icon(Icons
                                  //                         .linear_scale_sharp),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                 const EdgeInsets.all(
                                  //                     8.0),
                                  //                 child: Text(
                                  //                   "Video Meme only available in Meme competition. If this Switch App will perform well, we will allow this option here too.",
                                  //                   textAlign:
                                  //                   TextAlign.center,
                                  //                   style: TextStyle(
                                  //                       fontSize: 15,
                                  //                       fontFamily: "cutes",
                                  //                       fontWeight:
                                  //                       FontWeight.bold,
                                  //                       color: Colors.lightBlue),
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                 const EdgeInsets.all(
                                  //                     8.0),
                                  //                 child: Text(
                                  //                   "Why?",
                                  //                   textAlign:
                                  //                   TextAlign.center,
                                  //                   style: TextStyle(
                                  //                       fontSize: 15,
                                  //                       fontFamily: "cutes",
                                  //                       fontWeight:
                                  //                       FontWeight.bold,
                                  //                       color: Colors
                                  //                           .red.shade700),
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                 const EdgeInsets.all(
                                  //                     8.0),
                                  //                 child: Text(
                                  //                   "Database for videos is very Expensive. And our budget is not enough to bear the cost yet. Hope we will allow it in future, very soon. ",
                                  //                   textAlign:
                                  //                   TextAlign.center,
                                  //                   style: TextStyle(
                                  //                       fontSize: 15,
                                  //                       fontFamily: "cutes",
                                  //                       fontWeight:
                                  //                       FontWeight.bold,
                                  //                       color: Colors.grey),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: _selectedIndex == 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 6, bottom: 16),
                  child: FloatingActionButton(
                    onPressed: () {
                      simpleStatusPage(widget.user);
                    },
                    elevation: 0,
                    backgroundColor: Colors.lightBlue,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.bubble_chart_outlined),
                label: 'Timeline',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fiber_smart_record_outlined),
                label: 'Meme',
              ),
              BottomNavigationBarItem(
                label: 'Chat',
                icon: new Stack(children: <Widget>[
                  new Icon(Icons.messenger_outline),
                  unread
                      ? new Positioned(
                          // draw a red marble
                          top: 0.0,
                          right: 0.0,
                          child: new Icon(Icons.brightness_1,
                              size: 8.0, color: Colors.redAccent),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        )
                ]),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                icon: Icon(Icons.sort),
                label: 'Switch',
              ),
            ],
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blue.shade700,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            iconSize: 22,
            onTap: _onTappedBar,
            currentIndex: _selectedIndex,
          ),
          body: Stack(children: [
            PageView(
              // physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                Provider<User>.value(
                  value: widget.user,
                  child: CheckAppControl(
                    user: widget.user,
                    post: posts,
                    controlData: widget.controlData,
                    appVersion: widget.appVersion,
                    followingUserList: followingList,
                    finalFollowingList: finalFollowingList,
                  ),
                ),
                Constants.username == ""
                    ? SimplePageModel(
                        user: widget.user,
                      )
                    : Provider<User>.value(
                        value: widget.user,
                        child: MemeProfile(
                          profileOwner: widget.user.uid,
                          currentUserId: widget.user.uid,
                          mainProfileUrl: Constants.myPhotoUrl,
                          mainSecondName: Constants.mySecondName,
                          mainFirstName: Constants.myName,
                          mainGender: Constants.gender,
                          mainEmail: Constants.myEmail,
                          mainAbout: Constants.about,
                          user: widget.user,
                          navigateThrough: "direct",
                          username: Constants.username,
                        ),
                      ),
                Constants.username == ""
                    ? SimplePageModel(
                        user: widget.user,
                      )
                    : SwitchChatList(
                        user: widget.user,
                        isInRelationShipMap: inRelationShipData,
                      ),
                Constants.username == ""
                    ? SimplePageModel(
                        user: widget.user,
                      )
                    : Provider<User>.value(
                        value: widget.user,
                        child: MainSearchPage(
                          navigateThrough: "direct",
                          user: widget.user,
                          userId: widget.user.uid,
                        ),
                      ),
                Constants.username == ""
                    ? SimplePageModel(
                        user: widget.user,
                      )
                    : AppSettings(
                        user: widget.user,
                      ),
              ],
              onPageChanged: (pageIndex) {
                setState(() {
                  _selectedIndex = pageIndex;
                });
              },
            ),
            isNotification
                ? InAppNotification(
                    openNotification: openNotification,
                  )
                : Container(
                    height: 0,
                  ),
          ]),
        ),
      ],
    );
  }

  void openNotification() {
    setState(() {
      isNotification = false;
    });
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;

      if (_selectedIndex == 2) {
        setState(() {
          unread = false;
        });
      }
    });
    _pageController.jumpToPage(value);
  }

  void checkUnreadMessages() {
    chatListRtDatabaseReference
        .child(widget.user.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        Map chatMap = dataSnapshot.value;

        chatMap.forEach((index, data) => chatList.add({"key": index, ...data}));
        chatList.sort((a, b) {
          return b["timestamp"].compareTo(a["timestamp"]);
        });

        if (chatList[0]['isRead'] == false || chatList[1]['isRead'] == false) {
          setState(() {
            unread = true;
            Constants.messageIconActive = true;
          });
        }
        print(
            "Chat list >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${chatList[0]['isRead']}");
      } else {}
    });
  }
}

///*********** New Class = > CheckAppControl **********///

class CheckAppControl extends StatefulWidget {
  final List post;
  final User user;
  final Map? controlData;
  final String appVersion;
  final List followingUserList;
  late List finalFollowingList;

  CheckAppControl(
      {required this.user,
      required this.post,
      required this.controlData,
      required this.appVersion,
      required this.followingUserList,
      required this.finalFollowingList});

  @override
  _CheckAppControlState createState() => _CheckAppControlState();
}

class _CheckAppControlState extends State<CheckAppControl> {
  bool isLoading = true;
  String postId = Uuid().v4();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });
    doActionOnce();
    super.initState();
  }

  doActionOnce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("doActionOnce") == null) {
      prefs.setInt("doActionOnce", 0);

      ///Slit is here Do not remove below comment
      // switchMemerSlitsRTD
      //     .child(widget.user.uid)
      //     .once()
      //     .then((DataSnapshot dataSnapshot) {
      //   if (dataSnapshot.exists) {
      //   } else {
      //     switchMemerSlitsRTD.child(widget.user.uid).set({
      //       'totalSlits': 0,
      //       'withdrawn': 0,
      //     });
      //   }
      // });

      followingCounter();
      switchMemeCompRTD
          .child(widget.user.uid)
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.exists) {
        } else {
          switchMemeCompRTD.child(widget.user.uid).set({
            'takePart': 0,
            'won': 0,
          });
        }
      });
    } else if (prefs.getInt("doActionOnce") == 2) {
      ///Slit is here
      // switchMemerSlitsRTD
      //     .child(widget.user.uid)
      //     .once()
      //     .then((DataSnapshot dataSnapshot) {
      //   if (dataSnapshot.exists) {
      //   } else {
      //     switchMemerSlitsRTD.child(widget.user.uid).set({
      //       'totalSlits': 0,
      //       'withdrawn': 0,
      //     });
      //   }
      // });
      followingCounter();
      switchMemeCompRTD
          .child(widget.user.uid)
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.exists) {
        } else {
          switchMemeCompRTD.child(widget.user.uid).set({
            'takePart': 0,
            'won': 0,
          });
        }
      });
      prefs.setInt("doActionOnce", 3);
    }
  }

  followingCounter() {
    late Map data;
    userFollowersRtd
        .child(widget.user.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });
        if (data.length < 100) {
          feedRtDatabaseReference
              .child(widget.user.uid)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "levelZero",
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
        }
      } else {
        feedRtDatabaseReference
            .child(widget.user.uid)
            .child("feedItems")
            .child(postId)
            .set({
          "type": "levelZero",
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Constants.username == ""
        ? SetUserData(user: widget.user)
        : Provider<User>.value(
            value: widget.user,
            child: MainFeed(
              user: widget.user,
              controlData: widget.controlData,
              finalFollowingList: widget.finalFollowingList,
            ),
          );
  }
}
