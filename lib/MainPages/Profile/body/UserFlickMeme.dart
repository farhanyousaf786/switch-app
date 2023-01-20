// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:switchapp/UniversalResources/DataBaseRefrences.dart';
//
// class UserFlickMeme extends StatefulWidget {
//   late final User user;
//   late final navigateThrough;
//   late final profileId;
//
//
//
//   UserFlickMeme(
//       {required this.user, required this.navigateThrough, required this.profileId});
//
//   @override
//   _UserFlickMemeState createState() => _UserFlickMemeState();
// }
//
// class _UserFlickMemeState extends State<UserFlickMeme> {
//
//   bool isLoading = true;
//   List userPosts = [];
//   bool _hasMore = false;
//   late int startAt = 0;
//   late int endAt = 20;
//   final ScrollController listScrollController = ScrollController();
//   double? _scrollPosition;
//
//   @override
//   void initState() {
//     listScrollController.addListener(_scrollListener);
//
//     super.initState();
//
//       getFirstPostList();
//
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   _scrollListener() {
//     if (listScrollController.offset >=
//         listScrollController.position.maxScrollExtent &&
//         !listScrollController.position.outOfRange) {
//       setState(() {
//         _hasMore = true;
//       });
//       startAt = startAt + 21;
//       endAt = endAt + 21;
//       getNextPosts();
//     }
//     setState(() {
//       _scrollPosition = listScrollController.position.pixels;
//     });
//
//
//   }
//
//   List userLists = [];
//
//
//   late Map data;
//   List posts = [];
//   List limitedPosts = [];
//
//
//
//   getFirstPostList() async {
//
//     postsRtd
//         .child(widget.profileId)
//         .child("usersPost")
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         data =  dataSnapshot.value;
//
//         data.forEach((index, data) =>
//             posts.add({"key": index, ...data}));
//         posts.sort((a, b) {
//           return b["timestamp"].compareTo(a["timestamp"]);
//         });
//         print("1111111111111111111111111111 ${posts}");
//
//
//         if(posts.length >  10){
//
//         limitedPosts =   posts.getRange(0, 10).toList();
//         print("222222222222222222222222 ${limitedPosts}");
//
//         setState(() {
//
//         });
//
//         }else{
//
//           limitedPosts =   posts;
//           print("333333333333333333333333 ${limitedPosts}");
//
//
//         }
//       }
//     });
//   }
//
//
//   getNextPosts() {
//
//     if(posts.length < endAt){
//
//       print("list Ended");
//     }else{
//
//
//       print("load more.....................");
//       startAt = startAt + 6;
//       endAt = endAt + 6;
//
//       limitedPosts = userLists.getRange(startAt, endAt).toList();
//
//     setState(() {
//
//     });
//
//
//     }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//             appBar: AppBar(
//               leading: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Icon(
//                   Icons.arrow_back_ios_rounded,
//                   color: Colors.blue,
//                   size: 18,
//                 ),
//               ),
//               centerTitle: true,
//               elevation: 0,
//               backgroundColor: Colors.white,
//               title: Text(
//                 "Flick Meme",
//                 style: TextStyle(
//                   fontFamily: "Cute",
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             body:  isLoading || posts.isEmpty
//                 ? Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Container(
//                         height: MediaQuery.of(context).size.height,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 100),
//                           child: Text(
//                         isLoading ?     "Loading.." : "There is no Flick Meme",
//                             style: TextStyle(
//                               fontFamily: "Cute",
//                               fontSize: 16,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : Container(
//                     height: MediaQuery.of(context).size.height,
//                     child: SingleChildScrollView(
//                       child:
//
//                       FeedPlayer(
//                         posts: limitedPosts,
//                         user: widget.user, loadMore:  getNextPosts, isHide: () {  }, isVisible: () {  },
//
//                       ),
//                     ),
//                   ),
//     );
//   }
// }
