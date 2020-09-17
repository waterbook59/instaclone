import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/view/comments/components/comment_display_part.dart';
import 'package:instaclone/view/comments/components/comment_input_part.dart';

class CommentScreen extends StatelessWidget {
  final Post post;
  final User postUser;

  CommentScreen({@required this.post, @required this.postUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).comments),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //キャプション
              CommentDisplayPart(
                postUserPhotoUrl: postUser.photoUrl,
                name: postUser.inAppUserName,
                text: post.caption,
                postDateTime: post.postDatetime,
              ),
              //todo コメント
              //コメント入力欄
              CommentInputPart(),
            ],
          ),
        ));
  }
}
