import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/MainPages/AdminPage/addFavMemers.dart';
import 'package:switchapp/MainPages/AdminPage/addMemeTopic.dart';
import 'package:switchapp/MainPages/AdminPage/addRemoveCompTopic.dart';
import 'package:switchapp/MainPages/AdminPage/adminUserDetails.dart';
import 'package:switchapp/MainPages/AdminPage/appControlAdmin.dart';
import 'package:switchapp/MainPages/AdminPage/removeWinners.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AdminPage extends StatefulWidget {
  User user;
  late Map? controlData;

  AdminPage({required this.user, required this.controlData});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  late String groupChatId;
  late String textQuery;
  late Map userMap;
  bool uploading = false;
  late QuerySnapshot searchSnapShot;
  List userList = [];
  List userList2 = [];
  late Map<dynamic, dynamic> values;
  String postId = Uuid().v4();
  TextEditingController decency = TextEditingController();

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  bool userListEmpty = false;

  getAllUsers() {
    userRefForSearchRtd.once().then((DataSnapshot snapshot) {
      values = snapshot.value;
      List userList = [];
      if (values == null) {

        setState(() {
          userListEmpty = true;
        });
      } else {
        setState(() {
          values
              .forEach((index, data) => userList.add({"user": index, ...data}));
        });
        setState(() {
          this.userList2 = userList;
          print(userList2.length);
        });
      }
    });
  }

  getUser(String string) async {
    if (string.isNotEmpty) {
      setState(() {
        textQuery = searchTextEditingController.text[0].toUpperCase() +
            searchTextEditingController.text.substring(1);
      });

      setState(() {
        userList = userList2;
      });
    } else {
    }
  }

  groupIdAndRelationInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      groupChatId = prefs.getString('groupChatId')!;
    });
  }

  getUserData(String uid) async {
    await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          userMap = dataSnapshot.value;

          print(uid);
        });
      }
    });
  }

  addAsFavMemer(
      String username, String name, String url, String uid, String decency) {
    return showModalBottomSheet(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Switch App',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      topMemerfRTD.child(postId).set({
                        'postId': postId,
                        'username': username,
                        'uid': uid,
                        'name': name,
                        'decency': decency,
                        'url': url
                      });

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          postId = Uuid().v4();

                          uploading = false;
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add as Fav Memer",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "cutes",
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      topWinnerRTD.child(postId).set({
                        'postId': postId,
                        'username': username,
                        'uid': uid,
                        'name': name,
                        'decency': decency,
                        'url': url
                      });

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          postId = Uuid().v4();

                          uploading = false;
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add as Winner",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "cutes",
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget searchTile({
    required String receiverName,
    required String receiverEmail,
    required String receiverAvatar,
    required String receiverId,
    required String receiverSecondName,
    required String userName,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => {
          setState(() {
            uploading = true;
          }),
          getUserData(receiverId),
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              uploading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider<User>.value(
                  value: widget.user,
                  child: AdminUserDetails(
                    currentUserId: widget.user.uid,
                    mainProfileUrl: userMap['url'],
                    mainFirstName: userMap['firstName'],
                    profileOwner: userMap['ownerId'],
                    mainSecondName: userMap['secondName'],
                    mainCountry: userMap['country'],
                    mainDateOfBirth: userMap['dob'],
                    mainAbout: userMap['about'],
                    mainEmail: userMap['email'],
                    mainGender: userMap['gender'],
                    username: userName,
                    isVerified: userMap['isVerified'],
                    action: 'fromSearch',
                    user: widget.user,
                    isBan: userMap['isBan'],
                  ),
                ),
              ),
            );
          }),
        },
        child: SingleChildScrollView(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(receiverAvatar),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiverName.characters.take(12).toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      fontFamily: 'Names',
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "User: ",
                        style:
                            TextStyle(color: Colors.blue.shade300, fontSize: 8),
                      ),
                      Container(
                        width: 100,
                        child: MarqueeWidget(
                          child: Text(
                            userName,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              fontFamily: 'Names',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () => {
                  setState(() {
                    uploading = true;
                  }),
                  addAsFavMemer(userName, receiverName, receiverAvatar,
                      receiverId, "100%"),
                },
                child: Text(
                  "Add Fav",
                  style: TextStyle(
                      fontSize: 10, fontFamily: 'cutes', color: Colors.blue),
                ),
              ),

              ///** This is route for chat but here is a problem, that if user is blocked then this will allow blocked user to
              ///to access in. So we have close this option for now

              // StreamBuilder(
              //   stream: relationShipReferenceRtd.child(widget.user.uid).onValue,
              //   builder: (context, dataSnapShot) {
              //     if (dataSnapShot.hasData) {
              //       DataSnapshot snapshot = dataSnapShot.data.snapshot;
              //       Map relationShipData = snapshot.value;
              //
              //       if (relationShipData == null) {
              //         print("empty data");
              //       } else {
              //         return Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: GestureDetector(
              //             onTap: () => {
              //               FirebaseDatabase.instance
              //                   .reference()
              //                   .child("lastTimeVisit")
              //                   .child(receiverId)
              //                   .child(Constants.myId)
              //                   .set({
              //                 'timeStamp': DateTime.now()
              //                     .millisecondsSinceEpoch
              //                     .toString(),
              //               }),
              //               chatHelper.readLocal(receiverId),
              //               Future.delayed(const Duration(milliseconds: 300), () {
              //                 groupIdAndRelationInfo();
              //               }),
              //               Future.delayed(const Duration(milliseconds: 600), () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => SwitchChat(
              //                       inRelationShipId:
              //                       relationShipData['inRelationshipWithId'],
              //                       receiverId: receiverId,
              //                       receiverName: receiverName,
              //                       receiverEmail: receiverEmail,
              //                       receiverAvatar: receiverAvatar,
              //                       myId: widget.user.uid,
              //                       groupChatId: groupChatId,
              //
              //                       // inRelationShip: inRelation,
              //                     ),
              //                   ),
              //                 );
              //               }),
              //             },
              //             child: Icon(
              //              Icons.messenger_outline,
              //               size: 17,
              //             ),
              //           ),
              //         );
              //       }
              //     }
              //     return Padding(
              //       padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              //       child: Center(
              //         child: CircularProgressIndicator(
              //           color: Colors.blue,
              //         ),
              //       ),
              //     );
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  _returnValue(List userList, int index) {
    String searchQuery = userList[index]['firstName'];
    String searchQuery2 = userList[index]['secondName'];
    String userName = userList[index]['username'];
    String cUserName;
    cUserName = userName[0].toUpperCase() + userName.substring(1);

    if (searchQuery.contains(textQuery) ||
        searchQuery2.contains(textQuery) ||
        searchQuery.contains(
          textQuery.substring(0, 1),
        ) ||
        cUserName.contains(textQuery)) {
      return searchTile(
        receiverName: userList[index]['firstName'],
        receiverAvatar: userList[index]['url'],
        receiverId: userList[index]['ownerId'],
        receiverSecondName: userList[index]['secondName'],
        userName: userList[index]['username'],
        receiverEmail: userList[index]['email'],
      );
    } else {
      return Container();
    }
  }

  FocusNode searchFocus = FocusNode();

  void onSearchComplete() {
    getUser(searchTextEditingController.text);
  }

  List userLists = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.arrow_back_ios_sharp,
              size: 18,
              color: Colors.black38,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () => {
              getUser(searchTextEditingController.text),
            },
          )
        ],
        leadingWidth: 30,
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onEditingComplete: onSearchComplete,
                  decoration: new InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                  ),
                  controller: searchTextEditingController,
                ),
              ),
            ),
          ],
        ),
      ),
      body: userList.isNotEmpty
          ? Stack(
              children: [
                uploading
                    ? LinearProgressIndicator()
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                Container(
                  child: ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return _returnValue(userList, index);
                      }),
                ),
              ],
            )
          : Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMemePage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Add/Remove App Topic",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddRemoveCompTopic()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Add/Remove Comp. Topic",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RemoveFavMemers()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Remove Fav Memers",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RemoveCompWinner()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Remove Comp. Winner",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        userLists.clear();

                        userRefRTD.orderByChild("timestamp").once().then(
                          (DataSnapshot dataSnapshot) {
                            if (dataSnapshot.value != null) {
                              Map data = dataSnapshot.value;

                              data.forEach((index, data) =>
                                  userLists.add({"key": index, ...data}));
                              //
                              // Future.delayed(const Duration(seconds: 1), () {
                              //   print("length : : : : : : " +
                              //       userLists.length.toString());
                              //   int time = int.parse(userLists[0]['timestamp']);
                              //
                              //   print("TimeStamp : : : : : : " +
                              //       getCustomFormattedDateTime(
                              //           time, 'yyyy/MM/dd'));
                              //
                              //   final now = DateTime.now();
                              //   final expirationDate = DateTime(2021, 1, 10);
                              //   final bool isExpired = expirationDate.isBefore(now);
                              //
                              //   print("username : : : : : : " +
                              //       userLists[0]['username']);
                              //
                              // });

                              Future.delayed(
                                const Duration(milliseconds: 600),
                                () {

                                  for (int i = 0;
                                      i <= userLists.length - 1;
                                      i++) {
                                    switchAllUserIdRTD
                                        .child(userLists[i]['ownerId'])
                                        .update({
                                      "ownerId": userLists[i]['ownerId'],
                                    });
                                  }
                                },
                              );
                            }
                          },
                        );

                        Fluttertoast.showToast(
                          msg: "Done",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.blue.withOpacity(0.8),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Update User List",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppControlAdmin(
                                      controlData: widget.controlData,
                                    ))),
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "App Control",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  getCustomFormattedDateTime(int givenDateTime, String dateFormat) {
    // dateFormat = 'MM/dd/yy';
    final DateTime docDateTime =
        DateTime.fromMicrosecondsSinceEpoch(givenDateTime);
    return DateFormat(dateFormat).format(docDateTime);
  }
}
