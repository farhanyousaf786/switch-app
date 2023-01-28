
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarTop extends StatelessWidget {
  const BarTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.linear_scale_sharp,
              color: Colors.white,
            ),
          ],
        ),
      ),
      color: Colors.lightBlue,
    );
  }
}
