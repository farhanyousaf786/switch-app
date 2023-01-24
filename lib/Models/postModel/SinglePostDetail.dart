import 'dart:io';

import 'package:emojis/emoji.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/postReportPage.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'CommentsPage.dart';
import 'PostsReactCounters.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'TextStatus.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class SinglePostDetail extends StatefulWidget {
  final String url;
  final String ownerId;
  final String postId;

  const SinglePostDetail({
    required this.url,
    required this.ownerId,
    required this.postId,
  });

  @override
  _SinglePostDetailState createState() => _SinglePostDetailState();
}

class _SinglePostDetailState extends State<SinglePostDetail> {
  late Map data;
  bool dataAvail = false;
  bool loading = true;
  late int timestamp;
  late String description;
  late String type;
  late String postTheme;
  late DateTime dt;
  late String postPicUrl;
  late String time = "";

  @override
  void initState() {
    super.initState();
    print(widget.postId);
    print(widget.ownerId);
    Future.delayed(const Duration(milliseconds: 200), () {
      _getPostData();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted)
        setState(() {
          loading = false;
        });
    });
  }

  _getPostData() {
    postsRtd
        .child(widget.ownerId)
        .child("usersPost")
        .child(widget.postId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      print(">>>>>>>>>>>>>>>>>snapShot: : : : ${dataSnapshot.value}");

      if (dataSnapshot.value != null) {
        setState(() {
          data = dataSnapshot.value;
        });
        timestamp = data['timestamp'];
        description = data['description'];
        type = data['type'];
        postTheme = data['statusTheme'];
        postPicUrl = data['url'];
        print(">>>>>>>>>>>>>>>>>theme: : : : ${postTheme}");

        time = formatTime(timestamp);

        setState(() {
          dataAvail = true;
        });
      } else {
        print("nullllllllllllllllllll");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return _mainScaffold(user);
  }

  _mainScaffold(User user) {
    if (dataAvail) {
      return type == "meme" || type =="videoMemeT" || type == "memeT"
          ? type == "meme" || type =="videoMemeT" || type == "memeT"

              ? _mainPosts(widget.ownerId, widget.postId, postTheme, time,
                  description, type, widget.url, user)
              : Container()
          : _mainPosts(widget.ownerId, widget.postId, postTheme, time,
              description, type, widget.url, user);
    } else {
      return Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Text(
                    loading
                        ? "Loading.."
                        : "This Post might be removed by owner!",
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'cute', fontSize: 16),
                  )),
                ),
                loading
                    ? Text("")
                    : GestureDetector(
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
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                       BarTop(),
                                        widget.ownerId == Constants.myId
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12, left: 10),
                                                child: ElevatedButton(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Delete Post',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'cutes',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.black,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () => {
                                                    postsRtd
                                                        .child(widget.ownerId)
                                                        .child("usersPost")
                                                        .child(widget.postId)
                                                        .remove(),
                                                    switchAllUserFeedPostsRTD
                                                        .child("UserPosts")
                                                        .child(widget.postId)
                                                        .remove(),
                                                    Navigator.pop(context),
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Deleted! Refresh App :)",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.SNACKBAR,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor:
                                                          Colors.white,
                                                      textColor: Colors.blue,
                                                      fontSize: 16.0,
                                                    ),
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          elevation: 0.0,
                                                          primary: Colors
                                                              .transparent,
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12, left: 10),
                                                child: ElevatedButton(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Report Post ',
                                                        style: TextStyle(
                                                            color: Constants.isDark ==
                                                                "true"
                                                                ? Colors.white
                                                                : Colors.blue,                                                            fontFamily: 'cutes',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(
                                                        Icons.error_outline,
                                                        color: Colors.black,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () => {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PostReport(
                                                                      reportById:
                                                                          user.uid,
                                                                      reportedId:
                                                                          widget
                                                                              .ownerId,
                                                                      postId: widget
                                                                          .postId,
                                                                      type:
                                                                          "reportPost",
                                                                    )))
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0.0,
                                                    primary: Colors.transparent,
                                                    textStyle: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                        GestureDetector(
                                          onTap: () {
                                            switchShowCaseRTD
                                                .child(user.uid)
                                                .child(widget.postId)
                                                .once()
                                                .then((DataSnapshot
                                                        dataSnapshot) =>
                                                    {
                                                      if (dataSnapshot.value !=
                                                          null)
                                                        {
                                                          switchShowCaseRTD
                                                              .child(Constants
                                                                  .myId)
                                                              .child(
                                                                  widget.postId)
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
                                                              .child(Constants
                                                                  .myId)
                                                              .child(
                                                                  widget.postId)
                                                              .set({
                                                            "memeUrl":
                                                                widget.url,
                                                            "ownerId":
                                                                widget.ownerId,
                                                            'timestamp': DateTime
                                                                    .now()
                                                                .millisecondsSinceEpoch,
                                                            'postId':
                                                                widget.postId,
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
                                                  " Add/Remove from Meme ShowCase ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'cutes',
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
                                                    // color: selectedIndex == index
                                                    //     ? Colors.pink
                                                    //     : selectedIndex == 121212
                                                    //         ? Colors.grey
                                                    //         : Colors.teal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
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
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.list,
                            // color: selectedIndex == index
                            //     ? Colors.pink
                            //     : selectedIndex == 121212
                            //         ? Colors.grey
                            //         : Colors.teal,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    }
  }

  _mainPosts(String ownerId, String postId, String postTheme, String time,
      String description, String type, String url, User user) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => {Navigator.pop(context)},
            child: Icon(
              Icons.arrow_back_ios_sharp,
              size: 18,
            )),
        centerTitle: true,
        title: Text(
          "Post",
          style: TextStyle(
            fontFamily: 'cute',
            fontSize: 20,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _showProfilePicAndName(
              ownerId,
              time,
              postId,
              postTheme == "" ? "photo" : postTheme,
              type,
            ),

            SizedBox(
              height: 15,
            ),
            _mainPicture(description, type, postPicUrl),

            type == "thoughts"
                ? SizedBox(
                    height: 10.0,
                  )
                : SizedBox(
                    height: 5,
                  ),
            _postFooter(user, postId, ownerId, url, postTheme),
            SizedBox(
              height: 10,
            ),

            type != "thoughts" ? _description(description) : Container(),
            // creatPostFooter(),

            SizedBox(
              height: 20,
            ),
          ],
        ),
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
                                  fontFamily: "cute",
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
                                    fontFamily: "cute",
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
        style: TextStyle(color: Colors.black),
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
                                        color: Colors.black,
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

  // _description(String description) {
  //   return Row(
  //     children: [
  //       SizedBox(
  //         width: 15,
  //       ),
  //       description == ""
  //           ? Container()
  //           : Flexible(
  //               child: RichText(
  //                 text: TextSpan(
  //                   text: 'Caption: ',
  //                   style: TextStyle(
  //                     color: Colors.blue,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   children: <TextSpan>[
  //                     TextSpan(
  //                       text: '$description',
  //                       style: TextStyle(
  //                            fontWeight: FontWeight.bold, color: Colors.black
  //                           // decoration: TextDecoration.underline,
  //                           // decorationStyle: TextDecorationStyle.wavy,
  //                           ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //     ],
  //   );
  // }

  /// Show Picture + Video Of the Posts  \\\

  _mainPicture(String description, String type, String url) {
    if ( type =="videoMemeT" || type == "memeT"
        ) {
      return _showVideo(url);
    } else if (type == "thoughts") {
      return TextStatus(
        description: description,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(url)),
      );
    }
  }

  List reactorList = [];

  _showVideo(String url) {
    return Flexible(
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: [SingleVideoShow(videoUrl: url)],
        ),
      ),
    );
  }

  _postFooter(User user, String postId, String ownerId, String videoId,
      String postTheme) {
    return Row(
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
                  print("Time Line Page");
                  showModalBottomSheet(
                      useRootNavigator: true,
                      isScrollControlled: true,
                      barrierColor: Colors.red.withOpacity(0.2),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      context: context,
                      builder: (context) {
                        return Provider<User>.value(
                          value: user,
                          child: CommentsPage(
                              postId: postId,
                              ownerId: ownerId,
                              photoUrl: videoId),
                        );
                      });
                },
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        StreamBuilder(
                          stream:
                              commentRtDatabaseReference.child(postId).onValue,
                          builder: (context, AsyncSnapshot dataSnapShot) {
                            if (!dataSnapShot.hasData) {
                              return Text("0");
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

                              return dataSnapShot.data.snapshot.value == null
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
        TextButton(
          onPressed: () => {
            reactorList.clear(),
            reactRtDatabaseReference
                .child('reactors')
                .child(postId)
                .once()
                .then((DataSnapshot dataSnapshot) {
              if (dataSnapshot.exists) {
                Map data = dataSnapshot.value;
                data.forEach(
                    (index, data) => reactorList.add({"key": index, ...data}));
              }
            }),
            Future.delayed(const Duration(seconds: 1), () {
              showModalBottomSheet(
                  useRootNavigator: true,
                  isScrollControlled: true,
                  barrierColor: Colors.red.withOpacity(0.2),
                  elevation: 0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                           BarTop(),
                            ownerId == Constants.myId
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: ElevatedButton(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Delete Post',
                                            style: TextStyle(
                                                fontFamily: 'cutes',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {
                                        deleteFunc(postId, ownerId, type),
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          primary: Colors.transparent,
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: ElevatedButton(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Report Post ',
                                            style: TextStyle(
                                                fontFamily: 'cutes',
                                                color: Constants.isDark ==
                                                    "true"
                                                    ? Colors.white
                                                    : Colors.blue,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.error_outline,
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
                                                    PostReport(
                                                      reportById: user.uid,
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
                            GestureDetector(
                              onTap: () {
                                switchShowCaseRTD
                                    .child(user.uid)
                                    .child(postId)
                                    .once()
                                    .then((DataSnapshot dataSnapshot) => {
                                          if (dataSnapshot.value != null)
                                            {
                                              switchShowCaseRTD
                                                  .child(Constants.myId)
                                                  .child(postId)
                                                  .remove(),
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Remove From Your Meme Showcase",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 3,
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            }
                                          else
                                            {
                                              switchShowCaseRTD
                                                  .child(Constants.myId)
                                                  .child(postId)
                                                  .set({
                                                "memeUrl": widget.url,
                                                "ownerId": ownerId,
                                                'timestamp': DateTime.now()
                                                    .millisecondsSinceEpoch,
                                                'postId': postId,
                                              }),
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Added to your Meme Showcase",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 3,
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            }
                                        });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, left: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "Add/Remove from Meme ShowCase ",
                                      style: TextStyle(
                                          fontFamily: 'cutes',
                                          fontSize: 14,
                                          color: Constants.isDark ==
                                              "true"
                                              ? Colors.white
                                              : Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: Text(
                                    " Reactors",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "cute",
                                         fontWeight: FontWeight.bold,

                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            reactorList.isEmpty
                                ? Text("No one react yet")
                                : Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Container(
                                      height: MediaQuery.of(context).size.height /
                                          1.6,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: reactorList.length,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                          onTap: () {
                                            _getUserDetail(
                                                reactorList[index]['reactorId']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8.0),
                                                  child: Image.network(
                                                    reactorList[index]
                                                        ['reactorPhoto'],
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
                                                        fontFamily: 'cutes',
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
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
            }),
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.list,
              // color: selectedIndex == index
              //     ? Colors.pink
              //     : selectedIndex == 121212
              //         ? Colors.grey
              //         : Colors.teal,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  _showProfilePicAndName(String ownerId, String timeStamp, String postsId,
      String postTheme, String type) {
    return StreamBuilder(
        stream: userRefRTD.child(ownerId).onValue,
        builder: (context, AsyncSnapshot dataSnapShot) {
          if (dataSnapShot.hasData) {
            DataSnapshot snapshot = dataSnapShot.data.snapshot;
            Map data = snapshot.value;
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                title: Transform(
                  transform: Matrix4.translationValues(-1, 5.0, 0.0),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1),
                          image: DecorationImage(
                            image: NetworkImage(data['url']),
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
                                    fontSize: 14,
                                  ),
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
                              padding: const EdgeInsets.only(left: 10, top: 5),
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

//                    subtitle: Text(description),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
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

  int like = 0;
  int disLike = 0;
  int heartReact = 0;
  int total = 0;

  deleteFunc(
      String postId,
      String ownerId,
      String type,
      )  async {


    try  {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)



        if (type == 'meme' ||
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

class SingleVideoShow extends StatefulWidget {
  late final String videoUrl;

  SingleVideoShow({required this.videoUrl});

  @override
  _SingleVideoShowState createState() => _SingleVideoShowState();
}

class _SingleVideoShowState extends State<SingleVideoShow> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        print("position::::" + "${_controller.value.duration}");
      });
    print("url : : : ${widget.videoUrl}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 40,
              width: 100,
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
