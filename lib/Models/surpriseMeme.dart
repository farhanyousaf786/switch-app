import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/learning/video_widget.dart';
import 'package:video_player/video_player.dart';

import '../MainPages/TimeLineSwitch/MainFeed/CacheImageTemplate.dart';

class SurpriseMeme extends StatefulWidget {
  final String url;
  final bool play;
  final miliSec;

  const SurpriseMeme(
      {Key? key, required this.url, required this.play, required this.miliSec})
      : super(key: key);

  @override
  _SurpriseMemeState createState() => _SurpriseMemeState();
}

class _SurpriseMemeState extends State<SurpriseMeme> {
  late VideoPlayerController _controller;

  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      widget.url,
    );

    _initializeVideoPlayerFuture = _controller.initialize().then(
      (_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        setState(() {});
      },
    );

    if (widget.play) {
      _controller.play();
      _controller.setLooping(false);
    }

    Future.delayed(Duration(milliseconds: widget.miliSec), () {
      Navigator.pop(context);
    });

    super.initState();
  }

  bottomSheetToShowMeme(BuildContext context, String url, String caption) {
    return showModalBottomSheet(
      useRootNavigator: true,
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: Colors.blue.withOpacity(0.4),
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 1.2,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                caption != ""
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 5, top: 20),
                        child: Row(
                          children: [
                            Text(
                              caption,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 100),
                  slidingBeginOffset: Offset(0.0, 1.0),
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: url,
                      placeholder: (context, url) => Container(child: Text("")),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DelayedDisplay(
                        delay: Duration(seconds: 2),
                        slidingBeginOffset: Offset(0.0, -1),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LandingPage(),
                              ),
                            );
                          },
                          child: DelayedDisplay(
                            delay: Duration(milliseconds: 100),
                            slidingBeginOffset: Offset(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 38,
                              width: MediaQuery.of(context).size.width / 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () async {
                      //     //"http://via.placeholder.com/350x150"
                      //     // surpriseMeme
                      //     //     .createState()
                      //     //     .bottomSheetForSkipButton(context);
                      //     // Navigator.pushReplacement(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => SurpriseMeme(
                      //     //         miliSec: 4000,
                      //     //         play: true,
                      //     //         url:
                      //     //             "https://switchappvideos.nyc3.digitaloceanspaces.com/appMeme/Bahut%20tez%20ho%20rhy%20ho.mp4"),
                      //     //   ),
                      //     // );
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => LandingPage(),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.green.shade900,
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //     height: 50,
                      //     width: MediaQuery.of(context).size.width / 2.5,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Center(
                      //         child: Text(
                      //           "Watch Now",
                      //           style: TextStyle(
                      //               color: Colors.white, fontSize: 13),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Switch Meme",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'cutes',
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: <Widget>[
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                      // Text(
                      //   "Hello",
                      //   style: TextStyle(
                      //     fontSize: 30,
                      //   ),
                      // ),

                      //FURTHER IMPLEMENTATION
                    ],
                  );
                } else {
                  return Center();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
