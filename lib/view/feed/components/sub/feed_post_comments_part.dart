import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/common/components/comment_rich_text.dart';

class FeedPostCommentsPart extends StatelessWidget {
  final Post post;
  final User postUser;
  FeedPostCommentsPart({@required this.post,@required this.postUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 投稿者名とキャプション
          CommentRichText(name: postUser.inAppUserName,text: post.caption,),
          InkWell(
            //todo
            onTap: null,
            child: Text('0 ${S.of(context).comments}',style: numberOfCommentsTextStyle,
            ),
          ),
          SizedBox(height: 4,),
          Text(
            //todo
             '○時間前',style: timeAgoTextStyle,
          ),
        ],
      ),
    );
  }
}
