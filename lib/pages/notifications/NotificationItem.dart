import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/pages/Profile/Panelandbody.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:switchapp/Universal/UniversalMethods.dart';
import 'package:time_formatter/time_formatter.dart';

import '../../Models/SwitchCacheImg/SwitchImageCache.dart';
import '../../Models/postModel/SinglePostDetail.dart';

class BuildItemForNotification extends StatefulWidget {
  final Map data;
  final List item;
  final User user;

  const BuildItemForNotification(
      {required this.data, required this.item, required this.user});

  @override
  _BuildItemForNotificationState createState() =>
      _BuildItemForNotificationState();
}

class _BuildItemForNotificationState extends State<BuildItemForNotification> {
  bool? isLoading = true;
  int? selectedIndex;
  UniversalMethods universalMethods = UniversalMethods();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              // new
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    selectedIndex == index
                        ? isLoading!
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 120, right: 120),
                                child: LinearProgressIndicator(
                                  color: Colors.lightBlue,
                                  backgroundColor: Colors.blue.shade200,
                                  minHeight: 2,
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    buildItemForNotificationPage(index, widget.item),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  buildItemForNotificationPage(int index, List item) {
    late String type;
    late String content;
    late String url;
    late String ownerId;
    late String firstName;
    late String postId;
    late String secondName;
    late bool isRead = false;
    int timestamp = item[index]['timestamp'];
    type = item[index]['type'];
    url = item[index]['url'];
    firstName = item[index]['firstName'];
    secondName = item[index]['secondName'];
    ownerId = item[index]['ownerId'];
    postId = item[index]['postId'];
    String time = formatTime(timestamp);

    item[index]['isRead'] == null
        ? isRead = true
        : isRead = item[index]['isRead'];

    if (item[index]['type'] == "comment") {
      content = "${item[index]['comment']}";
    } else if (item[index]['type'] == "follow") {
      content =
          "This Person is following you from Now, He can watch all your post from now. You can blocked him anytime to restrict this person for you timeline";
    } else if (item[index]['type'] == "sendRequestToConformRelationShip") {
      content =
          "This person wants to be in relationship with you. Click to Respond, (Accept or Decline). Or you can respond anytime by visit your profile.";
    } else if (item[index]['type'] == "ConformedAboutRelationShip") {
      content =
          "You are in relationship with $firstName, We hope your Relationship will remain for million of billions of years.";
    } else if (item[index]['type'] == "crushOnReference") {
      content = "Crush On You 💝, hmm :)";
    } else if (item[index]['type'] == 'notInterested') {
      content =
          "This person is not interested in you, We are very sorry for this. But you know what? There must be someone that really destined for you ";
    } else if (item[index]['type'] == 'cancelRequest') {
      content =
          "This person sent you relationship request and then cancel it too. May be he/she did it accidentally.";
    } else if (item[index]['type'] == 'breakUp') {
      content =
          "This person Broken Up with you. We are very sad to hear you this. Contact us for help :)";
    } else if (item[index]['type'] == 'disLike' ||
        item[index]['type'] == 'loveIt' ||
        item[index]['type'] == 'like') {
      content = "This is reaction of that person to your post. ";
    } else if (item[index]['type'] == 'profileRating') {
      content = "This person Rated your Profile";
    } else if (item[index]['type'] == 'memeProfileRating') {
      content = "This person Rated your MEME Profile";
    } else if (item[index]['type'] == 'Friend') {
      content = "This Person add you As Bestie";
    } else if (item[index]['type'] == 'unFriend') {
      content = "Sorry, But this Person remove you from Bestie";
    } else if (item[index]['type'] == 'planetLevel') {
      content = "Hurray! You have been promoted to PLANET LEVEL.";
    } else if (item[index]['type'] == 'solarLevel') {
      content = "Hurray! You have been promoted to SOLAR LEVEL.";
    } else if (item[index]['type'] == 'galaxyLevel') {
      content = "Hurray! You have been promoted to GALAXY LEVEL.";
    }
    late Map userData;

    getUserData(String uid) async {
      await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          setState(() {
            userData = dataSnapshot.value;
          });
        }
      });
    }

    unReadWidget(bool isRead) {
      if (isRead) {
        return Container(
          height: 0,
          width: 0,
        );
      } else {
        return Row(
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
                height: 18,
                width: 18,
                child: SpinKitRipple(
                  color: Colors.green.shade700,
                )),
            Text(
              " UnRead",
              style: TextStyle(
                  fontSize: 8,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold),
            ),
          ],
        );
      }
    }

    _gotoUserProfile(String ownerId) {
      getUserData(ownerId);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Provider<User>.value(
              value: widget.user,
              child: SwitchProfile(
                currentUserId: widget.user.uid,
                mainProfileUrl: userData['url'],
                mainFirstName: userData['firstName'],
                profileOwner: userData['ownerId'],
                mainSecondName: userData['secondName'],
                mainCountry: userData['country'],
                mainDateOfBirth: userData['dob'],
                mainAbout: userData['about'],
                mainEmail: userData['email'],
                mainGender: userData['gender'],
                username: userData['username'],
                isVerified: userData['isVerified'],
                action: 'notificationPage',
                user: widget.user,
              ),
            ),
          ),
        );
      });
    }

    if (item[index]['type'] == "comment") {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider.value(
                    value: widget.user,
                    child: SinglePostDetail(
                      url: url,
                      postId: postId,
                      ownerId: ownerId,
                    ),
                  ),
                ),
              );
              _checkRead(postId);
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  selectedIndex = null;
                });
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SwitchCacheImage(
                            width: 35.0,
                            height: 35.0,
                            url: url,
                            boxFit: BoxFit.fitWidth, screen: '',
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border:
                              Border.all(color: Colors.grey.shade500, width: 2),

                          // image: DecorationImage(
                          //   image: NetworkImage(
                          //       widget.foundUsers[widget.index]['photoUrl']),
                          // ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          firstName + " " + secondName,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      unReadWidget(isRead),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 3, top: 20),
                  child: Icon(
                    Icons.navigate_next_sharp,
                    size: 27,
                  ),
                ),
              ],
            ),
          ),
          ExpansionTileCard(
            elevation: 0.0,
            baseColor: Constants.isDark == "false"
                ? Colors.white
                : ThemeData.dark().primaryColor,
            title: Text(""),

            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 55,
                  ),
                  child: Text(
                    'Comment On Your Post',
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55, top: 5),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          "Comment:  ",
                          style: TextStyle(
                              color: Colors.lightBlue.shade600,
                              fontSize: 12,
                              fontFamily: 'cute',
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "$content",
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'cute',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // heightFactorCurve: Curves.linear,
            // isThreeLine: true,
          ),
          Divider()
        ],
      );
    } else if (type == "follow") {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: SwitchCacheImage(
                                width: 35,
                                height: 35,
                                url: url,
                                boxFit: BoxFit.cover, screen: '',
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: Colors.grey.shade500, width: 2),

                              // image: DecorationImage(
                              //   image: NetworkImage(
                              //       widget.foundUsers[widget.index]['photoUrl']),
                              // ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              firstName + " " + secondName,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              time,
                              style: TextStyle(
                                fontSize: 7,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          unReadWidget(isRead),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.navigate_next_sharp,
                      size: 30,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 75, bottom: 5),
                child: Text(
                  'is Starting to Follow You',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                child: Divider(),
              ),
            ],
          ),
        ),
      );
    } else if (type == "crushOnReference") {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5),
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        unReadWidget(isRead),
                      ],
                    ),
                    Icon(
                      Icons.navigate_next_sharp,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 75,
              ),
              child: Text(
                'Has crush on you.',
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (type == "sendRequestToConformRelationShip") {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Wants to Be in Relationship with You.',
                        style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.w800,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Go to your profile to respond that.',
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (type == "ConformedAboutRelationShip") {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "acceptReq",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                'You are in relationship with $firstName',
                style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (type == "breakUp") {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "breakUp",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                'Broke up with You.',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (type == "cancelRequest") {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "cancleRequest",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                'Canceled the relationship request',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (type == "notInterested") {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "cancleRequest",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                'Sorry, but this Person is Not interested in You.',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (item[index]['type'] == 'disLike' ||
        item[index]['type'] == 'loveIt' ||
        item[index]['type'] == 'like') {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _checkRead(postId);
          feedRtDatabaseReference
              .child(widget.user.uid)
              .child("feedItems")
              .child(postId)
              .update({"isRead": true});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider.value(
                value: widget.user,
                child: SinglePostDetail(
                  url: url,
                  postId: postId,
                  ownerId: ownerId,
                ),
              ),
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted)
              setState(() {
                selectedIndex = null;
              });
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: SwitchCacheImage(
                              width: 35,
                              height: 35,
                              url: url,
                              boxFit: BoxFit.fill, screen: '',
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.lightBlue.shade500, width: 2),
                          ),
                        ),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                item[index]['type'] == 'disLike'
                    ? 'disLike your post'
                    : item[index]['type'] == 'like'
                        ? "Like your Post"
                        : item[index]['type'] == 'loveIt'
                            ? "Love your post"
                            : "",
                style: TextStyle(
                    color: item[index]['type'] == 'disLike'
                        ? Colors.red
                        : Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (item[index]['type'] == 'profileRating') {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "cancleRequest",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                "This Person Rated Your Profile by ${item[index]['rating']}/5",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (item[index]['type'] == 'memeProfileRating') {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "cancleRequest",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                "This Person has Rated Your Meme Profile by ${item[index]['rating']}/5",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (item[index]['type'] == 'Friend') {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          //  _checkRead(postId);

          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "cancleRequest",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                "Added You as Bestie",
                style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (item[index]['type'] == 'unFriend') {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _gotoUserProfile(ownerId);
          _checkRead(postId);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Provider.value(
          //       value: widget.user,
          //       child: SwitchProfile(
          //           mainProfileUrl: Constants.myPhotoUrl,
          //           profileOwner: Constants.myId,
          //           mainFirstName: Constants.myName,
          //           mainAbout: Constants.about,
          //           mainCountry: Constants.country,
          //           mainSecondName: Constants.mySecondName,
          //           mainEmail: Constants.myEmail,
          //           mainGender: Constants.gender,
          //           currentUserId: Constants.myId,
          //           user: widget.user,
          //           action: "cancleRequest",
          //           username: Constants.username,
          //           isVerified: Constants.isVerified,
          //           mainDateOfBirth: Constants.dob),
          //     ),
          //     //     Provider<User>.value(
          //     //   value: user,
          //     //   child: MainSearchPage(
          //     //     user: user,
          //     //     userId: user.uid,
          //     //   ),
          //     // ),
          //   ),
          // );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Row(
                      children: [
                        profileImg(url),
                        name(firstName, secondName),
                        postTime(time),
                        unReadWidget(isRead),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_sharp,
                    size: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75, bottom: 5),
              child: Text(
                "Removed you From Bestie",
                style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider(),
            ),
          ],
        ),
      );
    } else if (type == "planetLevel") {
      return GestureDetector(
        onTap: () => {
          universalMethods.bottomSheetForMemerLevel(context),
          setState(() {
            selectedIndex = index;
          }),
          _checkRead(postId),
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          }),
        },
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // unReadWidget(isRead),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Double Slit || Notification",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      child: Lottie.asset(
                        "images/level_images/level_planet.json",
                      ),
                      height: 60,
                      width: 60,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Hurray! You have been promoted to PLANET LEVEL.',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                  postTime(time),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                    child: Divider(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (type == "solarLevel") {
      return GestureDetector(
        onTap: () => {
          universalMethods.bottomSheetForMemerLevel(context),
          setState(() {
            selectedIndex = index;
          }),
          _checkRead(postId),
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          }),
        },
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // unReadWidget(isRead),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Double Slit || Notification",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      child: Lottie.asset(
                        "images/level_images/level_solar.json",
                      ),
                      height: 60,
                      width: 60,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Hurray! You have been promoted to SOLAR LEVEL.',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                  postTime(time),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                    child: Divider(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (type == "galaxyLevel") {
      return GestureDetector(
        onTap: () => {
          universalMethods.bottomSheetForMemerLevel(context),
          setState(() {
            selectedIndex = index;
          }),
          _checkRead(postId),
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          }),
        },
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // unReadWidget(isRead),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Double Slit || Notification",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      child: Lottie.asset(
                        "images/level_images/level_galaxy.json",
                      ),
                      height: 60,
                      width: 60,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Hurray! You have been promoted to GALAXY LEVEL.',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                  postTime(time),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                    child: Divider(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (type == "levelZero") {
      return GestureDetector(
        onTap: () => {
          universalMethods.bottomSheetForMemerLevel(context),
          setState(() {
            selectedIndex = index;
          }),
          _checkRead(postId),
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              selectedIndex = null;
            });
          }),
        },
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // unReadWidget(isRead),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Double Slit || Notification",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      child: Lottie.asset(
                        "images/level_images/level_zero.json",
                      ),
                      height: 60,
                      width: 60,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Hi, You are in LEVEL ZERO as a memer.',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                  postTime(time),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                    child: Divider(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void _checkRead(String postId) {
    Future.delayed(const Duration(seconds: 1), () {
      feedRtDatabaseReference
          .child(widget.user.uid)
          .child("feedItems")
          .child(postId)
          .update({"isRead": true});
    });
  }

  Widget profileImg(String url) {
    return Container(
      width: 35,
      height: 35,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: SwitchCacheImage(
          width: 35,
          height: 35,
          url: url,
          boxFit: BoxFit.cover, screen: '',
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.grey.shade500, width: 2),

        // image: DecorationImage(
        //   image: NetworkImage(
        //       widget.foundUsers[widget.index]['photoUrl']),
        // ),
      ),
    );
  }

  Widget postTime(String time) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        time,
        style: TextStyle(
          fontSize: 7,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget name(String firstName, String secondName){
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        firstName + " " + secondName,
        style: TextStyle(
            fontSize: 14,
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
