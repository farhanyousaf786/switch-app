import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:switchapp/MainPages/SearchPages/MainSearchPage.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChat.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChatHelper.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Models/appIntro.dart';
import 'package:switchapp/Universal/ConnectivityChecker.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

late String receiverIdForLoveNote;
final appIntro = new AppIntro();

class SwitchChatList extends StatefulWidget {
  final User user;
  final Map? isInRelationShipMap;

  const SwitchChatList({
    required this.user,
    required this.isInRelationShipMap,
  });

  @override
  _SwitchChatListState createState() => _SwitchChatListState();
}

class _SwitchChatListState extends State<SwitchChatList> {
  late String groupChatId;
  late String inRelation;
  late bool loadingScreen;

  List listForSendButton = new List.from([]); // line 1894

  Widget chatRoomList(String uid, Map listMap) {
    List list = [];
    listMap.forEach((index, data) => list.add({"key": index, ...data}));
    list.sort((a, b) {
      return b["timestamp"].compareTo(a["timestamp"]);
    });

    return ListView.builder(
        shrinkWrap: true,
        itemCount: listMap.length,
        itemBuilder: (context, index) => buildItem(index, list, uid, listMap));
  }

  ///********* Functions for Chat list Tiles ************\\\\\

  _profilePicture(String receiverAvatar, String senderAvatar, String senderId,
      int index, String uid) {
    if (uid == senderId) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
                image: DecorationImage(
                  image: NetworkImage(receiverAvatar),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return senderAvatar == null
          ? Text("Loading..")
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                      image: DecorationImage(
                        image: NetworkImage(receiverAvatar),
                      ),
                    ),
                  ),
                ),
              ],
            );
    }
  }

  @override
  void initState() {
    super.initState();



    controlNotificationToastForMessages();
    setState(() {
      loadingScreen = true;
    });
    hasNetwork();
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (Constants.introForChatListPage == "true") {
        showIntro();
      } else {}
      setState(() {
        loadingScreen = false;
        Constants.messageIconActive = false;
      });
      isOnline = await hasNetwork();

      setState(() {
        Constants.messageIconActive = false;
      });
    });
    super.initState();
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  controlNotificationToastForMessages() {
    setState(() {
      Constants.notifyCounter = 2;
    });
  }

  ///****\\\\\\
  Future<void> getGroupChatId(String receiverId) async {
    if (widget.user.uid.hashCode <= receiverId.hashCode) {
      groupChatId = '${widget.user.uid}-$receiverId';
    } else {
      groupChatId = '$receiverId-${widget.user.uid}';
    }
  }

  ///********\\\\
  _nameRelationShip(String receiverName, String senderName, String senderId,
      index, String uid) {
    if (uid == senderId) {
      return Row(
        children: [
          Text(
            receiverName.characters.take(13).toString() + " ",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'cutes'),
          ),
          Container(
            height: 18,
            child: Image.asset(
              "images/heartFill.gif",
              fit: BoxFit.contain,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            senderName.characters.take(13).toString() + " ",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'cutes'),
          ),
          Container(
            height: 18,
            child: Image.asset(
              "images/heartFill.gif",
              fit: BoxFit.contain,
            ),
          ),
        ],
      );
    }
  }

  _name(String receiverName, String senderName, String senderId, index,
      String uid, String receiverId) {
    if (uid == senderId) {
      return Row(
        children: [
          Text(
            receiverName.characters.take(13).toString() + " ",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'cutes'),
          ),
          StreamBuilder(
              stream: userRefRTD.child(receiverId).onValue,
              builder: (context, AsyncSnapshot dataSnapShot) {
                if (dataSnapShot.hasData) {
                  DataSnapshot snapshot1 = dataSnapShot.data.snapshot;
                  Map receiverData = snapshot1.value;

                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: receiverData['isOnline'] == "true"
                        ? Container(
                            child: Text(
                              "Online",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 8),
                            ),
                          )
                        : Container(
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 8),
                            ),
                          ),
                  );
                } else {
                  return Text("");
                }
              }),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            senderName.characters.take(13).toString() + " ",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'cutes'),
          ),
          StreamBuilder(
              stream: userRefRTD.child(receiverId).onValue,
              builder: (context, AsyncSnapshot dataSnapShot) {
                if (dataSnapShot.hasData) {
                  DataSnapshot snapshot1 = dataSnapShot.data.snapshot;
                  Map receiverData = snapshot1.value;
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: receiverData['isOnline'] == "true"
                        ? Container(
                            child: Text(
                              "Online",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 8),
                            ),
                          )
                        : Container(
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 8),
                            ),
                          ),
                  );
                } else {
                  return Text("");
                }
              }),
        ],
      );
    }
  }

  final whitespaceRE = RegExp(r"\s+");

  lastOfMessage(
    String content,
    String type,
  ) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 1, top: 8),
            child: Row(
              children: [
                Text(
                  "Last Message: ",
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey.shade500,
                  ),
                ),
                MarqueeWidget(
                  animationDuration: const Duration(seconds: 1),
                  backDuration: const Duration(seconds: 3),
                  pauseDuration: const Duration(milliseconds: 100),
                  child: Text(
                    type == "image"
                        ? "Image"
                        : type == 'audio'
                            ? "voice message"
                            : "${content.split(whitespaceRE).join(" ").characters.take(10)}...",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  groupIdAndRelationInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      groupChatId = prefs.getString('groupChatId')!;
    });
  }

  Widget buildItem(int index, List lists, String uid, Map data) {
    String receiverName;
    String senderName;
    String senderId;
    String receiverId;
    String senderAvatar;
    String receiverAvatar;
    String receiverEmail;
    String senderEmail;
    String groupChatId;
    String content;
    String type;
    String isOnline;
    bool isRead;
    String blockBy = "";
    int timestamp;

    timestamp = lists[index]['timestamp'];
    receiverName = lists[index]['receiverName'];
    senderName = lists[index]['senderName'];
    receiverAvatar = lists[index]['receiverAvatar'];
    senderAvatar = lists[index]['senderAvatar'];
    receiverId = lists[index]['receiverId'];
    senderId = lists[index]['senderId'];
    receiverEmail = lists[index]['receiverEmail'];
    senderEmail = lists[index]['senderEmail'];
    groupChatId = lists[index]['groupChatId'];
    content = lists[index]['content'];
    type = lists[index]['type'];
    isRead = lists[index]['isRead'];
    blockBy = lists[index]['blockBy'];

    String formatted = formatTime(timestamp);
    late Map userToken;
    return StreamBuilder(
      stream: relationShipReferenceRtd.child(widget.user.uid).onValue,
      builder: (context, AsyncSnapshot dataSnapShot) {
        if (dataSnapShot.hasData) {
          DataSnapshot snapshot = dataSnapShot.data.snapshot;
          Map relationShipData = snapshot.value;

          if (relationShipData == null) {

          } else {
            return relationShipData['inRelationshipWithId'] != receiverId
                ? Container(
                    child: ListTile(
                      onLongPress: () {
                        _openBottomSheet(groupChatId, receiverId);
                      },
                      trailing: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MarqueeWidget(
                            animationDuration: const Duration(seconds: 1),
                            backDuration: const Duration(seconds: 3),
                            pauseDuration: const Duration(milliseconds: 100),
                            direction: Axis.horizontal,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Text(
                                    //   "Sent at: ",
                                    //   style: TextStyle(
                                    //     fontSize: 8,
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    Text(
                                      formatted,
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                isRead
                                    ? Container(
                                        height: 0,
                                        width: 0,
                                      )
                                    : Container(
                                        height: 30,
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Text(
                                              "New Message ",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontFamily: 'cute',
                                                fontSize: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(""),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      leading: _profilePicture(
                          receiverAvatar, senderAvatar, senderId, index, uid),
                      title: _name(receiverName, senderName, senderId, index,
                          uid, receiverId),
                      subtitle: lastOfMessage(
                        content,
                        type,
                      ),
                      onTap: () => {
                        if (uid == senderId)
                          {
                            userRefRTD
                                .child(receiverId)
                                .once()
                                .then((DataSnapshot dataSnapshot) {
                              if (dataSnapshot.value != null) {
                                setState(() {
                                  userToken = dataSnapshot.value;
                                });
                                setState(() {
                                  Constants.token =
                                      userToken['androidNotificationToken']
                                          .toString();
                                });
                              }
                            }),
                            FirebaseDatabase.instance
                                .reference()
                                .child("switchLastVisit-786")
                                .child(receiverId)
                                .child(widget.user.uid)
                                .set({
                              'timeStamp': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'isRead': true,
                            }),
                            getGroupChatId(receiverId),
                            chatListRtDatabaseReference
                                .child(Constants.myId)
                                .child(receiverId)
                                .update({"isRead": true}),
                            Future.delayed(const Duration(milliseconds: 600),
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Provider<User>.value(
                                          value: widget.user,
                                          child: SwitchChat(
                                            receiverId: receiverId,
                                            receiverName: receiverName,
                                            receiverEmail: receiverEmail,
                                            receiverAvatar: receiverAvatar,
                                            myId: widget.user.uid,
                                            groupChatId: groupChatId,
                                            inRelationShipId: relationShipData[
                                                'inRelationshipWithId'],
                                            listForSendButton:
                                                listForSendButton,
                                            blockBy: blockBy,
                                            // inRelationShip: inRelation,
                                          ),
                                        )),
                              );
                            }),
                          }
                        else
                          {
                            userRefRTD
                                .child(receiverId)
                                .once()
                                .then((DataSnapshot dataSnapshot) {
                              if (dataSnapshot.value != null) {
                                setState(() {
                                  userToken = dataSnapshot.value;
                                });
                                setState(() {
                                  Constants.token =
                                      userToken['androidNotificationToken']
                                          .toString();
                                });
                              }
                            }),
                            FirebaseDatabase.instance
                                .reference()
                                .child("switchLastVisit-786")
                                .child(receiverId)
                                .child(widget.user.uid)
                                .set({
                              'timeStamp': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'isRead': true,
                            }),
                            getGroupChatId(receiverId),
                            chatListRtDatabaseReference
                                .child(Constants.myId)
                                .child(receiverId)
                                .update({"isRead": true}),
                            Future.delayed(const Duration(milliseconds: 600),
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Provider<User>.value(
                                          value: widget.user,
                                          child: SwitchChat(
                                            receiverId: receiverId,
                                            receiverName: receiverName,
                                            receiverEmail: receiverEmail,
                                            receiverAvatar: receiverAvatar,
                                            myId: widget.user.uid,
                                            groupChatId: groupChatId,
                                            inRelationShipId: relationShipData[
                                                'inRelationshipWithId'],
                                            listForSendButton:
                                                listForSendButton,
                                            blockBy: blockBy,
                                            // inRelationShip: inRelation,
                                          ),
                                        )),
                              );
                            }),
                          }
                      },
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                    child: Text(""),
                  );
          }
        }
        return Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Center(
            child: Text(""),
          ),
        );
      },
    );
  }

  // UserProvider userProvider;
  TextEditingController loveNoteText = TextEditingController();
  bool isOnline = true;

  profilePicture(String receiverAvatar, String senderAvatar, String senderId,
      int index, String uid) {
    if (uid == senderId) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
          image: DecorationImage(
            image: NetworkImage(receiverAvatar),
          ),
        ),
      );
    } else {
      return Container(
        width: 40,
        height: 40,
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

  Widget chatRoomForInRelationShipPerson(String uid, Map listMap) {
    List list = [];

    listMap.forEach((index, data) => list.add({"key": index, ...data}));
    list.sort((a, b) {
      return b["timestamp"].compareTo(a["timestamp"]);
    });

    listForSendButton =
        list; // this is for list of chat for sending forward messages

    return new ListView.builder(
        shrinkWrap: true,
        itemCount: listMap.length,
        itemBuilder: (context, index) => buildItemForRelationShipChat(
              index,
              list,
              uid,
            ));
  }

  Widget loveNoteWidget() {
    return StreamBuilder(
      stream: chatMoodReferenceRtd.child(widget.user.uid).onValue,
      builder: (context, AsyncSnapshot dataSnapShot) {
        if (dataSnapShot.hasData) {
          DataSnapshot snapshot = dataSnapShot.data.snapshot;
          Map data = snapshot.value;
          if (snapshot == null) {
          } else {
            return MarqueeWidget(
              animationDuration: const Duration(seconds: 3),
              backDuration: const Duration(seconds: 3),
              pauseDuration: const Duration(seconds: 1),
              child: Text(
                data["loveNote"],
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'cute',
                ),
              ),
            );
          }
        }
        return Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Text(
            "Noting Here...",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'cutes'),
          ),
        );
      },
    );
  }

  void _openBottomSheet(
    String groupChatId,
    String receiverId,
  ) {
    showModalBottomSheet(
        elevation: 0,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BarTop(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "It will only delete your current tile not entire chat with that person. When you starting chat with this person again, all previous chat will show again. However, you can delete individual message.",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Note: ',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      "In future we will add facility to delete complete chat from your side",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                    fontSize: 14,
                                    // decoration: TextDecoration.underline,
                                    // decorationStyle: TextDecorationStyle.wavy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      chatListRtDatabaseReference
                          .child(Constants.myId)
                          .child(receiverId)
                          .remove();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        width: 120,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'cute'),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ],
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

  Widget buildItemForRelationShipChat(
    int index,
    List lists,
    String uid,
  ) {
    String receiverName;
    String senderName;
    String senderId;
    String receiverId;
    String senderAvatar;
    String receiverAvatar;
    String receiverEmail;
    String senderEmail;
    String content = "";
    String groupChatId;
    String type;
    bool isRead;
    String blockBy = "";
    blockBy = lists[index]['blockBy'];

    receiverName = lists[index]['receiverName'];
    senderName = lists[index]['senderName'];
    senderId = lists[index]['senderId'];
    receiverId = lists[index]['receiverId'];
    senderAvatar = lists[index]['senderAvatar'];
    receiverAvatar = lists[index]['receiverAvatar'];
    receiverEmail = lists[index]['receiverEmail'];
    senderEmail = lists[index]['senderEmail'];
    content = lists[index]['content'];
    type = lists[index]['type'];
    isRead = lists[index]['isRead'];
    groupChatId = lists[index]['groupChatId'];

    late Map userToken;
    return StreamBuilder(
      stream: relationShipReferenceRtd.child(widget.user.uid).onValue,
      builder: (context, AsyncSnapshot dataSnapShot) {
        if (dataSnapShot.hasData) {
          DataSnapshot snapshot = dataSnapShot.data.snapshot;
          Map relationShipData = snapshot.value;

          if (relationShipData == null) {
          } else {
            receiverIdForLoveNote = relationShipData['inRelationshipWithId'];
            return relationShipData['inRelationshipWithId'] == receiverId
                ? Column(
                    children: [
                      ListTile(
                        onLongPress: () {
                          _openBottomSheet(
                            groupChatId,
                            receiverId,
                          );
                        },
                        trailing: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: MarqueeWidget(
                                  animationDuration: const Duration(seconds: 1),
                                  backDuration: const Duration(seconds: 3),
                                  pauseDuration:
                                      const Duration(milliseconds: 100),
                                  direction: Axis.horizontal,
                                  child: Text(
                                    DateFormat('hh:mm a, dd MMM').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(lists[index]['timestamp']
                                            .toString()),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              isRead
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Container(
                                      height: 30,
                                      width: 100,
                                      child: Row(
                                        children: [
                                          Text(
                                            "New Message ",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontFamily: 'cute',
                                              fontSize: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Text(""),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        leading: _profilePicture(
                            receiverAvatar, senderAvatar, senderId, index, uid),
                        title: _nameRelationShip(
                            receiverName, senderName, senderId, index, uid),
                        subtitle: lastOfMessage(
                          content,
                          type,
                        ),
                        onTap: () => {
                          if (uid == senderId)
                            {
                              userRefRTD
                                  .child(receiverId)
                                  .once()
                                  .then((DataSnapshot dataSnapshot) {
                                if (dataSnapshot.value != null) {
                                  setState(() {
                                    userToken = dataSnapshot.value;
                                  });
                                  setState(() {
                                    Constants.token =
                                        userToken['androidNotificationToken']
                                            .toString();
                                  });
                                }
                              }),
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("switchLastVisit-786")
                                  .child(receiverId)
                                  .child(widget.user.uid)
                                  .set({
                                'timeStamp': DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                'isRead': true,
                              }),
                              chatListRtDatabaseReference
                                  .child(Constants.myId)
                                  .child(receiverId)
                                  .update({"isRead": true}),
                              getGroupChatId(receiverId),
                              Future.delayed(const Duration(milliseconds: 600),
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Provider<User>.value(
                                            value: widget.user,
                                            child: SwitchChat(
                                              receiverId: receiverId,
                                              receiverName: receiverName,
                                              receiverEmail: receiverEmail,
                                              receiverAvatar: receiverAvatar,
                                              myId: widget.user.uid,
                                              groupChatId: groupChatId,
                                              inRelationShipId:
                                                  relationShipData[
                                                      'inRelationshipWithId'],
                                              listForSendButton:
                                                  listForSendButton,
                                              blockBy: blockBy,
                                              // inRelationShip: inRelation,
                                            ),
                                          )),
                                );
                              }),
                            }
                          else
                            {
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("switchLastVisit-786")
                                  .child(receiverId)
                                  .child(widget.user.uid)
                                  .set({
                                'timeStamp': DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                'isRead': true,
                              }),
                              getGroupChatId(receiverId),
                              userRefRTD
                                  .child(receiverId)
                                  .once()
                                  .then((DataSnapshot dataSnapshot) {
                                if (dataSnapshot.value != null) {
                                  setState(() {
                                    userToken = dataSnapshot.value;
                                  });
                                  setState(() {
                                    Constants.token =
                                        userToken['androidNotificationToken']
                                            .toString();
                                  });

                                  // we want this token because we want token of receiver end

                                }
                              }),
                              chatListRtDatabaseReference
                                  .child(Constants.myId)
                                  .child(receiverId)
                                  .update({"isRead": true}),
                              Future.delayed(const Duration(milliseconds: 400),
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Provider<User>.value(
                                            value: widget.user,
                                            child: SwitchChat(
                                              receiverId: receiverId,
                                              receiverName: receiverName,
                                              receiverEmail: receiverEmail,
                                              receiverAvatar: receiverAvatar,
                                              myId: widget.user.uid,
                                              groupChatId: groupChatId,
                                              inRelationShipId:
                                                  relationShipData[
                                                      'inRelationshipWithId'],
                                              listForSendButton:
                                                  listForSendButton,
                                              blockBy: blockBy,
                                              // inRelationShip: inRelation,
                                            ),
                                          )),
                                );
                              }),
                            }
                        },
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        BarTop(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            "Love Note",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "cute",
                                                color: Colors.pink),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50, right: 50, top: 20),
                                          child: TextField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,
                                            maxLength: 60,
                                            style: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            controller: loveNoteText,
                                            decoration: InputDecoration(
                                              fillColor: Colors.blue.shade50
                                                  .withOpacity(0.5),
                                              isDense: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                borderSide: new BorderSide(
                                                    color: Colors.blue.shade700,
                                                    width: 1),
                                              ),
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                borderSide: new BorderSide(
                                                    color: Colors.blue.shade700,
                                                    width: 1),
                                              ),
                                              labelText: ' Write Here',
                                              labelStyle: TextStyle(
                                                fontFamily: "Cutes",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade700,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => {
                                            chatMoodReferenceRtd
                                                .child(Constants.myId)
                                                .update({
                                              "loveNote": loveNoteText.text,
                                              "timestamp": DateTime.now()
                                                  .millisecondsSinceEpoch,
                                            }),
                                            chatMoodReferenceRtd
                                                .child(receiverIdForLoveNote)
                                                .update(
                                              {
                                                "loveNote": loveNoteText.text,
                                                "timestamp": DateTime.now()
                                                    .millisecondsSinceEpoch,
                                              },
                                            ),
                                            Navigator.pop(context),
                                          },
                                          child: Text("Done"),
                                          // color: Colors.blue.shade50,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: Text(
                                  "Love Note",
                                  style: TextStyle(
                                      fontFamily: 'cute',
                                      fontSize: 15,
                                      color: Colors.blue.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0,
                          left: 20,
                          right: 20,
                          bottom: 0,
                        ),
                        child: loveNoteWidget(),
                      ),
                    ],
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  );
          }
        }
        return Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Center(
            child: Text(""),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Stack(
      children: [
        !isOnline
            ? Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                ),
                body: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No Internet ",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 20,
                                fontFamily: 'cute'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "We are working on to availability of chat's record offline too",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontFamily: 'cute'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
                floatingActionButton: FloatingActionButton(
                  elevation: 0.0,
                  backgroundColor: Colors.grey,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Provider<User>.value(
                          value: user,
                          child: MainSearchPage(
                            navigateThrough: "",
                            user: user,
                            userId: user.uid,
                          ),
                        ),
                      ),
                    )
                  },
                  child: Icon(
                    Icons.search,
                  ),
                ),
                body: SafeArea(
                  child: StreamBuilder(
                    stream: chatListRtDatabaseReference
                        .child(Constants.myId)
                        .orderByChild("timestamp")
                        .onValue,
                    builder: (context, AsyncSnapshot dataSnapShot) {
                      if (!dataSnapShot.hasData) {
                        return Container(
                          child: _noDataWidget(),
                        );
                      } else {
                        DataSnapshot snapshot = dataSnapShot.data.snapshot;
                        Map data = snapshot.value;
                        return data == null
                            ? _noDataWidget()
                            : Column(
                                children: [
                                  _loveChat(data),
                                  Material(
                                    child: Container(

                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade300,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5, bottom: 5),
                                        child: Container(
                                          child: Text(
                                            "Other Chats",
                                            style: TextStyle(
                                                fontFamily: 'cute',
                                                fontSize: 20,
                                                color: Colors.white,
                                                 fontWeight: FontWeight.bold),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ),
                                    elevation: 6,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                      child:
                                          chatRoomList(widget.user.uid, data)),
                                ],
                              );
                      }
                    },
                  ),
                ),
              ),
        GestureDetector(
          onTap: () {
            setState(() {
              loadingScreen = false;
            });
          },
          child: loadingScreen == true
              ? Scaffold(
                  body: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(height: MediaQuery.of(context).size.height /5,),

                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.5,
                          ),

                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.grey.shade200,
                            child: Text(
                              "Loading Chats..",
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 20,
                                fontFamily: 'cute',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  _loveChat(Map listMap) {
    if (widget.isInRelationShipMap?['inRelationShip'] == true) {
      return Container(
        // key: loveChat,

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      offset: Offset(0.0, 2.0), //(x,y)
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Love Chat",
                          style: TextStyle(
                              fontFamily: 'cute',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                   BarTop(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Love Note",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "cute",
                                              color: Colors.pink),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50, top: 20),
                                        child: TextField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          maxLength: 60,
                                          style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          controller: loveNoteText,
                                          decoration: InputDecoration(
                                            fillColor: Colors.blue.shade50
                                                .withOpacity(0.5),
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              borderSide: new BorderSide(
                                                  color: Colors.blue.shade700,
                                                  width: 1),
                                            ),
                                            filled: true,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: new BorderSide(
                                                  color: Colors.blue.shade700,
                                                  width: 1),
                                            ),
                                            labelText: ' Write Here',
                                            labelStyle: TextStyle(
                                              fontFamily: "Cutes",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade700,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => {
                                          chatMoodReferenceRtd
                                              .child(Constants.myId)
                                              .update({
                                            "loveNote": loveNoteText.text,
                                            "timestamp": DateTime.now()
                                                .millisecondsSinceEpoch,
                                          }),
                                          chatMoodReferenceRtd
                                              .child(receiverIdForLoveNote)
                                              .update(
                                            {
                                              "loveNote": loveNoteText.text,
                                              "timestamp": DateTime.now()
                                                  .millisecondsSinceEpoch,
                                            },
                                          ),
                                          Navigator.pop(context),
                                        },
                                        child: Text("Done"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                "Note",
                                style: TextStyle(
                                    fontFamily: 'cute',
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  child:
                      chatRoomForInRelationShipPerson(widget.user.uid, listMap),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (widget.isInRelationShipMap?['inRelationShip'] == false) {
      return Container(
        key: loveChat,

        child: SingleChildScrollView(
          child: Column(
            children: [
              Material(
                elevation: 6,
                child: Container(
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                        child: Text(
                          "Love Chat",
                          style: TextStyle(
                              fontFamily: 'cute',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.shade100,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    child: Lottie.asset(
                      'images/dating.json',
                    ),
                    height: 120,
                    width: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "The Luckiest Person Will Be Here! Click Search Icon to find That Person",
                      style: TextStyle(
                          fontFamily: 'cute', fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  _noDataWidget() {
    return SafeArea(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Material(
            elevation: 6,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 5, top: 5),
                            child: Text(
                              "Love Chat",
                              style: TextStyle(
                                  fontFamily: 'cute',
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.shade100,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          key: loveChat,

                          child: Lottie.asset(
                            'images/dating.json',
                          ),
                          height: 120,
                          width: 120,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "The Luckiest Person Will Be Here! Click Search Icon to find That Person",
                            style: TextStyle(
                                fontFamily: 'cute',
                                fontSize: 10,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Material(
            elevation: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade300,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                child: Container(
                  key: otherChat,

                  child: Text(
                    "Other Chats",
                    style: TextStyle(
                        fontFamily: 'cute',
                        fontSize: 20,
                        color: Colors.white,
                         fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              "All chats will be here..",
              style: TextStyle(
                  fontFamily: 'cute', fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey loveChat = GlobalKey();
  GlobalKey otherChat = GlobalKey();

  void showIntro() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.blue,
      textSkip: "Skip",
      paddingFocus: 4,
      pulseAnimationDuration: Duration(milliseconds: 1000),
      focusAnimationDuration: Duration(milliseconds: 500),
      opacityShadow: 0.9,
      textStyleSkip:
          TextStyle(fontFamily: 'cute', fontSize: 20, color: Colors.white),
      onFinish: () async {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("chatListIntro", 1);
        if (mounted)
          setState(() {
            Constants.introForChatListPage = "";
          });



      },
      onClickTarget: (target) {
        print('onClickTarget: ${target.keyTarget}');
      },
      onSkip: () {
        appIntro.createState().bottomSheetForChatListSkipButton(context);
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "Target",
        keyTarget: loveChat,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "When you are in relationship with someone, this section will show the chat of that person with you in this section.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'cute',
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "1 of 2",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15,
      ),
    );

    targets.add(TargetFocus(
        identify: "Target",
        keyTarget: otherChat,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "This is simple chat list of all users.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "2 of 2",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 15));
  }
}
