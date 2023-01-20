import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rive/rive.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../MainPages/ReportAndComplaints/complaintPage.dart';

class NeedHelpPageForSigninPage extends StatefulWidget {


  @override
  _NeedHelpPageForSigninPageState createState() => _NeedHelpPageForSigninPageState();
}

class _NeedHelpPageForSigninPageState extends State<NeedHelpPageForSigninPage> {
  late Map links;
  bool isLoading = true;

  _launchURL(String updateLink) async {
    if (await canLaunch(updateLink)) {
      await launch(updateLink);
    } else {
      throw 'Could not launch $updateLink';
    }
  }

  void _needHelpLinks() {
    switchHelpLinkListRTD.once().then((DataSnapshot snapshot) => {
          if (snapshot.exists)
            {
              setState(() {
                links = snapshot.value;
              }),
            }
          else
            {
              switchHelpLinkListRTD.set({
                'registerLink': "",
                'helpLink': "",
                'howToUseApp': "",
              })
            }
        });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });
    _needHelpLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
      ),
      body: isLoading
          ? Center(
              child: SpinKitCircle(
                color: Colors.white,
                size: 20,
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: 200,
                      child: RiveAnimation.asset(
                        'images/authLogo.riv',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(

                               "How To Register (SignIn/SignUp)?",

                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'cute',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>{


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
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "This will lead you out of the Switch App.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "cutes",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                if (await canLaunch(links['registerLink'])) {
                                                  await launch(links['registerLink']);
                                                } else {
                                                  throw 'Could not launch ${links['registerLink']}';
                                                }
                                              },
                                              child: Text(
                                                "Ok Continue",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "cutes",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),





                        },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Click Here",
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontFamily: 'cute',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
