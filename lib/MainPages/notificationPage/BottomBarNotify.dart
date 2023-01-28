import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:switchapp/MainPages/notificationPage/NotificationItem.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class NotifyBottomBar {
  final _random = new Random();

  late int randomNotify = 100;

  void bottomSheetForNotify(BuildContext context, User user) {
    randomNotify = _random.nextInt(80) + 20; // 100-200
    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.blue.withOpacity(0.2),
        elevation: 0,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.2,
            child: StreamBuilder(
                stream: feedRtDatabaseReference
                    .child(Constants.myId)
                    .child("feedItems")
                    .orderByChild("timestamp")
                    .limitToLast(randomNotify)
                    .onValue,
                builder: (context, AsyncSnapshot dataSnapShot) {
                  if (!dataSnapShot.hasData) {
                    return Scaffold(
                      body: Center(
                        child: SpinKitRipple(
                          color: Colors.lightBlue,
                        ),
                      ),
                    );
                  }

                  DataSnapshot snapshot = dataSnapShot.data.snapshot;
                  Map data = snapshot.value;
                  List item = [];

                  if (data == null) {
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 0.0,
                        title: Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      body: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Center(
                              child: Center(
                                child: Text(
                                  "There is no Notification yet",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'cute'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Center(
                              child: Container(
                                child: SpinKitRipple(
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    data.forEach(
                        (index, data) => item.add({"key": index, ...data}));
                  }

                  item.sort((a, b) {
                    return b["timestamp"].compareTo(a["timestamp"]);
                  });
                  print("Notificatonssssss: : : : : : : : :: ${item.length}");

                  return dataSnapShot.data.snapshot.value == null
                      ? Scaffold(
                          appBar: AppBar(
                            elevation: 0.0,
                            title: Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            centerTitle: true,
                          ),
                          body: Container(
                              child: SpinKitRipple(
                            color: Colors.lightBlue,
                          )),
                        )
                      : Scaffold(
                          appBar: AppBar(
                            elevation: 1.0,
                            title: Text(
                              "Notification",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'cute'),
                            ),
                            centerTitle: true,
                          ),
                          body: BuildItemForNotification(
                            item: item,
                            data: data,
                            user: user,
                          ),
                        );
                }),
          );
        });
  }
}
