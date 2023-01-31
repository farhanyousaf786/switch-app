import 'package:flutter/material.dart';

class FollowButtonUi extends StatelessWidget {
  const FollowButtonUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          " Follow ",
          style: TextStyle(
              fontSize: 11,
              fontFamily: 'cute',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
