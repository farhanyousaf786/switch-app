import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/services/auth/auth_service.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class SignOut {
  Future<void> signOut(String uid, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final auth = Provider.of<AuthBase>(context, listen: false);
    prefs.remove("firstName");
    prefs.remove("ownerId");
    prefs.remove("url");
    prefs.remove("secondName");
    prefs.remove("email");
    prefs.remove("currentMood");
    prefs.remove("gender");
    prefs.remove("country");
    prefs.remove("dob");
    prefs.remove("about");
    prefs.remove("username");
    prefs.remove("isVerified");
    prefs.remove("isBan");
    prefs.remove("followList");
    final googleSignIn = GoogleSignIn();
    userRefRTD.child(uid).update({"isOnline": "false"});
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
