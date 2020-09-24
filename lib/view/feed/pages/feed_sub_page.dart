import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/components/feed_post_tile.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FeedSubPage extends StatelessWidget {
  final FeedMode feedMode;
  final int index;
  final User feedUser;

  FeedSubPage({@required this.feedMode,this.feedUser,@required this.index});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);

    // プロフィール画面からきた場合はユーザーの設定変更
    feedViewModel.setFeedUser(feedMode, feedUser);

    Future(() => feedViewModel.getPosts(feedMode));

    return Consumer<FeedViewModel>(builder: (context, model, child) {
      if (model.isProcessing) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return RefreshIndicator(
          onRefresh: ()=>feedViewModel.getPosts(feedMode),
          child: ScrollablePositionedList.builder(
            //initialに設定したものに初期表示される
            initialScrollIndex: index,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: model.posts.length,
              itemBuilder: (context,index){
              return FeedPostTile(
                feedMode:feedMode,
                post:model.posts[index],
              );
              }),
        );
      }
    },);
  }
}
