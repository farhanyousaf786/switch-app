import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../Universal/DataBaseRefrences.dart';

class RemoveFavMemers extends StatefulWidget {
  @override
  _RemoveFavMemersState createState() => _RemoveFavMemersState();
}

class _RemoveFavMemersState extends State<RemoveFavMemers> {


  List<String> memeTopic = [];

  bool isLoading = true;

  @override
  void initState() {


    super.initState();
    _getMemeTopics();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });
  }

  Map? topicMap;
  List? topicList = [];

  void _getMemeTopics() {
    topMemerfRTD.once().then((DataSnapshot? dataSnapshot) {
      if (dataSnapshot != null) {
        topicMap = dataSnapshot.value;
        topicMap!
            .forEach((index, data) => topicList!.add({"key": index, ...data}));

        setState(() {});
      } else {
        print("null");
      }
    });
  }

  bottomBar(int index, List? listOfTopics) {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(

                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(Icons.linear_scale_sharp,
                            color: Colors.white,),
                        ],
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'details',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                  "Username: " +    listOfTopics?[index]['username'],
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                    "Name: " +   listOfTopics?[index]['name'],
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      topMemerfRTD
                          .child(topicList![index]['postId'])
                          .remove();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Delete It",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "cutes",
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Remove Fav Memers",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontFamily: 'cute',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Material(
                  elevation: 2,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: isLoading
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                                "Loading..",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'cute',
                                    fontSize: 14),
                              ),
                            ),
                        )
                        : Column(

                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    "Topics",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'cute',
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              Container(
                                height: 400,
                                width: MediaQuery.of(context).size.width / 1.45,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: topicList!.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      bottomBar(index, topicList);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${topicList![index]['username']}",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontFamily: 'cute',
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
