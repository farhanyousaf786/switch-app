// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:switchapp/MainPages/switchChat/SwitchChatComposer.dart';
// import 'package:switchapp/Models/Constans.dart';
// import 'package:switchapp/UniversalResources/DataBaseRefrences.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// final GlobalKey<ScaffoldState> _scaffoldKeyForImagePicker =
//     GlobalKey<ScaffoldState>();
//
// class SendQuickGalleryMessage extends StatefulWidget {
//   SendQuickGalleryMessage(
//       {
//         required   this.receiverAvatar,
//         required   this.receiverId,
//         required   this.receiverName,
//         required   this.receiverEmail,
//         required   this.myId,
//         required   this.groupChatId});
//
//   // final BaseAuth auth;
//   // final VoidCallback onSignedOut;
//
//   final String receiverName;
//   final String receiverId;
//   final String receiverAvatar;
//   final String receiverEmail;
//   final String myId;
//   final String groupChatId;
//
//   @override
//   _SendQuickGalleryMessageState createState() =>
//       _SendQuickGalleryMessageState();
// }
//
// class _SendQuickGalleryMessageState extends State<SendQuickGalleryMessage> {
//   // This will hold all the assets we fetched
//   List<AssetEntity> assets = [];
//
//   @override
//   void initState() {
//     _fetchAssets();
//     super.initState();
//   }
//
//   _fetchAssets() async {
//     // Set onlyAll to true, to fetch only the 'Recent' album
//     // which contains all the photos/videos in the storage
//     final albums = await PhotoManager.getAssetPathList(
//       onlyAll: true,
//     );
//     final recentAlbum = albums.first;
//
//     // Now that we got the album, fetch all the assets it contains
//     final recentAssets = await recentAlbum.getAssetListRange(
//       start: 0, // start at index 0
//       end: 1000000, // end at a very big index (to get all the assets)
//     );
//
//     // Update the state and notify UI
//     setState(() => assets = recentAssets);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Recent Images",
//           style: TextStyle(color: Colors.blue),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(
//             Icons.arrow_back_rounded,
//             color: Colors.blue,
//           ),
//         ),
//       ),
//       body: assets.length == 0
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CircularProgressIndicator(),
//                   ),
//                   Text(
//                     "Loading Images",
//                     style: TextStyle(color: Colors.blue, fontSize: 15),
//                   )
//                 ],
//               ),
//             )
//           : GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 // A grid view with 3 items per row
//                 crossAxisCount: 3,
//                 childAspectRatio: 1,
//                 crossAxisSpacing: 3,
//                 mainAxisSpacing: 3,
//               ),
//               itemCount: assets.length,
//               itemBuilder: (_, index) {
//                 return AssetThumbnail(
//                   asset: assets[index],
//                   groupChatId: widget.groupChatId,
//                   receiverId: widget.receiverId,
//                   receiverName: widget.receiverName,
//                   receiverEmail: widget.receiverEmail,
//                   receiverAvatar: widget.receiverAvatar,
//                   myId: widget.myId,
//                 );
//               },
//             ),
//     );
//   }
// }
//
// class AssetThumbnail extends StatelessWidget {
//   const AssetThumbnail(
//       {
//       required this.asset,
//         required    this.receiverAvatar,
//         required    this.receiverId,
//         required    this.receiverName,
//         required    this.receiverEmail,
//         required    this.myId,
//         required    this.groupChatId})
//       ;
//
//   final AssetEntity asset;
//   final String receiverName;
//   final String receiverId;
//   final String receiverAvatar;
//   final String receiverEmail;
//   final String myId;
//   final String groupChatId;
//   final bool uploading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     // We're using a FutureBuilder since thumbData is a future
//     return FutureBuilder<Uint8List>(
//       future: asset.thumbData,
//       builder: (_, snapshot) {
//         final bytes = snapshot.data;
//         // If we have no data, display a spinner
//         if (bytes == null)
//           return Padding(
//             padding: const EdgeInsets.all(50.0),
//             child: Text(""),
//           );
//         // If there's data, display it as an image
//         return InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) {
//                   if (asset.type == AssetType.image) {
//                     // If this is an image, navigate to ImageScreen
//                     return ImageScreen(
//                       imageFile: asset.file,
//                       groupChatId: groupChatId,
//                       receiverId: receiverId,
//                       receiverName: receiverName,
//                       receiverEmail: receiverEmail,
//                       receiverAvatar: receiverAvatar,
//                       myId: myId,
//                     );
//                   } else {
//                     // if it's not, navigate to VideoScreen
//                     return VideoScreen(videoFile: asset.file);
//                   }
//                 },
//               ),
//             );
//           },
//           child: Stack(
//             children: [
//
//               // Wrap the image in a Positioned.fill to fill the space
//               Positioned.fill(
//                 child: Image.memory(bytes, fit: BoxFit.cover),
//               ),
//               // Display a Play icon if the asset is a video
//               if (asset.type == AssetType.video)
//                 Center(
//                   child: Container(
//                     color: Colors.blue,
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class ImageScreen extends StatefulWidget {
//   ImageScreen(
//       {
//       required this.imageFile,
//         required    this.receiverAvatar,
//         required     this.receiverId,
//         required     this.receiverName,
//         required    this.receiverEmail,
//         required    this.myId,
//         required    this.groupChatId})
//       ;
//
//   final Future<File> imageFile;
//   final String receiverName;
//   final String receiverId;
//   final String receiverAvatar;
//   final String receiverEmail;
//   final String myId;
//   final String groupChatId;
//
//   @override
//   _ImageScreenState createState() => _ImageScreenState();
// }
//
// class _ImageScreenState extends State<ImageScreen> {
//  late File file;
//
//   cropImage(filePath, BuildContext context) async {
//     File? croppedImage = await ImageCropper.cropImage(
//         sourcePath: filePath,
//         maxWidth: 2500,
//         maxHeight: 2500,
//         androidUiSettings: AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.blue,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//             cropFrameColor: Colors.blue,
//             activeControlsWidgetColor: Colors.lightBlue),
//         iosUiSettings: IOSUiSettings(
//           minimumAspectRatio: 1.0,
//         ));
//     if (croppedImage != null) {
//       file = croppedImage;
//
//       showModalBottomSheet(
//           useRootNavigator: true,
//           isScrollControlled: true,
//           barrierColor: Colors.red.withOpacity(0.2),
//           elevation: 0,
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           context: context,
//           builder: (_scaffoldKeyForImagePicker) {
//             return Container(
//               height: MediaQuery.of(context).size.height / 1.8,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Cropped Image",
//                           style: TextStyle(
//                               fontFamily: 'cute',
//                               fontSize: 15,
//                               color: Colors.blue),
//                         )),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               _sendImage(file, context, true);
//                               int count = 0;
//                               Navigator.of(context)
//                                   .popUntil((_) => count++ >= 3);
//                             },
//                             child: Text('Send'),
//                             style: ElevatedButton.styleFrom(
//                                 elevation: 0.0,
//                                 primary: Colors.blueAccent,
//                                 textStyle: TextStyle(
//                                     fontSize: 15, fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('Cancel'),
//                             style: ElevatedButton.styleFrom(
//                               elevation: 0.0,
//                               primary: Colors.red,
//                               textStyle: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.bold),),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Center(
//                         child: Container(
//                           child: Image.file(
//                             file,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             );
//           });
//     }
//   }
//
//  late bool fromCrop;
//
//   void _sendImage(File image, BuildContext context, bool fromCrop) async {
//     // ignore: deprecated_member_use
//     final String fileName = Uuid().v4();
//     StorageReference photoRef = FirebaseStorage.instance
//         .ref()
//         .child('ChatPhotos/${widget.groupChatId}/$fileName.jpg');
//
//
//
//     final StorageUploadTask uploadTask = photoRef.putFile(image);
//     final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
//
//     String imageUrl = await downloadUrl.ref.getDownloadURL();
//
//     checkIfUserIsAlreadyExists(imageUrl, context);
// setState(() {
//   uploading = false;
// });
//     if (!fromCrop) {
//       Navigator.pop(context);
//       Navigator.pop(context);
//     }
//   }
//
//   ///*** Check If User Exists ***\\\
//   String messageId = Uuid().v4();
//
//   checkIfUserIsAlreadyExists(String content, BuildContext context) {
//        chatListRtDatabaseReference.child(widget.myId).child(widget.receiverId).set(
//       messageDataBase.toMapForChatList(
//         widget.receiverName,
//         widget.receiverId,
//         widget.receiverAvatar,
//         widget.receiverEmail,
//         content,
//         widget.groupChatId,
//         "image",
//         true,
//       ),
//     );
//     chatListRtDatabaseReference.child(widget.receiverId).child(widget.myId).set(
//       messageDataBase.toMapForChatList(
//         Constants.myName,
//         widget.myId,
//         Constants.myPhotoUrl,
//         Constants.myEmail,
//         content,
//         widget.groupChatId,
//         "image",
//         false,
//       ),
//     );
//
//     messageRtDatabaseReference.child(widget.groupChatId).child(messageId).set(
//       messageDataBase.toMap(
//         widget.receiverName,
//         widget.receiverId,
//         widget.receiverAvatar,
//         widget.receiverEmail,
//         content,
//         widget.groupChatId,
//         "image",
//         messageId,
//       ),
//     );
//     messageId = Uuid().v4();
//
//
//   }
//
// bool uploading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           body: Container(
//             color: Colors.black,
//             alignment: Alignment.center,
//             child: FutureBuilder<File>(
//               future: widget.imageFile,
//               builder: (_, snapshot) {
//                 final file = snapshot.data;
//                 if (file == null) return Container();
//                 return Scaffold(
//                     backgroundColor: Colors.white,
//                     appBar: AppBar(
//                       backgroundColor: Colors.white,
//                       elevation: 0.0,
//                       leading: IconButton(
//                         icon: Icon(
//                           Icons.arrow_back,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       actions: [
//                         GestureDetector(
//                           onTap: () {
//                             cropImage(file.path, context);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "Crop",
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontFamily: 'cute',
//                                       color: Colors.black),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.crop,
//                                     size: 15,
//                                   ), onPressed: () {  },
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//
//                             setState(() {
//                               uploading = true;
//                             });
//                             _sendImage(file, context, false);
//
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "Send",
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontFamily: 'cute',
//                                       color: Colors.black),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.send_outlined,
//                                     size: 15,
//                                   ), onPressed: () {  },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     body: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           uploading ? Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: LinearProgressIndicator(),
//                           ) : Text(""),
//
//                           Center(
//                               child: Container(
//                                   child: Image.file(
//                             file,
//                             fit: BoxFit.cover,
//                           ))),
//                         ],
//                       ),
//                     ));
//               },
//             ),
//           ),
//         ),
//         // Positioned(
//         //     bottom: 0.0,
//         //     right: 0.0,
//         //     left: 0.0,
//         //     child: Container(
//         //       color: Colors.white,
//         //       child: Padding(
//         //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         //           child: Container(
//         //               alignment: Alignment.bottomCenter,
//         //               width: MediaQuery.of(context).size.width / 1.2,
//         //               child: Text("dddd",
//         //               style: TextStyle(
//         //                 color: Colors.yellow
//         //               ),))),
//         //     )),
//       ],
//     );
//   }
// }
//
// class VideoScreen extends StatefulWidget {
//   const VideoScreen({
//
//     required this.videoFile,
//   }) ;
//
//   final Future<File> videoFile;
//
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   late VideoPlayerController _controller;
//   bool initialized = false;
//
//   @override
//   void initState() {
//     _initVideo();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   _initVideo() async {
//     final video = await widget.videoFile;
//     _controller = VideoPlayerController.file(video)
//       // Play the video again when it ends
//       ..setLooping(true)
//       // initialize the controller and notify UI when done
//       ..initialize().then((_) => setState(() => initialized = true));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Video"),
//         backgroundColor: Colors.pink.shade200,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Video sending is not allow yet, This option will be soon added to this app",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.pink),
//           ),
//         ),
//       ),
//     );
//
//     //   Scaffold(
//     //   body: initialized
//     //       // If the video is initialized, display it
//     //       ? Scaffold(
//     //           body: Center(
//     //             child: AspectRatio(
//     //               aspectRatio: _controller.value.aspectRatio,
//     //               // Use the VideoPlayer widget to display the video.
//     //               child: VideoPlayer(_controller),
//     //             ),
//     //           ),
//     //           floatingActionButton: FloatingActionButton(
//     //             onPressed: () {
//     //               // Wrap the play or pause in a call to `setState`. This ensures the
//     //               // correct icon is shown.
//     //               setState(() {
//     //                 // If the video is playing, pause it.
//     //                 if (_controller.value.isPlaying) {
//     //                   _controller.pause();
//     //                 } else {
//     //                   // If the video is paused, play it.
//     //                   _controller.play();
//     //                 }
//     //               });
//     //             },
//     //             // Display the correct icon depending on the state of the player.
//     //             child: Icon(
//     //               _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//     //             ),
//     //           ),
//     //         )
//     //       // If the video is not yet initialized, display a spinner
//     //       : Center(child: CircularProgressIndicator()),
//     // );
//   }
// }
