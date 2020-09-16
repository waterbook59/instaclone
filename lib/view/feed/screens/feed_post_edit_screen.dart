import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/common/components/user_card.dart';
import 'package:instaclone/view/post/components/post_caption_part.dart';

class FeedPostEditScreen extends StatelessWidget {
  final Post post;
  final User postUser;
  final FeedMode feedMode;

  FeedPostEditScreen(
      {@required this.post, @required this.postUser, @required this.feedMode});

  //Scaffoldがないと（Material widgetがないという）エラー
  //たぶんMaterialPageRouteでこのScreenにこれない

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //todo
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserCard(
              photoUrl: postUser.photoUrl,
              title: postUser.inAppUserName,
              subtitle: post.locationString,
              onTap: null,
            ),
            PostCaptionPart(
              from: PostCaptionOpenMode.FROM_FEED,
              post: post,
            ),
          ],
        ),
      ),
    );
  }
}
