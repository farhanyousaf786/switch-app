import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/imageCacheFilter.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';

import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Models/postModel/CommentsPage.dart';
import 'package:switchapp/Models/postModel/PostsReactCounters.dart';
import 'package:switchapp/Models/postModel/TextStatus.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:time_formatter/time_formatter.dart';

import '../ReportAndComplaints/postReportPage.dart';

class ProfilePosts extends StatefulWidget {
  final String profileOwner;
  final User user;

  const ProfilePosts({required this.profileOwner, required this.user,});

  @override
  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  void initState() {
    super.initState();
    Constants.myId != widget.profileOwner
        ? getAllProfilePost(widget.profileOwner)
        : getAllProfilePost(Constants.myId);

    setState(() {

    });
  }


  bool loading = false;
  int countPost = 0;
  List posts = [];
  late Map data;
  List reactorList = [];


  getAllProfilePost(String uid) async {
      postsRtd
          .child(uid)
          .child("usersPost").orderByChild('timestamp')
          .once()
          .then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          data = dataSnapshot.value;
          data.forEach((index, data) => posts.add({"key": index, ...data}));
          posts.sort((a, b) {
            return b["timestamp"].compareTo(a["timestamp"]);
          });
          setState(() {

          });
        }
      });



   // Constants.allMemes = posts;

  }

  getAllProfilePostForDirectMemeProfile(String uid) async {
    postsRtd
        .child(uid)
        .child("usersPost")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        data = dataSnapshot.value;

        data.forEach((index, data) => posts.add({"key": index, ...data}));
        posts.sort((a, b) {
          return a["timestamp"].compareTo(b["timestamp"]);
        });
      }
    });
    Constants.allMemes = posts;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
               // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, index) =>
                    profilePostWidget(posts, widget.user, index),
              ),
      ),
    );
  }

  profilePostWidget(List posts, User user, int index) {
    final user = Provider.of<User>(context, listen: false);
    String url = posts[index]['url'];
    int timestamp = posts[index]['timestamp'];
    String postId = posts[index]['postId'];
    String ownerId = posts[index]['ownerId'];
    String description = posts[index]['description'];
    String type = posts[index]['type'];
    String postTheme = posts[index]['statusTheme'];
    String time = formatTime(timestamp);

    if (type == "videoMeme" || type == "videoMemeT") {
      return Container(
        height: 0,
        width: 0,
      );
    } else {
      return _mainPosts(
          ownerId, postId, postTheme, time, description, type, url, user, index);
    }
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

  _mainPosts(String ownerId, String postId, String postTheme, String time,
      String description, String type, String url, User user, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
        ),

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
            index
          ),
        ),

        SizedBox(
          height: 15,
        ),
        mainStatus(description, type, url),

        type == "thoughts"
            ? SizedBox(
                height: 10.0,
              )
            : SizedBox(
                height: 5,
              ),
        _postFooter(user, postId, ownerId, url, postTheme, type),
        SizedBox(
          height: 10,
        ),

        type != "thoughts" ? _description(description) : Container(),
        // creatPostFooter(),

        SizedBox(
          height: 20,
        ),
      ],
    );
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
        style: TextStyle(color: Colors.black),
        linkStyle: TextStyle(color: Colors.blue,
            fontWeight: FontWeight.w700),
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
  //   return Row(
  //     children: [
  //       SizedBox(
  //         width: 15,
  //       ),
  //       if (description.length > 40)
  //         Flexible(
  //           child: GestureDetector(
  //             onTap: () => {
  //               showModalBottomSheet(
  //                   useRootNavigator: true,
  //                   isScrollControlled: true,
  //                   barrierColor: Colors.red.withOpacity(0.2),
  //                   elevation: 0,
  //                   clipBehavior: Clip.antiAliasWithSaveLayer,
  //                   context: context,
  //                   builder: (context) {
  //                     return Container(
  //                       height: MediaQuery.of(context).size.height / 2,
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.all(5.0),
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Icon(Icons.linear_scale_sharp),
  //                                 ],
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Text(
  //                                 "Caption",
  //                                 style: TextStyle(
  //                                     fontSize: 20,
  //                                     fontFamily: "cutes",
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.lightBlue),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(15),
  //                               child: Text(
  //                                 "$description",
  //                                 style: TextStyle(
  //                                     fontSize: 15,
  //                                     fontFamily: "cutes",
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.black),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   }),
  //             },
  //             child: RichText(
  //               text: TextSpan(
  //                 text: 'Caption: ',
  //                 style: TextStyle(
  //                   color: Colors.lightBlue,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 children: <TextSpan>[
  //                   TextSpan(
  //                     text: '${description.substring(0, 35)}..',
  //                     style: TextStyle(
  //                          fontWeight: FontWeight.bold, color: Colors.black
  //                       // decoration: TextDecoration.underline,
  //                       // decorationStyle: TextDecorationStyle.wavy,
  //                     ),
  //                   ),
  //                   TextSpan(
  //                     text: ' Read More',
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold, color: Colors.black
  //                       // decoration: TextDecoration.underline,
  //                       // decorationStyle: TextDecorationStyle.wavy,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )
  //       else
  //         Flexible(
  //           child: RichText(
  //             text: TextSpan(
  //               text: 'Caption: ',
  //               style: TextStyle(
  //                 color: Colors.lightBlue,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //               children: <TextSpan>[
  //                 TextSpan(
  //                   text: '$description',
  //                   style: TextStyle(
  //                        fontWeight: FontWeight.bold, color: Colors.black
  //                     // decoration: TextDecoration.underline,
  //                     // decorationStyle: TextDecorationStyle.wavy,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //     ],
  //   );
  // }


  /// Show Picture + Video Of the Posts  \\\

  mainStatus(String description, String type, String url) {
    if (type == "thoughts") {
      return TextStatus(
        description: description,
      );
    } else {
      return ImageCacheFilter(url: url, type: type, description: description);
    }
  }

  _postFooter(User user, String postId, String ownerId, String videoId,
      String postTheme, String type) {
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
                                      fontFamily: 'cute',
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
                        fontFamily: 'cute',
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
    );
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

  _showProfilePicAndName(String ownerId, String timeStamp, String postsId,
      String postTheme, String type, String description, int index) {
    return StreamBuilder(
        stream: userRefRTD.child(ownerId).onValue,
        builder: (context, AsyncSnapshot dataSnapShot) {
          if (dataSnapShot.hasData) {
            DataSnapshot snapshot = dataSnapShot.data.snapshot;
            Map data = snapshot.value;
            return Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
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
                            height: MediaQuery.of(context).size.height / 5,
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
                                                      fontFamily: 'cute',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                            onPressed: () => {



                                              deleteFunc(postsId, ownerId, type, index),

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
                                                          : Colors.blue,                                                      fontFamily: 'cute',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.error_outline,
                                                  color: Constants.isDark ==
                                                      "true"
                                                      ? Colors.white
                                                      : Colors.blue,                                                  size: 20,
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
                                                            postId: postsId,
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
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Icon(
                    Icons.more_horiz,
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
                                      color: Colors.black,
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
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
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
            return CircularProgressIndicator();
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
      int index
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
            }
          });
        } else {
        }

      postsRtd.child(ownerId).child("usersPost").child(postId).remove();
      switchAllUserFeedPostsRTD.child("UserPosts").child(postId).remove();
      setState(() {
        posts.removeAt(index);

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
