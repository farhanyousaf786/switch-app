//
//
// import 'dart:io';
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:switchtofuture/MainPages/switchChat/ChatFullImage.dart';
// import 'package:switchtofuture/MainPages/switchChat/SwitchChat.dart';
// import 'package:switchtofuture/MainPages/switchChat/audioMessageStateManager.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
// import 'package:uuid/uuid.dart';
// import 'MessageDatabase.dart';
// import 'package:just_audio/just_audio.dart';
//
// MessageDataBase messageDataBase = MessageDataBase();
// SwitchChat switchChat = SwitchChat();
//
// class SwitchMessages extends StatefulWidget {
//   final String myId;
//   final String groupChatId;
//   final String mood;
//   final String inRelationShipId;
//   final String receiverId;
//   final List listForSendButton;
//   final VoidCallback loveTextCallback;
//
//   const SwitchMessages(
//       {Key key,
//       this.myId,
//       this.groupChatId,
//       this.mood,
//       this.inRelationShipId,
//       this.receiverId,
//       this.listForSendButton,
//       this.loveTextCallback})
//       : super(key: key);
//
//   @override
//   _SwitchMessageState createState() => _SwitchMessageState();
// }
//
// class _SwitchMessageState extends State<SwitchMessages>
//     with TickerProviderStateMixin {
//   final ScrollController listScrollController = ScrollController();
//   TextEditingController copiedMessage = new TextEditingController();
//   final FocusNode focusNode = FocusNode();
//   int _limit = 15;
//   int _limitIncrement = 30;
//   bool isShowSticker;
//   String messageId = Uuid().v4();
//   bool isPlayingMsg = false;
//   int selectedIndex;
//
//   _scrollListener() {
//     if (listScrollController.offset >=
//             listScrollController.position.maxScrollExtent &&
//         !listScrollController.position.outOfRange) {
//       print("reach the top");
//       setState(() {
//         _limit += _limitIncrement;
//       });
//     }
//     if (listScrollController.offset <=
//             listScrollController.position.minScrollExtent &&
//         !listScrollController.position.outOfRange) {
//       print("reach the bottom");
//     }
//   }
//
//   AudioPlayer player;
//   PageManager _pageManager = PageManager();
//
//   @override
//   @override
//   void initState() {
//     super.initState();
//     focusNode.addListener(onFocusChange);
//     listScrollController.addListener(_scrollListener);
//     player = AudioPlayer();
//     _pageManager = PageManager();
//   }
//
//   void onFocusChange() {
//     if (focusNode.hasFocus) {
//       // Hide sticker when keyboard appear
//       setState(() {
//         isShowSticker = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: StreamBuilder(
//         stream: messageRtDatabaseReference
//             .child(widget.groupChatId)
//             .orderByChild("timeStamp")
//             .limitToLast(_limit)
//             .onValue,
//         builder: (context, dataSnapShot) {
//           if (dataSnapShot.hasData) {
//             DataSnapshot snapshot = dataSnapShot.data.snapshot;
//             Map data = snapshot.value;
//             List list = [];
//             if (data == null) {
//               return Scaffold(
//                 backgroundColor: Colors.white,
//                 body: Center(child: Text("")),
//               );
//             } else {
//               data.forEach((index, data) => list.add({"key": index, ...data}));
//               list.sort((b, a) {
//                 return a["timeStamp"].compareTo(b["timeStamp"]);
//               });
//               print(">>>>>> : ${list.length}");
//               return ShaderMask(
//                 shaderCallback: (Rect bounds) {
//                   return LinearGradient(
//                     colors: [Colors.white.withOpacity(0.000), Colors.white],
//                     stops: [0.0, 0.2],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     tileMode: TileMode.clamp,
//                   ).createShader(bounds);
//                 },
//                 child: new ListView.builder(
//                   shrinkWrap: true,
//                   reverse: true,
//                   controller: listScrollController,
//                   itemCount: data.length,
//                   itemBuilder: (context, index) => buildMessage(
//                     index,
//                     list,
//                   ),
//                 ),
//               );
//             }
//           }
//           return Padding(
//             padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
//             child: Text(
//               "",
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   int calculateDifference(DateTime date) {
//     DateTime now = DateTime.now();
//     return DateTime(date.year, date.month, date.day)
//         .difference(DateTime(now.year, now.month, now.day))
//         .inDays;
//   }
//
//   Widget buildMessage(
//     int index,
//     List lists,
//   ) {
//     String receiverName;
//     String senderName;
//     String senderId;
//     String receiverId;
//     String senderAvatar;
//     String receiverAvatar;
//     String receiverEmail;
//     String senderEmail;
//     String content;
//     String groupChatId;
//     String idFrom;
//     String timeStamp;
//     String type;
//     String messageId;
//     DateTime dateTime;
//
//     receiverName = lists[index]['receiverName'];
//     senderName = lists[index]['senderName'];
//     content = lists[index]['content'];
//     receiverAvatar = lists[index]['receiverAvatar'];
//     senderAvatar = lists[index]['senderAvatar'];
//     receiverId = lists[index]['receiverId'];
//     senderId = lists[index]['senderId'];
//     receiverEmail = lists[index]['receiverEmail'];
//     senderEmail = lists[index]['senderEmail'];
//     groupChatId = lists[index]['groupChatId'];
//     idFrom = lists[index]['idFrom'];
//     timeStamp = lists[index]['timeStamp'];
//     type = lists[index]['type'];
//     messageId = lists[index]['messageId'];
//
//     return idFrom != widget.myId
//         ? _leftSide(
//             context,
//             groupChatId,
//             idFrom,
//             receiverId,
//             receiverEmail,
//             receiverAvatar,
//             receiverName,
//             senderId,
//             senderEmail,
//             senderAvatar,
//             senderName,
//             content,
//             timeStamp,
//             type,
//             index,
//           )
//         : _rightSide(
//             context,
//             groupChatId,
//             idFrom,
//             receiverId,
//             receiverEmail,
//             receiverAvatar,
//             receiverName,
//             senderId,
//             senderEmail,
//             senderAvatar,
//             senderName,
//             content,
//             timeStamp,
//             type,
//             messageId,
//             index,
//           );
//   }
//
//   /// Left side chat Screen ///
//
//   _leftSide(
//       BuildContext context,
//       String groupChatId,
//       String idFrom,
//       String receiverId,
//       String receiverEmail,
//       String receiverAvatar,
//       String receiverName,
//       String senderId,
//       String senderEmail,
//       String senderAvatar,
//       String senderName,
//       String content,
//       String timeStamp,
//       String type,
//       int index) {
//     return GestureDetector(
//       onLongPress: () {
//         Clipboard.setData(ClipboardData(text: content));
//
//         _bottomSheetForMessage(messageId, timeStamp, content, type, senderId);
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   _leftContent(
//                     groupChatId,
//                     idFrom,
//                     receiverId,
//                     receiverEmail,
//                     receiverAvatar,
//                     receiverName,
//                     senderId,
//                     senderEmail,
//                     senderAvatar,
//                     senderName,
//                     content,
//                     timeStamp,
//                     type,
//                     index,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _leftContent(
//       String groupChatId,
//       String idFrom,
//       String receiverId,
//       String receiverEmail,
//       String receiverAvatar,
//       String receiverName,
//       String senderId,
//       String senderEmail,
//       String senderAvatar,
//       String senderName,
//       String content,
//       String timeStamp,
//       String type,
//       int index) {
//     if (type == "text") {
//       return Container(
//         margin: EdgeInsets.only(left: 20.0),
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Container(
//                   child: Text(
//                     content,
//                     style: TextStyle(color: Colors.black, fontSize: 15),
//                   ),
//                   padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
//                   width: content.length <= 8
//                       ? 100
//                       : content.length <= 12
//                           ? 140
//                           : content.length <= 15
//                               ? 155
//                               : content.length <= 20
//                                   ? 200
//                                   : 250,
//                   decoration: widget.receiverId != widget.inRelationShipId
//                       ? BoxDecoration(
//                           color: Colors.blue.shade100,
//                           borderRadius: BorderRadius.circular(15.0),
//                         )
//                       : BoxDecoration(
//                           color: widget.mood == 'romantic'
//                               ? Colors.pinkAccent.shade100
//                               : widget.mood == 'sad'
//                                   ? Colors.grey.shade500
//                                   : widget.mood == 'break'
//                                       ? Colors.lightBlue.shade200
//                                       : widget.mood == 'angry'
//                                           ? Colors.red.shade200
//                                           : widget.mood == 'ignore'
//                                               ? Colors.teal.shade200
//                                               : Colors.purpleAccent,
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                   margin: EdgeInsets.only(left: 5.0),
//                 )
//               ],
//             ),
//             Container(
//               child: Text(
//                 DateFormat('hh:mm a').format(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     int.parse(timeStamp),
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.black54,
//                 ),
//               ),
//               margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
//             ),
//           ],
//           crossAxisAlignment: CrossAxisAlignment.start,
//         ),
//       );
//     } else if (type == "image") {
//       return Padding(
//         padding: const EdgeInsets.only(left: 20),
//         child: Column(
//           children: [
//             Container(
//               margin: EdgeInsets.only(right: 20.0),
//               child: FlatButton(
//                 child: Material(
//                   elevation: 0,
//                   child: CachedNetworkImage(
//                     placeholder: (context, url) => Container(
//                       child: CircularProgressIndicator(
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(Colors.lightBlue),
//                       ),
//                       width: 200.0,
//                       height: 200.0,
//                       padding: EdgeInsets.all(70.0),
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         border: Border.all(width: 1, color: Colors.black12),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => Material(
//                       child: Image.asset(
//                         null,
//                         width: 200.0,
//                         height: 200.0,
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(
//                           8.0,
//                         ),
//                       ),
//                       clipBehavior: Clip.hardEdge,
//                     ),
//                     imageUrl: content,
//                     width: 200.0,
//                     height: 200.0,
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(15.0),
//                   ),
//                   clipBehavior: Clip.hardEdge,
//                 ),
//                 onPressed: () => {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatFullImage(
//                         url: content,
//                       ),
//                     ),
//                   ),
//                 },
//                 padding: EdgeInsets.all(0),
//               ),
//             ),
//             Container(
//               child: Text(
//                 DateFormat('dd MMM, hh:mm a').format(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     int.parse(timeStamp),
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.black54,
//                 ),
//               ),
//               margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
//             )
//           ],
//         ),
//       );
//     } else if (type == "GestureNote") {
//       return GestureDetector(
//         onTap: () {
//           widget.loveTextCallback();
//           setState(() {
//             Constants.content = content;
//             Constants.timeStamp = timeStamp;
//           });
//         },
//         child: Column(
//           children: [
//             Container(
//               margin: EdgeInsets.only(left: 20.0),
//               clipBehavior: Clip.antiAlias,
//               decoration: new BoxDecoration(
//                 borderRadius: BorderRadius.circular(18.0),
//                 border: Border.all(width: 3, color: Colors.pink.shade100),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Love Note",
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 18,
//                         fontFamily: 'cute',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 30),
//               child: Container(
//                 child: Text(
//                   DateFormat('hh:mm a').format(
//                     DateTime.fromMillisecondsSinceEpoch(
//                       int.parse(timeStamp),
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else if (type == 'audio') {
//       return Padding(
//         padding: const EdgeInsets.only(left: 15),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(15.0),
//             ),
//             color: widget.mood == 'romantic'
//                 ? Colors.pinkAccent.shade100
//                 : widget.mood == 'sad'
//                     ? Colors.grey.shade500
//                     : widget.mood == 'break'
//                         ? Colors.lightBlue.shade200
//                         : widget.mood == 'angry'
//                             ? Colors.red.shade200
//                             : widget.mood == 'ignore'
//                                 ? Colors.teal.shade200
//                                 : Colors.purpleAccent,
//           ),
//           height: selectedIndex == index ? 70 : 50,
//           width: 200,
//           child: Column(
//             children: [
//               Row(
//                   // mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Padding(
//                         padding: EdgeInsets.only(left: 10), child: Text("Audio")
//
//                         // _playerControl(index, content),
//                         ),
//                   ])
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   _profilePicture(String receiverAvatar, String senderAvatar, String senderId,
//       int index, String uid) {
//     if (uid == senderId) {
//       return Container(
//         width: 35,
//         height: 35,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black, width: 1),
//           image: DecorationImage(
//             image: NetworkImage(receiverAvatar),
//           ),
//         ),
//       );
//     } else {
//       return senderAvatar == null
//           ? Text("Loading..")
//           : Container(
//               width: 35,
//               height: 35,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black, width: 1),
//                 image: DecorationImage(
//                   image: NetworkImage(receiverAvatar),
//                 ),
//               ),
//             );
//     }
//   }
//
//   Widget buildChatList(int index, List lists, String content, String type) {
//     String receiverName;
//     String senderName;
//     String senderId;
//     String receiverId;
//     String senderAvatar;
//     String receiverAvatar;
//     String receiverEmail;
//     String senderEmail;
//     String groupChatId;
//
//     receiverName = lists[index]['receiverName'];
//     senderName = lists[index]['senderName'];
//     senderId = lists[index]['senderId'];
//     receiverId = lists[index]['receiverId'];
//     senderAvatar = lists[index]['senderAvatar'];
//     receiverAvatar = lists[index]['receiverAvatar'];
//     receiverEmail = lists[index]['receiverEmail'];
//     senderEmail = lists[index]['senderEmail'];
//
//     groupChatId = lists[index]['groupChatId'];
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _profilePicture(receiverAvatar, senderAvatar, senderId, index,
//                   Constants.myId),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   receiverName,
//                   style: TextStyle(fontFamily: 'cute'),
//                 ),
//               ),
//             ],
//           ),
//           ElevatedButton(
//             child: Text(
//               'Send ',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold),
//             ),
//             onPressed: () => {
//               messageRtDatabaseReference
//                   .child(groupChatId)
//                   .child(messageId)
//                   .set(
//                     messageDataBase.toMap(
//                         receiverName,
//                         receiverId,
//                         receiverAvatar,
//                         receiverEmail,
//                         content,
//                         groupChatId,
//                         type,
//                         messageId),
//                   ),
//             },
//             style: ElevatedButton.styleFrom(
//                 elevation: 0.0,
//                 primary: Colors.blue.shade300,
//                 textStyle:
//                     TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _bottomSheetForMessage(String messageId, String timeStamp, String content,
//       String type, String compareId) {
//     return showModalBottomSheet(
//         useRootNavigator: true,
//         isScrollControlled: true,
//         barrierColor: Colors.red.withOpacity(0.2),
//         elevation: 0,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         context: context,
//         builder: (context) {
//           return Container(
//             color: Colors.white,
//             height: MediaQuery.of(context).size.height / 3.5,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           DateFormat('dd MMM, hh:mm a').format(
//                             DateTime.fromMillisecondsSinceEpoch(
//                               int.parse(timeStamp),
//                             ),
//                           ),
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.black54,
//                               fontFamily: 'cute'),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
//                     child: ElevatedButton(
//                       child: Row(
//                         children: [
//                           Text(
//                             'Forward ',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontFamily: 'cutes',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Icon(
//                             Icons.arrow_forward,
//                             color: Colors.black,
//                             size: 17,
//                           ),
//                         ],
//                       ),
//                       onPressed: () async {
//                         ClipboardData data =
//                             await Clipboard.getData('text/plain');
//
//                         copiedMessage.text = data.text.toString();
//                         showModalBottomSheet(
//                             useRootNavigator: true,
//                             isScrollControlled: true,
//                             barrierColor: Colors.red.withOpacity(0.2),
//                             elevation: 0,
//                             clipBehavior: Clip.antiAliasWithSaveLayer,
//                             context: context,
//                             builder: (context) {
//                               return Container(
//                                   height:
//                                       MediaQuery.of(context).size.height / 1.2,
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         color: Colors.lightBlueAccent,
//                                         height: 50,
//                                         child: Center(
//                                             child: Text(
//                                           "Chat List",
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontFamily: 'cute',
//                                               color: Colors.white),
//                                         )),
//                                       ),
//                                       ListView.builder(
//                                           shrinkWrap: true,
//                                           itemCount:
//                                               widget.listForSendButton.length,
//                                           itemBuilder: (context, index) =>
//                                               buildChatList(
//                                                 index,
//                                                 widget.listForSendButton,
//                                                 copiedMessage.text,
//                                                 type,
//                                               )),
//                                     ],
//                                   ));
//                             });
//                       },
//                       style: ElevatedButton.styleFrom(
//                           elevation: 0.0,
//                           primary: Colors.white,
//                           textStyle: TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                   type == 'image'
//                       ? Text("")
//                       : Padding(
//                           padding: const EdgeInsets.only(
//                               top: 0, left: 10, right: 10),
//                           child: ElevatedButton(
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Copy ',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontFamily: 'cutes',
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Icon(
//                                   Icons.copy,
//                                   color: Colors.black,
//                                   size: 17,
//                                 ),
//                               ],
//                             ),
//                             onPressed: () => {
//                               Clipboard.setData(ClipboardData(text: content)),
//                               Fluttertoast.showToast(
//                                 msg: "Copied",
//                                 toastLength: Toast.LENGTH_LONG,
//                                 gravity: ToastGravity.CENTER,
//                                 timeInSecForIosWeb: 3,
//                                 backgroundColor: Colors.blue.withOpacity(0.8),
//                                 textColor: Colors.white,
//                                 fontSize: 16.0,
//                               ),
//                               Navigator.pop(context),
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 elevation: 0.0,
//                                 primary: Colors.white,
//                                 textStyle: TextStyle(
//                                     fontSize: 15, fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                   compareId != Constants.myId
//                       ? Text("")
//                       : Padding(
//                           padding: const EdgeInsets.only(
//                               top: 0, left: 10, right: 10),
//                           child: ElevatedButton(
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Delete ',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontFamily: 'cutes',
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Icon(
//                                   Icons.delete_outline,
//                                   color: Colors.black,
//                                   size: 20,
//                                 ),
//                               ],
//                             ),
//                             onPressed: () => {
//                               messageRtDatabaseReference
//                                   .child(widget.groupChatId)
//                                   .child(messageId)
//                                   .remove(),
//                               print(widget.groupChatId),
//                               print(messageId),
//                               Navigator.pop(context),
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 elevation: 0.0,
//                                 primary: Colors.white,
//                                 textStyle: TextStyle(
//                                     fontSize: 15, fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   /// Right side chat Screen ///
//
//   _rightSide(
//       BuildContext context,
//       String groupChatId,
//       String idFrom,
//       String receiverId,
//       String receiverEmail,
//       String receiverAvatar,
//       String receiverName,
//       String senderId,
//       String senderEmail,
//       String senderAvatar,
//       String senderName,
//       String content,
//       String timeStamp,
//       String type,
//       String messageId,
//       int index) {
//     return GestureDetector(
//       onLongPress: () {
//         Clipboard.setData(ClipboardData(text: content));
//
//         _bottomSheetForMessage(
//           messageId,
//           timeStamp,
//           content,
//           type,
//           senderId,
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   _rightContent(
//                     groupChatId,
//                     idFrom,
//                     receiverId,
//                     receiverEmail,
//                     receiverAvatar,
//                     receiverName,
//                     senderId,
//                     senderEmail,
//                     senderAvatar,
//                     senderName,
//                     content,
//                     timeStamp,
//                     type,
//                     index,
//                   ),
//                 ],
//               ),
//             ),
//             // Container(
//             //   margin: const EdgeInsets.only(right: 16.0),
//             //   child: CircleAvatar(child: Text(senderName[0])),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _rightContent(
//     String groupChatId,
//     String idFrom,
//     String receiverId,
//     String receiverEmail,
//     String receiverAvatar,
//     String receiverName,
//     String senderId,
//     String senderEmail,
//     String senderAvatar,
//     String senderName,
//     String content,
//     String timeStamp,
//     String type,
//     int index,
//   ) {
//     if (type == "text") {
//       return Padding(
//         padding: const EdgeInsets.only(right: 20),
//         child: Column(children: <Widget>[
//           Row(
//             children: <Widget>[
//               Container(
//                 child: Text(
//                   content,
//                   style: TextStyle(color: Colors.black, fontSize: 15),
//                 ),
//                 padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
//                 width: content.length <= 8
//                     ? 100
//                     : content.length <= 12
//                         ? 140
//                         : content.length <= 15
//                             ? 155
//                             : content.length <= 20
//                                 ? 200
//                                 : 250,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(15.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.white,
//                       offset: Offset(0.0, .5), //(x,y)
//                       blurRadius: 0.0,
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(right: 10.0),
//               )
//             ],
//             mainAxisAlignment:
//                 MainAxisAlignment.end, // aligns the chatitem to right end
//           ),
//           Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
//             Container(
//               child: Text(
//                 DateFormat('hh:mm a').format(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     int.parse(timeStamp),
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: 9,
//                   color: Colors.black54,
//                 ),
//               ),
//               margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
//             )
//           ])
//         ]),
//       );
//     } else if (type == 'image') {
//       // return Image.network(imageUrl);
//
//       return Column(
//         children: [
//           Container(
//             margin: EdgeInsets.only(right: 20.0),
//             child: FlatButton(
//               child: Material(
//                 elevation: 0,
//                 child: CachedNetworkImage(
//                   placeholder: (context, url) => Container(
//                     child: CircularProgressIndicator(
//                       valueColor:
//                           AlwaysStoppedAnimation<Color>(Colors.lightBlue),
//                     ),
//                     width: 200.0,
//                     height: 200.0,
//                     padding: EdgeInsets.all(70.0),
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       border: Border.all(width: 1, color: Colors.black12),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10.0),
//                       ),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Material(
//                     child: Image.asset(
//                       null,
//                       width: 200.0,
//                       height: 200.0,
//                       fit: BoxFit.cover,
//                     ),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(
//                         8.0,
//                       ),
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                   ),
//                   imageUrl: content,
//                   width: 200.0,
//                   height: 200.0,
//                   fit: BoxFit.cover,
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(15.0),
//                 ),
//                 clipBehavior: Clip.hardEdge,
//               ),
//               onPressed: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatFullImage(
//                       url: content,
//                     ),
//                   ),
//                 ),
//               },
//               padding: EdgeInsets.all(0),
//             ),
//           ),
//           Container(
//             child: Text(
//               DateFormat('dd MMM, hh:mm a').format(
//                 DateTime.fromMillisecondsSinceEpoch(
//                   int.parse(timeStamp),
//                 ),
//               ),
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.black54,
//               ),
//             ),
//             margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
//           )
//         ],
//       );
//     } else if (type == "GestureNote") {
//       return GestureDetector(
//         onTap: () {
//           widget.loveTextCallback();
//           setState(() {
//             Constants.content = content;
//             Constants.timeStamp = timeStamp;
//           });
//         },
//         child: Column(
//           children: [
//             Container(
//                 margin: EdgeInsets.only(right: 20.0),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: new BoxDecoration(
//                   borderRadius: BorderRadius.circular(18.0),
//                   border: Border.all(width: 3, color: Colors.pink.shade100),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Love Note",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 18,
//                           fontFamily: 'cute',
//                         ),
//                       ),
//                     ],
//                   ),
//                 )),
//             Padding(
//               padding: const EdgeInsets.only(left: 30),
//               child: Container(
//                 child: Text(
//                   DateFormat('hh:mm a').format(
//                     DateTime.fromMillisecondsSinceEpoch(
//                       int.parse(timeStamp),
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else if (type == 'audio') {
//       return Padding(
//         padding: const EdgeInsets.only(right: 15),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(15.0),
//             ),
//             color: selectedIndex == index
//                 ? Colors.blue.shade100
//                 : Colors.grey.shade300,
//           ),
//           height: selectedIndex == index ? 150 : 120,
//           width: 220,
//           child: Column(
//             children: [
//               const Spacer(),
//               ValueListenableBuilder<ProgressBarState>(
//                 valueListenable: _pageManager.progressNotifier,
//                 builder: (_, value, __) {
//                   return ProgressBar(
//                     progress: value.current,
//                     buffered: value.buffered,
//                     total: value.total,
//                     onSeek: _pageManager.seek,
//                   );
//                 },
//               ),
//               ValueListenableBuilder<ButtonState>(
//                 valueListenable: _pageManager.buttonNotifier,
//                 builder: (_, value, __) {
//                   switch (value) {
//                     case ButtonState.loading:
//                       return Container(
//                         margin: const EdgeInsets.all(8.0),
//                         width: 32.0,
//                         height: 32.0,
//                         child: const CircularProgressIndicator(),
//                       );
//                     case ButtonState.paused:
//                       return selectedIndex != index
//                           ? IconButton(
//                               icon: Icon(Icons.play_arrow),
//                               iconSize: 32.0,
//                               onPressed: () => {
//
//
//                                 setState(() {
//                                   selectedIndex = index;
//                                 }),
//                                 _pageManager.init(content),
//                                 Future.delayed(const Duration(seconds: 1), () {
//                                   _pageManager.play();
//                                 })
//                               },
//                             )
//                           : IconButton(
//                               icon: const Icon(Icons.pause),
//                               iconSize: 32.0,
//                               onPressed: _pageManager.pause,
//                             );
//                     case  ButtonState.playing:
//                       return   IconButton(
//                         icon:  Icon(  Icons.pause ),
//                         iconSize: 32.0,
//                         onPressed: _pageManager.pause,
//                       );
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   bool isPlaying = false;
//
//   playerControl(index, content) {
//     return GestureDetector(
//         onTap: () async {
//           if (isPlaying) {
//             setState(() {
//               selectedIndex = index;
//               isPlaying = false;
//             });
//             player.stop();
//           } else {
//             setState(() {
//               selectedIndex = index;
//               isPlaying = true;
//             });
//
//             await player.setUrl(content);
//
//             player.play();
//           }
//         },
//         child: Icon(selectedIndex == index
//             ? isPlaying
//                 ? Icons.pause
//                 : Icons.play_arrow_outlined
//             : Icons.play_arrow_outlined));
//   }
//
//   @override
//   void dispose() {
//     player.dispose();
//     _pageManager.dispose();
//
//     super.dispose();
//   }
// }

///
///
///

import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:switchapp/MainPages/switchChat/ChatFullImage.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChat.dart';
import 'package:switchapp/MainPages/switchChat/audioMessageStateManager.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';
import 'MessageDatabase.dart';
import 'package:just_audio/just_audio.dart';

MessageDataBase messageDataBase = MessageDataBase();

class SwitchMessages extends StatefulWidget {
  final String myId;
  final String groupChatId;
  final String mood;
  final String inRelationShipId;
  final String receiverId;
  final List listForSendButton;
  final VoidCallback loveTextCallback;
  final ValueChanged onSwipedMessage;

  const SwitchMessages(
      {required this.myId,
      required this.groupChatId,
      required this.mood,
      required this.inRelationShipId,
      required this.receiverId,
      required this.listForSendButton,
      required this.loveTextCallback,
      required this.onSwipedMessage});

  @override
  _SwitchMessageState createState() => _SwitchMessageState();
}

class _SwitchMessageState extends State<SwitchMessages>
    with TickerProviderStateMixin {
  final ScrollController listScrollController = ScrollController();
  TextEditingController copiedMessage = new TextEditingController();
  final FocusNode focusNode = FocusNode();
  int _limit = 15;
  int _limitIncrement = 30;
  late bool isShowSticker;
  String messageId = Uuid().v4();
  bool isPlayingMsg = false;
  int? selectedIndex;

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
    }
  }

  AudioPlayer? player;
  PageManager? _pageManager = PageManager();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    player = AudioPlayer();
    _pageManager = PageManager();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: messageRtDatabaseReference
            .child(widget.groupChatId)
            .orderByChild("timeStamp")
            .limitToLast(_limit)
            .onValue,
        builder: (context, AsyncSnapshot dataSnapShot) {
          if (dataSnapShot.hasData) {
            DataSnapshot snapshot = dataSnapShot.data.snapshot;
            Map data = snapshot.value;
            List list = [];
            if (data == null) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: Text("")),
              );
            } else {
              data.forEach((index, data) => list.add({"key": index, ...data}));
              list.sort((b, a) {
                return a["timeStamp"].compareTo(b["timeStamp"]);
              });
              // print(">>>>>> : ${list.length}");
              return ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.white.withOpacity(0.000), Colors.white],
                    stops: [0.0, 0.2],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp,
                  ).createShader(bounds);
                },
                child: new ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  controller: listScrollController,
                  itemCount: data.length,
                  itemBuilder: (context, index) => buildMessage(
                    index,
                    list,
                  ),
                ),
              );
            }
          }
          return Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Text(
              "",
            ),
          );
        },
      ),
    );
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  Widget buildMessage(
    int index,
    List lists,
  ) {
    String receiverName;
    String senderName;
    String senderId;
    String receiverId;
    String senderAvatar;
    String receiverAvatar;
    String receiverEmail;
    String senderEmail;
    String content;
    String groupChatId;
    String idFrom;
    String timeStamp;
    String type;
    String messageId;
    DateTime dateTime;
    String isReplyMessage = "";
    receiverName = lists[index]['receiverName'];
    senderName = lists[index]['senderName'];
    content = lists[index]['content'];
    receiverAvatar = lists[index]['receiverAvatar'];
    senderAvatar = lists[index]['senderAvatar'];
    receiverId = lists[index]['receiverId'];
    senderId = lists[index]['senderId'];
    receiverEmail = lists[index]['receiverEmail'];
    senderEmail = lists[index]['senderEmail'];
    groupChatId = lists[index]['groupChatId'];
    idFrom = lists[index]['idFrom'];
    timeStamp = lists[index]['timeStamp'];
    type = lists[index]['type'];
    messageId = lists[index]['messageId'];

    if (lists[index]['isReplyMessage'] == null) {
      isReplyMessage = 'no';
    } else {
      isReplyMessage = lists[index]['isReplyMessage'];
      print("isReply Message: : : " + isReplyMessage);
    }

    return idFrom != widget.myId
        ? _leftSide(
            context,
            groupChatId,
            idFrom,
            receiverId,
            receiverEmail,
            receiverAvatar,
            receiverName,
            senderId,
            senderEmail,
            senderAvatar,
            senderName,
            content,
            timeStamp,
            type,
            index,
            isReplyMessage,
          )
        : _rightSide(
            context,
            groupChatId,
            idFrom,
            receiverId,
            receiverEmail,
            receiverAvatar,
            receiverName,
            senderId,
            senderEmail,
            senderAvatar,
            senderName,
            content,
            timeStamp,
            type,
            messageId,
            index,
            isReplyMessage);
  }

  /// Left side chat Screen ///

  _leftSide(
    BuildContext context,
    String groupChatId,
    String idFrom,
    String receiverId,
    String receiverEmail,
    String receiverAvatar,
    String receiverName,
    String senderId,
    String senderEmail,
    String senderAvatar,
    String senderName,
    String content,
    String timeStamp,
    String type,
    int index,
    String isReplyMessage,
  ) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: content));

        _bottomSheetForMessage(messageId, timeStamp, content, type, senderId);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _leftContent(
                      groupChatId,
                      idFrom,
                      receiverId,
                      receiverEmail,
                      receiverAvatar,
                      receiverName,
                      senderId,
                      senderEmail,
                      senderAvatar,
                      senderName,
                      content,
                      timeStamp,
                      type,
                      index,
                      isReplyMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _leftContent(
    String groupChatId,
    String idFrom,
    String receiverId,
    String receiverEmail,
    String receiverAvatar,
    String receiverName,
    String senderId,
    String senderEmail,
    String senderAvatar,
    String senderName,
    String content,
    String timeStamp,
    String type,
    int index,
    String isReplyMessage,
  ) {
    if (isReplyMessage[0] != "n") {
      return SwipeTo(
        onRightSwipe: () => {
          widget.onSwipedMessage(content),
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 23),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: Colors.grey.shade300,
                    ),
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 18, bottom: 5, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "${isReplyMessage.substring(3)}",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, right: 10, bottom: 5, left: 15),
                            child: Text(
                              "Reply Of",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 9,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 18, bottom: 5, right: 20),
                        child: Text(content),
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      if (type == "text") {
        return SwipeTo(
          onRightSwipe: () => {
            widget.onSwipedMessage(content),
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        content,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: content.length <= 8
                          ? 100
                          : content.length <= 12
                              ? 140
                              : content.length <= 15
                                  ? 155
                                  : content.length <= 20
                                      ? 200
                                      : 250,
                      decoration: widget.receiverId != widget.inRelationShipId
                          ? BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : BoxDecoration(
                              color: widget.mood == 'romantic'
                                  ? Colors.pinkAccent.shade100
                                  : widget.mood == 'sad'
                                      ? Colors.grey.shade500
                                      : widget.mood == 'break'
                                          ? Colors.lightBlue.shade200
                                          : widget.mood == 'angry'
                                              ? Colors.red.shade200
                                              : widget.mood == 'ignore'
                                                  ? Colors.teal.shade200
                                                  : Colors.purpleAccent,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                      margin: EdgeInsets.only(left: 5.0),
                    )
                  ],
                ),
                Container(
                  child: Text(
                    DateFormat('hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(timeStamp),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        );
      } else if (type == "image") {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: ElevatedButton(
                  child: Material(
                    elevation: 0,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                        ),
                        width: 200.0,
                        height: 200.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 1, color: Colors.black12),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Material(
                        child: Image.asset(
                          "null",
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            8.0,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: content,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatFullImage(
                          url: content,
                        ),
                      ),
                    ),
                  },
                  // padding: EdgeInsets.all(0),
                ),
              ),
              Container(
                child: Text(
                  DateFormat('dd MMM, hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(timeStamp),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              )
            ],
          ),
        );
      } else if (type == "GestureNote") {
        return GestureDetector(
          onTap: () {
            widget.loveTextCallback();
            setState(() {
              Constants.content = content;
              Constants.timeStamp = timeStamp;
            });
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                clipBehavior: Clip.antiAlias,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(width: 3, color: Colors.pink.shade100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Love Note",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontFamily: 'cute',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  child: Text(
                    DateFormat('hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(timeStamp),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                ),
              ),
            ],
          ),
        );
      } else if (type == 'audio') {
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              color: selectedIndex == index
                  ? Colors.blue.shade100
                  : Colors.grey.shade300,
            ),
            height: selectedIndex == index ? 100 : 65,
            width: selectedIndex == index ? 200 : 150,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Audio Message",
                      style: TextStyle(fontSize: 9, color: Colors.black87),
                    ),
                  ),
                  ValueListenableBuilder<ProgressBarState>(
                    valueListenable: _pageManager!.progressNotifier,
                    builder: (_, value, __) {
                      return selectedIndex == index
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 150,
                                height: 20,
                                child: ProgressBar(
                                  progress: value.current,
                                  buffered: value.buffered,
                                  total: value.total,
                                  onSeek: _pageManager!.seek,
                                  barHeight: 3,
                                  thumbRadius: 6,
                                  thumbGlowRadius: 12,
                                  timeLabelTextStyle: TextStyle(
                                      fontSize: 11, color: Colors.black),
                                  timeLabelPadding: 3,
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                  selectedIndex == index
                      ? ValueListenableBuilder<ButtonState>(
                          valueListenable: _pageManager!.buttonNotifier,
                          builder: (_, value, __) {
                            switch (value) {
                              case ButtonState.loading:
                                return Container(
                                  width: 15.0,
                                  height: 15.0,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                );
                              case ButtonState.paused:
                                return IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  iconSize: 25.0,
                                  onPressed: () => {
                                    setState(() {
                                      isPlaying = true;
                                      selectedIndex = index;
                                    }),
                                    _pageManager!.init(content),
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      _pageManager!.play();
                                    })
                                  },
                                );
                              case ButtonState.playing:
                                return IconButton(
                                  icon: Icon(Icons.pause),
                                  iconSize: 25.0,
                                  onPressed: _pageManager!.pause,
                                );
                            }
                          },
                        )
                      : GestureDetector(
                          onTap: () => {
                                if (isPlaying)
                                  {
                                    setState(() {
                                      isPlaying = false;
                                      _pageManager!.pause();
                                    }),
                                  }
                                else
                                  {
                                    setState(() {
                                      selectedIndex = index;
                                    }),
                                  },
                              },
                          child: Column(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                size: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Double tap to listen",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.black54),
                                ),
                              ),
                            ],
                          )),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  _profilePicture(String receiverAvatar, String senderAvatar, String senderId,
      int index, String uid) {
    if (uid == senderId) {
      return Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
          image: DecorationImage(
            image: NetworkImage(receiverAvatar),
          ),
        ),
      );
    } else {
      return senderAvatar == null
          ? Text("Loading..")
          : Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
                image: DecorationImage(
                  image: NetworkImage(receiverAvatar),
                ),
              ),
            );
    }
  }

  Widget buildChatList(int index, List lists, String content, String type) {
    String receiverName;
    String senderName;
    String senderId;
    String receiverId;
    String senderAvatar;
    String receiverAvatar;
    String receiverEmail;
    String senderEmail;
    String groupChatId;

    receiverName = lists[index]['receiverName'];
    senderName = lists[index]['senderName'];
    senderId = lists[index]['senderId'];
    receiverId = lists[index]['receiverId'];
    senderAvatar = lists[index]['senderAvatar'];
    receiverAvatar = lists[index]['receiverAvatar'];
    receiverEmail = lists[index]['receiverEmail'];
    senderEmail = lists[index]['senderEmail'];

    groupChatId = lists[index]['groupChatId'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _profilePicture(receiverAvatar, senderAvatar, senderId, index,
                  Constants.myId),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  receiverName,
                  style: TextStyle(fontFamily: 'cute'),
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: Text(
              'Send ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () => {
              messageRtDatabaseReference
                  .child(groupChatId)
                  .child(messageId)
                  .set(
                    messageDataBase.toMap(
                        receiverName,
                        receiverId,
                        receiverAvatar,
                        receiverEmail,
                        content,
                        groupChatId,
                        type,
                        messageId,
                        "no"),
                  ),
            },
            style: ElevatedButton.styleFrom(
                elevation: 0.0,
                primary: Colors.blue.shade300,
                textStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  _bottomSheetForMessage(String messageId, String timeStamp, String content,
      String type, String compareId) {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 3.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('dd MMM, hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(timeStamp),
                            ),
                          ),
                          style: TextStyle(fontSize: 12, fontFamily: 'cute'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                    child: ElevatedButton(
                      child: Row(
                        children: [
                          Text(
                            'Forward ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'cutes',
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 17,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        ClipboardData? data =
                            await Clipboard.getData('text/plain');

                        copiedMessage.text = data!.text.toString();
                        showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            barrierColor: Colors.red.withOpacity(0.2),
                            elevation: 0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            context: context,
                            builder: (context) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.2,
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
                                              Icon(
                                                Icons.linear_scale_sharp,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Colors.blue,
                                      ),
                                      Container(
                                        color: Colors.lightBlue,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          "Chat List",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'cute',
                                              color: Colors.white),
                                        )),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.listForSendButton.length,
                                          itemBuilder: (context, index) =>
                                              buildChatList(
                                                index,
                                                widget.listForSendButton,
                                                copiedMessage.text,
                                                type,
                                              )),
                                    ],
                                  ));
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: Colors.white,
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  type == 'image'
                      ? Text("")
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 10, right: 10),
                          child: ElevatedButton(
                            child: Row(
                              children: [
                                Text(
                                  'Copy ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'cutes',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.copy,
                                  color: Colors.black,
                                  size: 17,
                                ),
                              ],
                            ),
                            onPressed: () => {
                              Clipboard.setData(ClipboardData(text: content)),
                              Fluttertoast.showToast(
                                msg: "Copied",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                textColor: Colors.white,
                                fontSize: 16.0,
                              ),
                              Navigator.pop(context),
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Colors.white,
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                  compareId != Constants.myId
                      ? Text("")
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 10, right: 10),
                          child: ElevatedButton(
                            child: Row(
                              children: [
                                Text(
                                  'Delete ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'cutes',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                            onPressed: () => {
                              messageRtDatabaseReference
                                  .child(widget.groupChatId)
                                  .child(messageId)
                                  .remove(),
                              print(widget.groupChatId),
                              print(messageId),
                              Navigator.pop(context),
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Colors.white,
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }

  /// Right side chat Screen ///

  _rightSide(
    BuildContext context,
    String groupChatId,
    String idFrom,
    String receiverId,
    String receiverEmail,
    String receiverAvatar,
    String receiverName,
    String senderId,
    String senderEmail,
    String senderAvatar,
    String senderName,
    String content,
    String timeStamp,
    String type,
    String messageId,
    int index,
    String isReplyMessage,
  ) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: content));

        _bottomSheetForMessage(
          messageId,
          timeStamp,
          content,
          type,
          senderId,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _rightContent(
                    groupChatId,
                    idFrom,
                    receiverId,
                    receiverEmail,
                    receiverAvatar,
                    receiverName,
                    senderId,
                    senderEmail,
                    senderAvatar,
                    senderName,
                    content,
                    timeStamp,
                    type,
                    index,
                    isReplyMessage,
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(right: 16.0),
            //   child: CircleAvatar(child: Text(senderName[0])),
            // ),
          ],
        ),
      ),
    );
  }

  _rightContent(
    String groupChatId,
    String idFrom,
    String receiverId,
    String receiverEmail,
    String receiverAvatar,
    String receiverName,
    String senderId,
    String senderEmail,
    String senderAvatar,
    String senderName,
    String content,
    String timeStamp,
    String type,
    int index,
    String isReplyMessage,
  ) {
    if (isReplyMessage[0] != "n") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 23),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.grey.shade300,
                      ),
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 18, bottom: 5, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${isReplyMessage.substring(3)}",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, right: 10, bottom: 5, left: 15),
                              child: Text(
                                "Reply Of",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 9,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 18, bottom: 5, right: 20),
                          child: Text(content),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      if (type == "text") {
        return SwipeTo(
          onRightSwipe: () => {
            widget.onSwipedMessage(content),
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      content,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: content.length <= 8
                        ? 100
                        : content.length <= 12
                            ? 140
                            : content.length <= 15
                                ? 155
                                : content.length <= 20
                                    ? 200
                                    : 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, .5), //(x,y)
                          blurRadius: 0.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                ],
                mainAxisAlignment:
                    MainAxisAlignment.end, // aligns the chatitem to right end
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Container(
                  child: Text(
                    DateFormat('hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(timeStamp),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 9,
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
                )
              ])
            ]),
          ),
        );
      } else if (type == 'image') {
        // return Image.network(imageUrl);

        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                child: Material(
                  elevation: 0,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                      ),
                      width: 200.0,
                      height: 200.0,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 1, color: Colors.black12),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Material(
                      child: Image.asset(
                        "null",
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          8.0,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: content,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatFullImage(
                        url: content,
                      ),
                    ),
                  ),
                },
                // padding: EdgeInsets.all(0),
              ),
            ),
            Container(
              child: Text(
                DateFormat('dd MMM, hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(timeStamp),
                  ),
                ),
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            )
          ],
        );
      } else if (type == "GestureNote") {
        return GestureDetector(
          onTap: () {
            widget.loveTextCallback();
            setState(() {
              Constants.content = content;
              Constants.timeStamp = timeStamp;
            });
          },
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(right: 20.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(width: 3, color: Colors.pink.shade100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          "Love Note",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontFamily: 'cute',
                          ),
                        ),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  child: Text(
                    DateFormat('hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(timeStamp),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                ),
              ),
            ],
          ),
        );
      } else if (type == 'audio') {
        return Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              color: widget.mood == 'romantic'
                  ? Colors.pinkAccent.withOpacity(0.5)
                  : widget.mood == 'sad'
                      ? Colors.grey.shade500
                      : widget.mood == 'break'
                          ? Colors.lightBlue.shade200
                          : widget.mood == 'angry'
                              ? Colors.red.shade200
                              : widget.mood == 'ignore'
                                  ? Colors.teal.shade200
                                  : Colors.purpleAccent,
            ),
            height: selectedIndex == index ? 100 : 65,
            width: selectedIndex == index ? 200 : 150,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Audio Message",
                      style: TextStyle(fontSize: 9, color: Colors.black87),
                    ),
                  ),
                  ValueListenableBuilder<ProgressBarState>(
                    valueListenable: _pageManager!.progressNotifier,
                    builder: (_, value, __) {
                      return selectedIndex == index
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 150,
                                height: 20,
                                child: ProgressBar(
                                  progress: value.current,
                                  buffered: value.buffered,
                                  total: value.total,
                                  onSeek: _pageManager!.seek,
                                  barHeight: 3,
                                  thumbRadius: 6,
                                  thumbGlowRadius: 12,
                                  timeLabelTextStyle: TextStyle(
                                      fontSize: 11, color: Colors.black),
                                  timeLabelPadding: 3,
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                  selectedIndex == index
                      ? ValueListenableBuilder<ButtonState>(
                          valueListenable: _pageManager!.buttonNotifier,
                          builder: (_, value, __) {
                            switch (value) {
                              case ButtonState.loading:
                                return Container(
                                  width: 15.0,
                                  height: 15.0,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                );
                              case ButtonState.paused:
                                return IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  iconSize: 25.0,
                                  onPressed: () => {
                                    setState(() {
                                      isPlaying = true;
                                      selectedIndex = index;
                                    }),
                                    _pageManager!.init(content),
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      _pageManager!.play();
                                    })
                                  },
                                );
                              case ButtonState.playing:
                                return IconButton(
                                  icon: Icon(Icons.pause),
                                  iconSize: 25.0,
                                  onPressed: _pageManager!.pause,
                                );
                            }
                          },
                        )
                      : GestureDetector(
                          onTap: () => {
                                if (isPlaying)
                                  {
                                    setState(() {
                                      isPlaying = false;
                                      _pageManager!.pause();
                                    }),
                                  }
                                else
                                  {
                                    setState(() {
                                      selectedIndex = index;
                                    }),
                                  },
                              },
                          child: Column(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                size: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Double tap to listen",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.black54),
                                ),
                              ),
                            ],
                          )),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  bool isPlaying = false;

  playerControl(index, content) {
    return GestureDetector(
        onTap: () async {
          if (isPlaying) {
            setState(() {
              selectedIndex = index;
              isPlaying = false;
            });
            player!.stop();
          } else {
            setState(() {
              selectedIndex = index;
              isPlaying = true;
            });

            await player!.setUrl(content);

            player!.play();
          }
        },
        child: Icon(selectedIndex == index
            ? isPlaying
                ? Icons.pause
                : Icons.play_arrow_outlined
            : Icons.play_arrow_outlined));
  }

  @override
  void dispose() {
    player!.dispose();
    _pageManager!.dispose();

    super.dispose();
  }
}
