/*
 * This will be the first page that user see
 * after login or may be after signUp successfully.
 */

import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Authentication/SignUp/SetUserData.dart';
import 'package:switchapp/MainPages/AppSettings/settings.dart';
import 'package:switchapp/MainPages/Profile/memeProfile/Meme-profile.dart';
import 'package:switchapp/MainPages/TimeLineSwitch/MainFeed/MainFeed.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChatList.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/UsernameNotSetPage.dart';
import 'package:switchapp/Models/inAppNotificationModel.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

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

  @override
  void initState() {
    super.initState();
    Constants.pass = "";
    // this is an object to control page scroll and update current page no.
    pageController = PageController();
    // store user value to a static variable to access it any where
    Constants.myId = widget.user.uid;
    WidgetsBinding.instance!.addObserver(this);
    getRelationShipStatus();
    configNotification();
    getInAppAllNotification();
    checkUnreadMessages();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted)
        setState(() {
          Constants.notifyCounter = 1;
        });
    });
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
              "Ohh, WooW, Congrats, You are in relationship with ${item['firstName']}";
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

  getFollowingUsers(String uid) async {
    userFollowingRtd.child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;
        data.forEach(
            (index, data) => followingList.add({"key": index, ...data}));
        followingList.shuffle();
        if (mounted) setState(() {});
      } else {
        print("There is no post");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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

  CheckAppControl(
      {required this.user,
      required this.post,
      required this.controlData,
      required this.appVersion,
      required this.followingUserList});

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
        ? SetUserData(
            user: widget.user,
          )
        : Provider<User>.value(
            value: widget.user,
            child: MainFeed(
              user: widget.user,
              controlData: widget.controlData,
            ),
          );
  }
}
