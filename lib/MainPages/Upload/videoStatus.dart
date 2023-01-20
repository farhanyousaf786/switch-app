import 'dart:io';
import 'package:dospace/dospace.dart' as dospace;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class VideoStatus extends StatefulWidget {
  final String type;
  final User user;

  const VideoStatus({required this.type, required this.user});

  @override
  _VideoStatusState createState() => _VideoStatusState();
}

class _VideoStatusState extends State<VideoStatus> {
  late VideoPlayerController _controller;
  File? file;
  bool isFile = false;
  bool uploading = false;
  String postId = Uuid().v4();
  bool isTextStatus = false;
  bool _isComposing = false;
  String isMeme = "false";
  String isAdvice = "false";
  String isLifeExperience = "false";
  String doubleSlitShow = "false";
  String statusTheme = "status";
  TextEditingController _captionText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _intAd();
    pickVideo();
  }

  pickVideo() async {
    File videoFile = await ImagePicker.pickVideo(
      source: ImageSource.gallery,
    );

    _controller = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        print("position::::" + "${_controller.value.duration}");

        if (_controller.value.duration > Duration(seconds: 60)) {
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
                                Icon(Icons.linear_scale_sharp,
                                  color: Colors.white,),
                              ],
                            ),
                          ),
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Video Duration Must be less then 60 Seconds",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "cutes",
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: Provider<User>.value(
                                    value: widget.user,
                                    child: VideoStatus(
                                      type: "simpleVideo",
                                      user: widget.user,
                                    ),
                                  ),
                                ));
                          },
                          child: Center(
                              child: Column(
                            children: [
                              Text(
                                "Upload New Video",
                                style: TextStyle(
                                    fontFamily: 'cutes',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.blue),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.slow_motion_video_sharp,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else {
          setState(() {
            file = videoFile;
            isFile = true;
          });
        }
      });
  }

  controllAndUploadData() async {
    setState(() {
      uploading = true;
    });
    Fluttertoast.showToast(
      msg: "Please wait until upload!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 14.0,
    );
    uploadViaDoSpace(file);
  }

  /// DO AK: JWS6WXYZJTISDEQTOT2I
  /// DO SK: u06l5Az4RTpsWuvmkqgwH2lFAxf3J4Lsch+hrEWgoXQ
  /// PAKT: 43d68ef89a1247f93ea454eb30f3d7a915900acae0915e34d220fec81a2daf90
  ///  ep: nyc3.digitaloceanspaces.com
  ///
  /// WASABAI EP:  s3.wasabisys.com
  ///  accessKey: '0R2UZA8CI7Q83OUAGPTV',
  ///  secretKey: '1T2PhWnnYRfeZscRkbTMTu7Bn9Ywm8jw4pSrlH0B',

  /// Upload Via DoSpace

  uploadViaDoSpace(file) async {
    dospace.Spaces spaces = new dospace.Spaces(
      //change with your project's region
      region: "nyc3",
      //change with your project's accessKey
      accessKey: 'JWS6WXYZJTISDEQTOT2I',

      secretKey: 'u06l5Az4RTpsWuvmkqgwH2lFAxf3J4Lsch+hrEWgoXQ',
    );

    String projectName = "switchappvideos";

    String region = "nyc3";

    String folderName = "posts";

    String fileName =
        "switchapp_videomeme_${DateTime.now().microsecondsSinceEpoch}.mp4";

    print("filename : : : : : : : $fileName");
    String? etag = await spaces.bucket(projectName).uploadFile(
          folderName + '/' + Constants.username + '/' + fileName,
          file,
          'videos',
          dospace.Permissions.public,
        );

    print('upload: $etag');

    String url = "https://" +
        projectName +
        "." +
        region +
        ".digitaloceanspaces.com/" +
        folderName +
        '/' +
        Constants.username +
        "/" +
        fileName;

    print('--- presigned url:');

    print(url);

    savePostInfoToFirebase(
      type: widget.type,
      url: url,
      description: _captionText.text,
    );
    _captionText.clear();
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
      isFile = false;
    });
  }

  uploadVideo(videoFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        "UsersPosts/${Constants.myId}/${Constants.myEmail}/$postId/_${DateTime.now()}.mp4/");

    UploadTask uploadTask = ref.putFile(videoFile);

    uploadTask.whenComplete(() async {
      String uploadUrl = await ref.getDownloadURL();
      savePostInfoToFirebase(
        type: widget.type,
        url: uploadUrl,
        description: _captionText.text,
      );
      _captionText.clear();
      setState(() {
        file = null;
        uploading = false;
        postId = Uuid().v4();
        isFile = false;
      });
    });
  }

  savePostInfoToFirebase({
    required String description,
    required String url,
    required String type,
  }) {
    final user = Provider.of<User>(context, listen: false);

    postsRtd.child(user.uid).child("usersPost").child(postId).set({
      'postId': postId,
      'ownerId': user.uid,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      'description': description,
      'url': url,
      'email': Constants.myEmail,
      'type': type,
      'statusTheme': statusTheme,
    });

    switchAllUserFeedPostsRTD.child("UserPosts").child(postId).set({
      'postId': postId,
      'ownerId': user.uid,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      'description': description,
      'url': url,
      'email': Constants.myEmail,
      'type': type,
      'statusTheme': statusTheme,
    });

    ///Slit is here
    // if (widget.type == 'meme' || widget.type == "videoMeme") {
    //   switchMemerSlitsRTD
    //       .child(widget.user.uid)
    //       .once()
    //       .then((DataSnapshot dataSnapshot) {
    //     Map data = dataSnapshot.value;
    //     int slits = data['totalSlits'];
    //     setState(() {
    //       slits = slits + 20;
    //     });
    //     Future.delayed(const Duration(milliseconds: 100), () {
    //       switchMemerSlitsRTD.child(widget.user.uid).update({
    //         'totalSlits': slits,
    //       });
    //       print("Slitsssssssssssssssssssssssssssssssssssssssss $slits");
    //     });
    //   });
    // } else {}

    Future.delayed(const Duration(milliseconds: 300), () {
      isMeme = "false";
      isAdvice = "false";
      isLifeExperience = "false";
      doubleSlitShow = "false";
      statusTheme = "";

      Fluttertoast.showToast(
        msg: "Uploaded Successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      updateSuccessful();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _statusTheme() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
      child: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (isMeme == "true") {
                    setState(() {
                      isMeme = "false";
                    });
                  } else {
                    setState(() {
                      isMeme = "true";
                      isLifeExperience = "false";
                      isAdvice = 'false';
                      doubleSlitShow = 'false';
                      statusTheme = 'Meme';
                    });
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3, right: 5),
                      child: Icon(
                        isMeme == "false"
                            ? Icons.check_circle_outline
                            : Icons.check_circle,
                        size: 18,
                        color: isMeme == "false" ? Colors.grey : Colors.blue,
                      ),
                    ),
                    Text(
                      "Meme",
                      style: TextStyle(
                          color: Colors.blue, fontFamily: 'cute', fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (isLifeExperience == "true") {
                    setState(() {
                      isLifeExperience = "false";
                    });
                  } else {
                    setState(() {
                      isLifeExperience = "true";
                      isMeme = 'false';
                      doubleSlitShow = 'false';
                      isAdvice = 'false';
                      statusTheme = 'Life Experience';
                    });
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3, right: 5),
                      child: Icon(
                        isLifeExperience == "false"
                            ? Icons.check_circle_outline
                            : Icons.check_circle,
                        size: 18,
                        color: isLifeExperience == "false"
                            ? Colors.grey
                            : Colors.blue,
                      ),
                    ),
                    Text(
                      "Life Experience",
                      style: TextStyle(
                          color: Colors.blue, fontFamily: 'cute', fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (isAdvice == "true") {
                    setState(() {
                      isAdvice = "false";
                    });
                  } else {
                    setState(() {
                      isAdvice = "true";
                      isMeme = 'false';
                      isLifeExperience = 'false';
                      doubleSlitShow = 'false';
                      statusTheme = 'Advice';
                    });
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3, right: 5),
                      child: Icon(
                        isAdvice == "false"
                            ? Icons.check_circle_outline
                            : Icons.check_circle,
                        size: 18,
                        color: isAdvice == "false" ? Colors.grey : Colors.blue,
                      ),
                    ),
                    Text(
                      "Advice",
                      style: TextStyle(
                          color: Colors.blue, fontFamily: 'cute', fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (doubleSlitShow == "true") {
                    setState(() {
                      doubleSlitShow = "false";
                    });
                  } else {
                    setState(() {
                      doubleSlitShow = "true";
                      isMeme = "false";
                      isLifeExperience = "false";
                      statusTheme = 'Double Slit';
                      isAdvice = 'false';
                    });
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3, right: 5),
                      child: Icon(
                        doubleSlitShow == "false"
                            ? Icons.check_circle_outline
                            : Icons.check_circle,
                        size: 18,
                        color: doubleSlitShow == "false"
                            ? Colors.grey
                            : Colors.blue,
                      ),
                    ),
                    Text(
                      "Double Slit Show",
                      style: TextStyle(
                          color: Colors.blue, fontFamily: 'cute', fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ui();
  }

  Widget _ui() {
    if (isFile == false) {
      return Scaffold();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () => {
                controllAndUploadData(),
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Shares",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'cute',
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Upload Video",
            style: TextStyle(color: Colors.blue, fontFamily: 'cute'),
          ),
        ),
        body: ListView(
          children: [
            uploading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                                child: Text(
                              "Please wait, until uploading..",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontFamily: 'cutes'),
                            )),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CircleAvatar(
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(Constants.myPhotoUrl),
                      ),
                      radius: 23.5,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  Text(
                    "  " + Constants.myName + " " + Constants.mySecondName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'cutes'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Center(
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _captionText,
                  onChanged: (String text) {
                    setState(() {
                      _isComposing = text.length > 0;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  cursorHeight: 20,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration.collapsed(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Write Here...',
                    hintStyle: TextStyle(
                      fontFamily: 'cutes',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  scrollPadding: EdgeInsets.all(20),
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            _statusTheme()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      );
    }
  }

  // This is ad Area for Switch Shot Meme
  ///*****///

  late InterstitialAd _interstitialAd;

  bool _isAdLoaded = false;

  void _intAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-5525086149175557/6560478222",
        // adUnitId: "ca-app-pub-5525086149175557/7307056443",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded, onAdFailedToLoad: (error) {}));
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _isAdLoaded = true;
  }

  // late InterstitialAd _interstitialAd;
  // bool _isLoaded = false;
  //
  // void _initAd() {
  //   InterstitialAd.load(
  //       adUnitId: "ca-app-pub-5525086149175557/6560478222",
  //       request: AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //           onAdLoaded: onAdLoaded, onAdFailedToLoad: (error) {}));
  // }
  //
  // void onAdLoaded(InterstitialAd ad) {
  //   _interstitialAd = ad;
  //   _isLoaded = true;
  //
  //   _interstitialAd.fullScreenContentCallback =
  //       FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
  //     uploadViaDoSpace(file);
  //
  //     _interstitialAd.dispose();
  //   }, onAdFailedToShowFullScreenContent: (ad, error) {
  //     uploadViaDoSpace(file);
  //   });
  // }
  updateSuccessful() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: false,
        isDismissible: false,
        enableDrag: false,
        barrierColor: Colors.blue.withOpacity(0.5),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          Icon(Icons.linear_scale_sharp,
                            color: Colors.white,),
                        ],
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Upload Successful!",
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ///Slit is here
                  // widget.type == "meme" || widget.type == "videoMeme"
                  //     ? CongratsForSlits(
                  //         text: "You earn 20 slits",
                  //       )
                  //     : Container(
                  //         height: 0,
                  //         width: 0,
                  //       ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_isAdLoaded) {
                          _interstitialAd.show();
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.shade400,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Go Back",
                                  style: TextStyle(
                                      fontFamily: 'cute',
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.fiber_smart_record_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 5, top: 5),
                    child: Row(
                      children: [
                        Container(
                            child: Flexible(
                                child: Text(
                          "Where to find my uploaded MEME(Shot/Flick)?",
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'cute',
                              fontSize: 17),
                        ))),
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
                              "Your uploaded Memes are in Meme Profile. Open App > Click on Meme on bottom bar > There will be two options at the bottom (One for Flick Meme / One for Shot Meme).",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontFamily: 'cutes',
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 5, top: 5),
                    child: Row(
                      children: [
                        Container(
                            child: Flexible(
                                child: Text(
                          "Where to find my uploaded Thoughts and Photo?",
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'cute',
                              fontSize: 17),
                        ))),
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
                              "Open App > Click on your profile on top left corner > Slide up.",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontFamily: 'cutes',
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
