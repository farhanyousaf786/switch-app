import 'dart:io' show InternetAddress, SocketException;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import '../../../Models/imageCacheFilter.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/postReportPage.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/reportId.dart';
import 'package:switchapp/Models/postModel/TextStatus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Models/postModel/CommentsPage.dart';
import '../../../../Models/postModel/PostsReactCounters.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:time_formatter/time_formatter.dart';

import '../../../learning/video_widget.dart';
import '../MainFeed/CacheImageTemplate.dart';

class MemesOnly extends StatefulWidget {
  late final User user;
  final VoidCallback isVisible;
  final VoidCallback isHide;

  MemesOnly({
    required this.user,
    required this.isVisible,
    required this.isHide,
  });

  @override
  _MemesOnlyState createState() => _MemesOnlyState();
}

//my name is khan
class _MemesOnlyState extends State<MemesOnly> {
  int? selectedIndex;
  bool isLoading = true;
  bool _hasMore = false;
  late int startAt = 0;
  late int endAt = 0;
  final ScrollController listScrollController = ScrollController();
  double? _scrollPosition;
  bool loadingRecentPosts = false;
  List reactorList = [];

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    aboutYourMemePage();
    getFirstPostList();
    getRandomPosts();
  }

  void getRandomPosts() {
    Random random = Random();
    int randomNum = random.nextInt(5);

    if (randomNum == 0) {
      setState(() {
        startAt = 20;
        endAt = 35;
      });
    } else if (randomNum == 1) {
      setState(() {
        startAt = 36;
        endAt = 51;
      });
    } else if (randomNum == 2) {
      setState(() {
        startAt = 52;
        endAt = 67;
      });
    } else if (randomNum == 3) {
      setState(() {
        startAt = 68;
        endAt = 83;
      });
    } else if (randomNum == 4) {
      setState(() {
        startAt = 84;
        endAt = 99;
      });
    } else {
      setState(() {
        startAt = 100;
        endAt = 115;
      });
    }
  }

  late Map allPostMap;
  late Map store;
  List allPostList = [];
  List limitedPostList = [];

  getFirstPostList() async {
    allPostList.clear();
    limitedPostList.clear();
    switchAllUserFeedPostsRTD
        .child("UserPosts")
        .orderByChild('timestamp')
        .limitToLast(300)
        .once()
        .then(
      (DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          allPostMap = dataSnapshot.value;

          allPostMap.forEach(
            (index, data2) => allPostList.add({"key": index, ...data2}),
          );
        }
      },
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      allPostList.sort(
        (a, b) {
          return b["timestamp"].compareTo(a["timestamp"]);
        },
      );
      Future.delayed(const Duration(milliseconds: 400), () {
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
    });
  }

  late bool _isHide = false; // Variable to to hide switch trend

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
      print("isHide...................................");
      widget.isHide();

      setState(() {
        _isHide = true;
      });
    }
    if (_scrollPosition! < 50.0) {
      print("isHide......................<>.............");

      setState(() {
        _isHide = false;
      });
    }
  }

  getNextPosts() {
    if (endAt > 290) {
      print("***************** list Ended *****************");
      Fluttertoast.showToast(
        msg: "300+ posts has been seen",
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
  

  aboutYourMemePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("aboutYourMemePage") == null) {
      prefs.setInt("aboutYourMemePage", 0);
      print("aboutYourMemePage: ${prefs.getInt("aboutYourMemePage")}");

      aboutYourMemePageSlide();
    } else {
      if (prefs.getInt("aboutYourMemePage")! > 1) {
        print("aboutYourMemePage: ${prefs.getInt("aboutYourMemePage")}");
      } else {
        print("aboutYourMemePage: ${prefs.getInt("aboutYourMemePage")}");

        aboutYourMemePageSlide();
      }
      //  followSwitchId();
      // bottomSheetForFollowing();
    }
  }

  aboutYourMemePageSlide() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BarTop(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Important",
                      style: TextStyle(
                           fontWeight: FontWeight.bold,
                          fontSize: 22, fontFamily: "cute", color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 5, top: 5),
                    child: Row(
                      children: [
                        Container(
                          child: Flexible(
                            child: Text(
                              "What is MEME page?",
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontFamily: 'cute',
                                  fontSize: 18),
                            ),
                          ),
                        ),
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
                              "This slide will show the Latest Memes.\n"
                              "Support them by following them, so they can post more and more for you.",
                              style: TextStyle(
                                  color: Colors.lightBlue.shade700,
                                  fontFamily: 'cute',
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt("aboutYourMemePage", 2);

                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 40,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Do not show again",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Version 1.5",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                            fontFamily: 'cute'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // This is ad Area for Switch Shot Meme
  late NativeAd myNativeAd;
  bool isLoaded1 = false;

  void loadNativeAd() {
    myNativeAd = NativeAd(
        //adUnitId: 'ca-app-pub-5525086149175557/7947037502',
        adUnitId: 'ca-app-pub-3940256099942544/2247696110',
        factoryId: 'listTile',
        request: request,
        listener: NativeAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded1 = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();

          print('ad failed to load ${error.message}');
        }));

    myNativeAd.load();
  }

  static const AdRequest request = AdRequest(
      // keywords: ['', ''],
      // contentUrl: '',
      // nonPersonalizedAds: false
      );

  Widget nativeAdWidget() {
    return isLoaded1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://switchappimages.nyc3.digitaloceanspaces.com/StaticUse/1646080905939.jpg"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Switch Ad",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'cute',
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: AdWidget(
                    ad: myNativeAd,
                  ),
                  height: 180,
                ),
              ),
            ],
          )
        : Center(
            child: Container(
            height: 0,
            width: 0,
          ));
  }

  @override
  void dispose() {
    super.dispose();
    // myNativeAd.dispose();
  }

  late bool isHide = false; // Variable to to hide switch trend
  late bool _visible = false; // Variable to to hide switch trend
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
                child: SpinKitThreeBounce(
              color: Colors.lightBlue,
              size: 15,
            )),
          )
        : Expanded(
            child: Stack(
              children: [
                NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    final ScrollDirection direction = notification.direction;
                    setState(() {
                      if (direction == ScrollDirection.reverse) {
                        _visible = false;

                        print("visible: $_visible");
                      } else if (direction == ScrollDirection.forward) {
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
                    isInViewPortCondition: (double deltaTop, double deltaBottom,
                        double viewPortDimension) {
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
                        final user = Provider.of<User>(context, listen: false);
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

                        if (type == "memeT" ||
                            type == "meme" ||
                            type == "videoMeme" ||
                            type == "videoMemeT") {
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
                                    postTheme == "" ? "photo" : postTheme,
                                    type,
                                    description,
                                    url,
                                    index),
                              ),

                              type == "thoughts"
                                  ? TextStatus(description: description)
                                  : type == "videoMeme" || type == "videoMemeT"
                                      ? _videoPosts(index)
                                      : imagePosts(index),

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
                        } else {
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        }
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
                            if (listScrollController.hasClients) {
                              final position =
                                  listScrollController.position.minScrollExtent;
                              listScrollController.animateTo(
                                position,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 33, right: 15),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                        child: Icon(
                                      Icons.arrow_upward_sharp,
                                      size: 15,
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
        ),
      );
    });
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
        linkStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
    );
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
                                        fontSize: 12, fontFamily: 'cute'),
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
  //   return _caption(description);
  // }
  //
  // _caption(String description) {
  //   if (description.length > 40) {
  //     return Padding(
  //       padding: const EdgeInsets.only(left: 12),
  //       child: GestureDetector(
  //         onTap: (){
  //
  //           showModalBottomSheet(
  //               useRootNavigator: true,
  //               isScrollControlled: true,
  //               barrierColor: Colors.red.withOpacity(0.2),
  //               elevation: 0,
  //               clipBehavior: Clip.antiAliasWithSaveLayer,
  //               context: context,
  //               builder: (context) {
  //                 return Container(
  //                   height: MediaQuery.of(context).size.height / 3.5,
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Icon(Icons.linear_scale_sharp),
  //                           ],
  //                         ),
  //
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 12),
  //                           child: Text(
  //                             "Caption",
  //                             style: TextStyle(
  //                                 fontSize: 15,
  //                                 fontFamily: "cutes",
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.lightBlue),
  //                           ),
  //                         ),
  //
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text(
  //                             description,
  //                             style: TextStyle(
  //                                 fontSize: 10,
  //                                 fontFamily: "cutes",
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.grey),
  //                           ),
  //                         ),
  //
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               });
  //
  //         },
  //
  //         child: Align(
  //           alignment: Alignment.topLeft,
  //           child: description == ""
  //               ? Container(
  //             height: 0,
  //             width: 0,
  //           )
  //               : Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(4.0),
  //                 child: RichText(
  //                   overflow: TextOverflow.ellipsis,
  //                   text: TextSpan(
  //                     text: 'Caption: ',
  //                     style: TextStyle(
  //                       color: Colors.lightBlue,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                     children: <TextSpan>[
  //                       TextSpan(
  //                         text: '${description}..',
  //                         style: TextStyle(
  //                              fontWeight: FontWeight.bold, color: Colors.black
  //                           // decoration: TextDecoration.underline,
  //                           // decorationStyle: TextDecorationStyle.wavy,
  //                         ),
  //                       ),
  //
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Text("read more", style: TextStyle(
  //                   fontWeight: FontWeight.bold, color: Colors.grey,
  //                   fontSize: 12
  //                 // decoration: TextDecoration.underline,
  //                 // decorationStyle: TextDecorationStyle.wavy,
  //               ),)
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Align(
  //       alignment: Alignment.topLeft,
  //       child: Padding(
  //         padding: const EdgeInsets.all(4.0),
  //         child: description == ""
  //             ? Container(
  //           height: 0,
  //           width: 0,
  //         )
  //             : Padding(
  //           padding: const EdgeInsets.only(left: 12),
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
  //       ),
  //     );
  //   }
  // }
  mainStatus(String description, String type, String url, int index) {
    if (type == "meme" || type == "memeT") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.blue[200],
                      child: Center(
                          child: Icon(
                        Icons.image,
                        size: 60,
                      )),
                    )),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  late Map data;
  List posts = [];

  _postFooter(User user, String postId, String ownerId, String url,
      String postTheme, int index, String type) {
    return Column(
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
                              size: 22,
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
            TextButton(
              onPressed: () => {reactorList.clear(), getPostDetail(postId)},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Detail  ",
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
                ),
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
    );
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
                                  type == 'meme' || type == "memeT"
                                      ? Padding(
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
                                                        fontFamily: 'cute',
                                                        fontSize: 14,
                                                        color:
                                                            Constants.isDark ==
                                                                    "true"
                                                                ? Colors.white
                                                                : Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Icon(
                                                      Icons.apps,
                                                      color: Constants.isDark ==
                                                              "true"
                                                          ? Colors.white
                                                          : Colors.blue,
                                                      size: 17,
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
                                        )
                                      : SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                  ownerId == Constants.myId ||
                                          widget.user.uid == Constants.switchId
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 20),
                                          child: TextButton(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Delete Post',
                                                    style: TextStyle(
                                                        fontFamily: 'cute',
                                                        fontSize: 14,
                                                        color:
                                                            Constants.isDark ==
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
                                              onPressed: () => {
                                                    deleteFunc(postId, ownerId,
                                                        type, index),
                                                  }),
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
                                                    fontWeight: FontWeight.bold,
                                                    color: Constants.isDark ==
                                                            "true"
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
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
                                                    fontFamily: 'cute',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Constants.isDark ==
                                                            "true"
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
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
                            fontFamily: "cute",
                             fontWeight: FontWeight.bold,
                            color: Colors.lightBlue),
                      ),
                    ),
                    // Container(
                    //   height: 600,
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     reverse: false,
                    //     itemCount: posts.length,
                    //     itemBuilder: (context, index) => Provider<User>.value(
                    //       value: widget.user,
                    //       child: TimelinePosts(
                    //         index: index,
                    //         posts: posts,
                    //         navigatorType: "meme",
                    //         navigateThrough: "",
                    //         user: widget.user,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          );
        });
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
                                   fontWeight: FontWeight.bold,

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

  _videoPosts(int index) {
    return Container(
      height: 360.0,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return InViewNotifierWidget(
              id: '$index',
              builder: (BuildContext context, bool isInView, Widget? child) {
                return VideoWidget(
                    play: isInView, url: limitedPostList[index]['url'],
                  time: limitedPostList[index]['timestamp'],
                );
              },
            );
          },
        ),
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
            child: CacheImageTemplate(
              list: limitedPostList,
              index: index,
            )),
      ),
    );
  }
}
