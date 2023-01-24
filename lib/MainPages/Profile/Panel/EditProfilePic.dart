//
//
// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// class EditProfilePic extends StatefulWidget {
//
//   final String imgUrl;
//   final String uid;
//   final String profilerUrl;
//
//   const EditProfilePic({Key key, this.imgUrl, this.uid, this.profilerUrl}) : super(key: key);
//   @override
//   _EditProfilePicState createState() => _EditProfilePicState();
// }
//
// class _EditProfilePicState extends State<EditProfilePic> {
//
//   takeImage(mContext) {
//     return showDialog(
//         context: mContext,
//         builder: (context) {
//           return SimpleDialog(
//             backgroundColor: Colors.white,
//             title: Text(
//               "Take Photo",
//               style: TextStyle(color: Colors.blue),
//             ),
//             children: [
//               SimpleDialogOption(
//                 child: Text(
//                   "Camera",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontFamily: "Cutes",
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 onPressed: pickImageFromCamera,
//               ),
//               SimpleDialogOption(
//                 child: Text(
//                   "Gallery",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontFamily: "Cutes",
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 onPressed: imageFromGallery,
//               ),
//             ],
//           );
//         });
//   }
//   File file;
//   pickImageFromCamera() async {
//     File imageFile = await ImagePicker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 100,
//       maxHeight: 680,
//       maxWidth: 950,
//     );
//     setState(() {
//       file = imageFile;
//     });
//     cropImage(imageFile.path);
//   }
//
//   imageFromGallery() async {
//     File imageFile = await ImagePicker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 100,
//       maxHeight: 2500,
//       maxWidth: 2500,
//     );
//
//     cropImage(imageFile.path);
//   }
//
//   cropImage(filePath) async {
//     File croppedImage = await ImageCropper.cropImage(
//         sourcePath: filePath,
//         maxWidth: 2500,
//         maxHeight: 2500,
//         androidUiSettings: AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.blue,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         iosUiSettings: IOSUiSettings(
//           minimumAspectRatio: 1.0,
//         ));
//     if (croppedImage != null) {
//       file = croppedImage;
//       Navigator.pop(context);
//
//       setState(() {});
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return              Stack(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.blue.shade900,
//             child: CircleAvatar(
//
//               radius: 58,
//
//               child: Container(
//                 height: 150,
//                 width: 150,
//                 child: ClipOval(
//                   child: Image(
//                     image: CachedNetworkImageProvider(
//                         widget.profilerUrl),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 80, top: 90),
//           child: Container(
//             width: 35,
//             height: 35,
//             child: FloatingActionButton(
//               backgroundColor: Colors.blue.shade300,
//               child: Icon(
//                 Icons.camera_alt,
//                 size: 20,
//               ),
//               // onPressed: () => takeImage(context),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:image/image.dart' as ImD;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';


class EditProfilePic extends StatefulWidget {
  final String imgUrl;
  final String uid;

  EditProfilePic({required this.imgUrl,required this.uid,})
  ;
  final DateTime timestamp = DateTime.now();

  @override
  _EditProfilePicState createState() => _EditProfilePicState();
}

class _EditProfilePicState extends State<EditProfilePic> {
  File? file;
  bool uploading = false;
  String postId = Uuid().v4();
  late String gender;

  displayUploadScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.lightBlue,
        leading: Center(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          "Profile Picture",
          style:
          TextStyle(
               fontWeight: FontWeight.bold,

              color: Colors.white, fontFamily: "Cute", fontSize: 16),
        ),
        actions: [],
      ),
      body: Container(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select Your Beautiful Picture",
                    style: TextStyle(
                         fontWeight: FontWeight.bold,
                        color: Colors.white, fontFamily: "Cute", fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                      radius: 53,
                      backgroundColor: Colors.black12,
                      backgroundImage: NetworkImage(widget.imgUrl)),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleDialogOption(
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Cute",
                             fontWeight: FontWeight.bold,

                            fontSize: 20),
                      ),
                      onPressed: imageFromGallery,
                    ),
                    SimpleDialogOption(
                      child: Text(
                        "Camera",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Cute",
                             fontWeight: FontWeight.bold,

                            fontSize: 20),
                      ),
                      onPressed: pickImageFromCamera,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void  pickImageFromCamera() async {
    // final ImagePicker _picker = ImagePicker();

    final File? pickedFile = await ImagePicker.pickImage(source: ImageSource.camera,  imageQuality: 100,
        maxHeight: 680,
        maxWidth: 95);




    cropImage(pickedFile?.path);
  }

  void imageFromGallery() async {

    final File? pickedFile = await ImagePicker.pickImage(      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 2500,
      maxWidth: 2500,);

    cropImage(pickedFile?.path);

  }

  void cropImage(filePath) async {
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

      setState(() {});
    }
  }



  displayUploadFromScreen() {
    return DelayedDisplay(
      delay: Duration(seconds: 1),
      slidingBeginOffset: Offset(0.0, -1),
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.lightBlue,
          leading: Center(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () => {
                Navigator.pop(context),
              },
            ),
          ),
          centerTitle: true,
          title: Text(
            "Profile Picture",
            style: TextStyle(
                color: Colors.white,                                  fontWeight: FontWeight.bold,

                fontFamily: "Cute", fontSize: 16),
          ),
          actions: [],
        ),
        body: Container(
          color: Colors.lightBlue,
          child: ListView(
            children: [
              uploading ? LinearProgressIndicator() : Container(height: 0,width: 0,),
              Container(
                padding: EdgeInsets.all(30),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 55,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: FileImage(file!), //NetworkImage
                    radius: 53,
                  ), //CircleAvatar
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Press Done If This Is Good For You",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Cute",
                         fontWeight: FontWeight.bold,

                        fontSize: 10),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                         fontWeight: FontWeight.bold,
                        color: Colors.white, fontFamily: "Cute", fontSize: 15),
                  ),
                  onPressed: () => controlUpload(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  controlUpload() async {
    setState(() {
      uploading = true;
    });

    uploadPhoto(file);

  }

  savePostInfoToFirebase({
    required String url,
  }) async {
    // usersReference.doc(widget.uid).update({
    //   'url': url,
    // });
    userRefRTD.child(widget.uid).update({
      'url': url,
      'postId': postId,
    });

    userRefForSearchRtd.child(widget.uid).update({

      'url': url,

    });

  }

  uploadPhoto(mImageFile) async {

    FirebaseStorage storage = FirebaseStorage.instance;
    String? url;
    Reference ref = storage.ref().child("ProfilePictures/${widget.uid}/${Constants.myEmail}/_$postId.jpg/");

    UploadTask uploadTask = ref.putFile(mImageFile);

    uploadTask.whenComplete(() async {

      String uploadUrl = await ref.getDownloadURL();
      savePostInfoToFirebase(
        url: uploadUrl,
      );
      setState(() {
        uploading = false;
        postId = Uuid().v4();

        Navigator.pop(context);
      });

    });



  }


  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayUploadScreen(context)
        : displayUploadFromScreen();
  }
}
