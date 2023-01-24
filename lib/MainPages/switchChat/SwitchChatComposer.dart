// //
// // import 'dart:io';
// //
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// // import 'package:image_cropper/image_cropper.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:switchtofuture/MainPages/switchChat/MessageDatabase.dart';
// // import 'package:switchtofuture/MainPages/switchChat/SwitchMessage.dart';
// // import 'package:switchtofuture/Models/Constans.dart';
// // import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
// // import 'package:uuid/uuid.dart';
// // import 'dart:io';
// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:photo_manager/photo_manager.dart';
// // import 'package:video_player/video_player.dart';
// //
// // import 'galleryImagePicker.dart';
// //
// // MessageDataBase messageDataBase = MessageDataBase();
// // SwitchMessages switchMessages = SwitchMessages();
// //
// // class SwitchChatComposer extends StatefulWidget {
// //   SwitchChatComposer(
// //       {Key key,
// //       this.receiverAvatar,
// //       this.receiverId,
// //       this.receiverName,
// //       this.receiverEmail,
// //       this.myId,
// //       this.groupChatId,
// //       this.inRelationShipId,
// //       this.mood,
// //       this.loveTextCallback,
// //       this.recordingCallBack});
// //
// //   // final BaseAuth auth;
// //   // final VoidCallback onSignedOut;
// //   final String mood;
// //   final String inRelationShipId;
// //   final String receiverName;
// //   final String receiverId;
// //   final String receiverAvatar;
// //   final String receiverEmail;
// //   final String myId;
// //   final String groupChatId;
// //   final VoidCallback loveTextCallback;
// //   final VoidCallback recordingCallBack;
// //
// //
// //   @override
// //   _SwitchChatComposerState createState() => _SwitchChatComposerState();
// // }
// //
// // class _SwitchChatComposerState extends State<SwitchChatComposer> {
// //   bool _isComposing = false;
// //
// //   TextEditingController textController = new TextEditingController();
// //   ScrollController scrollController = ScrollController();
// //   String messageId = Uuid().v4();
// //   bool  isRecording = false, isSending = false;
// //   FlutterAudioRecorder2 _audioRecorder;
// //   String _filePath;
// //
// //   Future<bool> checkPermission() async {
// //     if (!await Permission.microphone.isGranted) {
// //       PermissionStatus status = await Permission.microphone.request();
// //       if (status != PermissionStatus.granted) {
// //         return false;
// //       }
// //     }
// //     return true;
// //   }
// //
// //   Future<void> _startRecording() async {
// //     final bool hasRecordingPermission =
// //         await FlutterAudioRecorder2.hasPermissions;
// //
// //     if (hasRecordingPermission ?? false) {
// //       Directory directory = await getApplicationDocumentsDirectory();
// //       String filepath = directory.path +
// //           '/' +
// //           DateTime.now().millisecondsSinceEpoch.toString() +
// //           '.aac';
// //       _audioRecorder =
// //           FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
// //       await _audioRecorder.initialized;
// //       _audioRecorder.start();
// //       _filePath = filepath;
// //       setState(() {});
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //           content: Center(child: Text('Please enable recording permission'))));
// //     }
// //   }
// //
// //   void stopRecord() async {
// //     _audioRecorder.stop();
// //     setState(() {
// //       isSending = true;
// //     });
// //
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       uploadAudio();
// //     });
// //
// //   }
// //
// //   Future<void> uploadAudio() async {
// //     final StorageReference firebaseStorageRef = FirebaseStorage.instance
// //         .ref()
// //         .child(
// //             'AudioMessage/${widget.groupChatId}/audio${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
// //
// //     StorageUploadTask task = firebaseStorageRef.putFile(File(_filePath));
// //     task.onComplete.then((value) async {
// //       var audioURL = await value.ref.getDownloadURL();
// //       String strVal = audioURL.toString();
// //       await sendAudioMsg(strVal);
// //     }).catchError((e) {
// //       print(e);
// //     });
// //   }
// //
// //   sendAudioMsg(String audioMsg) async {
// //     if (audioMsg.isNotEmpty) {
// //       checkIfUserIsAlreadyExists(audioMsg, "", 'audio');
// //
// //       isSending = false;
// //     } else {
// //       print("Error");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Container(
// //           margin: const EdgeInsets.symmetric(horizontal: 8.0),
// //           child: Row(
// //             children: <Widget>[
// //               widget.inRelationShipId == widget.receiverId
// //                   ? GestureDetector(
// //                       onTap: () {
// //                         widget.loveTextCallback();
// //                         _handleSubmitted("Gesture Note", 'GestureNote');
// //                       },
// //                       child: Padding(
// //                         padding: const EdgeInsets.only(left: 5, bottom: 8),
// //                         child: SizedBox(
// //                           height: 40,
// //                           width: 40,
// //                           child: Lottie.asset(
// //                             'images/loveChatComposer.json',
// //                           ),
// //                         ),
// //                       ),
// //                     )
// //                   : Padding(
// //                       padding: const EdgeInsets.only(left: 5, bottom: 8),
// //                       child: SizedBox(
// //                         height: 40,
// //                         width: 40,
// //                         child: Icon(Icons.favorite),
// //                       ),
// //                     ),
// //               Flexible(
// //                 child: Container(
// //                   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
// //                   // constraints: BoxConstraints.expand(),
// //                   child: new Scrollbar(
// //                     child: Padding(
// //                       padding:
// //                           const EdgeInsets.only(bottom: 7, left: 5, right: 5),
// //                       child: TextField(
// //                         cursorColor: Colors.grey,
// //                         cursorHeight: 20,
// //                         controller: textController,
// //                         onChanged: (String text) {
// //                           setState(() {
// //                             _isComposing = text.length > 0;
// //                           });
// //                         },
// //                         keyboardType: TextInputType.multiline,
// //                         minLines: 1,
// //                         maxLines: 10,
// //                         decoration: new InputDecoration(
// //                           contentPadding: const EdgeInsets.symmetric(
// //                               vertical: 10, horizontal: 20),
// //                           border: new OutlineInputBorder(
// //                             borderSide: BorderSide.none,
// //                             borderRadius: const BorderRadius.all(
// //                               const Radius.circular(30.0),
// //                             ),
// //                           ),
// //                           filled: true,
// //                           hintStyle: new TextStyle(
// //                               color: Colors.grey,
// //                               fontSize: 13,
// //                               fontFamily: 'cute'),
// //                           hintText: "Type here...",
// //                           fillColor: Colors.white60,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(right: 8, bottom: 8),
// //                 child: GestureDetector(
// //                   // onTap: _sendImageFromCamera,
// //
// //                   onLongPress: () => {
// //                     _startRecording(),
// //                     widget.recordingCallBack(),
// //                     setState(() {
// //                       isRecording = true;
// //                     }),
// //                   },
// //                   onLongPressEnd: (details) => {
// //                     stopRecord(),
// //                     widget.recordingCallBack(),
// //
// //                     setState(() {
// //                       isRecording = false;
// //                     }),
// //                   },
// //
// //                   child: isRecording
// //                       ? Icon(
// //                           Icons.fiber_smart_record_outlined,
// //                           size: 20,
// //                         )
// //                       : Icon(
// //                           Icons.record_voice_over,
// //                           color: widget.inRelationShipId == widget.receiverId
// //                               ? widget.mood == 'romantic'
// //                                   ? Colors.pinkAccent
// //                                   : widget.mood == 'sad'
// //                                       ? Colors.grey
// //                                       : widget.mood == 'break'
// //                                           ? Colors.lightBlue
// //                                           : widget.mood == 'angry'
// //                                               ? Colors.red
// //                                               : widget.mood == 'ignore'
// //                                                   ? Colors.teal
// //                                                   : Colors.purpleAccent
// //                               : Colors.blueAccent,
// //                           size: 22,
// //                         ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 8, bottom: 8),
// //                 child: GestureDetector(
// //                     onTap: () async {
// //                       final permitted = await PhotoManager.requestPermission();
// //                       if (!permitted) return;
// //                       Navigator.of(context).push(
// //                         MaterialPageRoute(
// //                             builder: (_) => SendQuickGalleryMessage(
// //                                   groupChatId: widget.groupChatId,
// //                                   receiverId: widget.receiverId,
// //                                   receiverName: widget.receiverName,
// //                                   receiverEmail: widget.receiverEmail,
// //                                   receiverAvatar: widget.receiverAvatar,
// //                                   myId: widget.myId,
// //                                 )),
// //                       );
// //                     },
// //                     child: Icon(
// //                       Icons.image_outlined,
// //                       color: widget.inRelationShipId == widget.receiverId
// //                           ? widget.mood == 'romantic'
// //                               ? Colors.pinkAccent
// //                               : widget.mood == 'sad'
// //                                   ? Colors.grey
// //                                   : widget.mood == 'break'
// //                                       ? Colors.lightBlue
// //                                       : widget.mood == 'angry'
// //                                           ? Colors.red
// //                                           : widget.mood == 'ignore'
// //                                               ? Colors.teal
// //                                               : Colors.purpleAccent
// //                           : Colors.blueAccent,
// //                       size: 22,
// //                     )),
// //               ),
// //               Theme.of(context).platform == TargetPlatform.iOS
// //                   ? CupertinoButton(
// //                       child: Text("Send"),
// //                       onPressed: _isComposing
// //                           ? () => _handleSubmitted(textController.text, 'text')
// //                           : null,
// //                     )
// //                   : Padding(
// //                       padding: const EdgeInsets.only(bottom: 7),
// //                       child: IconButton(
// //                         icon: Icon(
// //                           Icons.send_outlined,
// //                           size: 22,
// //                           color: widget.inRelationShipId == widget.receiverId
// //                               ? widget.mood == 'romantic'
// //                                   ? Colors.pinkAccent
// //                                   : widget.mood == 'sad'
// //                                       ? Colors.grey
// //                                       : widget.mood == 'break'
// //                                           ? Colors.lightBlue
// //                                           : widget.mood == 'angry'
// //                                               ? Colors.red
// //                                               : widget.mood == 'ignore'
// //                                                   ? Colors.teal
// //                                                   : Colors.purpleAccent
// //                               : Colors.blueAccent,
// //                         ),
// //                         onPressed: _isComposing
// //                             ? () => {
// //                                   _handleSubmitted(textController.text, "text"),
// //                                   // player.play('sendMessage.mp3'),
// //                                 }
// //                             : null,
// //                       ),
// //                     ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   void _handleSubmitted(String content, String type) {
// //     print(type);
// //     textController.clear();
// //     setState(() {
// //       _isComposing = false;
// //     });
// //     String imageUrl = "";
// //
// //     checkIfUserIsAlreadyExists(content, imageUrl, type);
// //   }
// //
// //   void _sendImage(ImageSource imageSource) async {
// //     // ignore: deprecated_member_use
// //     File image = await ImagePicker.pickImage(source: imageSource);
// //     final String fileName = Uuid().v4();
// //     StorageReference photoRef = FirebaseStorage.instance
// //         .ref()
// //         .child('ChatPhotos')
// //         .child(widget.groupChatId)
// //         .child(fileName);
// //     final StorageUploadTask uploadTask = photoRef.putFile(image);
// //     final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
// //
// //     String imageUrl = await downloadUrl.ref.getDownloadURL();
// //     String content = 'null';
// //     checkIfUserIsAlreadyExists(content, imageUrl, 'image');
// //   }
// //
// //   File file;
// //
// //   _sendImageFromCamera() async {
// //     File imageFile = await ImagePicker.pickImage(
// //       source: ImageSource.camera,
// //       imageQuality: 100,
// //       maxHeight: 680,
// //       maxWidth: 950,
// //     );
// //     setState(() {
// //       file = imageFile;
// //     });
// //
// //     showModalBottomSheet(
// //         useRootNavigator: true,
// //         isScrollControlled: true,
// //         barrierColor: Colors.red.withOpacity(0.2),
// //         elevation: 0,
// //         clipBehavior: Clip.antiAliasWithSaveLayer,
// //         context: context,
// //         builder: (context) {
// //           return Container(
// //             height: MediaQuery.of(context).size.height / 2,
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Text(
// //                       "What You Want?",
// //                       style: TextStyle(
// //                           fontSize: 15,
// //                           fontFamily: "cutes",
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.red),
// //                     ),
// //                   ),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       ElevatedButton(
// //                         child: Text('Send'),
// //                         onPressed: () {
// //                           _sendImageCamera(file, 'image');
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                             elevation: 0.0,
// //                             primary: Colors.green,
// //                             textStyle: TextStyle(
// //                                 fontSize: 15, fontWeight: FontWeight.bold)),
// //                       ),
// //                       ElevatedButton(
// //                         child: Text('Crop'),
// //                         onPressed: () {
// //                           cropImage(file.path);
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                             elevation: 0.0,
// //                             primary: Colors.blue,
// //                             textStyle: TextStyle(
// //                                 fontSize: 15, fontWeight: FontWeight.bold)),
// //                       ),
// //                       ElevatedButton(
// //                         child: Text('Cancel'),
// //                         onPressed: () {
// //                           Navigator.pop(context);
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                             elevation: 0.0,
// //                             primary: Colors.red,
// //                             textStyle: TextStyle(
// //                                 fontSize: 15, fontWeight: FontWeight.bold)),
// //                       ),
// //                     ],
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Center(
// //                       child: Container(
// //                         child: Image.file(
// //                           file,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         });
// //   }
// //
// //   cropImage(filePath) async {
// //     File croppedImage = await ImageCropper.cropImage(
// //         sourcePath: filePath,
// //         maxWidth: 2500,
// //         maxHeight: 2500,
// //         androidUiSettings: AndroidUiSettings(
// //             toolbarTitle: 'Cropper',
// //             toolbarColor: Colors.blue,
// //             toolbarWidgetColor: Colors.white,
// //             initAspectRatio: CropAspectRatioPreset.original,
// //             lockAspectRatio: false),
// //         iosUiSettings: IOSUiSettings(
// //           minimumAspectRatio: 1.0,
// //         ));
// //     if (croppedImage != null) {
// //       file = croppedImage;
// //
// //       String type = "image";
// //
// //       _sendImageCamera(file, type);
// //     }
// //   }
// //
// //   void _sendImageCamera(File image, String type) async {
// //     final String fileName = Uuid().v4();
// //     StorageReference photoRef = FirebaseStorage.instance
// //         .ref()
// //         .child('ChatPhotos')
// //         .child(widget.groupChatId)
// //         .child(fileName);
// //     final StorageUploadTask uploadTask = photoRef.putFile(image);
// //     final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
// //
// //     String imageUrl = await downloadUrl.ref.getDownloadURL();
// //     String content = 'null';
// //     checkIfUserIsAlreadyExists(content, imageUrl, type);
// //     Navigator.pop(context);
// //   }
// //
// //   ///*** Check If User Exists ***\\\
// //
// //   checkIfUserIsAlreadyExists(String content, String imageUrl, String type) {
// //     DatabaseReference _messageDatabaseReferences =
// //         compareListRtDatabaseReference
// //             .child(widget.myId)
// //             .child(widget.receiverId);
// //
// //     _messageDatabaseReferences.once().then((DataSnapshot snapshot) {
// //       if (snapshot.value == null) {
// //         chatListRtDatabaseReference
// //             .child(widget.myId)
// //             .child(widget.receiverId)
// //             .set(messageDataBase.toMapForChatList(
// //                 widget.receiverName,
// //                 widget.receiverId,
// //                 widget.receiverAvatar,
// //                 widget.receiverEmail,
// //                 content,
// //                 widget.groupChatId,
// //                 imageUrl,
// //                 type));
// //         chatListRtDatabaseReference
// //             .child(widget.receiverId)
// //             .child(widget.myId)
// //             .set(messageDataBase.toMapForReceiverForChatList(
// //                 widget.receiverName,
// //                 widget.receiverId,
// //                 widget.receiverAvatar,
// //                 widget.receiverEmail,
// //                 content,
// //                 widget.groupChatId,
// //                 imageUrl,
// //                 type));
// //
// //         compareListRtDatabaseReference
// //             .child(widget.myId)
// //             .child(widget.receiverId)
// //             .push()
// //             .set(messageDataBase.toMapForCompareChatList(
// //                 widget.receiverName,
// //                 widget.receiverId,
// //                 widget.receiverAvatar,
// //                 widget.receiverEmail,
// //                 content,
// //                 widget.groupChatId,
// //                 imageUrl,
// //                 type));
// //         compareListRtDatabaseReference
// //             .child(widget.receiverId)
// //             .child(widget.myId)
// //             .push()
// //             .set(messageDataBase.toMapForCompareChatListForReceiver(
// //               widget.receiverName,
// //               widget.receiverId,
// //               widget.receiverAvatar,
// //               widget.receiverEmail,
// //               content,
// //               widget.groupChatId,
// //               imageUrl,
// //               type,
// //             ));
// //
// //         messageRtDatabaseReference
// //             .child(widget.groupChatId)
// //             .child(messageId)
// //             .set(messageDataBase.toMap(
// //               widget.receiverName,
// //               widget.receiverId,
// //               widget.receiverAvatar,
// //               widget.receiverEmail,
// //               content,
// //               widget.groupChatId,
// //               imageUrl,
// //               type,
// //               messageId,
// //             ));
// //         messageId = Uuid().v4();
// //       } else {
// //         messageRtDatabaseReference
// //             .child(widget.groupChatId)
// //             .child(messageId)
// //             .set(messageDataBase.toMap(
// //                 widget.receiverName,
// //                 widget.receiverId,
// //                 widget.receiverAvatar,
// //                 widget.receiverEmail,
// //                 content,
// //                 widget.groupChatId,
// //                 imageUrl,
// //                 type,
// //                 messageId));
// //
// //         chatListRtDatabaseReference
// //             .child(widget.myId)
// //             .child(widget.receiverId)
// //             .set(messageDataBase.toMapForChatList(
// //                 widget.receiverName,
// //                 widget.receiverId,
// //                 widget.receiverAvatar,
// //                 widget.receiverEmail,
// //                 content,
// //                 widget.groupChatId,
// //                 imageUrl,
// //                 type));
// //         chatListRtDatabaseReference
// //             .child(widget.receiverId)
// //             .child(widget.myId)
// //             .set(messageDataBase.toMapForReceiverForChatList(
// //                 widget.receiverName,
// //                 widget.receiverId,
// //                 widget.receiverAvatar,
// //                 widget.receiverEmail,
// //                 content,
// //                 widget.groupChatId,
// //                 imageUrl,
// //                 type));
// //         print("exists");
// //         messageId = Uuid().v4();
// //       }
// //     });
// //   }
// // }
//
// ///
// ///
// ///
//
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:rive/rive.dart';
// import 'package:switchtofuture/MainPages/switchChat/MessageDatabase.dart';
// import 'package:switchtofuture/MainPages/switchChat/SwitchMessage.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:video_player/video_player.dart';
//
// import 'galleryImagePicker.dart';
//
// MessageDataBase messageDataBase = MessageDataBase();
// SwitchMessages switchMessages = SwitchMessages();
//
// class SwitchChatComposer extends StatefulWidget {
//   SwitchChatComposer(
//       {Key key,
//       this.receiverAvatar,
//       this.receiverId,
//       this.receiverName,
//       this.receiverEmail,
//       this.myId,
//       this.groupChatId,
//       this.inRelationShipId,
//       this.mood,
//       this.loveTextCallback,
//       this.recordingCallBack});
//
//   // final BaseAuth auth;
//   // final VoidCallback onSignedOut;
//   final String mood;
//   final String inRelationShipId;
//   final String receiverName;
//   final String receiverId;
//   final String receiverAvatar;
//   final String receiverEmail;
//   final String myId;
//   final String groupChatId;
//   final VoidCallback loveTextCallback;
//   final VoidCallback recordingCallBack;
//
//   @override
//   _SwitchChatComposerState createState() => _SwitchChatComposerState();
// }
//
// class _SwitchChatComposerState extends State<SwitchChatComposer> {
//   bool _isComposing = false;
//
//   TextEditingController textController = new TextEditingController();
//   ScrollController scrollController = ScrollController();
//   String messageId = Uuid().v4();
//   bool isRecording = false, isSending = false;
//   FlutterAudioRecorder2 _audioRecorder;
//   String _filePath;
//   TextEditingController loveNote = TextEditingController();
//
//   Color romanticColor = Colors.grey;
//
//   Future<bool> checkPermission() async {
//     if (!await Permission.microphone.isGranted) {
//       PermissionStatus status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   Future<void> _startRecording() async {
//     final bool hasRecordingPermission =
//         await FlutterAudioRecorder2.hasPermissions;
//
//     if (hasRecordingPermission ?? false) {
//       Directory directory = await getApplicationDocumentsDirectory();
//       String filepath = directory.path +
//           '/' +
//           DateTime.now().millisecondsSinceEpoch.toString() +
//           '.aac';
//       _audioRecorder =
//           FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
//       await _audioRecorder.initialized;
//       _audioRecorder.start();
//       _filePath = filepath;
//       setState(() {});
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Center(child: Text('Please enable recording permission'))));
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     setState(() {
//       romanticColor = widget.mood == 'romantic'
//           ? Colors.pinkAccent
//           : widget.mood == 'sad'
//               ? Colors.grey
//               : widget.mood == 'break'
//                   ? Colors.lightBlue
//                   : widget.mood == 'angry'
//                       ? Colors.red
//                       : widget.mood == 'ignore'
//                           ? Colors.teal
//                           : Colors.purpleAccent;
//     });
//   }
//
//   void stopRecord() async {
//     _audioRecorder.stop();
//     setState(() {
//       isSending = true;
//     });
//
//     Future.delayed(const Duration(milliseconds: 500), () {
//       uploadAudio();
//     });
//   }
//
//   Future<void> uploadAudio() async {
//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child(
//             'AudioMessage/${widget.groupChatId}/audio${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
//
//     StorageUploadTask task = firebaseStorageRef.putFile(File(_filePath));
//     task.onComplete.then((value) async {
//       var audioURL = await value.ref.getDownloadURL();
//       String strVal = audioURL.toString();
//       await sendAudioMsg(strVal);
//     }).catchError((e) {
//       print(e);
//     });
//   }
//
//   sendAudioMsg(String audioMsg) async {
//     if (audioMsg.isNotEmpty) {
//       sendMessage(audioMsg, 'audio');
//
//       isSending = false;
//     } else {
//       print("Error");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             children: <Widget>[
//               widget.inRelationShipId == widget.receiverId
//                   ? GestureDetector(
//                       onTap: () {
//                         // widget.loveTextCallback();
//                         loveNoteBottomSheet();
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 5, bottom: 8),
//                         child: SizedBox(
//                           height: 40,
//                           width: 40,
//                           child: Lottie.asset(
//                             'images/loveChatComposer.json',
//                           ),
//                         ),
//                       ),
//                     )
//                   : GestureDetector(
//                 onTap: (){
//                   Fluttertoast.showToast(
//                   msg: "This feature will come very soon! :)",
//                   toastLength: Toast.LENGTH_LONG,
//                   gravity: ToastGravity.TOP,
//                   timeInSecForIosWeb: 3,
//                   backgroundColor: Colors.blue.withOpacity(0.8),
//                   textColor: Colors.white,
//                   fontSize: 16.0,
//                 );
//
//
//                 },
//                     child: Padding(
//                         padding: const EdgeInsets.only(left: 5, bottom: 8),
//                         child: SizedBox(
//                           height: 40,
//                           width: 40,
//                           child: Icon(Icons.favorite),
//                         ),
//                       ),
//                   ),
//               Flexible(
//                 child: Container(
//                   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                   // constraints: BoxConstraints.expand(),
//                   child: new Scrollbar(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.only(bottom: 7, left: 5, right: 5),
//                       child: TextField(
//                         cursorColor: Colors.grey,
//                         cursorHeight: 20,
//                         controller: textController,
//                         onChanged: (String text) {
//                           setState(() {
//                             _isComposing = text.length > 0;
//                           });
//                         },
//                         keyboardType: TextInputType.multiline,
//                         minLines: 1,
//                         maxLines: 10,
//                         decoration: new InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 20),
//                           border: new OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                             borderRadius: const BorderRadius.all(
//                               const Radius.circular(30.0),
//                             ),
//                           ),
//                           filled: true,
//                           hintStyle: new TextStyle(
//                               color: Colors.grey,
//                               fontSize: 13,
//                               fontFamily: 'cute'),
//                           hintText: "Type here...",
//                           fillColor: Colors.white60,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 8, bottom: 8),
//                 child: GestureDetector(
//                   // onTap: _sendImageFromCamera,
//
//                   onLongPress: () => {
//                     _startRecording(),
//                     widget.recordingCallBack(),
//                     setState(() {
//                       isRecording = true;
//                     }),
//                   },
//                   onLongPressEnd: (details) => {
//                     stopRecord(),
//                     widget.recordingCallBack(),
//                     setState(() {
//                       isRecording = false;
//                     }),
//                   },
//
//                   child: isRecording
//                       ? Icon(
//                           Icons.fiber_smart_record_outlined,
//                           size: 20,
//                         )
//                       : Icon(
//                           Icons.record_voice_over,
//                           color: widget.inRelationShipId == widget.receiverId
//                               ? widget.mood == 'romantic'
//                                   ? Colors.pinkAccent
//                                   : widget.mood == 'sad'
//                                       ? Colors.grey
//                                       : widget.mood == 'break'
//                                           ? Colors.lightBlue
//                                           : widget.mood == 'angry'
//                                               ? Colors.red
//                                               : widget.mood == 'ignore'
//                                                   ? Colors.teal
//                                                   : Colors.purpleAccent
//                               : Colors.blueAccent,
//                           size: 22,
//                         ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8, bottom: 8),
//                 child: GestureDetector(
//                     onTap: () async {
//                       final permitted = await PhotoManager.requestPermission();
//                       if (!permitted) return;
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                             builder: (_) => SendQuickGalleryMessage(
//                                   groupChatId: widget.groupChatId,
//                                   receiverId: widget.receiverId,
//                                   receiverName: widget.receiverName,
//                                   receiverEmail: widget.receiverEmail,
//                                   receiverAvatar: widget.receiverAvatar,
//                                   myId: widget.myId,
//                                 )),
//                       );
//                     },
//                     child: Icon(
//                       Icons.image_outlined,
//                       color: widget.inRelationShipId == widget.receiverId
//                           ? widget.mood == 'romantic'
//                               ? Colors.pinkAccent
//                               : widget.mood == 'sad'
//                                   ? Colors.grey
//                                   : widget.mood == 'break'
//                                       ? Colors.lightBlue
//                                       : widget.mood == 'angry'
//                                           ? Colors.red
//                                           : widget.mood == 'ignore'
//                                               ? Colors.teal
//                                               : Colors.purpleAccent
//                           : Colors.blueAccent,
//                       size: 22,
//                     )),
//               ),
//               Theme.of(context).platform == TargetPlatform.iOS
//                   ? CupertinoButton(
//                       child: Text("Send"),
//                       onPressed: _isComposing
//                           ? () => _handleSubmitted(textController.text, 'text')
//                           : null,
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(bottom: 7),
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.send_outlined,
//                           size: 22,
//                           color: widget.inRelationShipId == widget.receiverId
//                               ? widget.mood == 'romantic'
//                                   ? Colors.pinkAccent
//                                   : widget.mood == 'sad'
//                                       ? Colors.grey
//                                       : widget.mood == 'break'
//                                           ? Colors.lightBlue
//                                           : widget.mood == 'angry'
//                                               ? Colors.red
//                                               : widget.mood == 'ignore'
//                                                   ? Colors.teal
//                                                   : Colors.purpleAccent
//                               : Colors.blueAccent,
//                         ),
//                         onPressed: _isComposing
//                             ? () => {
//                                   _handleSubmitted(textController.text, "text"),
//                                   // player.play('sendMessage.mp3'),
//                                 }
//                             : null,
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   loveNoteBottomSheet() {
//     return showModalBottomSheet(
//       useRootNavigator: true,
//       isScrollControlled: true,
//       barrierColor: Colors.blue.withOpacity(0.2),
//       elevation: 0,
//       isDismissible: false,
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       context: context,
//       builder: (context) {
//         return Container(
//           color: Colors.white,
//           height: MediaQuery.of(context).size.height / 1.2,
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10, right: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               loveNote.clear();
//                               Navigator.pop(context);
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 "Back",
//                                 style: TextStyle(
//                                   fontFamily: 'cute',
//                                   color: romanticColor,
//                                   fontSize: 17,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Love Note",
//                                   style: TextStyle(
//                                     fontFamily: 'cute',
//                                     color: Colors.pinkAccent.shade400,
//                                     fontSize: 20,
//                                   ),
//                                 ),
//                               ),
//                               Center(
//                                 child: Container(
//                                   height: 50,
//                                   width: 50,
//                                   child: RiveAnimation.asset(
//
//                                     'images/chatNotes/loveNoteLogo.riv',
//
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Theme.of(context).platform == TargetPlatform.iOS
//                               ? CupertinoButton(
//                                   child: Text("Send"),
//                                   onPressed: () => {
//                                         _handleSubmitted(
//                                             loveNote.text, "GestureNote"),
//                                         loveNote.clear(),
//                                         Navigator.pop(context),
//
//                                         // player.play('sendMessage.mp3'),
//                                       })
//                               : Padding(
//                                   padding: const EdgeInsets.only(bottom: 0),
//                                   child: IconButton(
//                                       icon: Icon(
//                                         Icons.send_outlined,
//                                         size: 22,
//                                         color: widget.inRelationShipId ==
//                                                 widget.receiverId
//                                             ? romanticColor
//                                             : Colors.black,
//                                       ),
//                                       onPressed: () => {
//                                             _handleSubmitted(
//                                                 loveNote.text, "GestureNote"),
//                                             loveNote.clear(),
//                                             Navigator.pop(context),
//                                             // player.play('sendMessage.mp3'),
//                                           }),
//                                 ),
//                         ],
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 30, right: 30, top: 30, bottom: 50),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               color: Colors.pinkAccent.shade100, width: 3),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//
//                         // constraints: BoxConstraints.expand(),
//                         child: new Scrollbar(
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 bottom: 0, left: 5, right: 5),
//                             child: TextFormField(
//                               style: TextStyle(fontFamily: 'cute'),
//                               cursorColor: Colors.white,
//                               cursorHeight: 10,
//                               controller: loveNote,
//                               maxLength: 180,
//                               onSaved: (v) {
//                                 print(v);
//                               },
//                               keyboardType: TextInputType.multiline,
//                               minLines: 1,
//                               maxLines: 6,
//                               textAlign: TextAlign.center,
//                               decoration: new InputDecoration(
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 20),
//                                 filled: true,
//                                 border: InputBorder.none,
//                                 focusColor: Colors.white,
//                                 hintStyle: new TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13,
//                                     fontFamily: 'cute'),
//                                 hintText: "Write Here..",
//                                 fillColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _handleSubmitted(String content, String type) {
//     print(type);
//     textController.clear();
//     loveNote.clear();
//     setState(() {
//       _isComposing = false;
//     });
//     String imageUrl = "";
//
//     sendMessage(content, type);
//   }
//
//   void _sendImage(ImageSource imageSource) async {
//     // ignore: deprecated_member_use
//     File image = await ImagePicker.pickImage(source: imageSource);
//     final String fileName = Uuid().v4();
//     StorageReference photoRef = FirebaseStorage.instance
//         .ref()
//         .child('ChatPhotos')
//         .child(widget.groupChatId)
//         .child(fileName);
//     final StorageUploadTask uploadTask = photoRef.putFile(image);
//     final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
//
//     String imageUrl = await downloadUrl.ref.getDownloadURL();
//     String content = 'null';
//     sendMessage(imageUrl, 'image');
//   }
//
//   File file;
//
//   _sendImageFromCamera() async {
//     File imageFile = await ImagePicker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 100,
//       maxHeight: 680,
//       maxWidth: 950,
//     );
//     setState(() {
//       file = imageFile;
//     });
//
//     showModalBottomSheet(
//         useRootNavigator: true,
//         isScrollControlled: true,
//         barrierColor: Colors.red.withOpacity(0.2),
//         elevation: 0,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         context: context,
//         builder: (context) {
//           return Container(
//             height: MediaQuery.of(context).size.height / 2,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "What You Want?",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontFamily: "cutes",
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         child: Text('Send'),
//                         onPressed: () {
//                           _sendImageCamera(file, 'image');
//                         },
//                         style: ElevatedButton.styleFrom(
//                             elevation: 0.0,
//                             primary: Colors.green,
//                             textStyle: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         child: Text('Crop'),
//                         onPressed: () {
//                           cropImage(file.path);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             elevation: 0.0,
//                             primary: Colors.blue,
//                             textStyle: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         child: Text('Cancel'),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             elevation: 0.0,
//                             primary: Colors.red,
//                             textStyle: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold)),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Container(
//                         child: Image.file(
//                           file,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
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
//
//       String type = "image";
//
//       _sendImageCamera(file, type);
//     }
//   }
//
//   void _sendImageCamera(File image, String type) async {
//     final String fileName = Uuid().v4();
//     StorageReference photoRef = FirebaseStorage.instance
//         .ref()
//         .child('ChatPhotos')
//         .child(widget.groupChatId)
//         .child(fileName);
//     final StorageUploadTask uploadTask = photoRef.putFile(image);
//     final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
//
//     String imageUrl = await downloadUrl.ref.getDownloadURL();
//     String content = 'null';
//     sendMessage(imageUrl, type);
//     Navigator.pop(context);
//   }
//
//   ///*** Check If User Exists ***\\\
//
//   sendMessage(String content, String type) {
//     // DatabaseReference _messageDatabaseReferences =
//     //     compareListRtDatabaseReference
//     //         .child(widget.myId)
//     //         .child(widget.receiverId);
//
//     chatListRtDatabaseReference.child(widget.myId).child(widget.receiverId).set(
//           messageDataBase.toMapForChatList(
//             widget.receiverName,
//             widget.receiverId,
//             widget.receiverAvatar,
//             widget.receiverEmail,
//             content,
//             widget.groupChatId,
//             type,
//             true,
//           ),
//         );
//     chatListRtDatabaseReference.child(widget.receiverId).child(widget.myId).set(
//           messageDataBase.toMapForChatList(
//             Constants.myName,
//             Constants.myId,
//             Constants.myPhotoUrl,
//             Constants.myEmail,
//             content,
//             widget.groupChatId,
//             type,
//             false,
//           ),
//         );
//
//     messageRtDatabaseReference.child(widget.groupChatId).child(messageId).set(
//           messageDataBase.toMap(
//             widget.receiverName,
//             widget.receiverId,
//             widget.receiverAvatar,
//             widget.receiverEmail,
//             content,
//             widget.groupChatId,
//             type,
//             messageId,
//           ),
//         );
//     messageId = Uuid().v4();
//
//   }
// }
///
///
///
//
// import 'dart:io';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:switchtofuture/MainPages/switchChat/MessageDatabase.dart';
// import 'package:switchtofuture/MainPages/switchChat/SwitchMessage.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:video_player/video_player.dart';
//
// import 'galleryImagePicker.dart';
//
// MessageDataBase messageDataBase = MessageDataBase();
// SwitchMessages switchMessages = SwitchMessages();
//
// class SwitchChatComposer extends StatefulWidget {
//   SwitchChatComposer(
//       {Key key,
//       this.receiverAvatar,
//       this.receiverId,
//       this.receiverName,
//       this.receiverEmail,
//       this.myId,
//       this.groupChatId,
//       this.inRelationShipId,
//       this.mood,
//       this.loveTextCallback,
//       this.recordingCallBack});
//
//   // final BaseAuth auth;
//   // final VoidCallback onSignedOut;
//   final String mood;
//   final String inRelationShipId;
//   final String receiverName;
//   final String receiverId;
//   final String receiverAvatar;
//   final String receiverEmail;
//   final String myId;
//   final String groupChatId;
//   final VoidCallback loveTextCallback;
//   final VoidCallback recordingCallBack;
//
//
//   @override
//   _SwitchChatComposerState createState() => _SwitchChatComposerState();
// }
//
// class _SwitchChatComposerState extends State<SwitchChatComposer> {
//   bool _isComposing = false;
//
//   TextEditingController textController = new TextEditingController();
//   ScrollController scrollController = ScrollController();
//   String messageId = Uuid().v4();
//   bool  isRecording = false, isSending = false;
//   FlutterAudioRecorder2 _audioRecorder;
//   String _filePath;
//
//   Future<bool> checkPermission() async {
//     if (!await Permission.microphone.isGranted) {
//       PermissionStatus status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   Future<void> _startRecording() async {
//     final bool hasRecordingPermission =
//         await FlutterAudioRecorder2.hasPermissions;
//
//     if (hasRecordingPermission ?? false) {
//       Directory directory = await getApplicationDocumentsDirectory();
//       String filepath = directory.path +
//           '/' +
//           DateTime.now().millisecondsSinceEpoch.toString() +
//           '.aac';
//       _audioRecorder =
//           FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
//       await _audioRecorder.initialized;
//       _audioRecorder.start();
//       _filePath = filepath;
//       setState(() {});
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Center(child: Text('Please enable recording permission'))));
//     }
//   }
//
//   void stopRecord() async {
//     _audioRecorder.stop();
//     setState(() {
//       isSending = true;
//     });
//
//     Future.delayed(const Duration(milliseconds: 500), () {
//       uploadAudio();
//     });
//
//   }
//
//   Future<void> uploadAudio() async {
//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child(
//             'AudioMessage/${widget.groupChatId}/audio${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
//
//     StorageUploadTask task = firebaseStorageRef.putFile(File(_filePath));
//     task.onComplete.then((value) async {
//       var audioURL = await value.ref.getDownloadURL();
//       String strVal = audioURL.toString();
//       await sendAudioMsg(strVal);
//     }).catchError((e) {
//       print(e);
//     });
//   }
//
//   sendAudioMsg(String audioMsg) async {
//     if (audioMsg.isNotEmpty) {
//       checkIfUserIsAlreadyExists(audioMsg, "", 'audio');
//
//       isSending = false;
//     } else {
//       print("Error");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             children: <Widget>[
//               widget.inRelationShipId == widget.receiverId
//                   ? GestureDetector(
//                       onTap: () {
//                         widget.loveTextCallback();
//                         _handleSubmitted("Gesture Note", 'GestureNote');
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 5, bottom: 8),
//                         child: SizedBox(
//                           height: 40,
//                           width: 40,
//                           child: Lottie.asset(
//                             'images/loveChatComposer.json',
//                           ),
//                         ),
//                       ),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(left: 5, bottom: 8),
//                       child: SizedBox(
//                         height: 40,
//                         width: 40,
//                         child: Icon(Icons.favorite),
//                       ),
//                     ),
//               Flexible(
//                 child: Container(
//                   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                   // constraints: BoxConstraints.expand(),
//                   child: new Scrollbar(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.only(bottom: 7, left: 5, right: 5),
//                       child: TextField(
//                         cursorColor: Colors.grey,
//                         cursorHeight: 20,
//                         controller: textController,
//                         onChanged: (String text) {
//                           setState(() {
//                             _isComposing = text.length > 0;
//                           });
//                         },
//                         keyboardType: TextInputType.multiline,
//                         minLines: 1,
//                         maxLines: 10,
//                         decoration: new InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 20),
//                           border: new OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                             borderRadius: const BorderRadius.all(
//                               const Radius.circular(30.0),
//                             ),
//                           ),
//                           filled: true,
//                           hintStyle: new TextStyle(
//                               color: Colors.grey,
//                               fontSize: 13,
//                               fontFamily: 'cute'),
//                           hintText: "Type here...",
//                           fillColor: Colors.white60,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 8, bottom: 8),
//                 child: GestureDetector(
//                   // onTap: _sendImageFromCamera,
//
//                   onLongPress: () => {
//                     _startRecording(),
//                     widget.recordingCallBack(),
//                     setState(() {
//                       isRecording = true;
//                     }),
//                   },
//                   onLongPressEnd: (details) => {
//                     stopRecord(),
//                     widget.recordingCallBack(),
//
//                     setState(() {
//                       isRecording = false;
//                     }),
//                   },
//
//                   child: isRecording
//                       ? Icon(
//                           Icons.fiber_smart_record_outlined,
//                           size: 20,
//                         )
//                       : Icon(
//                           Icons.record_voice_over,
//                           color: widget.inRelationShipId == widget.receiverId
//                               ? widget.mood == 'romantic'
//                                   ? Colors.pinkAccent
//                                   : widget.mood == 'sad'
//                                       ? Colors.grey
//                                       : widget.mood == 'break'
//                                           ? Colors.lightBlue
//                                           : widget.mood == 'angry'
//                                               ? Colors.red
//                                               : widget.mood == 'ignore'
//                                                   ? Colors.teal
//                                                   : Colors.purpleAccent
//                               : Colors.blueAccent,
//                           size: 22,
//                         ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8, bottom: 8),
//                 child: GestureDetector(
//                     onTap: () async {
//                       final permitted = await PhotoManager.requestPermission();
//                       if (!permitted) return;
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                             builder: (_) => SendQuickGalleryMessage(
//                                   groupChatId: widget.groupChatId,
//                                   receiverId: widget.receiverId,
//                                   receiverName: widget.receiverName,
//                                   receiverEmail: widget.receiverEmail,
//                                   receiverAvatar: widget.receiverAvatar,
//                                   myId: widget.myId,
//                                 )),
//                       );
//                     },
//                     child: Icon(
//                       Icons.image_outlined,
//                       color: widget.inRelationShipId == widget.receiverId
//                           ? widget.mood == 'romantic'
//                               ? Colors.pinkAccent
//                               : widget.mood == 'sad'
//                                   ? Colors.grey
//                                   : widget.mood == 'break'
//                                       ? Colors.lightBlue
//                                       : widget.mood == 'angry'
//                                           ? Colors.red
//                                           : widget.mood == 'ignore'
//                                               ? Colors.teal
//                                               : Colors.purpleAccent
//                           : Colors.blueAccent,
//                       size: 22,
//                     )),
//               ),
//               Theme.of(context).platform == TargetPlatform.iOS
//                   ? CupertinoButton(
//                       child: Text("Send"),
//                       onPressed: _isComposing
//                           ? () => _handleSubmitted(textController.text, 'text')
//                           : null,
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(bottom: 7),
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.send_outlined,
//                           size: 22,
//                           color: widget.inRelationShipId == widget.receiverId
//                               ? widget.mood == 'romantic'
//                                   ? Colors.pinkAccent
//                                   : widget.mood == 'sad'
//                                       ? Colors.grey
//                                       : widget.mood == 'break'
//                                           ? Colors.lightBlue
//                                           : widget.mood == 'angry'
//                                               ? Colors.red
//                                               : widget.mood == 'ignore'
//                                                   ? Colors.teal
//                                                   : Colors.purpleAccent
//                               : Colors.blueAccent,
//                         ),
//                         onPressed: _isComposing
//                             ? () => {
//                                   _handleSubmitted(textController.text, "text"),
//                                   // player.play('sendMessage.mp3'),
//                                 }
//                             : null,
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _handleSubmitted(String content, String type) {
//     print(type);
//     textController.clear();
//     setState(() {
//       _isComposing = false;
//     });
//     String imageUrl = "";
//
//     checkIfUserIsAlreadyExists(content, imageUrl, type);
//   }
//
//   void _sendImage(ImageSource imageSource) async {
//     // ignore: deprecated_member_use
//     File image = await ImagePicker.pickImage(source: imageSource);
//     final String fileName = Uuid().v4();
//     StorageReference photoRef = FirebaseStorage.instance
//         .ref()
//         .child('ChatPhotos')
//         .child(widget.groupChatId)
//         .child(fileName);
//     final StorageUploadTask uploadTask = photoRef.putFile(image);
//     final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
//
//     String imageUrl = await downloadUrl.ref.getDownloadURL();
//     String content = 'null';
//     checkIfUserIsAlreadyExists(content, imageUrl, 'image');
//   }
//
//   File file;
//
//   _sendImageFromCamera() async {
//     File imageFile = await ImagePicker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 100,
//       maxHeight: 680,
//       maxWidth: 950,
//     );
//     setState(() {
//       file = imageFile;
//     });
//
//     showModalBottomSheet(
//         useRootNavigator: true,
//         isScrollControlled: true,
//         barrierColor: Colors.red.withOpacity(0.2),
//         elevation: 0,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         context: context,
//         builder: (context) {
//           return Container(
//             height: MediaQuery.of(context).size.height / 2,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "What You Want?",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontFamily: "cutes",
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         child: Text('Send'),
//                         onPressed: () {
//                           _sendImageCamera(file, 'image');
//                         },
//                         style: ElevatedButton.styleFrom(
//                             elevation: 0.0,
//                             primary: Colors.green,
//                             textStyle: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         child: Text('Crop'),
//                         onPressed: () {
//                           cropImage(file.path);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             elevation: 0.0,
//                             primary: Colors.blue,
//                             textStyle: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         child: Text('Cancel'),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             elevation: 0.0,
//                             primary: Colors.red,
//                             textStyle: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold)),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Container(
//                         child: Image.file(
//                           file,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
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
//
//       String type = "image";
//
//       _sendImageCamera(file, type);
//     }
//   }
//
//   void _sendImageCamera(File image, String type) async {
//     final String fileName = Uuid().v4();
//     StorageReference photoRef = FirebaseStorage.instance
//         .ref()
//         .child('ChatPhotos')
//         .child(widget.groupChatId)
//         .child(fileName);
//     final StorageUploadTask uploadTask = photoRef.putFile(image);
//     final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
//
//     String imageUrl = await downloadUrl.ref.getDownloadURL();
//     String content = 'null';
//     checkIfUserIsAlreadyExists(content, imageUrl, type);
//     Navigator.pop(context);
//   }
//
//   ///*** Check If User Exists ***\\\
//
//   checkIfUserIsAlreadyExists(String content, String imageUrl, String type) {
//     DatabaseReference _messageDatabaseReferences =
//         compareListRtDatabaseReference
//             .child(widget.myId)
//             .child(widget.receiverId);
//
//     _messageDatabaseReferences.once().then((DataSnapshot snapshot) {
//       if (snapshot.value == null) {
//         chatListRtDatabaseReference
//             .child(widget.myId)
//             .child(widget.receiverId)
//             .set(messageDataBase.toMapForChatList(
//                 widget.receiverName,
//                 widget.receiverId,
//                 widget.receiverAvatar,
//                 widget.receiverEmail,
//                 content,
//                 widget.groupChatId,
//                 imageUrl,
//                 type));
//         chatListRtDatabaseReference
//             .child(widget.receiverId)
//             .child(widget.myId)
//             .set(messageDataBase.toMapForReceiverForChatList(
//                 widget.receiverName,
//                 widget.receiverId,
//                 widget.receiverAvatar,
//                 widget.receiverEmail,
//                 content,
//                 widget.groupChatId,
//                 imageUrl,
//                 type));
//
//         compareListRtDatabaseReference
//             .child(widget.myId)
//             .child(widget.receiverId)
//             .push()
//             .set(messageDataBase.toMapForCompareChatList(
//                 widget.receiverName,
//                 widget.receiverId,
//                 widget.receiverAvatar,
//                 widget.receiverEmail,
//                 content,
//                 widget.groupChatId,
//                 imageUrl,
//                 type));
//         compareListRtDatabaseReference
//             .child(widget.receiverId)
//             .child(widget.myId)
//             .push()
//             .set(messageDataBase.toMapForCompareChatListForReceiver(
//               widget.receiverName,
//               widget.receiverId,
//               widget.receiverAvatar,
//               widget.receiverEmail,
//               content,
//               widget.groupChatId,
//               imageUrl,
//               type,
//             ));
//
//         messageRtDatabaseReference
//             .child(widget.groupChatId)
//             .child(messageId)
//             .set(messageDataBase.toMap(
//               widget.receiverName,
//               widget.receiverId,
//               widget.receiverAvatar,
//               widget.receiverEmail,
//               content,
//               widget.groupChatId,
//               imageUrl,
//               type,
//               messageId,
//             ));
//         messageId = Uuid().v4();
//       } else {
//         messageRtDatabaseReference
//             .child(widget.groupChatId)
//             .child(messageId)
//             .set(messageDataBase.toMap(
//                 widget.receiverName,
//                 widget.receiverId,
//                 widget.receiverAvatar,
//                 widget.receiverEmail,
//                 content,
//                 widget.groupChatId,
//                 imageUrl,
//                 type,
//                 messageId));
//
//         chatListRtDatabaseReference
//             .child(widget.myId)
//             .child(widget.receiverId)
//             .set(messageDataBase.toMapForChatList(
//                 widget.receiverName,
//                 widget.receiverId,
//                 widget.receiverAvatar,
//                 widget.receiverEmail,
//                 content,
//                 widget.groupChatId,
//                 imageUrl,
//                 type));
//         chatListRtDatabaseReference
//             .child(widget.receiverId)
//             .child(widget.myId)
//             .set(messageDataBase.toMapForReceiverForChatList(
//                 widget.receiverName,
//                 widget.receiverId,
//                 widget.receiverAvatar,
//                 widget.receiverEmail,
//                 content,
//                 widget.groupChatId,
//                 imageUrl,
//                 type));
//         print("exists");
//         messageId = Uuid().v4();
//       }
//     });
//   }
// }

///
///
///

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/MainPages/switchChat/MessageDatabase.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

MessageDataBase messageDataBase = MessageDataBase();

class SwitchChatComposer extends StatefulWidget {
  SwitchChatComposer({
    required this.receiverAvatar,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.myId,
    required this.groupChatId,
    required this.inRelationShipId,
    required this.mood,
    required this.loveTextCallback,
    required this.recordingCallBack,
    required this.focusNode,
    required this.replyMessage,
    required this.onCancelReplyMessage,
  });

  // final BaseAuth auth;
  // final VoidCallback onSignedOut;
  final String mood;
  final FocusNode focusNode;
  final String inRelationShipId;
  final String receiverName;
  final String receiverId;
  final String receiverAvatar;
  final String receiverEmail;
  final String myId;
  final String groupChatId;
  final String replyMessage;
  final VoidCallback loveTextCallback;
  final VoidCallback recordingCallBack;
  final VoidCallback onCancelReplyMessage;

  @override
  _SwitchChatComposerState createState() => _SwitchChatComposerState();
}

class _SwitchChatComposerState extends State<SwitchChatComposer> {
  bool _isComposing = false;

  TextEditingController textController = new TextEditingController();
  TextEditingController loveNote = TextEditingController();

  ScrollController scrollController = ScrollController();
  String messageId = Uuid().v4();
  bool isRecording = false, isSending = false;

  late String messageType;

  // late FlutterAudioRecorder2 _audioRecorder;
  late String _filePath;

  Color romanticColor = Colors.grey;

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // Future<void> _startRecording() async {
  //   final bool? hasRecordingPermission =
  //       await FlutterAudioRecorder2.hasPermissions;
  //
  //   if (hasRecordingPermission ?? false) {
  //     Directory directory = await getApplicationDocumentsDirectory();
  //     String filepath = directory.path +
  //         '/' +
  //         DateTime.now().millisecondsSinceEpoch.toString() +
  //         '.aac';
  //     _audioRecorder =
  //         FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
  //     await _audioRecorder.initialized;
  //     _audioRecorder.start();
  //     _filePath = filepath;
  //     setState(() {});
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Center(child: Text('Please enable recording permission'))));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      romanticColor = widget.mood == 'romantic'
          ? Colors.pinkAccent
          : widget.mood == 'sad'
              ? Colors.grey
              : widget.mood == 'break'
                  ? Colors.lightBlue
                  : widget.mood == 'angry'
                      ? Colors.red
                      : widget.mood == 'ignore'
                          ? Colors.teal
                          : Colors.purpleAccent;
    });
  }

  // void stopRecord() async {
  //   _audioRecorder.stop();
  //   setState(() {
  //     isSending = true;
  //   });
  //
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     uploadAudio();
  //   });
  // }

  Future<void> uploadAudio() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String? url;
    Reference ref = storage.ref().child(
        'AudioMessage/${widget.groupChatId}/${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');

    UploadTask uploadTask = ref.putFile(File(_filePath));
    uploadTask.whenComplete(() async {
      var audioURL = ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal);
    }).catchError((e) {
      print(e);
    });
  }

  sendAudioMsg(String audioMsg) async {
    if (audioMsg.isNotEmpty) {
      sendMessage(audioMsg, 'audio', "no");

      isSending = false;
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isReplying = widget.replyMessage != "";

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              widget.inRelationShipId == widget.receiverId
                  ? GestureDetector(
                      onTap: () {
                        // widget.loveTextCallback();
                        loveNoteBottomSheet();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 8),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Lottie.asset(
                            'images/loveChatComposer.json',
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                          msg: "This feature will come very soon! :)",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 3,
                          fontSize: 16.0,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 8),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(Icons.favorite),
                        ),
                      ),
                    ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  // constraints: BoxConstraints.expand(),
                  child: new Scrollbar(
                    child: Column(
                      children: [
                        if (isReplying) buildReply(),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 7, left: 5, right: 5),
                          child: TextField(
                            focusNode: widget.focusNode,
                            cursorHeight: 20,
                            controller: textController,
                            onChanged: (String text) {
                              setState(() {
                                _isComposing = text.length > 0;
                              });
                            },
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 10,
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'cute'),
                              hintText: "Type here...",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 8, bottom: 8),
              //   child: GestureDetector(
              //     onTap: () {
              //       Fluttertoast.showToast(
              //         msg: "Long Press to record Voice",
              //         toastLength: Toast.LENGTH_LONG,
              //         gravity: ToastGravity.TOP,
              //         timeInSecForIosWeb: 3,
              //         backgroundColor: Colors.blue.withOpacity(0.8),
              //         textColor: Colors.white,
              //         fontSize: 14.0,
              //       );
              //     },
              //     onLongPress: () => {
              //       _startRecording(),
              //       widget.recordingCallBack(),
              //       setState(() {
              //         isRecording = true;
              //       }),
              //     },
              //     onLongPressEnd: (details) => {
              //       stopRecord(),
              //       widget.recordingCallBack(),
              //       setState(() {
              //         isRecording = false;
              //       }),
              //     },
              //     child: isRecording
              //         ? Icon(
              //             Icons.fiber_smart_record_outlined,
              //             size: 20,
              //           )
              //         : Icon(
              //             Icons.record_voice_over,
              //             color: widget.inRelationShipId == widget.receiverId
              //                 ? widget.mood == 'romantic'
              //                     ? Colors.pinkAccent
              //                     : widget.mood == 'sad'
              //                         ? Colors.grey
              //                         : widget.mood == 'break'
              //                             ? Colors.lightBlue
              //                             : widget.mood == 'angry'
              //                                 ? Colors.red
              //                                 : widget.mood == 'ignore'
              //                                     ? Colors.teal
              //                                     : Colors.purpleAccent
              //                 : Colors.blueAccent,
              //             size: 22,
              //           ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: GestureDetector(
                    onTap: () async {
                      _handleImageMessage();
                    },
                    child: Icon(
                      Icons.image_outlined,
                      color: widget.inRelationShipId == widget.receiverId
                          ? widget.mood == 'romantic'
                              ? Colors.pinkAccent
                              : widget.mood == 'sad'
                                  ? Colors.grey
                                  : widget.mood == 'break'
                                      ? Colors.lightBlue
                                      : widget.mood == 'angry'
                                          ? Colors.red
                                          : widget.mood == 'ignore'
                                              ? Colors.teal
                                              : Colors.purpleAccent
                          : Colors.lightBlue,
                      size: 22,
                    )),
              ),
              Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text("Send"),
                      onPressed: _isComposing
                          ? () => {
                                _handleSubmitted(textController.text, 'text',
                                    Constants.isMessageReply),
                                widget.onCancelReplyMessage(),
                              }
                          : null,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: IconButton(
                        icon: Icon(
                          Icons.send_outlined,
                          size: 22,
                          color: widget.inRelationShipId == widget.receiverId
                              ? widget.mood == 'romantic'
                                  ? Colors.pinkAccent
                                  : widget.mood == 'sad'
                                      ? Colors.grey
                                      : widget.mood == 'break'
                                          ? Colors.lightBlue
                                          : widget.mood == 'angry'
                                              ? Colors.red
                                              : widget.mood == 'ignore'
                                                  ? Colors.teal
                                                  : Colors.purpleAccent
                              : Colors.lightBlue,
                        ),
                        onPressed: _isComposing
                            ? () => {
                                  _handleSubmitted(textController.text, "text",
                                      Constants.isMessageReply),
                                  widget.onCancelReplyMessage(),
                                  // player.play('sendMessage.mp3'),
                                }
                            : null,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  loveNoteBottomSheet() {
    return showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      barrierColor: Colors.blue.withOpacity(0.2),
      elevation: 0,
      isDismissible: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 1.2,
          child: Stack(
            children: [
              BarTop(),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              loveNote.clear();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  fontFamily: 'cute',
                                  color: romanticColor,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Love Note",
                                  style: TextStyle(
                                    fontFamily: 'cute',
                                    color: Colors.pinkAccent.shade400,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: RiveAnimation.asset(
                                    'images/chatNotes/loveNoteLogo.riv',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? CupertinoButton(
                                  child: Text("Send"),
                                  onPressed: () {
                                    _handleSubmitted(
                                        loveNote.text,
                                        "GestureNote",
                                        Constants.isMessageReply);
                                    loveNote.clear();
                                    Navigator.pop(context);
                                    widget.onCancelReplyMessage();

                                    // player.play('sendMessage.mp3'),
                                  })
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.send_outlined,
                                        size: 22,
                                        color: widget.inRelationShipId ==
                                                widget.receiverId
                                            ? romanticColor
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        _handleSubmitted(
                                            loveNote.text,
                                            "GestureNote",
                                            Constants.isMessageReply);
                                        loveNote.clear();
                                        Navigator.pop(context);
                                        widget.onCancelReplyMessage();
                                        // player.play('sendMessage.mp3'),
                                      }),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 30, bottom: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.pinkAccent.shade100, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),

                        // constraints: BoxConstraints.expand(),
                        child: new Scrollbar(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 0, left: 5, right: 5),
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'cute'),
                              cursorColor: Colors.white,
                              cursorHeight: 10,
                              controller: loveNote,
                              maxLength: 180,
                              onSaved: (v) {
                                print(v);
                              },
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 6,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                filled: true,
                                border: InputBorder.none,
                                focusColor: Colors.white,
                                hintStyle: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontFamily: 'cute'),
                                hintText: "Write Here..",
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _handleImageMessage() {
    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                 BarTop(),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text(
                      "Select an Option!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _sendImageFromCamera();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.blue.shade500,
                                  size: 50,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            imageFromGallery();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.blue.shade500,
                                  size: 50,
                                ),
                                Text(
                                  "Images",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )
                              ],
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

  void _handleSubmitted(String content, String type, String isMessageReply) {
    print(type);
    textController.clear();
    loveNote.clear();
    setState(() {
      _isComposing = false;
    });
    String imageUrl = "";

    sendMessage(content, type, Constants.isMessageReply);
    Constants.isMessageReply = 'no';
  }

  bool uploading = false;

  modalBottomSheetForOptions() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BarTop(),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "What You Want?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cute",
                           fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.red,
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        child: Text('Crop'),
                        onPressed: () {
                          cropImage(file.path);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.blue,
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        child: Text('Send'),
                        onPressed: () {
                          getImageUrl(file, 'image');
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.green,
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        child: Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String? imageUrl;
  late File file;

  _sendImageFromCamera() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxHeight: 680,
      maxWidth: 950,
    );
    setState(() {
      file = imageFile;
    });

    modalBottomSheetForOptions();
  }

  imageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 2500,
      maxWidth: 2500,
    );
    setState(() {
      file = imageFile;
    });
    modalBottomSheetForOptions();
  }


  cropImage(filePath) async {

    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    if (croppedFile != null) {
      file = croppedFile;
      String type = "image";
      Navigator.pop(context);
      // getImageUrl(file, 'image');
      modalBottomSheetForOptions();
    }
  }

  void getImageUrl(File? image, String type) async {
    final String fileName = Uuid().v4();

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child('ChatPhotos')
        .child(widget.groupChatId)
        .child(fileName);
    UploadTask uploadTask = ref.putFile(image!);
    uploadTask.whenComplete(() async {
      String uploadUrl = await ref.getDownloadURL();
      sendMessage(uploadUrl, type, "no");
      Navigator.pop(context);
    });
  }

  ///*** Check If User Exists ***\\\

  sendMessage(String content, String type, String isReplyMessage) {
    chatListRtDatabaseReference.child(widget.myId).child(widget.receiverId).set(
          messageDataBase.toMapForChatList(
            widget.receiverName,
            widget.receiverId,
            widget.receiverAvatar,
            widget.receiverEmail,
            content,
            widget.groupChatId,
            type,
            true,
          ),
        );
    chatListRtDatabaseReference.child(widget.receiverId).child(widget.myId).set(
          messageDataBase.toMapForChatList(
            Constants.myName,
            Constants.myId,
            Constants.myPhotoUrl,
            Constants.myEmail,
            content,
            widget.groupChatId,
            type,
            false,
          ),
        );

    messageRtDatabaseReference.child(widget.groupChatId).child(messageId).set(
          messageDataBase.toMap(
            widget.receiverName,
            widget.receiverId,
            widget.receiverAvatar,
            widget.receiverEmail,
            content,
            widget.groupChatId,
            type,
            messageId,
            isReplyMessage
          ),
        );

    messageId = Uuid().v4();
  }

  buildReply() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onCancelReplyMessage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear_outlined,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Container(
                    height: 20,


                  width: 3,),
                ),
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
                    child: Text(widget.replyMessage),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
