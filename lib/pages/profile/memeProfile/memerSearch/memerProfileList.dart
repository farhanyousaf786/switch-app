import 'package:flutter/material.dart';
import 'package:switchapp/Models/Marquee.dart';
import 'package:switchapp/Models/SwitchCacheImg/SwitchImageCache.dart';

class MemerProfileList extends StatefulWidget {
  late final List foundUsers;
  late final int index;

  MemerProfileList({required this.index, required this.foundUsers});

  @override
  _MemerProfileListState createState() => _MemerProfileListState();
}

class _MemerProfileListState extends State<MemerProfileList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(widget.foundUsers[widget.index]["username"]),
      elevation: 0.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      child: SwitchCacheImage(
                        width: 35,
                        height: 35,
                        url: widget.foundUsers[widget.index]['photoUrl'],
                        boxFit: BoxFit.cover, screen: '',
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.black54, width: 2),

                        // image: DecorationImage(
                        //   image: NetworkImage(
                        //       widget.foundUsers[widget.index]['photoUrl']),
                        // ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 150,
                      child: MarqueeWidget(
                        child: Text(
                          widget.foundUsers[widget.index]['username'],
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'cute',
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
