import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../Universal/DataBaseRefrences.dart';

class AddMemePage extends StatefulWidget {
  @override
  State<AddMemePage> createState() => _AddMemePageState();
}

class _AddMemePageState extends State<AddMemePage> {
  TextEditingController textMemeTopic = TextEditingController();
  TextEditingController textMemeTopicDetails = TextEditingController();

  String postId = Uuid().v4();

  void setTopics() {
    if (textMemeTopic.text.isNotEmpty && textMemeTopicDetails.text.isNotEmpty) {
      switchManiaTopicListRTD.child(postId).set({
        'topic': textMemeTopic.text,
        'postId': postId,
        'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'details': textMemeTopicDetails.text,
      });

      setState(() {
        textMemeTopic.clear();
        textMemeTopicDetails.clear();
        postId = Uuid().v4();
      });
    } else {
      print("Input field is empty");
    }
  }

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
    switchManiaTopicListRTD.once().then((DataSnapshot? dataSnapshot) {
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
                      listOfTopics?[index]['details'],
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "cutes",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      switchManiaTopicListRTD
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
                "Add Topics",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontFamily: 'cute',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 12,
                    fontFamily: "Cute",
                  ),
                  controller: textMemeTopic,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: new BorderSide(color: Colors.blue, width: 2),
                    ),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: new BorderSide(color: Colors.blue, width: 2),
                    ),
                    labelText: ' Add Topic Here..',
                    labelStyle: TextStyle(
                      fontFamily: "Cute",
                      color: Colors.blue.shade900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 12,
                    fontFamily: "Cute",
                  ),
                  controller: textMemeTopicDetails,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: new BorderSide(color: Colors.blue, width: 2),
                    ),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: new BorderSide(color: Colors.blue, width: 2),
                    ),
                    labelText: ' Add Details Here..',
                    labelStyle: TextStyle(
                      fontFamily: "Cute",
                      color: Colors.blue.shade900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setTopics();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontFamily: 'cute',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                elevation: 2,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: isLoading
                      ? Center(
                          child: Text(
                            "Loading..",
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'cute',
                                fontSize: 14),
                          ),
                        )
                      : Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Center(
                                child: Text(
                                  "Topics: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'cute',
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.45,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
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
                                            "${topicList![index]['topic']}",
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
      ),
    );
  }
}
