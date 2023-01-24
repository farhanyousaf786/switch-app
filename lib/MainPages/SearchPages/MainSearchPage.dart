//
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:delayed_display/delayed_display.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:switchtofuture/MainPages/switchChat/SwitchChat.dart';
// import 'package:switchtofuture/MainPages/switchChat/SwitchChatHelper.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import '../Profile/Panelandbody.dart';
// import 'package:switchtofuture/UniversalResources/DataBaseRefrences.dart';
//
// ChatHelper chatHelper = ChatHelper();
// SwitchSearchUserData searchUserData = SwitchSearchUserData();
//
// class MainSearchPage extends StatefulWidget {
//   MainSearchPage({this.userId, this.user});
//
//   final String userId;
//   final User user;
//
//   @override
//   _MainSearchPageState createState() => _MainSearchPageState();
// }
//
// class _MainSearchPageState extends State<MainSearchPage> {
//   TextEditingController searchTextEditingController = TextEditingController();
//   String groupChatId;
//   String textQuery;
//   Map userMap;
//   QuerySnapshot searchSnapShot;
//   List userList = [];
//   Map<dynamic, dynamic> values;
//
//   getUser(String string) async {
//     if (string.isNotEmpty) {
//       setState(() {
//         textQuery = searchTextEditingController.text[0].toUpperCase() +
//             searchTextEditingController.text.substring(1);
//       });
//
//       userRefForSearchRtd.once().then((DataSnapshot snapshot) {
//         values = snapshot.value;
//         List userList = [];
//         if (values == null) {
//         } else {
//           setState(() {
//             values.forEach(
//                 (index, data) => userList.add({"user": index, ...data}));
//           });
//
//           setState(() {
//             this.userList = userList;
//           });
//           print("userssssssssssssssss: $userList");
//         }
//       });
//     } else {
//       print("empty");
//     }
//   }
//
//   groupIdAndRelationInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       groupChatId = prefs.getString('groupChatId');
//       print("GroupChatId =>>>>>>>>>" + groupChatId);
//     });
//   }
//
//   getUserData(String uid) async {
//     await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         setState(() {
//           userMap = dataSnapshot.value;
//
//           print(uid);
//         });
//       }
//     });
//   }
//
//   Widget searchTile({
//     String receiverName,
//     String receiverEmail,
//     String receiverAvatar,
//     String receiverId,
//     String receiverSecondName,
//     String userName,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       child: GestureDetector(
//         onTap: () => {
//           getUserData(receiverId),
//           Future.delayed(const Duration(seconds: 1), () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Provider<User>.value(
//                   value: widget.user,
//                   child: SwitchProfile(
//                     currentUserId: widget.user.uid,
//                     mainProfileUrl: userMap['url'],
//                     mainFirstName: userMap['firstName'],
//                     profileOwner: userMap['ownerId'],
//                     mainSecondName: userMap['secondName'],
//                     mainCountry: userMap['country'],
//                     mainDateOfBirth: userMap['dob'],
//                     mainAbout: userMap['about'],
//                     mainEmail: userMap['email'],
//                     mainGender: userMap['gender'],
//                   ),
//                 ),
//               ),
//             );
//           }),
//         },
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: CachedNetworkImageProvider(receiverAvatar),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   receiverName,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15,
//                     fontFamily: 'Names',
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text("username: ",
//                     style: TextStyle(color: Colors.blue,
//                     fontSize: 10),),
//                     Text(
//                       userName,
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 9,
//                         fontFamily: 'Names',
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Spacer(),
//             StreamBuilder(
//               stream: relationShipReferenceRtd.child(widget.user.uid).onValue,
//               builder: (context, dataSnapShot) {
//                 if (dataSnapShot.hasData) {
//                   DataSnapshot snapshot = dataSnapShot.data.snapshot;
//                   Map relationShipData = snapshot.value;
//
//                   if (relationShipData == null) {
//                     print("empty data");
//                   } else {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: () => {
//                           FirebaseDatabase.instance
//                               .reference()
//                               .child("lastTimeVisit")
//                               .child(receiverId)
//                               .child(Constants.myId)
//                               .set({
//                             'timeStamp': DateTime.now()
//                                 .millisecondsSinceEpoch
//                                 .toString(),
//                           }),
//                           chatHelper.readLocal(receiverId),
//                           Future.delayed(const Duration(milliseconds: 300), () {
//                             groupIdAndRelationInfo();
//                           }),
//                           Future.delayed(const Duration(milliseconds: 600), () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SwitchChat(
//                                   inRelationShipId:
//                                       relationShipData['inRelationshipWithId'],
//                                   receiverId: receiverId,
//                                   receiverName: receiverName,
//                                   receiverEmail: receiverEmail,
//                                   receiverAvatar: receiverAvatar,
//                                   myId: widget.user.uid,
//                                   groupChatId: groupChatId,
//
//                                   // inRelationShip: inRelation,
//                                 ),
//                               ),
//                             );
//                           }),
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.lightBlue.shade500,
//                               borderRadius: BorderRadius.circular(20)),
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           child: Text('Message'),
//                         ),
//                       ),
//                     );
//                   }
//                 }
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.lightBlue,
//                     ),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   _returnValue(List userList, int index) {
//     String searchQuery = userList[index]['firstName'];
//     String searchQuery2 = userList[index]['secondName'];
//     String userName = userList[index]['userName'];
//     String cUserName;
//     cUserName = userName[0].toUpperCase() + userName.substring(1);
//
//     if (searchQuery.contains(textQuery) ||
//         searchQuery2.contains(textQuery) ||
//         searchQuery.contains(
//           textQuery.substring(0, 1),
//         ) ||
//         cUserName.contains(textQuery)) {
//       return searchTile(
//         receiverName: userList[index]['firstName'],
//         receiverAvatar: userList[index]['url'],
//         receiverId: userList[index]['ownerId'],
//         receiverSecondName: userList[index]['secondName'],
//         userName: userList[index]['userName'],
//       );
//     } else {
//       return Container();
//     }
//   }
//
//   FocusNode searchFocus = FocusNode();
//
//   void onSearchComplete() {
//     getUser(searchTextEditingController.text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context, listen: false);
//
//     return Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Icon(
//                 Icons.arrow_back,
//                 color: Colors.black38,
//               ),
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(
//                 Icons.search,
//                 color: Colors.black38,
//               ),
//               onPressed: () => {
//                 getUser(searchTextEditingController.text),
//               },
//             )
//           ],
//           leadingWidth: 30,
//           elevation: 1,
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           title: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   height: 35,
//                   decoration: BoxDecoration(
//                     color: Colors.black12,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: TextField(
//                     textInputAction: TextInputAction.search,
//                     onEditingComplete: onSearchComplete,
//                     decoration: new InputDecoration(
//                       hintText: "Search...",
//                       hintStyle: TextStyle(fontWeight: FontWeight.bold),
//                       border: InputBorder.none,
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       errorBorder: InputBorder.none,
//                       disabledBorder: InputBorder.none,
//                       contentPadding: EdgeInsets.only(
//                           left: 15, bottom: 11, top: 11, right: 15),
//                     ),
//                     cursorColor: Colors.black.withOpacity(0.9),
//                     controller: searchTextEditingController,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: userList.isNotEmpty
//             ? ListView.builder(
//                 itemCount: userList.length,
//                 itemBuilder: (context, index) {
//                   return _returnValue(userList, index);
//                 })
//             : Text(""));
//   }
// }
//
// class SwitchSearchUserData {
//   Map userMap;
// }

///
///
///

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChat.dart';
import 'package:switchapp/MainPages/switchChat/SwitchChatHelper.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/Marquee.dart';
import '../Profile/Panelandbody.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';


class MainSearchPage extends StatefulWidget {
  MainSearchPage({required this.userId, required this.user, required this.navigateThrough});

  final String userId;
  final User user;
  final String navigateThrough;

  @override
  _MainSearchPageState createState() => _MainSearchPageState();
}

class _MainSearchPageState extends State<MainSearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  late String groupChatId;
  late String textQuery;
  late Map userMap;
  bool uploading = false;
  late QuerySnapshot searchSnapShot;
  bool userListEmpty = false;

  List userList = [];
  List userList2 =
      []; // to control UI if list empty show simple white scree etc

  late Map<dynamic, dynamic> values;

  @override
  void initState() {

    setState(() {

    });

    getAllUsers();

    loadNativeAd();

    super.initState();
  }


  // This is ad Area for Switch Shot Meme
  late NativeAd myNativeAd;
  bool isLoaded1 = false;

  void loadNativeAd() {
    myNativeAd = NativeAd(
        adUnitId: 'ca-app-pub-5525086149175557/8037211423',

        // adUnitId: 'ca-app-pub-3940256099942544/2247696110',
        factoryId: 'listTile',
        request: request,
        listener: NativeAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded1 = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();

          print('ad failed to load ${error.message}');
        }));

    myNativeAd.load();
  }

  static const AdRequest request = AdRequest(
    // keywords: ['', ''],
    // contentUrl: '',
    // nonPersonalizedAds: false
  );
  Widget nativeAdWidget() {
    return isLoaded1
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://switchappimages.nyc3.digitaloceanspaces.com/StaticUse/1646080905939.jpg"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Switch Ad",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'cute',
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: AdWidget(
              ad: myNativeAd,
            ),
            height: 180,
          ),
        ),
      ],
    )
        : Center(
        child: Text(
          "",
          style: TextStyle(
              fontSize: 18, fontFamily: 'cute', color: Colors.lightBlue),
        ));
  }


  @override
  void dispose() {
    super.dispose();
    myNativeAd.dispose();
  }

  getAllUsers() {
    userRefForSearchRtd.once().then((DataSnapshot snapshot) {
      values = snapshot.value;
      List userList = [];
      if (values == null) {
        print("emty");
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
      print("empty");
    }
  }

  groupIdAndRelationInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      groupChatId = prefs.getString('groupChatId')!;
      print("GroupChatId =>>>>>>>>>" + groupChatId);
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
                  child: SwitchProfile(
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
                              color: Colors.grey,
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
                          child: SwitchProfile(
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
                            isVerified: userMap['isVerified'], action: 'fromSearch', user: widget.user,
                          ),
                        ),
                      ),
                    );
                  }),
                },
                child: Icon(
                  Icons.navigate_next_sharp,
                  size: 19,
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
              //           color: Colors.lightBlue,
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

    if (
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => widget.navigateThrough == "direct" ? {} :  Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 18,

                color: widget.navigateThrough == "direct" ? Colors.transparent :  Colors.grey.shade200,
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
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(

                    textInputAction: TextInputAction.search,
                    onEditingComplete: onSearchComplete,
                    decoration: new InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.grey.shade200),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                    ),
                    cursorColor: Colors.black.withOpacity(0.9),
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
                  uploading ? LinearProgressIndicator() : Container(height: 0,width: 0,),
                  Container(
                    child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return _returnValue(userList, index);
                        }),
                  ),
                ],
              )
            :  Center(
              child: nativeAdWidget(),
            ),);
  }
}

