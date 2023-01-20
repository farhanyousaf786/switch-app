

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Models/Marquee.dart';

import 'memeCompetition/memeComp.dart';
import 'rewardAds.dart';

class MemeAndStuff extends StatefulWidget {
  final User user;
  late Map? controlData;


   MemeAndStuff({required this.user, required this.controlData});

  @override
  _MemeAndStuffState createState() => _MemeAndStuffState();
}

class _MemeAndStuffState extends State<MemeAndStuff> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    getPrefInst();
  }

  getPrefInst() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemeComp(
                              user: widget.user,
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: MarqueeWidget(
                          child: Text(
                            "Meme Competition",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                              fontFamily: 'Names',
                            ),
                          ),
                        ),
                      ),
                    ),
                    height: 28,
                    width: MediaQuery.of(context).size.width / 4.2),
              ),
            ),
            GestureDetector(
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
                                  "Meme Crown will open when we reach 5000+ user in Switch App & Participant must have 100+ follower.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "cutes",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "What is Meme Crown?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "cutes",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Meme Crow will Show the activity of Switch App Memers, For Example: Top Memers, Memer of the week, Pro Tags etc",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "cutes",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: MarqueeWidget(
                        child: Text(
                          "Meme Crown",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),
                  height: 28,
                  width: MediaQuery.of(context).size.width / 4.6,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RewardAds()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: MarqueeWidget(
                        child: Text(
                          "Rewards",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                            fontFamily: 'Names',
                          ),
                        ),
                      ),
                    ),
                  ),
                  height: 28,
                  width: MediaQuery.of(context).size.width / 4.8,
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     showModalBottomSheet(
            //         useRootNavigator: true,
            //         isScrollControlled: true,
            //         barrierColor: Colors.red.withOpacity(0.2),
            //         elevation: 0,
            //         clipBehavior: Clip.antiAliasWithSaveLayer,
            //         context: context,
            //         builder: (context) {
            //           return Container(
            //             height: MediaQuery.of(context).size.height / 1.5,
            //             child: SingleChildScrollView(
            //               child: Column(
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(5.0),
            //                     child: Row(
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Icon(Icons.linear_scale_sharp),
            //                       ],
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.only(top: 10),
            //                     child: Text(
            //                       "Follow someone and Restart the App",
            //                       style: TextStyle(
            //                           fontSize: 18,
            //                           fontFamily: "cute",
            //                           color: Colors.blue),
            //                     ),
            //                   ),
            //                   Padding(
            //                       padding: const EdgeInsets.only(
            //                           top: 10, left: 8, right: 8),
            //                       child: Text(
            //                         "By following you will get your timeline fill with their posts",
            //                         textAlign: TextAlign.center,
            //                         style: TextStyle(
            //                             fontSize: 14,
            //                             fontFamily: "cutes",
            //                             color: Colors.black54,
            //                             fontWeight: FontWeight.bold),
            //                       )),
            //                   Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: FirstFollowing(
            //                         user: widget.user,
            //                       )),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: GestureDetector(
            //                         onTap: () {
            //                           prefs.setInt("totalFollowing", 1);
            //                           print("tapped");
            //                           Fluttertoast.showToast(
            //                             msg: "It will never show again",
            //                             toastLength: Toast.LENGTH_LONG,
            //                             gravity: ToastGravity.SNACKBAR,
            //                             timeInSecForIosWeb: 3,
            //                             backgroundColor:
            //                                 Colors.blue.withOpacity(0.8),
            //                             textColor: Colors.white,
            //                             fontSize: 16.0,
            //                           );
            //                         },
            //                         child: Text(
            //                           "Do not Show Again",
            //                           style: TextStyle(
            //                               color: Colors.red,
            //                               fontFamily: 'cute',
            //                               fontSize: 14),
            //                         )),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         });
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(color: Colors.blue),
            //           borderRadius: BorderRadius.circular(8)),
            //       child: Padding(
            //         padding: const EdgeInsets.all(4.0),
            //         child: Center(
            //           child: MarqueeWidget(
            //             child: Text(
            //               "Follow Users",
            //               style: TextStyle(
            //                 color: Colors.blue,
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: 9,
            //                 fontFamily: 'Names',
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       height: 28,
            //       width: MediaQuery.of(context).size.width / 4.5,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
