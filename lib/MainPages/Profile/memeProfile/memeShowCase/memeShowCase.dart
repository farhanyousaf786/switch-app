import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/Universal/Constans.dart';
import '../../../../Models/postModel/SinglePostDetail.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class MemeShowCase extends StatefulWidget {
  late final User user;
  late final String profileOwnerId;

  MemeShowCase({required this.user, required this.profileOwnerId});

  @override
  _MemeShowCaseState createState() => _MemeShowCaseState();
}

class _MemeShowCaseState extends State<MemeShowCase> {
  List imageList = [];
  bool loading = true;

  @override
  void initState() {

    switchShowCaseRTD
        .child(widget.profileOwnerId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map data = dataSnapshot.value;
        data.forEach((index, data) => imageList.add({"key": index, ...data}));
        imageList.sort((a, b) {
          return b["timestamp"].compareTo(a["timestamp"]);
        });
        setState(() {

        });
        print(data);
      } else {
        print("no data");
      }
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted)
        setState(() {
          loading = false;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(25),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
            color: Constants.isDark == "true" ? Colors.grey.shade900 : Colors.blue,
            borderRadius: BorderRadius.circular(15)),
        height: imageList.isEmpty ? 130 : 195,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Meme Show Case",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'cute'),
                ),
              ),

              imageList.isEmpty
                  ? Container(
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15)
                ),

                      height: 90,
                      width: MediaQuery.of(context).size.width/1.1,
                      child: Center(
                          child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, right: 10, left: 10),
                        child: Text(
                      loading ? "Loading..":    "Currently, No Meme to show. Here, user can add Favorite MEMES. User can add Memes to his/her ShowCase by just tapping option Icon on that Meme and then select 'Add/Remove from Meme ShowCase'.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'cute',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      )),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CarouselSlider.builder(
                        itemCount: imageList.length,
                        options: CarouselOptions(
                          height: 130,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          reverse: false,
                        ),
                        itemBuilder: (context, i, id) {
                          //for onTap to redirect to another screen
                          return Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                    )),
                                //ClipRRect for image border radius
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.network(
                                    imageList[i]['memeUrl'],
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Center(
                                        child: const Text(
                                          'Loading..',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'cute'),
                                        ),
                                      );
                                    },
                                    width: 270,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Provider.value(
                                      value: widget.user,
                                      child: SinglePostDetail(
                                        url: imageList[i]['memeUrl'],
                                        postId: imageList[i]['postId'],
                                        ownerId: imageList[i]['ownerId'],
                                      ),
                                    ),
                                  ),
                                );                            },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
