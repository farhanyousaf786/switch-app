import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class AppControlAdmin extends StatefulWidget {
  late Map? controlData;

  AppControlAdmin({required this.controlData});

  @override
  _AppControlAdminState createState() => _AppControlAdminState();
}

class _AppControlAdminState extends State<AppControlAdmin> {
  bool isLoading = true;
  String currentStatus = "";
  String appStatus = "";

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });

    getCurrentCompStatus();
    getAppStatus();
    super.initState();
  }

  void getCurrentCompStatus() {
    if (widget.controlData!['compStatus'] == 'live') {
      setState(() {
        currentStatus = "Live";
      });
    } else if (widget.controlData!['compStatus'] == 'end') {
      setState(() {
        currentStatus = "End";
      });
    } else {
      setState(() {
        currentStatus = "NotLiveYet";
      });
    }
  }

  void getAppStatus() {
    if (widget.controlData!['isAppLive'] == 'yes') {
      setState(() {
        appStatus = "yes";
      });
    } else if (widget.controlData!['isAppLive'] == 'no') {
      setState(() {
        appStatus = "no";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: Container(
                child: SpinKitCircle(
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            )
          : Container(
              child: Center(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Comp. Status",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text(
                            "End",
                            style: TextStyle(
                                color: currentStatus == 'End'
                                    ? Colors.lightBlue
                                    : Colors.grey),
                          ),
                          onPressed: () => {
                            setState(() {
                              currentStatus = "End";
                            }),
                            switchMemeCompRTD
                                .child('status')
                                .update({'status': "end"}),
                            appControlRTD.update({'compStatus': "end"}),
                          },
                        ),
                        TextButton(
                          onPressed: () => {
                            setState(() {
                              currentStatus = "Live";
                            }),
                            switchMemeCompRTD
                                .child('status')
                                .update({'status': "live"}),
                            appControlRTD.update({'compStatus': "live"}),
                          },
                          child: Text(
                            "Live",
                            style: TextStyle(
                                color: currentStatus == 'Live'
                                    ? Colors.lightBlue
                                    : Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
                            setState(() {
                              currentStatus = "NotLiveYet";
                            }),
                            switchMemeCompRTD
                                .child('status')
                                .update({'status': "notLiveYet"}),
                            appControlRTD.update({'compStatus': "notLiveYet"}),
                          },
                          child: Text(
                            "Not Live",
                            style: TextStyle(
                                color: currentStatus == 'NotLiveYet'
                                    ? Colors.lightBlue
                                    : Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "App Status",
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => {
                                setState(() {
                                  appStatus = "yes";
                                }),
                                appControlRTD.update({'isAppLive': "yes"}),
                              },
                              child: Text(
                                "Live",
                                style: TextStyle(
                                    color: appStatus == 'yes'
                                        ? Colors.lightBlue
                                        : Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () => {
                                setState(() {
                                  appStatus = "no";
                                }),
                                appControlRTD.update({'isAppLive': "no"}),
                              },
                              child: Text(
                                "Not Live",
                                style: TextStyle(
                                    color: appStatus == 'no'
                                        ? Colors.lightBlue
                                        : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
    );
  }
}
