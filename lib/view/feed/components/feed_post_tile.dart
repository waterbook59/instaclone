import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/components/sub/feed_post_comments_part.dart';
import 'package:instaclone/view/feed/components/sub/feed_post_header_part.dart';
import 'package:instaclone/view/feed/components/sub/feed_post_likes_part.dart';
import 'package:instaclone/view/feed/components/sub/image_from_url.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostTile extends StatelessWidget {
  final Post post;
  final FeedMode feedMode;

  FeedPostTile({this.feedMode, this.post});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder(
        future: feedViewModel.getPostUserInfo(post.userId),
        builder: (context, AsyncSnapshot<User> snapshot) {
          //snapshotが返ってきて、かつそのデータ(User)がnullでない時
          if (snapshot.hasData && snapshot.data != null) {
            final postUser = snapshot.data;
            final currentUser = feedViewModel.currentUser;
            print('postUser:$postUser');
            return Column(
              mainAxisAlignment: MainAxisAlignment.start, //上寄せ
              crossAxisAlignment: CrossAxisAlignment.stretch, //端まで伸ばす,
              children: <Widget>[
                FeedPostHeaderPart(),
                ImageFromUrl(
                  imageUrl: post.imageUrl,
                ),
                FeedPostLikesPart(),
                FeedPostCommentsPart(),
              ],
            );
          }else{
            return Container();
          }
        },
      ),
    );
  }
}
