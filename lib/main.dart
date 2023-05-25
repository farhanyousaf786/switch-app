//@dart=2.9

///******************<><><> Starting Point of the app <><><>**********************///

///********** DOCUMENTATION **********///

/*
 * Documentation will coming soon here:
 *
 */

///********** Bugs to resolve **********///

/*
 * Minor bugs to fix:
 * 1) Meme profile rating is not working for google signUp/signIn users.
 * 2) Sure that Only meme page show proper pop up message to new users.
 *
 */

///********** Important Commands **********///
/*
 * >$ flutter build appbundle --target-platform android-arm,android-arm64
 * >$ flutter build apk --target-platform=android-arm
 * >$ flutter build apk --target-platform=android-arm64
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/Bridges/landingPage.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Themes/switchThemes.dart';
import 'package:switchapp/Themes/theme_services.dart';
import 'package:switchapp/services/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  _launchURL(String updateLink) async {
    if (await canLaunch(updateLink)) {
      await launch(updateLink);
    } else {
      throw 'Could not launch $updateLink';
    }
  }

  // Error widget use to show the error in better UI instead for
  // Red harsh screen

  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Center(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "Internet Error or Restart app",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'cute',
                            color: Colors.lightBlue,
                            fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "or",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'cute',
                            color: Colors.green,
                            fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          _launchURL('http://switchapp.live/#/switchappinfo'),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Click here",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'cute',
                              color: Colors.lightBlue,
                              fontSize: 12),
                        ),
                      ),
                    ),
                    Center(
                        child: SpinKitThreeBounce(
                      color: Colors.lightBlue,
                      size: 12,
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  //The WidgetFlutterBinding is used to interact with the Flutter engine.
  // Firebase.initializeApp() needs to call native code to initialize Firebase,
  // and since the plugin needs to use platform channels to call the native code,
  // which is done asynchronously therefore you have to call ensureInitialized()
  // to make sure that you have an instance of the WidgetsBinding.

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  Constants.isDark = await ThemeService().isDarkTheme();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //MultiProvider provides a state management technique that is used
    // for managing a piece of data around the app. However here we have used
    // it because we want to tell our App's Parent widget if user is Logged in or not
    return MultiProvider(
      providers: [
        Provider<AuthBase>(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode:
            Constants.isDark == "false" ? ThemeMode.light : ThemeMode.dark,
        title: "Switch",
        debugShowCheckedModeBanner: false,
        // this is our home widget, when our app start. our Main widget send us toward first widget
        // that will be the first screen user will see after launch app
        home: LandingPage(),
      ),
    );
  }
}
