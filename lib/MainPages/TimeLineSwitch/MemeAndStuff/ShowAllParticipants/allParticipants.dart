import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/postReportPage.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/reportId.dart';
import 'package:switchapp/MainPages/TimeLineSwitch/MainFeed/CacheImageTemplate.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Models/postModel/CommentsPage.dart';
import 'package:switchapp/Models/postModel/PostsReactCounters.dart';
import 'package:switchapp/Models/postModel/TextStatus.dart';
import 'package:switchapp/learning/video_widget.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Universal/DataBaseRefrences.dart';

class AllParticipants extends StatefulWidget {
  late User user;

  AllParticipants({required this.user});

  @override
  _AllParticipantsState createState() => _AllParticipantsState();
}

class _AllParticipantsState extends State<AllParticipants> {
  bool isLoading = true;
  Map? memeMap;
  List? memeList = [];
  List? limitedMemeList = [];
  int counter = 0; // this variable will control the flow of postsList if
  // it not load, this will allow it to re run as limited

  int? selectedIndex;
  List userPosts = [];
  final ScrollController listScrollController = ScrollController();
  double? _scrollPosition;
  bool loadingRecentPosts = false;
  bool _hasMore = false;
  late int startAt = 0;
  late int endAt = 10;

  @override
  void initState() {
    listScrollController.addListener(_scrollListener);

    getCompMeme();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });
    super.initState();
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _hasMore = true;
      });
      startAt = startAt + 11;
      endAt = endAt + 11;
      getNextPosts();
    }
    setState(() {
      _scrollPosition = listScrollController.position.pixels;
    });

    if (_scrollPosition! > 50) {}
  }

  getCompMeme() {
    counter++;
    switchMemeCompRTD.child('live').once().then((DataSnapshot dataSnapshot) => {
          if (dataSnapshot.exists)
            {
              memeMap = dataSnapshot.value,
              memeMap!.forEach(
                  (index, data2) => memeList!.add({"key": index, ...data2})),
            }
        });

    Future.delayed(const Duration(milliseconds: 300), () {
      memeList!.sort((a, b) {
        return b["timestamp"].compareTo(a["timestamp"]);
      });
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      print("Length: : : : : : : ${memeList!.length}");

      if (memeList!.isEmpty) {
        print("Length: : : : : : : ${memeList!.length} :: so again");

        if (counter < 5) getCompMeme();
      } else {
        print("Length: : : : : : : ${memeList!.length}");

        if (memeList!.length < 11) {
          limitedMemeList = memeList!.toList();
        } else {
          limitedMemeList = memeList!.getRange(startAt, endAt).toList();
        }
      }
    });
  }

  getNextPosts() {
    if (memeList!.length < endAt) {
      print("***************** list Ended *****************");
    } else {
      endAt = endAt + 5;

      print("End At >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $endAt");

      limitedMemeList = memeList!.getRange(0, endAt).toList();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 20,
                )),
          ),
          elevation: 0,
          title: Text(
            "Current Memes",
            style: TextStyle(
              fontFamily: 'cute',
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            memeList!.length == 0
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Loading..",
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'cute',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: InViewNotifierList(
                      controller: listScrollController,
                      scrollDirection: Axis.vertical,
                      initialInViewIds: ['0'],
                      isInViewPortCondition: (double deltaTop,
                          double deltaBottom, double viewPortDimension) {
                        return deltaTop < (0.5 * viewPortDimension) &&
                            deltaBottom > (0.4 * viewPortDimension);
                      },
                      itemCount: _hasMore
                          ? limitedMemeList!.length + 1
                          : limitedMemeList!.length,
                      builder: (BuildContext context, int index) {
                        if (index >= limitedMemeList!.length) {
                          // Don't trigger if one async loading is already under way

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
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
                          final user =
                              Provider.of<User>(context, listen: false);
                          String url = limitedMemeList![index]['url'];
                          int timestamp = limitedMemeList![index]['timestamp'];
                          String postId = limitedMemeList![index]['postId'];
                          String ownerId = limitedMemeList![index]['ownerId'];
                          String description =
                              limitedMemeList![index]['description'];
                          String type = limitedMemeList![index]['type'];
                          String postTheme =
                              limitedMemeList![index]['statusTheme'];
                          String time = formatTime(timestamp);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _getUserDetail(ownerId);
                                },
                                child: _showProfilePicAndName(
                                    ownerId,
                                    time,
                                    postId,
                                    postTheme == "" ? "photo" : postTheme,
                                    type,
                                    description,
                                    url),
                              ),

                              type == "thoughts"
                                  ? TextStatus(description: description)
                                  : type == "videoMeme" || type == "videoMemeT"
                                      ? Container(
                                          height: 360.0,
                                          // decoration: BoxDecoration(
                                          //   color: Colors.white,
                                          //   borderRadius:
                                          //       BorderRadius.circular(
                                          //           20.0),
                                          // ),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, left: 8, right: 8),
                                            child: LayoutBuilder(
                                              builder: (BuildContext context,
                                                  BoxConstraints constraints) {
                                                return InViewNotifierWidget(
                                                  id: '$index',
                                                  builder:
                                                      (BuildContext context,
                                                          bool isInView,
                                                          Widget? child) {
                                                    return VideoWidget(
                                                        play: isInView,
                                                        url: limitedMemeList![
                                                            index]['url'],
                                                      time: limitedMemeList![index]['timestamp'],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15,
                                                bottom: 10,
                                                left: 10,
                                                right: 10),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: CacheImageTemplate(
                                                  list: limitedMemeList!,
                                                  index: index,
                                                )),
                                          ),
                                        ),

                              type == "thoughts"
                                  ? Container(
                                      height: 10.0,
                                    )
                                  : Container(
                                      height: 5,
                                    ),
                              _postFooter(user, postId, ownerId, url, postTheme,
                                  index, type),
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
                  )
          ],
        ));
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

  ///
  _showProfilePicAndName(String ownerId, String timeStamp, String postId,
      String postTheme, String type, String description, String url) {
    return StreamBuilder(
        stream: userRefRTD.child(ownerId).onValue,
        builder: (context, AsyncSnapshot dataSnapShot) {
          if (dataSnapShot.hasData) {
            DataSnapshot snapshot = dataSnapShot.data.snapshot;
            Map data = snapshot.value;
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                trailing: GestureDetector(
                  onTap: () {
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
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.linear_scale_sharp,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    color: Colors.blue,
                                  ),
                                  type == "videoMemeT"
                                      ? SizedBox(
                                          height: 0,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              switchShowCaseRTD
                                                  .child(widget.user.uid)
                                                  .child(postId)
                                                  .once()
                                                  .then((DataSnapshot
                                                          dataSnapshot) =>
                                                      {
                                                        if (dataSnapshot
                                                                .value !=
                                                            null)
                                                          {
                                                            switchShowCaseRTD
                                                                .child(widget
                                                                    .user.uid)
                                                                .child(postId)
                                                                .remove(),
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Remove From Your Meme Showcase",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              timeInSecForIosWeb:
                                                                  3,
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0,
                                                            ),
                                                          }
                                                        else
                                                          {
                                                            switchShowCaseRTD
                                                                .child(widget
                                                                    .user.uid)
                                                                .child(postId)
                                                                .set({
                                                              "memeUrl": url,
                                                              "ownerId":
                                                                  ownerId,
                                                              'timestamp': DateTime
                                                                      .now()
                                                                  .millisecondsSinceEpoch,
                                                              'postId': postId,
                                                            }),
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Added to your Meme Showcase",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              timeInSecForIosWeb:
                                                                  3,
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0,
                                                            ),
                                                          }
                                                      });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, left: 20),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Add/Remove from Meme ShowCase ",
                                                    style: TextStyle(
                                                        fontFamily: 'cutes',
                                                        color:
                                                            Constants.isDark ==
                                                                    "true"
                                                                ? Colors.white
                                                                : Colors.blue,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Icon(
                                                      Icons.apps,
                                                      size: 17,
                                                      color: Constants.isDark ==
                                                              "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      // color: selectedIndex == index
                                                      //     ? Colors.pink
                                                      //     : selectedIndex == 121212
                                                      //         ? Colors.grey
                                                      //         : Colors.teal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  ownerId == Constants.myId
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 20),
                                          child: TextButton(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Delete Post',
                                                  style: TextStyle(
                                                      fontFamily: 'cutes',
                                                      fontSize: 14,
                                                      color: Constants.isDark ==
                                                              "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.delete_outline,
                                                  size: 20,
                                                  color:
                                                      Constants.isDark == "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                ),
                                              ],
                                            ),
                                            onPressed: () => {
                                              deleteFunc(postId, ownerId, type),
                                            },
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 10),
                                          child: ElevatedButton(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Report Post ',
                                                  style: TextStyle(
                                                      color: Constants.isDark ==
                                                              "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      fontFamily: 'cutes',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.error_outline,
                                                  size: 20,
                                                  color:
                                                      Constants.isDark == "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                ),
                                              ],
                                            ),
                                            onPressed: () => {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostReport(
                                                            reportById:
                                                                widget.user.uid,
                                                            reportedId: ownerId,
                                                            postId: postId,
                                                            type: "reportPost",
                                                          )))
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              primary: Colors.transparent,
                                              textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                  ownerId == Constants.myId
                                      ? Container(
                                          height: 0,
                                          width: 0,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 10),
                                          child: ElevatedButton(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Report User ',
                                                  style: TextStyle(
                                                      color: Constants.isDark ==
                                                              "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      fontFamily: 'cutes',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.account_circle_outlined,
                                                  size: 20,
                                                  color:
                                                      Constants.isDark == "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                ),
                                              ],
                                            ),
                                            onPressed: () => {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReportId(
                                                            profileId:
                                                                ownerId)),
                                              )
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              primary: Colors.transparent,
                                              textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                  ownerId == Constants.myId
                                      ? Container(
                                          height: 0,
                                          width: 0,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 10),
                                          child: ElevatedButton(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Block User ',
                                                  style: TextStyle(
                                                      fontFamily: 'cutes',
                                                      fontSize: 14,
                                                      color: Constants.isDark ==
                                                              "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.block,
                                                  size: 20,
                                                  color:
                                                      Constants.isDark == "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                ),
                                              ],
                                            ),
                                            onPressed: () => {
                                              blockUser(
                                                  ownerId, Constants.myId),
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              primary: Colors.transparent,
                                              textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Icon(
                      Icons.more_horiz,
                      // color: selectedIndex == index
                      //     ? Colors.pink
                      //     : selectedIndex == 121212
                      //         ? Colors.grey
                      //         : Colors.teal,
                      color: Colors.grey,
                    ),
                  ),
                ),

                title: Transform(
                  transform: Matrix4.translationValues(-1, 5.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Container(
                        //   width: 35,
                        //   height: 35,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(color: Colors.black, width: 1),
                        //     image: DecorationImage(
                        //       image: NetworkImage(data['url']),
                        //     ),
                        //   ),
                        // ),

                        CircleAvatar(
                          child: CircleAvatar(

                            radius: 18,
                            backgroundColor: Colors.black,
                            backgroundImage:
                                CachedNetworkImageProvider(data['url']),

                          ),

                          radius: 20.5,
                          backgroundColor: Colors.blue,
                        ),
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
                                        ? " share meme"
                                        : " share $postTheme",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
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
                                        fontFamily: 'cutes'),
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
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.linear_scale_sharp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Are you sure?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
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
                                fontFamily: "cutes",
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
                                fontFamily: "cutes",
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700),
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
                          fontFamily: "cutes",
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

  ///********///////

  _blockFunction(String profileOwner, String currentUserId) {
    Map? userMap;
    late String username;
    late String url;

    userRefRTD.child(widget.user.uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userMap = dataSnapshot.value;

        username = userMap?['username'];
        url = userMap?['url'];
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      print("Profile Id: $profileOwner");
      print("currentId Id: $currentUserId");
      print("Profile Id: $username");

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

      ///

      Fluttertoast.showToast(
        msg: "Blocked, Restart App!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.white,
        textColor: Colors.blue,
        fontSize: 16.0,
      );

      Navigator.pop(context);
    });
  }

  late Map data;
  List posts = [];
  List reactorList = [];

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

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Provider<User>.value(
                        //       value: user,
                        //       child: CommentsPage(
                        //           postId: postId, ownerId: ownerId, photoUrl: url),
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_outlined,
                                color: Colors.grey,
                                size: 21,
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
                                          fontFamily: 'cutes',
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
                                            fontFamily: 'cutes',
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
                                                fontFamily: 'cutes',
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
                child: TextButton(
                    onPressed: () => {
                          reactorList.clear(),
                          getPostDetail(postId),
                        },
                    child: Row(
                      children: [
                        Text(
                          "Details ",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'cutes',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: Colors.grey),
                            image: DecorationImage(
                              image: AssetImage('images/logoPro.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
          loadingRecentPosts
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    color: Colors.blue,
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

  Widget textControl(String description) {
    return GestureDetector(
      onLongPress: () => {
        Clipboard.setData(ClipboardData(text: description)),
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text('Copied'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(top: 50, right: 20, left: 20),
        )),
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
                                color: Constants.isDark == "true"
                                    ? Colors.white
                                    : Colors.blue,
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
                                    color: Colors.blue),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        text: description,
        style: TextStyle(
          color: Constants.isDark == "true" ? Colors.white : Colors.blue,
        ),
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
    // color: Colors.blue),
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
                                Text(
                                  "Caption:  ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontFamily: 'cute'),
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
                                                          color: Colors.blue,
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
                                        color: Constants.isDark == "true"
                                            ? Colors.white
                                            : Colors.blue,
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
                          //                           color: Colors.blue),
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
                          //         color: Colors.blue),
                          //     onTap: (link) => {
                          //       // url = link.value.toString(),
                          //       // _launchURL('http://$url'),
                          //     },
                          //   ),
                          // )
                          else
                            Row(
                              children: [
                                Text(
                                  "Caption:  ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontFamily: 'cute'),
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
                          //         color: Colors.blue),
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
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.linear_scale_sharp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                    child: ElevatedButton(
                      child: Row(
                        children: [
                          Text(
                            'Copy ',
                            style: TextStyle(
                                color: Constants.isDark == "true"
                                    ? Colors.white
                                    : Colors.blue,
                                fontFamily: 'cutes',
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.copy,
                            color: Constants.isDark == "true"
                                ? Colors.white
                                : Colors.blue,
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
                                  color: Colors.blue),
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
                                          fontFamily: 'cutes', fontSize: 14),
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

  int like = 0;
  int disLike = 0;
  int heartReact = 0;
  int total = 0;

  deleteFunc(
    String postId,
    String ownerId,
    String type,
  ) async {
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

      ///Slit is here
      // switchMemeCompRTD
      //     .child('live')
      //     .child(ownerId)
      //     .once()
      //     .then((DataSnapshot dataSnapshot) {
      //   if (dataSnapshot.exists) {
      //     switchMemerSlitsRTD
      //         .child(ownerId)
      //         .once()
      //         .then((DataSnapshot dataSnapshot) {
      //       Map data = dataSnapshot.value;
      //       int slits = data['totalSlits'];
      //       setState(() {
      //         slits = slits - (1000 + total);
      //       });
      //       Future.delayed(const Duration(milliseconds: 100), () {
      //         switchMemerSlitsRTD.child(ownerId).update({
      //           'totalSlits': slits,
      //         });
      //       });
      //     });
      //
      switchMemeCompRTD.child(ownerId).once().then((DataSnapshot dataSnapshot) {
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
      //   } else {
      //     if (type == 'meme' ||
      //         type == "memeT" ||
      //         type == "videoMeme" ||
      //         type == "videoMemeT") {
      //       switchMemerSlitsRTD
      //           .child(ownerId)
      //           .once()
      //           .then((DataSnapshot dataSnapshot) {
      //         Map data = dataSnapshot.value;
      //         int slits = data['totalSlits'];
      //         setState(() {
      //           slits = slits - (20 + total);
      //         });
      //         Future.delayed(const Duration(milliseconds: 100), () {
      //           switchMemerSlitsRTD.child(ownerId).update({
      //             'totalSlits': slits,
      //           });
      //
      //           Navigator.pop(context);
      //           Fluttertoast.showToast(
      //             msg: "Deleted! Refresh App :)",
      //             toastLength: Toast.LENGTH_LONG,
      //             gravity: ToastGravity.SNACKBAR,
      //             timeInSecForIosWeb: 5,
      //             backgroundColor: Colors.white,
      //             textColor: Colors.blue,
      //             fontSize: 16.0,
      //           );
      //         });
      //       });
      //     } else {
      //       Navigator.pop(context);
      //       Fluttertoast.showToast(
      //         msg: "Deleted! Refresh App :)",
      //         toastLength: Toast.LENGTH_LONG,
      //         gravity: ToastGravity.SNACKBAR,
      //         timeInSecForIosWeb: 5,
      //         backgroundColor: Colors.white,
      //         textColor: Colors.blue,
      //         fontSize: 16.0,
      //       );
      //     }
      //   }
      // });
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
}
