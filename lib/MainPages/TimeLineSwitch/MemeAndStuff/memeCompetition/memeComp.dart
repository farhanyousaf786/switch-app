import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/MainPages/TimeLineSwitch/MemeAndStuff/memeCompetition/participatePage.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../Universal/Constans.dart';
import '../../../Profile/Panelandbody.dart';
import '../ShowAllParticipants/allParticipants.dart';

class MemeComp extends StatefulWidget {
  final User user;

  const MemeComp({required this.user});

  @override
  _MemeCompState createState() => _MemeCompState();
}

class _MemeCompState extends State<MemeComp> {
  bool isLive = true;

  List<String> memeTopic = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //_getMemerDetail();
    _getMemeTopics();
    _getMemeCompStatus();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });
  }

  List allMemerList = [];
  Map? data;

  _getMemerDetail() {
    userFollowersCountRtd.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        data = dataSnapshot.value;

        setState(() {});
      } else {}
    });
  }

  Map? topicMap;
  List? topicList = [];
  Map? compStatus;
  late String competitionStatus = "";

  void _getMemeTopics() {
    switchCompTopicListRTD.once().then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot != null) {
        topicMap = dataSnapshot.value;
        topicMap!
            .forEach((index, data) => topicList!.add({"key": index, ...data}));

        setState(() {});
      } else {
        print("null");
      }
    });
  }

  _getMemeCompStatus() {
    switchMemeCompRTD
        .child('status')
        .once()
        .then((DataSnapshot dataSnapshot) => {
              compStatus = dataSnapshot.value,
              if (dataSnapshot.exists)
                {
                  if (compStatus!['status'] == "end")
                    {
                      getWinner(),
                      setState(() {
                        competitionStatus = "end";
                      }),
                    }
                  else if (compStatus!['status'] == "live")
                    {
                      setState(() {
                        competitionStatus = "live";
                      }),
                    }
                  else
                    {
                      setState(() {
                        competitionStatus = "notLiveYet";
                      }),
                    }
                }
              else
                {}
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor:Constants.isDark == "true" ? Colors.grey.shade700 : Colors.blue.shade500,
        leading: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 20,
              )),
        ),
        title: Text(
          "Meme Competition",
          style:
              TextStyle(fontSize: 18, fontFamily: 'cute', color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: Constants.isDark == "true" ? [Colors.grey.shade700, Colors.grey.shade500]: [Colors.blue, Colors.lightBlue.shade100]),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),

              // isLoading
              //     ? Padding(
              //         padding: const EdgeInsets.only(bottom: 10),
              //         child: Center(
              //           child: Text(
              //             "Counting Users..",
              //             style: TextStyle(
              //                 color: Colors.blue.shade900,
              //                 fontFamily: 'cute',
              //                 fontSize: 14),
              //           ),
              //         ),
              //       )
              //     : Padding(
              //         padding: const EdgeInsets.only(bottom: 10),
              //         child: Center(
              //           child: Text(
              //             "Switch Users: ${data!.length}",
              //             style: TextStyle(
              //                 color: Colors.blue.shade900,
              //                 fontFamily: 'cute',
              //                 fontSize: 14),
              //           ),
              //         ),
              //       ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: Constants.isDark == "true" ? [Colors.grey.shade800, Colors.grey.shade600]: [Colors.blue.shade900, Colors.lightBlue.shade700]),
                    ),
                    child: isLoading
                        ? Center(
                            child: Text(
                              "Loading..",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'cute',
                                  fontSize: 14),
                            ),
                          )
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Center(
                                  child: Text(
                                    "Trending: ",
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontFamily: 'cute',
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 1.45,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topicList!.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "${topicList![index]['topic']}, ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'cute',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: isLoading
                      ? Center(
                          child: Text(
                            "Loading..",
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'cute',
                                fontSize: 14),
                          ),
                        )
                      : Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Center(
                                    child: Text(
                                      "1st Prize:",
                                      style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontFamily: 'cute',
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Center(
                                    child: Text(
                                      "1500 pkr, ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'cute',
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Center(
                                    child: Text(
                                      "2nd Prize:",
                                      style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontFamily: 'cute',
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Center(
                                    child: Text(
                                      "1000 pkr",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'cute',
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),

              competitionStatus == 'end'
                  ? SingleChildScrollView(
                      child: Material(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: Constants.isDark == "true" ? [Colors.grey.shade800, Colors.grey.shade600]: [Colors.blue.shade900, Colors.lightBlue.shade700]),

                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                competitionStatus == 'end'
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Top 3 Winner",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'cute',
                                              color: Colors.yellow),
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                topMemerUI()
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),

              SizedBox(
                height: competitionStatus == "end" ? 20 : 0,
              ),

              SingleChildScrollView(
                child: Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: Constants.isDark == "true" ? [Colors.grey.shade800, Colors.grey.shade600]: [Colors.blue.shade900, Colors.lightBlue.shade700]),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          competitionStatus == 'live'
                                              ? "  Live Now "
                                              : competitionStatus == 'end'
                                                  ? "Competition End "
                                                  : "Not Live Yet",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'cute',
                                              color: competitionStatus == 'live'
                                                  ? Colors.yellow
                                                  : Colors.white),
                                        ),
                                      ),
                                      competitionStatus == 'live'
                                          ? SpinKitPulse(
                                              color: competitionStatus == 'live'
                                                  ? Colors.yellow
                                                  : Colors.white,
                                              size: 20,
                                            )
                                          : SizedBox(
                                              height: 0,
                                              width: 0,
                                            ),
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Submit your Memes On the Trending Topics that Are Mentioned Above. If anyone submit out of context Meme, will not be part of prize money.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'cutes',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                height: 45,
                                child: TextButton(
                                  onPressed: () => {
                                    competitionStatus == 'end' ||
                                            competitionStatus == 'notLiveYet'
                                        ? Fluttertoast.showToast(
                                            msg: "Time Over / Not Live",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 10,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.red,
                                            fontSize: 14.0,
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ParticipatePage(
                                                user: widget.user,
                                              ),
                                            ),
                                          ),

                                    // showModalBottomSheet(
                                    //     useRootNavigator: true,
                                    //     isScrollControlled: true,
                                    //     barrierColor:
                                    //         Colors.red.withOpacity(0.2),
                                    //     elevation: 0,
                                    //     clipBehavior:
                                    //         Clip.antiAliasWithSaveLayer,
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return Container(
                                    //         height: MediaQuery.of(context)
                                    //                 .size
                                    //                 .height /
                                    //             3.5,
                                    //         child: SingleChildScrollView(
                                    //           child: Column(
                                    //             children: [
                                    //               Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.all(
                                    //                         5.0),
                                    //                 child: Row(
                                    //                   crossAxisAlignment:
                                    //                       CrossAxisAlignment
                                    //                           .center,
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment
                                    //                           .center,
                                    //                   children: [
                                    //                     Icon(Icons
                                    //                         .linear_scale_sharp),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //               Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.all(
                                    //                         8.0),
                                    //                 child: Text(
                                    //                   "Meme Competition will open when we reach 5000+ user in Switch App & Participant must have 100+ follower.",
                                    //                   textAlign:
                                    //                       TextAlign.center,
                                    //                   style: TextStyle(
                                    //                       fontSize: 15,
                                    //                       fontFamily: "cutes",
                                    //                       fontWeight:
                                    //                           FontWeight.bold,
                                    //                       color: Colors.blue),
                                    //                 ),
                                    //               ),
                                    //               Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.all(
                                    //                         8.0),
                                    //                 child: Text(
                                    //                   "Why?",
                                    //                   textAlign:
                                    //                       TextAlign.center,
                                    //                   style: TextStyle(
                                    //                       fontSize: 15,
                                    //                       fontFamily: "cutes",
                                    //                       fontWeight:
                                    //                           FontWeight.bold,
                                    //                       color: Colors
                                    //                           .red.shade700),
                                    //                 ),
                                    //               ),
                                    //               Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.all(
                                    //                         8.0),
                                    //                 child: Text(
                                    //                   "There is no point to create a competition environment, if there is not good number audience and participants",
                                    //                   textAlign:
                                    //                       TextAlign.center,
                                    //                   style: TextStyle(
                                    //                       fontSize: 15,
                                    //                       fontFamily: "cutes",
                                    //                       fontWeight:
                                    //                           FontWeight.bold,
                                    //                       color: Colors.grey),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       );
                                    //     }),
                                  },
                                  child: Container(
                                    child: Center(
                                      child: isLoading
                                          ? SpinKitCircle(
                                              color: Colors.blue,
                                              size: 18,
                                            )
                                          : Text(
                                              competitionStatus == 'live'
                                                  ? "Tap to Participate"
                                                  : competitionStatus == 'end'
                                                      ? "Time Over"
                                                      : "Start Soon",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'cutes',
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                    height: 40,
                                    width: 200,
                                  ),
                                ),
                              ),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                child: Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: Constants.isDark == "true" ? [Colors.grey.shade800, Colors.grey.shade600]: [Colors.blue.shade900, Colors.lightBlue.shade700]),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Participants",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'cute',
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Material(
                                  clipBehavior: Clip.antiAlias,
                                  child: TextButton(
                                    onPressed: () => {
                                      competitionStatus == 'live'
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Provider<User>.value(
                                                  value: widget.user,
                                                  child: AllParticipants(
                                                    user: widget.user,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Fluttertoast.showToast(
                                              msg: "Not Live",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 10,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.red,
                                              fontSize: 14.0,
                                            ),
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Show All Participants & Memes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'cutes',
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                    ),
                                  ),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),

              SingleChildScrollView(
                child: Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.4,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: Constants.isDark == "true" ? [Colors.grey.shade800, Colors.grey.shade600]: [Colors.blue.shade900, Colors.lightBlue.shade700]),
                    ),
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Rules",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'cute',
                                  color: Colors.orange),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              " 1) Memes which get most up votes, will be count winner's memes.\n\n"
                              " 2) Prize will distribute by JazzCash, for Now.\n\n"
                              " 3) Switch App Team will contact to winner.\n\n"
                              " 4) You cannot post any meme against any religion.\n\n"
                              " 5) You cannot use any bad words openly, but can use double meaning words.\n\n"
                              "6) Meme on nudity and sexual content will be delete and user will be block.\n\n"
                              " 7) Switch App have all the rights to make any type of changes in rules and prize amount.\n\n"
                              " 8) Racism and vulgar words are not allowed.\n\n"
                              " 9) Copied meme will not count in competition.\n\n",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "cute",
                                   fontWeight: FontWeight.bold,

                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: Constants.isDark == "true" ? [Colors.grey.shade800, Colors.grey.shade600]: [Colors.blue.shade900, Colors.lightBlue.shade700]),

                      ),
                      child: Center(
                          child: Text(
                        "More (Coming soon)",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'cute',
                            color: Colors.white),
                      ))),
                ),
              ),

              // SingleChildScrollView(
              //   child: Material(
              //     elevation: 2,
              //     shadowColor: Colors.blue.shade700,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15)),
              //     child: Container(
              //       height: 90,
              //       width: MediaQuery.of(context).size.width / 1.1,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(15),
              //         gradient: LinearGradient(
              //             begin: Alignment.centerLeft,
              //             end: Alignment.centerRight,
              //             colors: [Colors.blue.shade900, Colors.blue.shade700]),
              //       ),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.all(
              //           const Radius.circular(15.0),
              //         ),
              //         child: WebView(
              //
              //           initialUrl:
              //               'https://sites.google.com/view/switch-app-updates/home',
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Map? topMemer;
  List? memerList = [];

  getWinner() {
    topWinnerRTD.once().then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot != null) {
        topMemer = dataSnapshot.value;
        topMemer!
            .forEach((index, data) => memerList!.add({"key": index, ...data}));
        memerList = memerList?.reversed.toList();

        setState(() {});
      } else {
        print("null");
      }
    });
  }

  Widget topMemerUI() {
    if (memerList!.length == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.yellow,
            highlightColor: Colors.white,
            child: Center(
                child: Text(
              "Loading..",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'cutes',
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      );
    } else {
      return Container(
          width: MediaQuery.of(context).size.width / 1.05,
          height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.blue.shade900, Colors.blue.shade700]),
          ),
          child: CarouselSlider.builder(
              itemCount: memerList!.length,
              itemBuilder: (BuildContext context, int itemIndex,
                      int pageViewIndex) =>
                  SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () => {
                        setState(() {
                          isLoading = true;
                        }),
                        getUserData(memerList![itemIndex]["uid"]),
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Provider<User>.value(
                                  value: widget.user,
                                  child: SwitchProfile(
                                    currentUserId: widget.user.uid,
                                    mainProfileUrl: memerMap['url'],
                                    mainFirstName: memerMap['firstName'],
                                    profileOwner: memerMap['ownerId'],
                                    mainSecondName: memerMap['secondName'],
                                    mainCountry: memerMap['country'],
                                    mainDateOfBirth: memerMap['dob'],
                                    mainAbout: memerMap['about'],
                                    mainEmail: memerMap['email'],
                                    mainGender: memerMap['gender'],
                                    username: memerList![itemIndex]['username']
                                        .toString(),
                                    isVerified: memerMap['isVerified'],
                                    action: 'memerProfile',
                                    user: widget.user,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        setState(() {
                          isLoading = false;
                        }),
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'cutes',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 30, right: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${memerList![itemIndex]['name'].toString().toUpperCase()}",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'cutes',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade500),
                                      ),
                                      Text(
                                        "Decency " +
                                            memerList![itemIndex]['decency'],
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'cutes',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink.shade200),
                                      ),
                                    ],
                                  ),
                                ),
                                isLoading == true
                                    ? SpinKitRipple(
                                        color: Colors.blue,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 33,
                                          height: 33,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Colors.blue, width: 2),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                memerList![itemIndex]['url'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                Center(
                                  child: Text(
                                    "Memer #" + "${itemIndex + 1}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'cutes',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "username: " +
                                        memerList![itemIndex]['username'],
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'cutes',
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              options: CarouselOptions(
                height: 350,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(seconds: 4),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              )));
    }
  }

  late Map memerMap;

  getUserData(String uid) async {
    await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          memerMap = dataSnapshot.value;

          print(uid);
        });
      }
    });
  }
}
