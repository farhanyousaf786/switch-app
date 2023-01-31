import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchapp/Universal/Constans.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';
import 'package:uuid/uuid.dart';

class FollowButtonMainPage {
  List followingList = [];
  String postId = Uuid().v4();


  getFollowingUsers(
    String uid,
    String followId,
      String username,
      String url,
      int index,
  ) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 1), () {
      /// this code will add notification to the use that have been followed
      feedRtDatabaseReference
          .child(followId)
          .child("feedItems")
          .child(postId)
          .set({
        "type": "follow",
        "firstName": Constants.myName,
        "secondName": Constants.mySecondName,
        "comment": "",
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "url": Constants.myPhotoUrl,
        "postId": postId,
        "ownerId": followId,
        "photourl": "",
        "isRead": false,
      });

      //For Realtime DataBase

      userFollowingRtd
          .child(uid)
          .child(followId)
          .set({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'followingId': followId,
        'token': Constants.token,
      });

      userFollowersRtd
          .child(followId)
          .child(uid)
          .set({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'followerId': uid,
        'token': Constants.token,
      });

      followingCounter(followId, uid, username, url);
      prefs.remove("followList");
    });

  }


  followingCounter(String followId, String uid, String username, String url) {
    late Map data;
    userFollowersRtd
        .child(followId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
          data = dataSnapshot.value;

        userFollowersCountRtd.child(followId).update({
          "followerCounter": data.length,
          "uid": followId,
          "username": username,
          "photoUrl": url,
        });
        if (data.length == 100) {
          feedRtDatabaseReference
              .child(followId)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "planetLevel",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "postId": postId,
            "ownerId": uid,
            "photourl": "",
            "isRead": false,
          });
        } else if (data.length == 1000) {
          feedRtDatabaseReference
              .child(followId)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "solarLevel",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "postId": postId,
            "ownerId": uid,
            "photourl": "",
            "isRead": false,
          });
        } else if (data.length == 10000) {
          feedRtDatabaseReference
              .child(followId)
              .child("feedItems")
              .child(postId)
              .set({
            "type": "galaxyLevel",
            "firstName": Constants.myName,
            "secondName": Constants.mySecondName,
            "comment": "",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "url": Constants.myPhotoUrl,
            "postId": postId,
            "ownerId": uid,
            "photourl": "",
            "isRead": false,
          });
        }
        print("yesssssssssssssssssssssss");
      } else {
        print("nooooooooooooooooooooooooooo");
        userFollowersCountRtd.child(followId).update({
          "followerCounter": 0,
          "uid": followId,
          "username": username,
          "photoUrl": url,
        });
      }
    });


  }

}
