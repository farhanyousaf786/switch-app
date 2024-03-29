import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:switchapp/Models/BottomBarComp/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';

import '../../Universal/DataBaseRefrences.dart';

class ReportId extends StatefulWidget {
  late final String profileId;

  ReportId({required this.profileId});

  @override
  _ReportIdState createState() => _ReportIdState();
}

class _ReportIdState extends State<ReportId> {
  TextEditingController _reason = TextEditingController();

  late String action;

  actionWidget() {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 BarTop(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "You want to report this id for $action",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cute",
                           fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please, click on Report to confirm, so Switch App team can make report on it and take appropriate action. "
                      "Our team will resolve this issue within 1 to 2 days and may send you report via email. thanks!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "cute",
                           fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () =>{
                        reportRTD
                            .child("reportId")
                            .child(Constants.myId)
                            .push()
                            .set({
                          "reportId": widget.profileId,
                          "timestamp": DateTime.now().millisecondsSinceEpoch,
                          "reason": action
                        }),
                        Navigator.pop(context),
                        Navigator.pop(context),

                      Fluttertoast.showToast(
                      msg: "Done",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 10,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 14.0,
                      ),

                    },
                      child: Text("Report"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 33,
              height: 33,
              child: Center(
                  child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: Colors.black,
              )),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Report Page",
            style: TextStyle(                            fontWeight: FontWeight.bold,
                color: Colors.black, fontFamily: 'cute'),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "Write the reason, why you are reporting this Profile?",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Colors.grey, fontFamily: 'cute', fontSize: 13),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     height: 50,
              //     padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
              //     child: TextField(
              //       keyboardType: TextInputType.emailAddress,
              //       textInputAction: TextInputAction.next,
              //       style: TextStyle(
              //         color: Colors.lightBlue,
              //         fontSize: 12,
              //         fontFamily: "Cute",
              //       ),
              //       controller: _reason,
              //       decoration: InputDecoration(
              //         fillColor: Colors.transparent,
              //         isDense: true,
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(20)),
              //           borderSide:
              //               new BorderSide(color: Colors.blue, width: 2),
              //         ),
              //         filled: true,
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(20)),
              //           borderSide:
              //               new BorderSide(color: Colors.blue, width: 2),
              //         ),
              //         labelText: 'Write here..',
              //         labelStyle: TextStyle(
              //             fontFamily: "Cute", color: Colors.lightBlue, fontSize: 12),
              //       ),
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please Select a problem.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,

                          fontFamily: 'cute',
                          fontSize: 13),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    action = "Fake Account";
                  });

                  actionWidget();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Fake Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,

                              fontFamily: 'cute',
                              fontSize: 13),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    action = "Fake Name";
                  });

                  actionWidget();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Fake Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,

                              fontFamily: 'cute',
                              fontSize: 13),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    action = "Posting thing against community rules";
                  });

                  actionWidget();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Posting thing against community rules",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,

                              fontFamily: 'cute',
                              fontSize: 13),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    action = "Harassment or Bullying";
                  });

                  actionWidget();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Harassment or Bullying",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,

                              fontFamily: 'cute',
                              fontSize: 13),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    action = "Spread Hate against any group";
                  });

                  actionWidget();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Spread Hate against any group",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,

                              fontFamily: 'cute',
                              fontSize: 13),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
