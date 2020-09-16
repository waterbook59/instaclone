import 'package:flutter/material.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/components/feed_post_tile.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedSubPage extends StatelessWidget {
  final FeedMode feedMode;

  FeedSubPage({@required this.feedMode});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    //todo プロフィール画面からきた場合はユーザーの設定変更
    feedViewModel.setFeedUser(feedMode, null);

    Future(() => feedViewModel.getPosts(feedMode));

    return Consumer<FeedViewModel>(builder: (context, model, child) {
      if (model.isProcessing) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.builder(
          itemCount: model.posts.length,
            itemBuilder: (context,index){
            return FeedPostTile(
              feedMode:feedMode,
              post:model.posts[index],
            );
            });
      }
    },);
  }
}
