import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../mood/moodUi.dart';

class SwitchFav extends StatefulWidget {
  User user;

  SwitchFav({required this.user});

  @override
  _SwitchFavState createState() => _SwitchFavState();
}

class _SwitchFavState extends State<SwitchFav> {
  bool isLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SpinKitThreeBounce(
                  color: Colors.lightBlue,
                  size: 15,
                ),
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Favourites Memers",
                      style: TextStyle(
                          color: Colors.blue, fontFamily: 'cute', fontSize: 15),
                    ),
                  ),
                ),
                FrontSlides(user: widget.user),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 15, bottom: 4),
                //     child: Text(
                //       "Favourites Meme",
                //       style: TextStyle(
                //           color: Colors.blue, fontFamily: 'cute', fontSize: 15),
                //     ),
                //   ),
                // ),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       "This slide will update soon",
                //       style: TextStyle(
                //           color: Colors.grey, fontFamily: 'cute', fontSize: 10),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
  }
}
