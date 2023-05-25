import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switchapp/pages/report_and_complaints/postReportPage.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

import '../../../Models/BottomBarComp/topBar.dart';
import '../../report_and_complaints/reportId.dart';

class OptionBottomBar {
  void optionBottomBar(
      BuildContext context,
      String type,
      String uid,
      String postId,
      String url,
      String ownerId,
      int index,
      Function deleteFunc,
      Function blockFunction) {
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
                  type == 'meme' || type == "memeT"
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              switchShowCaseRTD
                                  .child(uid)
                                  .child(postId)
                                  .once()
                                  .then((DataSnapshot dataSnapshot) => {
                                        if (dataSnapshot.value != null)
                                          {
                                            switchShowCaseRTD
                                                .child(uid)
                                                .child(postId)
                                                .remove(),
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Remove From Your Meme Showcase",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 3,
                                              backgroundColor: Colors.lightBlue,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          }
                                        else
                                          {
                                            switchShowCaseRTD
                                                .child(uid)
                                                .child(postId)
                                                .set({
                                              "memeUrl": url,
                                              "ownerId": ownerId,
                                              'timestamp': DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              'postId': postId,
                                            }),
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Added to your Meme Showcase",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 3,
                                              backgroundColor: Colors.lightBlue,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          }
                                      });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4, left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Add/Remove from Meme ShowCase ",
                                    style: TextStyle(
                                        fontFamily: 'cute',
                                        fontSize: 14,
                                        color: Constants.isDark == "true"
                                            ? Colors.white
                                            : Colors.lightBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.apps,
                                      color: Constants.isDark == "true"
                                          ? Colors.white
                                          : Colors.lightBlue,
                                      size: 17,
                                      // color: selectedIndex == index
                                      //     ? Colors.pink
                                      //     : selectedIndex == 121212
                                      //         ? Colors.grey
                                      //         : Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  ownerId == Constants.myId || uid == Constants.switchId
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0, left: 20),
                          child: TextButton(
                              child: Row(
                                children: [
                                  Text(
                                    'Delete Post',
                                    style: TextStyle(
                                        fontFamily: 'cute',
                                        fontSize: 14,
                                        color: Constants.isDark == "true"
                                            ? Colors.white
                                            : Colors.lightBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Constants.isDark == "true"
                                        ? Colors.white
                                        : Colors.lightBlue,
                                  ),
                                ],
                              ),
                              onPressed: () => {
                                    deleteFunc(postId, ownerId, type, index),
                                  }),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10),
                          child: ElevatedButton(
                            child: Row(
                              children: [
                                Text(
                                  'Report Post ',
                                  style: TextStyle(
                                    fontFamily: 'cute',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.isDark == "true"
                                        ? Colors.white
                                        : Colors.lightBlue,
                                  ),
                                ),
                                Icon(
                                  Icons.error_outline,
                                  size: 20,
                                  color: Constants.isDark == "true"
                                      ? Colors.white
                                      : Colors.blue,
                                ),
                              ],
                            ),
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostReport(
                                            reportById: uid,
                                            reportedId: ownerId,
                                            postId: postId,
                                            type: "reportPost",
                                          )))
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.transparent,
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  ownerId == Constants.myId
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10),
                          child: ElevatedButton(
                            child: Row(
                              children: [
                                Text(
                                  'Report User ',
                                  style: TextStyle(
                                    fontFamily: 'cute',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.isDark == "true"
                                        ? Colors.white
                                        : Colors.lightBlue,
                                  ),
                                ),
                                Icon(
                                  Icons.account_circle_outlined,
                                  size: 20,
                                  color: Constants.isDark == "true"
                                      ? Colors.white
                                      : Colors.lightBlue,
                                ),
                              ],
                            ),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReportId(profileId: ownerId)),
                              )
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.transparent,
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  ownerId == Constants.myId
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10),
                          child: ElevatedButton(
                            child: Row(
                              children: [
                                Text(
                                  'Block User ',
                                  style: TextStyle(
                                      fontFamily: 'cute',
                                      fontSize: 14,
                                      color: Constants.isDark == "true"
                                          ? Colors.white
                                          : Colors.lightBlue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.block,
                                  size: 20,
                                  color: Constants.isDark == "true"
                                      ? Colors.white
                                      : Colors.lightBlue,
                                ),
                              ],
                            ),
                            onPressed: () => {
                              blockUser(context, ownerId, Constants.myId,
                                  blockFunction),
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.transparent,
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }

  blockUser(BuildContext context, String profileOwner, String currentUserId,
      Function blockFunction) {
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
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Are you sure?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cute",
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "cute",
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          onTap: () {
                            blockFunction(profileOwner, currentUserId);
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "cute",
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "To see immediate effect, Restart your app. After restart, you will not see any posts and comments from this person. And this person will not be able to see your profile and posts.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: "cute",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
