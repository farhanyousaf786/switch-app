import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Models/SwitchImageCache/SwitchImageCache.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

class RankingList extends StatefulWidget {
  late final List rankingData;
  late final int index;
  late final User user;

  RankingList(
      {required this.index, required this.rankingData, required this.user});

  @override
  _RankingListState createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: 90,
        child: Material(
          elevation: 2,
          color: Constants.isDark == "true" ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "# ${widget.index + 1}",
                    style: TextStyle(
                        fontSize: 8,
                        fontFamily: 'cute',
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 35,
                    height: 35,
                    child: SwitchImageCache(width: 35, height: 35, url:  widget.rankingData[widget.index]['photoUrl'], ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //       widget.rankingData[widget.index]['photoUrl']),
                      // ),


                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    widget.rankingData[widget.index]['username'],
                    style: TextStyle(
                        fontSize: 8,
                        fontFamily: 'cute',
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }


}
