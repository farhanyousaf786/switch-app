import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BestFriendList extends StatefulWidget {
  final int index;
  final List bestFriendList;

  const BestFriendList({ required this.index, required this.bestFriendList})
      ;

  @override
  _BestFriendListState createState() => _BestFriendListState();
}

class _BestFriendListState extends State<BestFriendList> {
  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                border: Border.all(color: Colors.blue, width: 1),
                image: DecorationImage(
                  image: NetworkImage(
                      widget.bestFriendList[widget.index]['profileUrl']),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                child: Text(widget.bestFriendList[widget.index]['firstName'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'cute',
                  color: Colors.grey.shade600,
                  fontSize: 10
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
