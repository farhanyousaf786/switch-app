import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class CongratsForSlits extends StatefulWidget {
  late String text;

  CongratsForSlits({required this.text});

  @override
  _CongratsForSlitsState createState() => _CongratsForSlitsState();
}

class _CongratsForSlitsState extends State<CongratsForSlits> {
  bool isLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading == false
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 130,
                      child: Center(
                        child: Text(
                          "Congrats! ${widget.text}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 20,
                              fontFamily: 'cute'),
                        ),
                      ),
                    ),
                )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
              height: 130,
              width: 130,
              child: Lottie.asset(
                "images/effects/boom.json",
                repeat: false,
              )),
        ),
      ),
    ]);
  }
}
