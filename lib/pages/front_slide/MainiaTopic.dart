import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class FrontSlide extends StatefulWidget {
  @override
  _FrontSlideState createState() => _FrontSlideState();
}

class _FrontSlideState extends State<FrontSlide> {
  Map? topicMap;
  List? topicList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted)
        setState(() {
          loading = false;
        });
    });

    getTopic();
  }

  getTopic() {
    FirebaseDatabase.instance
        .reference()
        .child("SwitchManiaTopics")
        .orderByChild('timeStamp')
        .once()
        .then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot != null) {
        topicMap = dataSnapshot.value;
        topicMap!
            .forEach((index, data) => topicList!.add({"key": index, ...data}));
        topicList!.sort((a, b) {
          return b["timeStamp"].compareTo(a["timeStamp"]);
        });
        if (mounted) setState(() {});
      } else {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Column(
            children: [
              Container(
                child: DelayedDisplay(
                  delay: Duration(microseconds: 100),
                  slidingBeginOffset: Offset(0.0, -1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "News & Trend..",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 14,
                              fontFamily: 'cute'),
                        ),
                      ),
                      SpinKitCircle(
                        color: Colors.lightBlue,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          )
        : Container(
            width: MediaQuery.of(context).size.width / 1,
            height: 95,
            child: CarouselSlider.builder(
              itemCount: topicList?.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              topicList![itemIndex]['topic'],
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontFamily: 'cute',
                                  fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: Center(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "This link (${link.url}) will lead you out of the Switch App.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "cute",
                                                           fontWeight: FontWeight.bold,

                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  TextButton(
                                                      onPressed: () async {
                                                        if (await canLaunch(
                                                            link.url)) {
                                                          await launch(
                                                              link.url);
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
                                text: topicList![itemIndex]['details'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                                linkStyle: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    fontFamily: 'cute'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              options: CarouselOptions(
                height: 400,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
  }
}
