import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:switchapp/Universal/Constans.dart';

class InAppNotification extends StatefulWidget {
  late final VoidCallback openNotification;

  InAppNotification({required this.openNotification});

  @override
  _InAppNotificationState createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<InAppNotification> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.openNotification();
      },
      child: DelayedDisplay(
        delay: Duration(microseconds: 100),
        slidingBeginOffset: Offset(0.0, -1),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue),
            ),
            height: MediaQuery.of(context).size.height / 8,
            child: Center(
                child: SingleChildScrollView(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text(
                    Constants.notificationType,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Constants.notificationContent,
                    style: TextStyle(
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Close",
                    style: TextStyle( fontSize: 12, fontFamily: 'cutes'),
                  ),
              ],
            ),
                )),
          ),
        ),
      ),
    );
  }
}
