// // ignore: import_of_legacy_library_into_null_safe
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:switchapp/Models/Constans.dart';
// import 'package:switchapp/UniversalResources/DataBaseRefrences.dart';
// import 'package:uuid/uuid.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoStatus extends StatefulWidget {
//   final String type;
//   final String uid;
//
//   const VideoStatus({required this.type, required this.uid});
//
//   @override
//   _VideoStatusState createState() => _VideoStatusState();
// }
//
// class _VideoStatusState extends State<VideoStatus> {
//   String videoUrl = "";
//   bool? isUploaded = false;
//   bool? isUploading = false;
//
//   String postId = Uuid().v4();
//
//   ui() {
//     if (isUploaded!) {
//       return Center(
//         child: Container(
//           child: SingleChildScrollView(
//             reverse: true,
//             child: Column(
//               children: [
//                 Text("This is Uploaded video"),
//                 // Container(
//                 //   child: VideoWidget(play: true, url: videoUrl),
//                 // ),
//                 GestureDetector(
//                   onTap: () => {
//                     uploadToFireBase(),
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Upload"),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Center(
//         child: Container(
//           child: Column(
//             children: [
//               isUploading! ? LinearProgressIndicator() : Text(""),
//               Text("Upload video")
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ui(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           uploadToStorage();
//         },
//         backgroundColor: Colors.transparent,
//         child: Icon(
//           Icons.add,
//           size: 40,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   final picker = ImagePicker();
//   File? file;
//
//   Future uploadToStorage() async {
//     setState(() {
//       isUploading = true;
//     });
//     try {
//       PickedFile pickedFile =
//           await picker.getVideo(source: ImageSource.gallery);
//       file = File(pickedFile.path);
//
//       FirebaseStorage storage = FirebaseStorage.instance;
//       String? url;
//       Reference ref = storage.ref().child("UsersPosts/${Constants.myId}/${Constants.myEmail}/_$postId.mp4");
//       UploadTask uploadTask = ref.putFile(file!);
//       uploadTask.whenComplete(() {
//         videoUrl = ref.getDownloadURL() as String;
//       });
//
//
//
//       setState(() {
//         isUploaded = true;
//         isUploading = false;
//       });
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   @override
//   void initState() {}
//
//   void uploadToFireBase() {
//     print("upload");
//     final user = Provider.of<User>(context, listen: false);
//
//     postsRtd.child(user.uid).child("usersPost").child(postId).set({
//       'postId': postId,
//       'ownerId': user.uid,
//       "timestamp": DateTime.now().toIso8601String(),
//       'description': "description",
//       'url': videoUrl,
//       'email': Constants.myEmail,
//       'type': widget.type,
//       'statusTheme': "",
//     });
//   }
// }
//
//
