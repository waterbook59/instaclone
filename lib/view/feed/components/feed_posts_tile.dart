import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/components/sub/feed_post_comments_part.dart';
import 'package:instaclone/view/feed/components/sub/feed_post_header_part.dart';
import 'package:instaclone/view/feed/components/sub/feed_post_likes_part.dart';
import 'package:instaclone/view/feed/components/sub/image_from_url.dart';

class FeedPostTile extends StatelessWidget {
  final Post post;
  final FeedMode feedMode;
  FeedPostTile({this.feedMode,this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,//上寄せ
        crossAxisAlignment: CrossAxisAlignment.stretch,//端まで伸ばす,
        children: <Widget>[


          FeedPostHeaderPart(),
          ImageFromUrl(imageUrl: post.imageUrl,),
          FeedPostLikesPart(),
          FeedPostCommentsPart(),

        ],
      ),
    );
  }
}
