import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class UserSearchList extends SearchDelegate {
  UserSearchList({required this.userId, required this.user});

  final String userId;
  final User user;

  final userList = ["farhan", "noamn", "hira", "usman", "nomi", "natini"];
  final historyList = ["noamn", "salman"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => {query = ""})
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp,
        size: 18,),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestonList = query.isEmpty
        ? historyList
        : userList.where((value) => value.startsWith(query)).toList();

    // return ListView.builder(
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       leading: Icon(Icons.supervised_user_circle),
    //       title: Text(suggestonList[index]),
    //     );
    //   },
    //   itemCount: suggestonList.length,
    // );

    return StreamBuilder(
      stream: userRefRTD.orderByChild("firstName").onValue,
      builder: (context,AsyncSnapshot dataSnapShot) {
        if (!dataSnapShot.hasData) {
          return new Text('Loading...');
        } else {


          final results =
          dataSnapShot.data.values.where((a) => a['firstName'].contains(query));
          return   ListView(
            children: results.map<Widget>((a) => Text(a['firstName'])).toList(),
          );
        }
      },
    );
  }
}
