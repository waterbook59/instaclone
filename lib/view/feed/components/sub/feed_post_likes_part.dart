import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/comments/screens/comment_screen.dart';

class FeedPostLikesPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostLikesPart({@required this.post,@required this.postUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            IconButton(
              icon: FaIcon(FontAwesomeIcons.solidHeart),
              //todo
              onPressed: null,
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.comment),
              onPressed: () => _openCommentsScreen(context, post,postUser),
            ),
          ]),
          Text(
            '0${S.of(context).likes}',
            style: numberOfLikesTextStyle,
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
                  post: post,postUser: postUser,
                ),
        ),
    );
  }
}
