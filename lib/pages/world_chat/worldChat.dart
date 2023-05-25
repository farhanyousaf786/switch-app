import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

import '../Profile/Panelandbody.dart';

class WorldChat extends StatefulWidget {
  final String userId;
  final User user;

  const WorldChat({required this.userId,required this.user});

  @override
  _WorldChatState createState() => _WorldChatState();
}

class _WorldChatState extends State<WorldChat> {
  TextEditingController texMessage = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  TextEditingController copiedMessage = new TextEditingController();
  final FocusNode focusNode = FocusNode();
  int _limit = 15;
  int _limitIncrement = 30;
 late bool isShowSticker;
  String messageId = Uuid().v4();
  bool _isComposing = false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
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
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Clusty Chat",
              style:
                  TextStyle( fontSize: 15, fontFamily: 'cute'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Where Worlds Connect",
                style:
                TextStyle( fontSize: 9, fontFamily: 'cute', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: clustyChatRTD
                .orderByChild("timeStamp")
                .limitToLast(_limit)
                .onValue,
            builder: (context,AsyncSnapshot dataSnapShot) {
              if (dataSnapShot.hasData) {
                DataSnapshot snapshot = dataSnapShot.data.snapshot;
                Map data = snapshot.value;
                List list = [];
                if (data == null) {
                  return Scaffold(
                    body: Center(child: Text("")),
                  );
                } else {
                  data.forEach(
                      (index, data) => list.add({"key": index, ...data}));
                  list.sort((b, a) {
                    return a["timeStamp"].compareTo(b["timeStamp"]);
                  });
                  print(">>>>>> : ${list.length}");
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: new Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 0, left: 5, right: 5),
                        child: TextField(
                          cursorColor: Colors.grey,
                          cursorHeight: 20,
                          controller: texMessage,
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


                                const Radius.circular(30.0),

                              ),

                            ),
                            filled: true,
                            hintStyle: new TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontFamily: 'cute'),
                            hintText: "Type here...",
                            fillColor: Colors.white60,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: _isComposing
                        ? () => _handleSubmitted(texMessage.text)
                        : null,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                    backgroundColor: Colors.blue.shade200,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(
    String content,
  ) {
    texMessage.clear();
    setState(() {
      _isComposing = false;
    });

    sendMessage(content);
  }


  late Map userInfo;

  getUserData(String uid) async {
    await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          userInfo = dataSnapshot.value;

          print(uid);
        });
      }
    });
  }
  buildMessage(int index, List lists) {
    String senderName;
    String senderId;
    String senderAvatar;
    String senderEmail;
    String content;
    String timeStamp;
    senderName = lists[index]['senderName'];
    content = lists[index]['content'];
    senderAvatar = lists[index]['senderAvatar'];
    senderId = lists[index]['senderId'];
    senderEmail = lists[index]['senderEmail'];
    timeStamp = lists[index]['timeStamp'];
    messageId = lists[index]['messageId'];

    if (senderId == widget.user.uid) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  content,
                  style: TextStyle( fontSize: 12),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: content.length <= 8
                    ? 80
                    : content.length <= 12
                        ? 120
                        : content.length <= 15
                            ? 140
                            : content.length <= 20
                                ? 180
                                : 250,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade200,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
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
              margin: EdgeInsets.only(right: 15.0, top: 5.0, bottom: 2.0),
            )
          ])
        ]),
      );
    } else {
      return GestureDetector(
        onTap: (){
          getUserData(lists[index]['senderId']);
          Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider<User>.value(
                  value: widget.user,
                  child: SwitchProfile(
                    currentUserId: widget.user.uid,
                    mainProfileUrl: userInfo['url'],
                    mainFirstName: userInfo['firstName'],
                    profileOwner: userInfo['ownerId'],
                    mainSecondName: userInfo['secondName'],
                    mainCountry: userInfo['country'],
                    mainDateOfBirth: userInfo['dob'],
                    mainAbout: userInfo['about'],
                    mainEmail: userInfo['email'],
                    mainGender: userInfo['gender'],
                    username: userInfo['username'],
                    isVerified: userInfo['isVerified'],
                    action: 'memerProfile',
                    user: widget.user,
                  ),
                ),
              ),
            );
          },);


        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20, top: 10),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all( width: 1),
                      image: DecorationImage(
                        image: NetworkImage(senderAvatar),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content,
                        style: TextStyle( fontSize: 12,
                        color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                        "Send by: " +  senderName,
                          style: TextStyle( fontSize: 9,
                          color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
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
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
              mainAxisAlignment:
                  MainAxisAlignment.start, // aligns the chatitem to right end
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Container(
                child: Text(
                  DateFormat('hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(timeStamp),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.black54,
                  ),
                ),
                margin: EdgeInsets.only(left: 90.0, top: 5.0, bottom: 2.0),
              )
            ])
          ]),
        ),
      );
    }
  }

  sendMessage(String content) {
    clustyChatRTD.push().set({
      'content': content,
      'senderName': Constants.myName,
      'senderAvatar': Constants.myPhotoUrl,
      'senderId': Constants.myId,
      'senderEmail': Constants.myEmail,
      'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}
