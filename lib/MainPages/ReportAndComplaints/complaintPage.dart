import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switchapp/Models/BottomBar/topBar.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class ComplaintUs extends StatefulWidget {
  @override
  _ComplaintUsState createState() => _ComplaintUsState();
}

class _ComplaintUsState extends State<ComplaintUs> {
  TextEditingController _reason = TextEditingController();

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
                      "Please, click on Send button to confirm",
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
                      onPressed: () => {
                        reportRTD
                            .child("switchComplaint")
                            .child(Constants.myId)
                            .push()
                            .set({
                          "timestamp": DateTime.now().millisecondsSinceEpoch,
                          "reason": _reason.text
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
                      child: Text("Send"),
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
            "Complaint Page",
            style: TextStyle(color: Colors.black, fontFamily: 'cute',                         fontWeight: FontWeight.bold,
            ),
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
                      "Please Write Below",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'cute',
                          fontSize: 13),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "Cute",
                       fontWeight: FontWeight.bold,

                    ),
                    controller: _reason,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            new BorderSide(color: Colors.grey, width: 2),
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            new BorderSide(color: Colors.grey, width: 2),
                      ),
                      labelText: 'type here..',
                      labelStyle: TextStyle(
                        fontFamily: "Cute",
                         fontWeight: FontWeight.bold,

                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () => {
                    reportRTD
                        .child("switchComplaint")
                        .child(Constants.myId)
                        .push()
                        .set({
                      "timestamp": DateTime.now().millisecondsSinceEpoch,
                      "reason": _reason.text,
                    }),
                    Navigator.pop(context),
                    Fluttertoast.showToast(
                      msg:
                          "Switch App team can make report on it and take appropriate action."
                          "Our team will resolve this issue within 1 to 2 weeks and may send you report via email. thanks!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 20,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    ),
                  },
                  child: Text("Send"),
                ),
              ),
            ],
          ),
        ));
  }
}
