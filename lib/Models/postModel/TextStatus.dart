import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class TextStatus extends StatefulWidget {
  final String description;

  const TextStatus({
    required this.description,
  });

  @override
  _TextStatusState createState() => _TextStatusState();
}

class _TextStatusState extends State<TextStatus> {
  late String url;

  _launchURL(String updateLink) async {
    if (await canLaunch(updateLink)) {
      await launch(updateLink);
    } else {
      throw 'Could not launch $updateLink';
    }
  }

  Widget textControl() {
    return GestureDetector(
      onLongPress: () => {
        Clipboard.setData(ClipboardData(text: widget.description)),
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text('Copied'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(
              top: 50,
              right: 20,
              left: 20),
        )),
      },
      child: Linkify(
        onOpen: (link) async {
          showModalBottomSheet(
              useRootNavigator: true,
              isScrollControlled: true,
              barrierColor: Colors.red.withOpacity(0.2),
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              context: context,
              builder: (context) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "This link (${link.url}) will lead you out of the Switch App.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "cutes",
                                  fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),

                          TextButton(
                              onPressed: () async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              child: Text(
                                "Ok Continue",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "cutes",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        text: widget.description,
        linkStyle: TextStyle(color: Colors.blue
        ,
            fontWeight: FontWeight.w700),
      ),
    );

    // return LinkifyText(
    // widget.description,
    // textAlign: TextAlign.left,
    // linkTypes: [
    // LinkType.url,
    // LinkType.hashTag,
    // ],
    // linkStyle: TextStyle(
    // fontSize: 13,
    // fontFamily: "cutes",
    // fontWeight: FontWeight.bold,
    // color: Colors.blue),
    // onTap: (link) => {
    // url = link.value.toString(),
    // },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.description.length < 60
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade50.withOpacity(0.6),
                    ),
                    height: 150,
                    width: MediaQuery.of(context).size.width / 1.08,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: textControl()

                            // Text(
                            //   widget.description,
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(color: Colors.black,
                            //   fontWeight: FontWeight.w500,
                            //   fontSize: 25),
                            // ),
                            ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
                    child: textControl()),
          ],
        ),
      ),
    );
  }
}
