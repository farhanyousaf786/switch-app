import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class CacheImageTemplate extends StatefulWidget {

  final List list;
  final int index;
  CacheImageTemplate({required this.list, required this.index});


  @override
  _CacheImageTemplateState createState() => _CacheImageTemplateState();
}

class _CacheImageTemplateState extends State<CacheImageTemplate> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.list[widget.index]['url'],
      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.blue[200],
                child: Center(
                    child: SpinKitCircle(
                  color: Colors.blue,
                  size: 20,
                )),
              )),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
