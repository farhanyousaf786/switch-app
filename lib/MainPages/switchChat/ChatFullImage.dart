import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatFullImage extends StatelessWidget {
  final String url;

  const ChatFullImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(""),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
        elevation: 0,
      ),
      body: InteractiveViewer(
        panEnabled: false,
        // Set it to false
        boundaryMargin: EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.network(
              url,
              fit: BoxFit.fitWidth,
            )),
      ),
    );
  }
}
