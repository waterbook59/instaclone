import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/components/sub/image_from_url.dart';
import 'package:instaclone/view/post/components/post_caption_input_text_field.dart';
import 'package:instaclone/view/post/screens/enlarge_image_screen.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

import 'hero_image.dart';

class PostCaptionPart extends StatelessWidget {
  final PostCaptionOpenMode from;
  final Post post;//編集時にすでに投稿してあるキャプションを持ってくる

  PostCaptionPart({@required this.from, this.post});

  @override
  Widget build(BuildContext context) {


    if (from == PostCaptionOpenMode.FROM_POST) {//投稿時
      final postViewModel = Provider.of<PostViewModel>(context); //ここはlistenする
      //chapter114 FROM_FEEDからきた時に下記Imageがnullでエラー出る（build下からif文の下に移動）
      final getImage = Image.file(postViewModel.imageFile); //Image.assetみたいなもの

      return ListTile(
        leading: HeroImage(
          image: getImage,
          //Heroアニメーション手順３&４ 遷移先へviewModelから取ってきたimage渡す
          onTap: () => _displayLargeImage(context, getImage),
        ),
        //todo
        title: PostCaptionInputTextField(),
      );
    } else {
      //編集時
      return Column(
        children: [
          ImageFromUrl(imageUrl: post.imageUrl,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PostCaptionInputTextField(
              cationBeforeUpdated: post.caption,
              from: from,
            ),
          ),
        ],
      );
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
