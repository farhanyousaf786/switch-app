import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class ImageCacheFilter extends StatefulWidget {
  late final String description;
  late final String url;
  late final String type;

  ImageCacheFilter(
      {required this.url, required this.type, required this.description});

  @override
  _ImageCacheFilterState createState() => _ImageCacheFilterState();
}

class _ImageCacheFilterState extends State<ImageCacheFilter> {
  bool isLoading = true;
  File? file;

  void initPlatformState(String url) async {
    FileInfo? fileInfo =
        await DefaultCacheManager().getFileFromCache(url); //url of video

    if (fileInfo?.file == null) {
      print('caching now................................ "=>" ${widget.url}');
      file = await DefaultCacheManager()
          .getSingleFile(url); //here we provide the url of video to cache.

    } else {
      if(mounted)
      setState(() {
        file = fileInfo?.file;
      });
      print(
          'cached ln>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:  "=>" ${file!} "==> " ${fileInfo?.validTill}');
    }
  }

  @override
  void initState() {
    initPlatformState(widget.url);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return file != null
        ? Container(
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(

                  file!,
                ),
              ),
            ),
        )
        : Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.white,
                  width: 200,
                  height: 100,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.blue[200],
                    child: Center(
                        child: Icon(
                      Icons.image,
                      size: 60,
                    )),
                  ),
                )),
          );
  }
}
