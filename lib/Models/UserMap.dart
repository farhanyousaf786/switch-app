import 'package:cloud_firestore/cloud_firestore.dart';

class UserMap {
 late String currentMood;
 late String about;
 late String isBan;
 late String country;

  // Timestamp dateOfBirth;
 late String email;
 late String dob;
 late String androidNotificationToken;
 late String firstName;
 late String secondName;
 late String ownerId;
 late String url;
 late String gender;
 late String postId;
 late String timestamp;

  UserMap({
   required this.firstName,
    required  this.url,
    required this.dob,
    required   this.email,
    required  this.about,
    required  this.ownerId,
    required  this.isBan,
    required  this.country,
    // this.dateOfBirth,
    required this.secondName,
    required this.androidNotificationToken,
    required this.gender,
    required this.postId,
    required this.timestamp,
    required this.currentMood,
  });

   Map toMap(UserMap userMap) {
    var data = Map<String, dynamic>();
    data['firstName'] = userMap.firstName;
    data['dob'] = userMap.dob;

    data['url'] = userMap.url;
    data['email'] = userMap.email;
    data['secondName'] = userMap.secondName;
    data["isBan"] = userMap.isBan;
    data["androidNotificationToken"] = userMap.androidNotificationToken;
    // data["dateOfBirth"] = userMap.dateOfBirth;
    data["about"] = userMap.about;
    data["ownerId"] = userMap.ownerId;
    data["country"] = userMap.country;
    data["gender"] = userMap.gender;
    data["postId"] = userMap.postId;
    data["timestamp"] = userMap.timestamp;
    data["currentMood"] = userMap.currentMood;

    return data;
  }

  UserMap.fromMap(Map<String, dynamic> mapData) {
    this.firstName = mapData['firstName'];

    this.ownerId = mapData['ownerId'];
    this.email = mapData['email'];
    this.dob = mapData['dob'];

    this.url = mapData['url'];
    this.about = mapData['about'];
    this.secondName = mapData['secondName'];
    this.postId = mapData['postId'];
    this.isBan = mapData['isBan'];
    this.country = mapData['country'];
    // this.dateOfBirth = mapData['dateOfBirth'];
    this.gender = mapData['gender'];
    this.androidNotificationToken = mapData['androidNotificationToken'];
    this.timestamp = mapData['timestamp'];
    this.currentMood = mapData['currentMood'];
  }
}

class UserMap2 {
  final String currentMood;

  final String about;
  final String isBan;
  final String country;

  // final Timestamp dateOfBirth;
  final String email;
  final String dob;
  final String androidNotificationToken;
  final String firstName;
  final String secondName;
  final String ownerId;
  final String url;
  final String gender;
  final String postId;
  final String timestamp;

  UserMap2({
    required this.currentMood,
    required  this.firstName,
    required   this.url,
    required   this.dob,
    required   this.email,
    required   this.about,
    required   this.ownerId,
    required   this.isBan,
    required  this.country,
    // this.dateOfBirth,
    required  this.secondName,
    required this.androidNotificationToken,
    required  this.gender,
    required  this.postId,
    required  this.timestamp,
  });

  factory UserMap2.fromDocument(
    DocumentSnapshot doc,
  ) {
    return UserMap2(
      currentMood: doc['currentMood'],
      firstName: doc['firstName'],
      ownerId: doc['ownerId'],
      email: doc['email'],
      url: doc['url'],
      dob: doc['dob'],

      about: doc['about'],
      secondName: doc['secondName'],
      postId: doc['postId'],
      isBan: doc['isBan'],
      country: doc['country'],
      // dateOfBirth: doc['dateOfBirth'],
      gender: doc['gender'],
      androidNotificationToken: doc['androidNotificationToken'],
      timestamp: doc['timestamp'],
    );
  }
}
