import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/bottomBarModel/congratsModel.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;
import 'package:video_player/video_player.dart';
import 'package:dospace/dospace.dart' as dospace;

class UploadShotMemes extends StatefulWidget {
  final String type;
  final String uid;

  UploadShotMemes({required this.type, required this.uid});

  @override
  _UploadShotMemesState createState() => _UploadShotMemesState();
}

class _UploadShotMemesState extends State<UploadShotMemes> {
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
  int totalSlits = 0;
  int takePart = 0;

  @override
  void initState() {
    super.initState();
    _intAd();
    if (widget.type == "photo" || widget.type == "memeT") imageFromGallery();
  }

  imageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 2500,
      maxWidth: 2500,
    );

    await cropImage(imageFile.path);
  }

  cropImage(filePath) async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 2500,
        maxHeight: 2500,
        androidUiSettings: AndroidUiSettings(
            cropGridRowCount: 4,
            cropGridColumnCount: 4,
            backgroundColor: Colors.white,
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            activeControlsWidgetColor: Colors.pink,
            toolbarWidgetColor: Colors.white,
            showCropGrid: true,
            cropGridStrokeWidth: 2,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedImage != null) {
      file = croppedImage;
      isFile = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: SizedBox(
            height: 0,
            width: 0,
          ),
          centerTitle: true,
          title: Text(
            widget.type == "memeT"
                ? "Share Meme"
                : widget.type == "photo"
                    ? "Share Photo"
                    : widget.type == "videoMeme"
                        ? "Share Video Meme"
                        : "Share Thoughts",
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,

              fontFamily: 'cute',
              fontSize: 16,
            ),
          ),
          elevation: 0.0,
          actions: [
            isTextStatus
                ? Container(
                    height: 100,
                    child: Center(
                      child: TextButton(
                        onPressed: uploading
                            ? null
                            : _isComposing
                                ? () {
                                    controllAndUploadData();
                                  }
                                : null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "Share",
                            style: TextStyle(
                              color: _isComposing
                                  ? Colors.blue.shade900
                                  : Colors.blue.shade100,
                              fontFamily: 'cutes',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    child: TextButton(
                      onPressed: () => {
                        controllAndUploadData(),
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "Upload",
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,

                              fontFamily: 'cute',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        body: statusBody());
  }

  statusBody() {
    if (widget.type == "thoughts") {
      return textStatus();
    } else if (widget.type == "photo" && isFile == true) {
      return photoOrMeme();
    } else if (widget.type == "memeT" && isFile == true) {
      return photoOrMeme();
    }
  }

  textStatus() {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
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
                      fontFamily: 'cutes'
                      // shadows: <Shadow>[
                      //   Shadow(
                      //     offset: Offset(0.5, 0.5),
                      //     blurRadius: 3.0,
                      //     color: Colors.black,
                      //   ),
                      //   Shadow(
                      //     offset: Offset(0.5, 0.5),
                      //     blurRadius: 3.0,
                      //     color: Colors.black,
                      //   ),
                      // ],
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: TextField(
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              keyboardType: TextInputType.multiline,
              controller: _captionText,
              maxLines: 10,
              cursorHeight: 20,
              cursorColor: Colors.grey,
              decoration: InputDecoration.collapsed(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Write Here...',
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'cutes',
                    fontWeight: FontWeight.bold),
              ),
              scrollPadding: EdgeInsets.all(20),
            ),
          ),
          _statusTheme(),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.red,
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  photoOrMeme() {
    return ListView(
      children: [
        uploading
            ? LinearProgressIndicator()
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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.05,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(
                    file!,
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
        widget.type == "memeT" ? Container() : _statusTheme(),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                elevation: 0.0,
                primary: Colors.red,
                textStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  controllAndUploadData() async {
    setState(() {
      uploading = true;
    });

    switchMemeCompRTD
        .child('live')
        .child(widget.uid)
        .once()
        .then((DataSnapshot dataSnapshot) => {
              if (dataSnapshot.exists)
                {
                  Fluttertoast.showToast(
                    msg: "You can post only 1 Meme in Competition",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 10,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 14.0,
                  ),
                  Navigator.pop(context),
                }
              else
                {

                  Fluttertoast.showToast(
                    msg: "Please wait until upload!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 10,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 14.0,
                  ),
                  compressImage(),
                  uploadInDOSpace(file),

                }
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
    switchMemeCompRTD.child('live').child(widget.uid).set({
      'postId': postId,
      'ownerId': user.uid,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      'description': description,
      'url': url,
      'email': Constants.myEmail,
      'type': type,
      'statusTheme': statusTheme,
    });

    switchMemeCompRTD
        .child(widget.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {

        ///Slit is here
        // switchMemerSlitsRTD
        //     .child(widget.uid)
        //     .once()
        //     .then((DataSnapshot dataSnapshot) {
        //   Map data = dataSnapshot.value;
        //   int slits = data['totalSlits'];
        //   setState(() {
        //     slits = slits + 1000;
        //   });
        //   Future.delayed(const Duration(milliseconds: 100), () {
        //     switchMemerSlitsRTD.child(widget.uid).update({
        //       'totalSlits': slits,
        //     });
        //     print("Slitsssssssssssssssssssssssssssssssssssssssss $slits");
        //   });
        // });

        switchMemeCompRTD
            .child(widget.uid)
            .once()
            .then((DataSnapshot dataSnapshot) {
          Map data = dataSnapshot.value;
          int takePart = data['takePart'];
          setState(() {
            takePart = takePart + 1;
          });

          Future.delayed(const Duration(milliseconds: 200), () {
            switchMemeCompRTD.child(widget.uid).update({
              'takePart': takePart,
            });
            print("takepartssssssssssssssssssssssssssssssss $takePart");
          });
        });

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
      } else {

        ///Slit is here
        // switchMemerSlitsRTD.child(widget.uid).set({
        //   'totalSlits': 1000,
        // });

        switchMemeCompRTD.child(widget.uid).set({
          'takePart': 1,
        });
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
    });
  }

  /// Upload in DO via space

  uploadInDOSpace(mImageFile) async {
    dospace.Spaces spaces = new dospace.Spaces(
      //change with your project's region
      region: "nyc3",
      //change with your project's accessKey
      accessKey: 'JWS6WXYZJTISDEQTOT2I',

      secretKey: 'u06l5Az4RTpsWuvmkqgwH2lFAxf3J4Lsch+hrEWgoXQ',
    );

    String projectName = "switchappimages";

    String region = "nyc3";

    String folderName = "posts";

    String fileName =
        "switchapp_image_${DateTime.now().microsecondsSinceEpoch}.jpg";
    print("filename : : : : : : : $fileName");

    String? etag = await spaces.bucket(projectName).uploadFile(
          folderName + '/' + Constants.username + '/' + fileName,
          file,
          'images',
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

  uploadPhoto(mImageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        "UsersPosts/${Constants.myId}/${Constants.myEmail}/$postId/_${DateTime.now()}.mp4/");

    UploadTask uploadTask = ref.putFile(mImageFile);

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

  compressImage() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image? mImageFle = ImD.decodeImage(file!.readAsBytesSync());
    final compressImage = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFle!, quality: 90));
    setState(() {
      file = compressImage;
    });
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

  // This is ad Area for Switch Shot Meme
  ///*****///

  late InterstitialAd _interstitialAd;

  bool _isAdLoaded = false;

  void _intAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-5525086149175557/9017776670",
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
  //       adUnitId: 'ca-app-pub-5525086149175557/9017776670',
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
  //     switchMemeCompRTD
  //         .child('live')
  //         .child(widget.uid)
  //         .once()
  //         .then((DataSnapshot dataSnapshot) => {
  //               if (dataSnapshot.exists)
  //                 {
  //                   Fluttertoast.showToast(
  //                     msg: "You can post only 1 Meme in Competition",
  //                     toastLength: Toast.LENGTH_LONG,
  //                     gravity: ToastGravity.TOP,
  //                     timeInSecForIosWeb: 10,
  //                     backgroundColor: Colors.blue,
  //                     textColor: Colors.white,
  //                     fontSize: 14.0,
  //                   ),
  //                   Navigator.pop(context),
  //                   Navigator.pop(context),
  //                 }
  //               else
  //                 {
  //                   uploadInDOSpace(file),
  //                   _interstitialAd.dispose(),
  //                 }
  //             });
  //   }, onAdFailedToShowFullScreenContent: (ad, error) {
  //     switchMemeCompRTD
  //         .child('live')
  //         .child(widget.uid)
  //         .once()
  //         .then((DataSnapshot dataSnapshot) => {
  //               if (dataSnapshot.exists)
  //                 {
  //                   Fluttertoast.showToast(
  //                     msg: "You can post only 1 Meme in Competition",
  //                     toastLength: Toast.LENGTH_LONG,
  //                     gravity: ToastGravity.TOP,
  //                     timeInSecForIosWeb: 10,
  //                     backgroundColor: Colors.blue,
  //                     textColor: Colors.white,
  //                     fontSize: 14.0,
  //                   ),
  //                   Navigator.pop(context),
  //                   Navigator.pop(context),
  //                 }
  //               else
  //                 {
  //                   uploadInDOSpace(file),
  //                 }
  //             });
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
            height: MediaQuery.of(context).size.height / 1.2,
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
                          fontFamily: "cute",
                           fontWeight: FontWeight.bold,
                          color: Colors.green.shade900),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  ///Slit is here

                  // CongratsForSlits(
                  //   text: "You earn 1000 slits",
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if(_isAdLoaded){

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
                          "Where to find my uploaded MEME?",
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
