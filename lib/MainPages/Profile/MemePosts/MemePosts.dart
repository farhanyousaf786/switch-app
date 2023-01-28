import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/MainPages/AllPosts/MainFeed/CacheImageTemplate.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Models/SwitchCacheImg/SwitchImageCache.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Models/postModel/CommentsPage.dart';
import '../../../Models/postModel/PostsReactCounters.dart';
import '../../../learning/video_widget.dart';
import '../../ReportAndComplaints/postReportPage.dart';
import '../../ReportAndComplaints/reportId.dart';
import '../Panelandbody.dart';

class AllMemePosts extends StatefulWidget {
  late User user;
  late String UserId;

  AllMemePosts({required this.user, required this.UserId});

  @override
  _AllMemePostsState createState() => _AllMemePostsState();
}

class _AllMemePostsState extends State<AllMemePosts> {
  late bool isLoading = true;
  List allPostList = [];
  List limitedPostList = [];

  bool _hasMore = false;
  late int startAt = 0;
  late int endAt = 5;
  final ScrollController listScrollController = ScrollController();
  double? _scrollPosition;
  bool loadingRecentPosts = false;
  int videoMeme = 0;
  late Map allPostMap;
  late Map store;
  late bool _isHide = false; // Variable to to hide switch trend

  @override
  void initState() {
    getFirstPost();
    listScrollController.addListener(_scrollListener);
    super.initState();
  }

  int nonMemeType = 0;

  getFirstPost() async {
    postsRtd
        .child(widget.UserId)
        .child("usersPost")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        allPostMap = dataSnapshot.value;

        allPostMap.forEach(
            (index, data2) => allPostList.add({"key": index, ...data2}));
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      allPostList.sort((a, b) {
        return b["timestamp"].compareTo(a["timestamp"]);
      });
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      print("Length: : : : : : : ${allPostList.length}");

      if (allPostList.length <= 5) {
        print("allPostList.length <= 5 >>>>>>>>>>>>>>>>>>");

        limitedPostList = allPostList.toList();
      } else {
        print("allPostList.length >= 5 >>>>>>>>>>>>>>>>>>");

        limitedPostList = allPostList.getRange(startAt, endAt).toList();

        for (int i = 0; i < limitedPostList.length; i++) {
          if (limitedPostList[i]['type'] != "meme" ||
              limitedPostList[i]['type'] != "memeT" ||
              limitedPostList[i]['type'] != "videoMemeT" ||
              limitedPostList[i]['type'] != "videoMeme") {
            nonMemeType = nonMemeType + 1;

            print("nonMemeType : : : : : $nonMemeType}");
          }
        }

        if (nonMemeType >= 5) {
          getNextPosts();
        }

        print(
            "allPostList.length >= 5 >>>>>>>>>>>>>>>>>> ${limitedPostList.length}");
      }
      // limitedPostList = allPostList.getRange(startAt, endAt).toList();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  _scrollListener() {
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
      // widget.isHide();
    }
    if (_scrollPosition! < 50.0) {
      setState(() {
        _isHide = false;
      });
    }
  }

  getNextPosts() {
    if (allPostList.length < endAt) {
      print("***************** list Ended *****************");
    } else {
      endAt = endAt + 6;

      print("End At >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $endAt");

      limitedPostList = allPostList.getRange(0, endAt).toList();

      for (int i = 0; i < limitedPostList.length; i++) {
        if (limitedPostList[i]['type'] != "meme" ||
            limitedPostList[i]['type'] != "memeT" ||
            limitedPostList[i]['type'] != "videoMemeT" ||
            limitedPostList[i]['type'] != "videoMeme") {
          nonMemeType = nonMemeType + 1;

          print("nonMemeType : : : : : $nonMemeType}");
        }
      }

      if (nonMemeType >= endAt) {
        getNextPosts();
      }

      setState(() {});
      // Future.delayed(const Duration(seconds: 12), () {
      //   setState(() {
      //     _hasMore = false;
      //   });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            : allPostList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'There is no post yet!',
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'cute',
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
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
                          ? limitedPostList.length + 1
                          : limitedPostList.length,
                      builder: (BuildContext context, int index) {
                        if (index >= limitedPostList.length) {
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
                          String url = limitedPostList[index]['url'];
                          int timestamp = limitedPostList[index]['timestamp'];
                          String postId = limitedPostList[index]['postId'];
                          String ownerId = limitedPostList[index]['ownerId'];
                          String description =
                              limitedPostList[index]['description'];
                          String type = limitedPostList[index]['type'];
                          String postTheme =
                              limitedPostList[index]['statusTheme'];
                          String time = formatTime(timestamp);

                          print(
                              "TYpe : : : : : :: : : :${limitedPostList[index]['type']}");
                          return Column(
                            children: [
                              type == "videoMeme" ||
                                      type == "videoMemeT" ||
                                      type == "meme" ||
                                      type == "memeT"
                                  ? _showProfilePicAndName(
                                      ownerId,
                                      time,
                                      postId,
                                      postTheme == "" ? "photo" : postTheme,
                                      type,
                                      description,
                                      url,
                                      index)
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),

                              type == "videoMeme" || type == "videoMemeT"
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
                                              builder: (BuildContext context,
                                                  bool isInView,
                                                  Widget? child) {
                                                return VideoWidget(
                                                    play: isInView,
                                                    url: limitedPostList[index]
                                                        ['url'],
                                                  time: limitedPostList[index]['timestamp'],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : type == "meme" || type == "memeT"
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15,
                                                bottom: 10,
                                                left: 10,
                                                right: 10),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: SwitchCacheImage(
                                                  url: limitedPostList[index]['url'],
                                                  height: MediaQuery.of(context).size.height / 4,
                                                  width: MediaQuery.of(context).size.width,
                                                  boxFit: BoxFit.fill,
                                                  screen: 'memePosts',
                                                )),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),

                              // type == "thoughts"
                              //     ? Container(
                              //         height: 10.0,
                              //         color: Colors.white,
                              //       )
                              //     : Container(
                              //         height: 5,
                              //         color: Colors.white,
                              //       ),
                              type == "videoMeme" ||
                                      type == "videoMemeT" ||
                                      type == "meme" ||
                                      type == "memeT"
                                  ? _postFooter(user, postId, ownerId, url,
                                      postTheme, index, type)
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                              type == "videoMeme" ||
                                      type == "videoMemeT" ||
                                      type == "meme" ||
                                      type == "memeT"
                                  ? Container(
                                      height: 10,
                                    )
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),

                              type == "videoMeme" ||
                                      type == "videoMemeT" ||
                                      type == "meme" ||
                                      type == "memeT"
                                  ? _description(description)
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                              // creatPostFooter(),

                              type == "videoMeme" ||
                                      type == "videoMemeT" ||
                                      type == "meme" ||
                                      type == "memeT"
                                  ? Container(
                                      height: 20,
                                    )
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
      ],
    );

    // return Scaffold(
    //   body: SafeArea(
    //     child: Container(
    //       color: Colors.white,
    //       child: Stack(
    //         children: <Widget>[
    //           Column(
    //             children: [
    //               isLoading
    //                   ? SizedBox(
    //                       height: 100,
    //                     )
    //                   : SizedBox(
    //                       height: 0,
    //                     ),
    //               isLoading
    //                   ? Container(
    //                       color: Colors.white,
    //                       child: Center(
    //                         child: Padding(
    //                           padding: const EdgeInsets.only(top: 20),
    //                           child: SpinKitThreeBounce(
    //                             color: Colors.lightBlueAccent,
    //                             size: 15,
    //                           ),
    //                         ),
    //                       ),
    //                     )
    //                   : Expanded(
    //                       child: InViewNotifierList(
    //                         controller: listScrollController,
    //                         scrollDirection: Axis.vertical,
    //                         initialInViewIds: ['0'],
    //                         isInViewPortCondition: (double deltaTop,
    //                             double deltaBottom, double viewPortDimension) {
    //                           return deltaTop < (0.5 * viewPortDimension) &&
    //                               deltaBottom > (0.4 * viewPortDimension);
    //                         },
    //                         itemCount: _hasMore
    //                             ? limitedPostList.length + 1
    //                             : limitedPostList.length,
    //                         builder: (BuildContext context, int index) {
    //                           if (index >= limitedPostList.length) {
    //                             // Don't trigger if one async loading is already under way
    //
    //                             return Center(
    //                               child: Padding(
    //                                 padding: const EdgeInsets.only(
    //                                     bottom: 3, top: 3),
    //                                 child: SizedBox(
    //                                   child: Column(
    //                                     children: [
    //                                       SpinKitThreeBounce(
    //                                         size: 14,
    //                                         color: Colors.grey,
    //                                       ),
    //                                     ],
    //                                   ),
    //                                   height: 100,
    //                                   width: 120,
    //                                 ),
    //                               ),
    //                             );
    //                           } else {
    //                             final user =
    //                                 Provider.of<User>(context, listen: false);
    //                             String url = limitedPostList[index]['url'];
    //                             int timestamp =
    //                                 limitedPostList[index]['timestamp'];
    //                             String postId =
    //                                 limitedPostList[index]['postId'];
    //                             String ownerId =
    //                                 limitedPostList[index]['ownerId'];
    //                             String description =
    //                                 limitedPostList[index]['description'];
    //                             String type = limitedPostList[index]['type'];
    //                             String postTheme =
    //                                 limitedPostList[index]['statusTheme'];
    //                             String time = formatTime(timestamp);
    //                             return Column(
    //                               children: [
    //                                 _showProfilePicAndName(
    //                                     ownerId,
    //                                     time,
    //                                     postId,
    //                                     postTheme == "" ? "photo" : postTheme,
    //                                     type,
    //                                     description,
    //                                     url),
    //
    //                                 type == "thoughts"
    //                                     ? TextStatus(description: description)
    //                                     : type == "videoMeme"
    //                                         ? Container(
    //                                             height: 360.0,
    //                                             color: Colors.white,
    //                                             // decoration: BoxDecoration(
    //                                             //   color: Colors.white,
    //                                             //   borderRadius:
    //                                             //       BorderRadius.circular(
    //                                             //           20.0),
    //                                             // ),
    //                                             alignment: Alignment.center,
    //                                             child: Padding(
    //                                               padding:
    //                                                   const EdgeInsets.only(
    //                                                       top: 8,
    //                                                       left: 8,
    //                                                       right: 8),
    //                                               child: LayoutBuilder(
    //                                                 builder:
    //                                                     (BuildContext context,
    //                                                         BoxConstraints
    //                                                             constraints) {
    //                                                   return InViewNotifierWidget(
    //                                                     id: '$index',
    //                                                     builder: (BuildContext
    //                                                             context,
    //                                                         bool isInView,
    //                                                         Widget? child) {
    //                                                       return VideoWidget(
    //                                                           play: isInView,
    //                                                           url:
    //                                                               limitedPostList[
    //                                                                       index]
    //                                                                   ['url']);
    //                                                     },
    //                                                   );
    //                                                 },
    //                                               ),
    //                                             ),
    //                                           )
    //                                         : Container(
    //                                             child: Padding(
    //                                               padding:
    //                                                   const EdgeInsets.only(
    //                                                       top: 15,
    //                                                       bottom: 10,
    //                                                       left: 10,
    //                                                       right: 10),
    //                                               child: ClipRRect(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           10.0),
    //                                                   child: CacheImageTemplate(
    //                                                     list: limitedPostList,
    //                                                     index: index,
    //                                                   )),
    //                                             ),
    //                                             color: Colors.white,
    //                                           ),
    //
    //                                 type == "thoughts"
    //                                     ? Container(
    //                                         height: 10.0,
    //                                         color: Colors.white,
    //                                       )
    //                                     : Container(
    //                                         height: 5,
    //                                         color: Colors.white,
    //                                       ),
    //                                 _postFooter(user, postId, ownerId, url,
    //                                     postTheme, index),
    //                                 Container(
    //                                   height: 10,
    //                                   color: Colors.white,
    //                                 ),
    //
    //                                 type != "thoughts"
    //                                     ? _description(description)
    //                                     : Container(
    //                                         height: 0,
    //                                         width: 0,
    //                                       ),
    //                                 // creatPostFooter(),
    //
    //                                 Container(
    //                                   height: 20,
    //                                   color: Colors.white,
    //                                 ),
    //                               ],
    //                             );
    //                           }
    //                         },
    //                       ),
    //                     ),
    //             ],
    //           ),
    //           // Container(
    //           //   height: isHide ? 50 : MediaQuery.of(context).size.height / 3.3,
    //           //   color: Colors.white,
    //           //   alignment: Alignment.topCenter,
    //           //   //BoxDecoration
    //           //   child: Column(
    //           //     children: [
    //           //       nameAndStuff(),
    //           //       frontSlide(),
    //           //       tabBar(
    //           //         widget.user,
    //           //       ),
    //           //     ],
    //           //   ),
    //           //   //Text
    //           // ),
    //
    //           // Align(
    //           //   alignment: Alignment.center,
    //           //   child: Container(
    //           //     height: 1,
    //           //     color: Colors.redAccent,
    //           //   ),
    //           // )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  _showProfilePicAndName(
      String ownerId,
      String timeStamp,
      String postId,
      String postTheme,
      String type,
      String description,
      String url,
      int index) {
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
                                 BarTop(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        switchShowCaseRTD
                                            .child(widget.user.uid)
                                            .child(postId)
                                            .once()
                                            .then((DataSnapshot dataSnapshot) =>
                                                {
                                                  if (dataSnapshot.value !=
                                                      null)
                                                    {
                                                      switchShowCaseRTD
                                                          .child(
                                                              widget.user.uid)
                                                          .child(postId)
                                                          .remove(),
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Remove From Your Meme Showcase",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor:
                                                            Colors.blue,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      ),
                                                    }
                                                  else
                                                    {
                                                      switchShowCaseRTD
                                                          .child(
                                                              widget.user.uid)
                                                          .child(postId)
                                                          .set({
                                                        "memeUrl": url,
                                                        "ownerId": ownerId,
                                                        'timestamp': DateTime
                                                                .now()
                                                            .millisecondsSinceEpoch,
                                                        'postId': postId,
                                                      }),
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Added to your Meme Showcase",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor:
                                                            Colors.blue,
                                                        textColor: Colors.white,
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
                                                  fontFamily: 'cute',
                                                  fontSize: 14,
                                                  color: Constants.isDark ==
                                                      "true"
                                                      ? Colors.white
                                                      : Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
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
                                              top: 0, left: 10),
                                          child: ElevatedButton(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Delete Post',
                                                  style: TextStyle(
                                                      fontFamily: 'cute',
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
                                                  color: Constants.isDark ==
                                                      "true"
                                                      ? Colors.white
                                                      : Colors.blue,
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              deleteFunc(
                                                  postId, ownerId, type, index);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                primary: Colors.transparent,
                                                textStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                      fontFamily: 'cute',
                                                      fontSize: 14,
                                                      color: Constants.isDark ==
                                                          "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.error_outline,
                                                  color: Constants.isDark ==
                                                      "true"
                                                      ? Colors.white
                                                      : Colors.blue,
                                                  size: 20,
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
                                                      fontFamily: 'cute',
                                                      color: Constants.isDark ==
                                                          "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.account_circle_outlined,
                                                  size: 20,
                                                  color: Constants.isDark ==
                                                      "true"
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
                                                      fontFamily: 'cute',
                                                      color: Constants.isDark ==
                                                          "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.block,
                                                  size: 20,
                                                  color: Constants.isDark ==
                                                      "true"
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
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                            image: DecorationImage(
                              image: NetworkImage(data['url'] == null ? "https://switchappimages.nyc3.digitaloceanspaces.com/StaticUse/1646080905939.jpg" : data['url']),
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
                                color: Colors.lightBlue.shade700),
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
                                  color: Colors.black),
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
                                Text(
                                  "Caption:  ",
                                  style: TextStyle(
                                      color: Colors.lightBlue,
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
                                                          color: Colors.lightBlue,
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
                                Text(
                                  "Caption:  ",
                                  style: TextStyle(
                                      color: Colors.lightBlue,
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

  // _description(String description) {
  //   return description.length == 0
  //       ? Container(
  //           height: 0,
  //           width: 0,
  //         )
  //       : Container(
  //           width: MediaQuery.of(context).size.width,
  //           color: Colors.white,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 8),
  //             child: SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Row(
  //                 children: [
  //                   SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: Row(
  //                       children: [
  //                         SizedBox(
  //                           width: 15,
  //                         ),
  //                         if (description.length > 34)
  //                           GestureDetector(
  //                             onTap: () => {
  //                               showModalBottomSheet(
  //                                   useRootNavigator: true,
  //                                   isScrollControlled: true,
  //                                   barrierColor: Colors.red.withOpacity(0.2),
  //                                   elevation: 0,
  //                                   clipBehavior: Clip.antiAliasWithSaveLayer,
  //                                   context: context,
  //                                   builder: (context) {
  //                                     return Container(
  //                                       height:
  //                                           MediaQuery.of(context).size.height /
  //                                               2,
  //                                       child: SingleChildScrollView(
  //                                         child: Column(
  //                                           children: [
  //                                             Padding(
  //                                               padding:
  //                                                   const EdgeInsets.all(8.0),
  //                                               child: Row(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.center,
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment.center,
  //                                                 children: [
  //                                                   Icon(Icons
  //                                                       .linear_scale_sharp),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             Padding(
  //                                               padding:
  //                                                   const EdgeInsets.all(8.0),
  //                                               child: LinkifyText(
  //                                                 description,
  //                                                 textAlign: TextAlign.left,
  //                                                 linkTypes: [
  //                                                   LinkType.email,
  //                                                   LinkType.url,
  //                                                   LinkType.hashTag,
  //                                                   LinkType.userTag,
  //                                                 ],
  //                                                 linkStyle: TextStyle(
  //                                                     fontSize: 13,
  //                                                     fontFamily: "cutes",
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     color: Colors.lightBlue),
  //                                                 onTap: (link) => {
  //                                                   // url = link.value.toString(),
  //                                                   // _launchURL('http://$url'),
  //                                                 },
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     );
  //                                   }),
  //                             },
  //                             child: LinkifyText(
  //                               "@Caption: " +
  //                                   description.substring(0, 30) +
  //                                   " ...(readMore)",
  //                               textAlign: TextAlign.left,
  //                               linkTypes: [
  //                                 LinkType.email,
  //                                 LinkType.url,
  //                                 LinkType.hashTag,
  //                                 LinkType.userTag,
  //                               ],
  //                               linkStyle: TextStyle(
  //                                   fontSize: 13,
  //                                   fontFamily: "cutes",
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.lightBlue),
  //                               onTap: (link) => {
  //                                 // url = link.value.toString(),
  //                                 // _launchURL('http://$url'),
  //                               },
  //                             ),
  //                           )
  //                         else
  //                           GestureDetector(
  //                             onTap: () => {
  //                               bottomSheetForCommentSection(description),
  //                             },
  //                             child: LinkifyText(
  //                               "@Caption: " + description,
  //                               textAlign: TextAlign.left,
  //                               linkTypes: [
  //                                 LinkType.email,
  //                                 LinkType.url,
  //                                 LinkType.hashTag,
  //                                 LinkType.userTag,
  //                               ],
  //                               linkStyle: TextStyle(
  //                                   fontSize: 13,
  //                                   fontFamily: "cutes",
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.lightBlue),
  //                               onTap: (link) => {
  //                                 // url = link.value.toString(),
  //                                 // _launchURL('http://$url'),
  //                               },
  //                             ),
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  // }

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
              GestureDetector(
                onTap: () => {
                  reactorList.clear(),
                  getPostDetail(postId),

                  // posts.clear(),
                  // setState(() {
                  //   loadingRecentPosts = true;
                  // }),
                  // postsRtd
                  //     .child(ownerId)
                  //     .child("usersPost")
                  //     .limitToLast(30)
                  //     .once()
                  //     .then((DataSnapshot dataSnapshot) {
                  //   if (dataSnapshot.value != null) {
                  //     data = dataSnapshot.value;
                  //
                  //     data.forEach(
                  //         (index, data) => posts.add({"key": index, ...data}));
                  //     posts.sort((a, b) {
                  //       return b["timestamp"].compareTo(a["timestamp"]);
                  //     });
                  //   }
                  // }),
                  // Future.delayed(const Duration(seconds: 1), () {
                  //   setState(() {
                  //     loadingRecentPosts = false;
                  //   });
                  //   _recentPosts(ownerId, posts);
                  // }),
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5, bottom: 8),
                      child: Text(
                        "Details",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'cute',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 8),
                      child: Container(
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
                    ),
                  ],
                ),
              ),
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

  _getUserDetail(String ownerId) {
    User user = Provider.of<User>(context, listen: false);

    userRefRTD.child(ownerId).once().then((DataSnapshot dataSnapshot) {
      Map data = dataSnapshot.value;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Provider<User>.value(
            value: user,
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

  List reactorList = [];

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
                                          fontFamily: 'cute',
                                          fontSize: 14),
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
