


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopMemes extends StatefulWidget {

  late final User user;
  final VoidCallback isVisible;
  final VoidCallback isHide;

  TopMemes({
    required this.user,
    required this.isVisible,
    required this.isHide,
  });

  @override
  _TopMemesState createState() => _TopMemesState();
}

class _TopMemesState extends State<TopMemes> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Text("Available Soon",

          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),),
        ),
      ),
    );
  }
}
