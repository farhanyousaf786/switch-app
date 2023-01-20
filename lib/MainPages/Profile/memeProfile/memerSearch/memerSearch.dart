import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchapp/MainPages/Profile/Panelandbody.dart';
import 'package:switchapp/MainPages/Profile/memeProfile/memerSearch/memerProfileList.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Universal/DataBaseRefrences.dart';

class MemerSearch extends StatefulWidget {
  final List memerList;
  final User user;

  const MemerSearch({required this.memerList, required this.user});

  @override
  _MemerSearchState createState() => _MemerSearchState();
}

class _MemerSearchState extends State<MemerSearch> {
  TextEditingController editingController = TextEditingController();

  List _foundUsers = [];
  bool uploading = false;

  @override
  void initState() {
    _foundUsers = widget.memerList;

    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.memerList;
    } else {
      results = widget.memerList
          .where((user) => user["username"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  late Map memerMap;

  getUserData(String uid) async {
    await userRefRTD.child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          memerMap = dataSnapshot.value;

          print(uid);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.blue,
              size: 18,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Memers Ranking",
          style:
              TextStyle(fontSize: 18, fontFamily: 'cute', color: Colors.blue),
        ),
      ),
      body: _foundUsers.isNotEmpty
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _foundUsers.length,
                        itemBuilder: (context, index) =>
                            memerList(index, _foundUsers)),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                          labelText: 'Search by username',
                          suffixIcon: Icon(Icons.search),
                          labelStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: "cutes",
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                uploading
                    ? LinearProgressIndicator()
                    : Container(
                        height: 0,
                        width: 0,
                      ),
              ],
            )
          : Center(
              child: const Text(
                'No Memer found',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontFamily: 'cutes',
                ),
              ),
            ),
    );
  }

  Widget _rankingList(List rankingData, int index) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "# ${index + 1}",
                style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'cutes',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white, width: 1),
                  image: DecorationImage(
                    image: NetworkImage(rankingData[index]['photoUrl']),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                rankingData[index]['username'],
                style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'cutes',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  memerList(int index, List _foundUsers) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          uploading = true;
        }),
        getUserData(_foundUsers[index]["uid"]),
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            uploading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider<User>.value(
                value: widget.user,
                child: SwitchProfile(
                  currentUserId: widget.user.uid,
                  mainProfileUrl: memerMap['url'],
                  mainFirstName: memerMap['firstName'],
                  profileOwner: memerMap['ownerId'],
                  mainSecondName: memerMap['secondName'],
                  mainCountry: memerMap['country'],
                  mainDateOfBirth: memerMap['dob'],
                  mainAbout: memerMap['about'],
                  mainEmail: memerMap['email'],
                  mainGender: memerMap['gender'],
                  username: _foundUsers[index]['username'],
                  isVerified: memerMap['isVerified'],
                  action: 'memerSearch',
                  user: widget.user,
                ),
              ),
            ),
          );
        }),
      },
      child: MemerProfileList(
        index: index,
        foundUsers: _foundUsers,
      ),
    );
  }
}
