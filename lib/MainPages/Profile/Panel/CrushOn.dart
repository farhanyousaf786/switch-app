import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class CrushOnPage extends StatefulWidget {
  final String profileOwner;
  final String currentUserId;

  const CrushOnPage({required this.profileOwner, required this.currentUserId});

  @override
  _CrushOnPageState createState() => _CrushOnPageState();
}

class _CrushOnPageState extends State<CrushOnPage> {
  bool isLoading = true;
  bool isError = false;
  bool isListReady = false;
  List followersList = [];

  @override
  void initState() {
    super.initState();

    _getFollowerList();
  }

  _getFollowerList() {
    crushOnRTD
        .child(widget.profileOwner)
        .child("crushOnReference")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        Map crushOnMap = dataSnapshot.value;
        List crushOnList = [];

        crushOnMap.forEach(
            (index, data) => crushOnList.add({"user": index, ...data}));

        setState(() {
          this.followersList = crushOnList;
        });

        isLoading = false;
      } else {
        setState(() {
          isError = true;
        });
      }
    });
  }

  _returnValue(List userList, int index) {
    return StreamBuilder(
      stream: userRefRTD.child(userList[index]['crushOnId']).onValue,
      builder: (context, AsyncSnapshot dataSnapShot) {
        if (dataSnapShot.hasData) {
          DataSnapshot snapshot = dataSnapShot.data.snapshot;
          Map followersDetail = snapshot.value;

          return _finalList(followersDetail);
        }
        return Container();
      },
    );
  }

  _finalList(Map followersDetail) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(followersDetail['url'] == null
                          ? "https://switchappimages.nyc3.digitaloceanspaces.com/StaticUse/1646080905939.jpg"
                          : followersDetail['url']),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  followersDetail['firstName'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                followersDetail['secondName'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          // Container(
          //   width: 90,
          //   height: 35,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       color: Colors.lightBlue.shade400),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Decency: ",
          //         style: TextStyle(
          //             color: Colors.white, fontSize: 9, fontFamily: 'cute'),
          //       ),
          //       Text(
          //         " 100%",
          //         style: TextStyle(
          //             color: Colors.white, fontSize: 10, fontFamily: 'cute'),
          //       )
          //     ],
          //   ),
          // ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Crush On"
            "",
            style: TextStyle(
                color: Colors.lightBlue, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                  semanticsLabel: "No Followers",
                ),
              )
            : ListView.builder(
                itemCount: followersList.length,
                itemBuilder: (context, index) {
                  return _returnValue(followersList, index);
                }));
  }
}
