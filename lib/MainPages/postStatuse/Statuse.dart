// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:switchtofuture/MainPages/Upload/SwitchStatus.dart';
// import 'package:switchtofuture/MainPages/Upload/uploadImages.dart';
// import 'package:switchtofuture/Models/Constans.dart';
// import 'package:switchtofuture/UniversalResources/UserProvider.dart';
//
// class PostStatus extends StatefulWidget {
//   @override
//   _PostStatusState createState() => _PostStatusState();
// }
//
// class _PostStatusState extends State<PostStatus> {
//   UserProvider userProvider;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       userProvider = Provider.of<UserProvider>(context, listen: false);
//       await userProvider.refreshUser();
//       userProvider.getUsers.ownerId == null
//           ? Text("")
//           : print(
//               "userProvider.refreshUser(): ${userProvider.getUsers.ownerId}");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0.0,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Switch To Upload',
//           style: GoogleFonts.baloo(fontSize: 20, color: Colors.black),
//         ),
//       ),
//       body: DelayedDisplay(
//         fadeIn: true,
//         delay: Duration(milliseconds: 300),
//         slidingBeginOffset: Offset(0.0, 0.40),
//         child: Container(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: ShaderMask(
//                     shaderCallback: (Rect rect) {
//                       return LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.red,
//                           Colors.transparent,
//                           Colors.transparent,
//                           Colors.pink
//                         ],
//                         stops: [
//                           0.0,
//                           0.0,
//                           0.7,
//                           1.0
//                         ], // 10% purple, 80% transparent, 10% purple
//                       ).createShader(rect);
//                     },
//                     blendMode: BlendMode.dstOut,
//                     child: Container(
//                       height: MediaQuery.of(context).size.height / 4.5,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage('images/fakeSmile.jpg'),
//                           fit: BoxFit.cover,
//                         ),
//                         shape: BoxShape.rectangle,
//                       ),
//                     )),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               GestureDetector(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
//                   child: Text(
//                     "You can Upload any image that's not suits your mood. After All this is Parallel Universe, Isn't? :):",
//                     style: TextStyle(
//                         color: Colors.black87,
//                         fontFamily: "Names",
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15),
//                     textAlign: TextAlign.center,
//                     textScaleFactor: 1,
//                   ),
//                 ),
//                 onTap: () {},
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width / 1.5,
//                 height: 230,
//                 child: ListView(
//                   children: [
//                     Container(
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SwitchStatus(
//                                 // globalKey: _globalKey,
//                                 user: Constants.myId,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Card(
//                             color: Colors.blue.shade100,
//                             child: Center(
//                                 child: Text(
//                               "Upload Image 🎴",
//                               style: GoogleFonts.baloo(
//                                   fontSize: 15, color: Colors.black),
//                             ))),
//                       ),
//                       height: 100,
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       child: Card(
//                           color: Colors.blue.shade100,
//                           child: Center(
//                               child: Text(
//                             "Upload Video 🎥",
//                             style: GoogleFonts.baloo(
//                                 fontSize: 15, color: Colors.black),
//                           ))),
//                       height: 100,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
