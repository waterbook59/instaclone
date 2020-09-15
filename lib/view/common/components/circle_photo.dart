//cached_network_imageは中級編１でも登場？
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CirclePhoto extends StatelessWidget {
  final double radius;
  final String photoUrl;
  //プロフィール画面のようにfirebaseではなく、端末内のファイルから画像を作る場合がある
  final bool isImageFromFile;

  CirclePhoto(
      {@required this.photoUrl, this.radius, @required this.isImageFromFile});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: isImageFromFile
          ? FileImage(File(photoUrl)) //fileから作る
          : CachedNetworkImageProvider(photoUrl), //firebaseから取ってきたやつで作る
    );
  }
}
