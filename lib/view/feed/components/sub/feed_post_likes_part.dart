import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/data_models/like.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/comments/screens/comment_screen.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostLikesPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostLikesPart({@required this.post, @required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      //いいねの変更が通知されたらFeedSubPageでConsumerしてるので、その下は１回読み込むだけのFutureBuilderで良い
      child: FutureBuilder(
        future: feedViewModel.getLikeResult(post.postId),
        builder: (context, AsyncSnapshot<LikeResult> snapshot) {
//          print('snapshot.data:${snapshot.data}');
          if (snapshot.hasData && snapshot.data != null) {
            final likeResult = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //いいねあり・なしでview側変更
                      likeResult.isLikedToThisPost
                          ? IconButton(
                        icon: FaIcon(FontAwesomeIcons.solidHeart),
                        onPressed: () => _unLikeIt(context),
                      )
                          : IconButton(
                        icon: FaIcon(FontAwesomeIcons.heart),
                        onPressed: () => _likeIt(context),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.comment),
                        onPressed: () =>
                            _openCommentsScreen(context, post, postUser),
                      ),
                    ]
                ),
                Text(
                  likeResult.likes.length.toString() + '' + S
                      .of(context)
                      .likes,
                  style: numberOfLikesTextStyle,
                ),
              ],
            );
          } else {
            return Container(child: Center(child: Text('何ー'),),);
          }
        },
      ),
    );
  }

  _openCommentsScreen(BuildContext context, Post post, User postUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CommentScreen(
              post: post,
              postUser: postUser,
            ),
      ),
    );
  }

  _likeIt(BuildContext context) async {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    await feedViewModel.likeIt(post);
  }

  //「いいね」やめる処理
  _unLikeIt(BuildContext context) async{
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    await feedViewModel.unLikeIt(post);
  }
}
