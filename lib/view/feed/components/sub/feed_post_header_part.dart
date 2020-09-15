import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/common/components/user_card.dart';

class FeedPostHeaderPart extends StatelessWidget {
  final User postUser;
  final Post post;
  final User currentUser;

  FeedPostHeaderPart(
      {this.postUser, @required this.post, @required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return UserCard(
      photoUrl: postUser.photoUrl,
      title: postUser.inAppUserName,
      subtitle: post.locationString,
      onTap: null,
      //todo
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (value) => _onPopupMenuSelected(context, value),
        itemBuilder: (context) {
          //自分の場合は編集・削除・シェア、他人の場合はシェアのみ
          if (postUser.userId == currentUser.userId) {
            return [//自分の場合
              PopupMenuItem(
                value: PostMenu.EDIT,
                child: Text(S.of(context).edit),),
              PopupMenuItem(
                value: PostMenu.DELETE,
                child: Text(S.of(context).delete),),
              PopupMenuItem(
                value: PostMenu.SHARE,
                child: Text(S.of(context).share),),
            ];
          }else{//自分じゃな場合
            return [PopupMenuItem(
              value: PostMenu.SHARE,
              child: Text(S.of(context).share),),
          ];
          }
        },
      ),
    );
  }

  //todo 選んだら実行する
  _onPopupMenuSelected(BuildContext context, value) {}
}
