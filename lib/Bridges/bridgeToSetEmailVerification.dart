/*
 * This class will set some initial var for database
 * and will set our routes to EmailVerification page
 * where we will see it user verified email link or not
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/services/auth/auth_service.dart';
import 'package:switchapp/pages/sign_up/SetUserData.dart';
import 'package:switchapp/pages/sign_up/emailVerification.dart';
import 'package:switchapp/pages/sign_up/signUpPage.dart';
import 'package:switchapp/Models/SwitchTimer.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class BridgeToSetEmailVerification extends StatefulWidget {
  @override
  _BridgeToSetEmailVerificationState createState() =>
      _BridgeToSetEmailVerificationState();
}

class _BridgeToSetEmailVerificationState
    extends State<BridgeToSetEmailVerification> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return SignUpPage();
          } else {
            return MultiProvider(
              providers: [
                Provider<AuthBase>(
                  create: (_) => Auth(),
                ),
                Provider<User>.value(value: user),
                ChangeNotifierProvider(
                  create: (context) => SwitchTimer(),
                )
              ],
              child: EmailVerification(
                user: user,
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
