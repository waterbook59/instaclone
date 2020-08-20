import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/post/screens/enlarge_image_screen.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

import 'hero_image.dart';

class PostCaptionPart extends StatelessWidget {
  final PostCaptionOpenMode from;

  PostCaptionPart({@required this.from});

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context); //ここはlistenする
    final getImage = Image.file(postViewModel.imageFile); //Image.assetみたいなもの

    if (from == PostCaptionOpenMode.FROM_POST) {
      return ListTile(
        leading: HeroImage(
          image: getImage,
          //Heroアニメーション手順３&４ 遷移先へviewModelから取ってきたimage渡す
          onTap: () => _displayLargeImage(context, getImage),
        ),
        //todo
//        title: PostCationInputTextField(),
      );
    } else {
      //todo
      return Container();
    }
  }

  _displayLargeImage(BuildContext context, Image getImage) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EnlargeImageScreen(
                  image: getImage,
                )));
  }
}
