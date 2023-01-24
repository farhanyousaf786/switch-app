import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Models/postModel/CommentsPage.dart';
import '../../../../Models/postModel/PostsReactCounters.dart';
import '../../../../Models/postModel/TextStatus.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:timeago/timeago.dart' as tAgo;

class AllProfileMemes extends StatefulWidget {
  final List posts;
  final int index;

  const AllProfileMemes({
    required this.posts,
    required this.index,
  });

  @override
  _AllProfileMemesState createState() =>
      _AllProfileMemesState();
}

class _AllProfileMemesState extends State<AllProfileMemes> {




  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    String url = widget.posts[widget.index]['url'];
    String timestamp = widget.posts[widget.index]['timestamp'].toString();
    String postId = widget.posts[widget.index]['postId'];
    String ownerId = widget.posts[widget.index]['ownerId'];
    String description = widget.posts[widget.index]['description'];
    String type = widget.posts[widget.index]['type'];
    String postTheme = widget.posts[widget.index]['statusTheme'];

    DateTime dt = DateTime.parse(timestamp);
    // print(DateFormat("EEE, d MMM yyyy HH:mm:aa").format(dt));

    return type == "meme"
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _showProfilePicAndName(
                ownerId,
                DateFormat('hh:mm a, dd MMM').format(dt),
                postId,
                postTheme == "" ? "photo" : postTheme,
                type,
              ),

              SizedBox(
                height: 15,
              ),
              _mainPicture(description, type, url),

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
          )
        : Container();
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
      color: Colors.white,
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

  // late String url;
  // _launchURL(String updateLink) async {
  //   if (await canLaunch(updateLink)) {
  //     await launch(updateLink);
  //   } else {
  //     throw 'Could not launch $updateLink';
  //   }
  // }
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
  //                               padding: const EdgeInsets.all(8.0),
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
  //                               child: LinkifyText(
  //                                 description,
  //                                 linkTypes: [
  //                                   LinkType.email,
  //                                   LinkType.url,
  //                                   LinkType.hashTag,
  //                                   LinkType.userTag,
  //                                 ],
  //                                 linkStyle: TextStyle(
  //                                     fontSize: 13,
  //                                     fontFamily: "cutes",
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.blue),
  //                                 onTap: (link)=> {
  //                                   // url = link.value.toString(),
  //                                   //
  //                                   // _launchURL('http://$url'),
  //
  //
  //                                 },
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   }),
  //             },
  //             child: LinkifyText(
  //
  //
  //               "@Caption: " +  description.substring(0,35) + " ...(readMore)",
  //
  //               linkTypes: [
  //                 LinkType.email,
  //                 LinkType.url,
  //                 LinkType.hashTag,
  //                 LinkType.userTag,
  //               ],
  //
  //               linkStyle: TextStyle(
  //
  //                   fontSize: 13,
  //                   fontFamily: "cutes",
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.blue),
  //               onTap: (link) => {
  //                 // url = link.value.toString(),
  //                 //
  //                 // _launchURL('http://$url'),
  //               },
  //             ),
  //           ),
  //         )
  //       else
  //         Flexible(
  //           child: LinkifyText(
  //             "@Caption: " + description,
  //             linkTypes: [
  //               LinkType.email,
  //               LinkType.url,
  //               LinkType.hashTag,
  //               LinkType.userTag,
  //
  //             ],
  //             linkStyle: TextStyle(
  //                 fontSize: 13,
  //                 fontFamily: "cutes",
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.blue),
  //             onTap: (link) => {
  //               //
  //               // url = link.value.toString(),
  //               //
  //               // _launchURL('http://$url'),
  //             },
  //           ),
  //         ),
  //     ],
  //   );
  // }
  /// Show Picture + Video Of the Posts  \\\

  _mainPicture(String description, String type, String url) {
    if (type == "videoMeme") {
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

  _showVideo(String url) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // VideoWidget(
          //   url: videoUrl,
          // ),
        ],
      ),
    );
  }

 late DataSnapshot snapshot;

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
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<User>.value(
                        value: user,
                        child: CommentsPage(
                            postId: postId,
                            ownerId: ownerId,
                            photoUrl: videoId),
                      ),
                    ),
                  );
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
                                  dataSnapShot.data!.snapshot;
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
                            height: MediaQuery.of(context).size.height / 3,
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
                                                      color: Colors.black,
                                                      fontFamily: 'cutes',
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
                                              postsRtd
                                                  .child(ownerId)
                                                  .child("usersPost")
                                                  .child(postsId)
                                                  .remove(),
                                              switchAllUserFeedPostsRTD
                                                  .child("UserPosts")
                                                  .child(postsId)
                                                  .remove(),
                                              Navigator.pop(context),
                                              Navigator.pop(context),
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
                                                          : Colors.blue,                                                      fontFamily: 'cutes',
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
                                              Navigator.pop(context),
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

// postPicture() {
//   final user = Provider.of<User>(context, listen: false);
//
//   if (videoUpload) {
//     _showVideo();
//   } else {
//     return Column(
//       children: [
//         _showProfilePicAndName(),
//         _mainPicture(),
//         _showCommentIcon(user),
//       ],
//     );
//   }
// }

}
