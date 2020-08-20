//HeroImageをonTapした時の拡大画像用ページ Heroアニメーション手順２
import 'package:flutter/material.dart';
import 'package:instaclone/view/post/components/hero_image.dart';

class EnlargeImageScreen extends StatelessWidget {
  final Image image;

  EnlargeImageScreen({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //戻るだけのために設定
      appBar: AppBar(),
      body: Center(
        child: HeroImage(
          image: image,
          onTap: (){
            Navigator.pop(context);
          },

        ),
      ),
    );
  }
}
