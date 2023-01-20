/*
 *This class will set our profile picture
 * moreover, user is able to skip that page
 */

import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as ImD;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:switchapp/Authentication/welcomePage/welcomepage.dart';
import 'package:uuid/uuid.dart';
import '../../Universal/DataBaseRefrences.dart';

class SetProfilePicture extends StatefulWidget {
  SetProfilePicture(
      {required this.user, required this.email, required this.users});

  final String? user;
  final String? email;
  final User users;

  @override
  _SetProfilePictureState createState() => _SetProfilePictureState();
}

class _SetProfilePictureState extends State<SetProfilePicture> {

  File? file;
  bool uploading = false;
  String postId = Uuid().v4();
  String gender = "";
  bool isMale = false;
  bool isFemale = false;
  bool others = false;
  TextEditingController about = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return file != null
        ? afterGettingImage()
        : beforeGettingImage(context);
  }

  beforeGettingImage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Profile Picture",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "Cute", fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select Your Beautiful Picture",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "Cute", fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        radius: 73,
                        backgroundColor: Colors.blue.shade900,
                        child: CircleAvatar(
                          radius: 70,
                          child: Container(
                            height: 150,
                            width: 150,
                            child: ClipOval(
                              child: Image(
                                image: AssetImage('images/logo.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 110, top: 100),
                      child: Container(
                        width: 35,
                        height: 35,
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue.shade300,
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                          ),
                          onPressed: () => takeImage(context),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WelcomePage(user: widget.users)),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DelayedDisplay(
                        delay: Duration(milliseconds: 300),
                        slidingBeginOffset: Offset(0.0, -1),
                        child: Center(
                          child: Text(
                            "Skip for later",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Cute",
                                fontSize: 16),
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
      ),
    );
  }

  afterGettingImage() {
    return DelayedDisplay(
      delay: Duration(seconds: 1),
      slidingBeginOffset: Offset(0.0, -1),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.lightBlue,
          leading: Center(
            child: Text(""),
          ),
          centerTitle: true,
          title: Text(
            "Profile Picture",
            style: TextStyle(
                color: Colors.white, fontFamily: "Cute", fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              child: Text(
                'Next',
                style: TextStyle(
                  fontFamily: "Cute",
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                controlAndUploadData();
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.lightBlue,
                  textStyle:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Container(
          color: Colors.lightBlue,
          child: ListView(
            children: [
              uploading
                  ? LinearProgressIndicator()
                  : Container(
                height: 0,
                width: 0,
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade700,
                  radius: 55,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade700,
                    backgroundImage: FileImage(file!), //NetworkImage
                    radius: 53,
                  ), //CircleAvatar
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Don't worry You Can change Your Profile Later",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "Cute", fontSize: 12),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DelayedDisplay(
                delay: Duration(seconds: 1),
                slidingBeginOffset: Offset(0.0, -1),
                child: Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
                  child: TextField(
                    maxLength: 50,
                    style: TextStyle(
                        color: Colors.blue.shade900, fontFamily: 'cute'),
                    controller: about,
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: new BorderSide(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: new BorderSide(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      labelText: ' About Yourself',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: "Cute",
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              DelayedDisplay(
                delay: Duration(seconds: 1),
                slidingBeginOffset: Offset(0.0, -1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      child: Text(
                        "Gender",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Cute",
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        // color: isMale ? Colors.blue.shade800 : Colors.white,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(15.0),
                        //     side: BorderSide(
                        //       color: Colors.blue,
                        //     )),
                        onPressed: () {
                          setState(() {
                            isMale = true;
                            isFemale = false;
                            others = false;
                            gender = "Male";
                          });
                        },
                        child: Text(
                          "Male",
                          style: TextStyle(
                              color: Colors.blue.shade300,
                              fontFamily: "Cute",
                              fontSize: 12),
                        )),
                    ElevatedButton(
                        // color: isFemale ? Colors.blue.shade800 : Colors.white,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(15.0),
                        //     side: BorderSide(
                        //       color: Colors.blue,
                        //     )),
                        onPressed: () {
                          setState(() {
                            isFemale = true;
                            isMale = false;
                            others = false;
                            gender = "Female";
                          });
                        },
                        child: Text(
                          "Female",
                          style: TextStyle(
                              color: Colors.blue.shade300,
                              fontFamily: "Cute",
                              fontSize: 12),
                        )),
                    ElevatedButton(
                        // color: others ? Colors.blue.shade800 : Colors.white,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(15.0),
                        //     side: BorderSide(
                        //       color: Colors.blue,
                        //     )),
                        onPressed: () {
                          setState(() {
                            others = true;
                            isFemale = false;
                            isMale = false;
                            gender = "Others";
                          });
                        },
                        child: Text(
                          "Others",
                          style: TextStyle(
                              color: Colors.blue.shade300,
                              fontFamily: "Cute",
                              fontSize: 12),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DelayedDisplay(
                    delay: Duration(seconds: 1),
                    slidingBeginOffset: Offset(0.0, -1),
                    child: Center(
                      child: Text(
                        "2 of 2 Steps",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Cute",
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WelcomePage(
                          user: widget.users,
                        )),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DelayedDisplay(
                      delay: Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0.0, -1),
                      child: Center(
                        child: Text(
                          "Skip for later",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Cute",
                              fontSize: 16),
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
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Take Photo",
              style: TextStyle(color: Colors.blue),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Camera",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: "Cute",
                  ),
                ),
                onPressed: pickImageFromCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Gallery",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: "Cute",
                  ),
                ),
                onPressed: imageFromGallery,
              ),
            ],
          );
        });
  }

  pickImageFromCamera() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxHeight: 680,
      maxWidth: 950,
    );
    setState(() {
      file = imageFile;
    });
    cropImage(imageFile.path);
  }

  imageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 2500,
      maxWidth: 2500,
    );
    cropImage(imageFile.path);
  }

  cropImage(filePath) async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 2500,
        maxHeight: 2500,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedImage != null) {
      file = croppedImage;

      Navigator.pop(context);

      setState(() {});
    }
  }


  controlAndUploadData() async {
    if (gender == "") {
      Fluttertoast.showToast(
        msg: "Select Gender",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.white,
        textColor: Colors.blue,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        uploading = true;
      });
      await compressImage();

      uploadPhoto(file);
    }
  }

  savePostInfoToFirebase({required String url, required String about}) async {
    // usersReference.doc(widget.user).update({
    //   'postId': postId,
    //   'ownerId': widget.user,
    //   'url': url,
    //   'about': about == "" ? "About is Not Set Yet" : about,
    //   'gender': gender,
    //   'inRelationship': "false",
    // });
    userRefRTD.child(widget.user!).update({
      'postId': postId,
      'ownerId': widget.user,
      'inRelationship': "false",
      'url': url,
      'about': about == "" ? "About is Not Set Yet" : about,
      'gender': gender,
    });
    userRefForSearchRtd.child(widget.user!).update({'url': url});
  }

  uploadPhoto(mImageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("ProfilePictures/${widget.user}/${widget.email}/_$postId.jpg/");
    UploadTask uploadTask = ref.putFile(mImageFile);
    uploadTask.whenComplete(() async {
      String uploadUrl = await ref.getDownloadURL();
      savePostInfoToFirebase(
        url: uploadUrl,
        about: about.text,
      );
      setState(() {
        about.clear();
        uploading = false;
        postId = Uuid().v4();
        File? file;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomePage(
                    user: widget.users,
                  )),
          (Route<dynamic> route) => false,
        );
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


}
