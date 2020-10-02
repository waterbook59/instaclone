import 'package:flutter/material.dart';
import 'package:instaclone/data_models/comments.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/utils/functions.dart';
import 'package:instaclone/view/comments/screens/comment_screen.dart';
import 'package:instaclone/view/common/components/comment_rich_text.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostCommentsPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostCommentsPart({@required this.post, @required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context,listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 投稿者名とキャプション
          CommentRichText(
            name: postUser.inAppUserName,
            text: post.caption,
          ),
          InkWell(
            //
            onTap: ()=>_openCommentsScreen(context, post, postUser),
            child: FutureBuilder(
              future: feedViewModel.getComments(post.postId),
              builder: (context,AsyncSnapshot<List<Comment>> snapshot){
                if(snapshot.hasData && snapshot.data !=null){
                  final comments =snapshot.data;
                  return  Text(
                    comments.length.toString()+''+ S.of(context).comments,
                    style: numberOfCommentsTextStyle,
                  );
                }else{
                  return Container();
                }

              },
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            //○時間前表示
            createTimeAgoString(post.postDatetime),
            style: timeAgoTextStyle,
          ),
        ],
      ),
    );
  }

  _openCommentsScreen(BuildContext context, Post post, User postUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentScreen(
          post: post,
          postUser: postUser,
        ),
      ),
    );
  }
}
