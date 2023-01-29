import 'dart:io';

import 'package:switchapp/Universal/Constans.dart';
import 'package:dospace/dospace.dart' as dospace;

class SwitchDB {



  Future<String> addPostImage(File? file) async {
    String projectName = "switchapp";
    String region = "nyc3";
    String folderName = "posts";
    String fileName =
        "switchapp_images_${DateTime.now().microsecondsSinceEpoch}.jpg";
    dospace.Spaces spaces = new dospace.Spaces(
      //change with your project's region
      region: "nyc3",
      //change with your project's accessKey
      accessKey: Constants.ak,
      secretKey: Constants.sk,
    );

    String? etag = await spaces.bucket(projectName).uploadFile(
          "images" +
              "/" +
              folderName +
              '/' +
              Constants.username +
              '/' +
              fileName,
          file,
          'images',
          dospace.Permissions.public,
        );

    print('upload: $etag');

    String url = "https://" +
        projectName +
        "." +
        region +
        ".digitaloceanspaces.com/" +
        'images' +
        "/" +
        folderName +
        '/' +
        Constants.username +
        "/" +
        fileName;
    print('--- presigned url:');

    return url;
  }
}
