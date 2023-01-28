// import 'dart:math';
// import 'package:intl/intl.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:switchapp/Universal/Constans.dart';
// import 'package:time_formatter/time_formatter.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoWidget extends StatefulWidget {
//   final String url;
//   final bool play;
//   final time;
//
//   const VideoWidget(
//       {Key? key, required this.url, required this.play, required this.time})
//       : super(key: key);
//
//   @override
//   _VideoWidgetState createState() => _VideoWidgetState();
// }
//
// class _VideoWidgetState extends State<VideoWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool isHide = true;
//   late DateTime dt1;
//   late DateTime dt2 = DateTime.parse("2023-01-01");
//
//   @override
//   void initState() {
//     var dt = DateTime.fromMillisecondsSinceEpoch(widget.time);
//     var date = DateFormat('yyyy-MM-dd').format(dt); // 12/31/2000, 10:00 PM
//     dt1 = DateTime.parse(date);
//     super.initState();
//     if (dt1.isBefore(dt2)) {
//       _controller = VideoPlayerController.network(
//         Constants.switchDemoVideo,
//       );
//     } else {
//       _controller = VideoPlayerController.network(
//         widget.url,
//       );
//     }
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//
//       setState(() {});
//     });
//
//     if (widget.play) {
//       _controller.play();
//       _controller.setLooping(false);
//     }
//   }
//
//   @override
//   void didUpdateWidget(VideoWidget oldWidget) {
//     if (oldWidget.play != widget.play) {
//       if (widget.play) {
//         _controller.play();
//         _controller.setLooping(false);
//       } else {
//         _controller.pause();
//       }
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void dispose() {
//     _controller.setVolume(0);
//     _controller.pause();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: FutureBuilder(
//           future: _initializeVideoPlayerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return SizedBox.expand(
//                 child: Stack(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                       child: Center(
//                         child: FittedBox(
//                           fit: BoxFit.fill,
//                           child: SizedBox(
//                             width: _controller.value.size.width,
//                             height: _controller.value.size.height,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(15.0),
//                               child: GestureDetector(
//                                 onTap: () => {
//                                   if (isHide)
//                                     {
//                                       setState(() {
//                                         isHide = false;
//                                       }),
//                                     }
//                                   else
//                                     {
//                                       isHide = true,
//                                     },
//                                   setState(() {
//                                     _controller.value.isPlaying
//                                         ? _controller.pause()
//                                         : _controller.play();
//                                   }),
//                                 },
//                                 child: Stack(
//                                   children: [
//                                     VideoPlayer(
//                                       _controller,
//                                     ),
//                                     Positioned(
//                                       bottom: 0.0,
//                                       right: 0.0,
//                                       top: 0.0,
//                                       left: 0.0,
//                                       child: Container(
//                                         padding: EdgeInsets.all(5),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               child: Center(
//                                                 child: Icon(
//                                                   _controller.value.isPlaying
//                                                       ? Icons.pause
//                                                       : Icons.play_arrow,
//                                                   color: isHide
//                                                       ? Colors.white
//                                                       : Colors.transparent,
//                                                   size: 40,
//                                                 ),
//                                               ),
//                                               decoration: BoxDecoration(
//                                                   color: isHide
//                                                       ? Colors.black54
//                                                       : Colors.transparent,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20)),
//                                               height: 60,
//                                               width: 60,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 6.0,
//                       right: 10.0,
//                       child: Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ValueListenableBuilder(
//                           valueListenable: _controller,
//                           builder: (context, VideoPlayerValue value, child) {
//                             final noMute = (_controller.value.volume) > 0;
//
//                             return GestureDetector(
//                               onTap: () => {
//                                 if (noMute)
//                                   {
//                                     _controller.setVolume(0),
//                                   }
//                                 else
//                                   {
//                                     _controller.setVolume(1.0),
//                                   }
//                               },
//                               child: Icon(
//                                 !noMute ? Icons.volume_off : Icons.volume_down,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 5.0,
//                       left: 8.0,
//                       child: Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ValueListenableBuilder(
//                           valueListenable: _controller,
//                           builder: (context, VideoPlayerValue value, child) {
//                             final remained = max(
//                                 0,
//                                 value.duration.inSeconds -
//                                     value.position.inSeconds);
//                             final minutes = convertTwo(remained ~/ 60);
//                             final seconds = convertTwo(remained % 60);
//
//                             return Text(
//                               "$minutes:$seconds",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Center(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(
//                       Icons.slow_motion_video,
//                       size: 60,
//                       color: Colors.lightBlue.shade400,
//                     ),
//                   ),
//                   SpinKitThreeBounce(
//                     color: Colors.lightBlue.shade400,
//                     size: 20,
//                   ),
//                 ],
//               ));
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   String convertTwo(int value) {
//     return value < 10 ? "0$value" : "$value";
//   }
// }



import 'dart:math';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final bool play;
  final time;

  const VideoWidget(
      {Key? key, required this.url, required this.play, required this.time})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late Future<void> _initializeVideoPlayerFuture;
  bool isHide = true;
  late DateTime dt1;
  late DateTime dt2 = DateTime.parse("2023-01-01");
  late CachedVideoPlayerController _controller;
  @override
  void initState() {
    var dt = DateTime.fromMillisecondsSinceEpoch(widget.time);
    var date = DateFormat('yyyy-MM-dd').format(dt); // 12/31/2000, 10:00 PM
    dt1 = DateTime.parse(date);
    super.initState();
    if (dt1.isBefore(dt2)) {
      _controller = CachedVideoPlayerController.network(
        Constants.switchDemoVideo,
      );
    } else {
      _controller = CachedVideoPlayerController.network(
        widget.url,
      );
      _controller = CachedVideoPlayerController.network(
          widget.url);
    }

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });


    if (widget.play) {
      _controller.play();
      _controller.setLooping(false);
    }
  }

  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(false);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.setVolume(0);
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox.expand(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: GestureDetector(
                                onTap: () => {
                                  if (isHide)
                                    {
                                      setState(() {
                                        isHide = false;
                                      }),
                                    }
                                  else
                                    {
                                      isHide = true,
                                    },
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  }),
                                },
                                child: Stack(
                                  children: [
                                    CachedVideoPlayer(
                                      _controller,
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      right: 0.0,
                                      top: 0.0,
                                      left: 0.0,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Center(
                                                child: Icon(
                                                  _controller.value.isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: isHide
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                  size: 40,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: isHide
                                                      ? Colors.black54
                                                      : Colors.transparent,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20)),
                                              height: 60,
                                              width: 60,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6.0,
                      right: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ValueListenableBuilder<dynamic>(
                          valueListenable: _controller,
                          builder: (context, dynamic, child) {
                            final noMute = (_controller.value.volume) > 0;

                            return GestureDetector(
                              onTap: () => {
                                if (noMute)
                                  {
                                    _controller.setVolume(0),
                                  }
                                else
                                  {
                                    _controller.setVolume(1.0),
                                  }
                              },
                              child: Icon(
                                !noMute ? Icons.volume_off : Icons.volume_down,
                                color: Colors.white,
                                size: 16,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      left: 8.0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ValueListenableBuilder<dynamic>(
                          valueListenable: _controller,
                          builder: (context, dynamic, child) {
                            final remained = max<int>(
                                0,
                                dynamic.duration.inSeconds -
                                    dynamic.position.inSeconds);
                            final minutes = convertTwo(remained ~/ 60);
                            final seconds = convertTwo(remained % 60);

                            return Text(
                              "$minutes:$seconds",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.slow_motion_video,
                          size: 60,
                          color: Colors.lightBlue.shade400,
                        ),
                      ),
                      SpinKitThreeBounce(
                        color: Colors.lightBlue.shade400,
                        size: 20,
                      ),
                    ],
                  ));
            }
          },
        ),
      ),
    );
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }
}
