//flutter_advanced networkimage 0.7.0はflutterSDK1.17までしか対応せず
//cached_network_image はflutterSDK1.20対応

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFromUrl extends StatelessWidget {
  final String imageUrl;


  ImageFromUrl( {@required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if(imageUrl==null){
      return const Icon(Icons.broken_image);
    }else{
      return CachedNetworkImage(
        imageUrl: imageUrl,
        //ダウンロードしてる時グリグリ(中級編vol1参照)
        placeholder:(context,url)=>CircularProgressIndicator(),
        errorWidget: (context,url,error)=>Icon(Icons.error),
      );
    }
  }
}
