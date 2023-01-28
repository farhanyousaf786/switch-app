import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/MainPages/ReportAndComplaints/postReportPage.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChat.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChatHelper.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:uuid/uuid.dart';

final commentRef = FirebaseFirestore.instance.collection("comments");

class CommentsPage extends StatefulWidget {
  CommentsPage(
      {required this.postId, required this.ownerId, required this.photoUrl});

  final String ownerId;
  final String postId;
  final String photoUrl;

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentTextEditingController = TextEditingController();
  late String groupChatId;

  late DocumentSnapshot snapshot;

  /// this initState IsUsed ryn a funtion that to to get username from Firebase
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String postId = Uuid().v4();

  saveComment() {
    if (commentTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Yo! Comment can't be empty",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      commentRtDatabaseReference.child(widget.postId).push().set({
        "ownerId": widget.ownerId,
        "commentOwnerId": Constants.myId,
        "firstName": Constants.myName,
        "secondName": Constants.mySecondName,
        "email": Constants.myEmail,
        "comment": commentTextEditingController.text,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "url": Constants.myPhotoUrl,
        "postId": widget.postId,
        "photoUrl": widget.photoUrl,
      });

      feedRtDatabaseReference
          .child(widget.ownerId)
          .child("feedItems")
          .child(widget.postId)
          .set({
        "type": "comment",
        "firstName": Constants.myName,
        "secondName": Constants.mySecondName,
        "comment": commentTextEditingController.text,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "url": Constants.myPhotoUrl,
        "postId": widget.postId,
        "ownerId": widget.ownerId,
        "photoUrl": widget.photoUrl,
        "commentOwnerId": Constants.myId,
        "isRead": false,
      });

      commentTextEditingController.clear();
    }
  }

  Widget buildComments() {
    return StreamBuilder(
      stream: commentRtDatabaseReference
          .child(widget.postId)
          .orderByChild('timestamp')
          .onValue,
      builder: (context, AsyncSnapshot dataSnapShot) {
        if (!dataSnapShot.hasData) {
          return CircularProgressIndicator();
        } else {
          DataSnapshot snapshot = dataSnapShot.data.snapshot;
          Map data = snapshot.value;
          List item = [];
          if (data == null) {
            return Text("");
          } else {
            data.forEach((index, data) => item.add({"key": index, ...data}));
          }

          item.sort((a, b) {
            return b["timestamp"].compareTo(a["timestamp"]);
          });
          return dataSnapShot.data.snapshot.value == null
              ? SizedBox()
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return buildItem(index, item);
                  },
                );
        }
      },
    );
  }

  _getUserDetail(String ownerId) {
    User user = Provider.of<User>(context, listen: false);

    userRefRTD.child(ownerId).once().then((DataSnapshot dataSnapshot) {
      Map data = dataSnapshot.value;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Provider<User>.value(
            value: user,
            child: SwitchProfile(
              mainProfileUrl: data['url'],
              profileOwner: data['ownerId'],
              mainFirstName: data['firstName'],
              mainAbout: data['about'],
              mainCountry: data['country'],
              mainSecondName: data['secondName'],
              mainEmail: data['email'],
              mainGender: data['gender'],
              currentUserId: Constants.myId,
              user: user,
              action: "fromTimeLine",
              username: data['username'],
              isVerified: data['isVerified'],
              mainDateOfBirth: data['dob'],
            ),
          ),
          //     Provider<User>.value(
          //   value: user,
          //   child: MainSearchPage(
          //     user: user,
          //     userId: user.uid,
          //   ),
          // ),
        ),
      );
    });
  }

  groupIdAndRelationInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      groupChatId = prefs.getString('groupChatId')!;
    });
  }

  Widget buildItem(int index, List item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
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
                        BarTop(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostReport(
                                      reportedId: item[index]['commentOwnerId'],
                                      reportById: Constants.myId,
                                      type: "comments",
                                      postId: widget.postId,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "Report Comment",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "cute",
                                       fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _getUserDetail(item[index]['commentOwnerId']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "Visit Profile",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "cute",
                                       fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 12,
                            child: CircleAvatar(
                              radius: 11,
                              backgroundImage: CachedNetworkImageProvider(
                                  item[index]['url']),
                            ),
                          ),
                        ),
                        Container(
                          width: item[index]['comment'].toString().length < 10
                              ? 120
                              : item[index]['comment'].toString().length < 40
                                  ? 160
                                  : MediaQuery.of(context).size.width / 1.3,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: item[index]['commentOwnerId'] ==
                                      Constants.myId
                                  ? Colors.blue.shade50
                                  : Colors.grey[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 0, top: 3, bottom: 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, bottom: 3),
                                  child: Text(
                                    item[index]['firstName'] +
                                        " " +
                                        item[index]['secondName'],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.lightBlue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  item[index]['comment'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                      ),
                      child: Text(
                        DateFormat('hh:mm a, dd MMM').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(item[index]['timestamp'].toString()),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.2,

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Comments",
                    style: TextStyle(
                        fontFamily: 'cute', color: Colors.lightBlue, fontSize: 18),
                  ),
                ),
                Expanded(
                    child: DelayedDisplay(
                        delay: Duration(milliseconds: 200),
                        slidingBeginOffset: Offset(0.0, 1),
                        child: buildComments())),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(

                    child: ListTile(
                      title: TextFormField(
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        controller: commentTextEditingController,
                        decoration: InputDecoration(
                          labelText: "Leave Comment Here...",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: ElevatedButton(
                        onPressed: saveComment,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, elevation: 0),
                        child: Text(
                          "publish",
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
