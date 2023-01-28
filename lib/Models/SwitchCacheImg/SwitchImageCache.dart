// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/file.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:shimmer/shimmer.dart';
//
// class SwitchImageCache extends StatefulWidget {
//   late final String url;
//   late final int width;
//   late final int height;
//
//   SwitchImageCache({
//     required this.url,
//     required this.height,
//     required this.width
//   });
//
//   @override
//   _SwitchImageCacheState createState() => _SwitchImageCacheState();
// }
//
// class _SwitchImageCacheState extends State<SwitchImageCache> {
//   bool isLoading = true;
//   File? file;
//
//   void initPlatformState(String url) async {
//     FileInfo? fileInfo =
//         await DefaultCacheManager().getFileFromCache(url); //url of video
//
//     if (fileInfo?.file == null) {
//       print('caching now................................ "=>" ${widget.url}');
//       file = await DefaultCacheManager()
//           .getSingleFile(url); //here we provide the url of video to cache.
//       if (mounted)
//
//       setState(() {
//
//       });
//     } else {
//       if (mounted)
//         setState(() {
//           file = fileInfo?.file;
//         });
//       print(
//           'cached ln>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:  "=>" ${file!} "==> " ${fileInfo?.validTill}');
//       setState(() {
//
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     initPlatformState(widget.url);
//
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted)
//         setState(() {
//           isLoading = false;
//         });
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return file != null
//         ? ClipRRect(
//           borderRadius: BorderRadius.circular(10.0),
//           child: Image.file(
//             file!,
//             fit: BoxFit.fitHeight,
//           ),
//         )
//         : Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10.0),
//                 child: Container(
//                   width: widget.width.toDouble(),
//                   height: widget.height.toDouble(),
//                   child: Shimmer.fromColors(
//                     baseColor: Colors.grey[300],
//                     highlightColor: Colors.blue[200],
//                     child: Center(
//                         child: Image.asset("images/logoPro.png",
//                         fit: BoxFit.fitHeight,),
//
//                     ),
//                   ),
//                 )),
//           );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class SwitchCacheImage extends StatefulWidget {
  late final String url;
  late final double width;
  late final double height;
  late final BoxFit boxFit;
  late final String screen;

  SwitchCacheImage(
      {required this.url,
      required this.height,
      required this.width,
      required this.boxFit,
      required this.screen});

  @override
  _SwitchCacheImageState createState() => _SwitchCacheImageState();
}

class _SwitchCacheImageState extends State<SwitchCacheImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url.toString(),
      fit: widget.boxFit,

      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: widget.width.toDouble(),
          height: widget.height.toDouble(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.blue[200],
              child: Center(
                child: SpinKitCircle(
                  color: Colors.lightBlue,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: widget.height,
        width: widget.width,
        child: Center(
            child: widget.screen == "mainFeed" ? Text("Image remove By Switch App",
            style: TextStyle(
              color: Colors.lightBlue,
              fontWeight: FontWeight.bold,
              fontFamily: 'cute'
            ),): Icon(
          Icons.error_outline_sharp,
          color: Colors.lightBlue,
        )),
      ),
    );
  }
}
