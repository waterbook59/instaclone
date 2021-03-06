import 'package:flutter/material.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/utils/functions.dart';
import 'package:instaclone/view/common/components/circle_photo.dart';
import 'package:instaclone/view/common/components/comment_rich_text.dart';

class CommentDisplayPart extends StatelessWidget {
  final String text;
  final DateTime postDateTime;
  final String postUserPhotoUrl;
  final String name;
  final GestureLongPressCallback onLongPressed;

  CommentDisplayPart(
      {@required this.postUserPhotoUrl,
      @required this.name,
      @required this.text,
      @required this.postDateTime,
      this.onLongPressed,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: Colors.grey,
        onLongPress: onLongPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, //上寄せ
          children: [
            //firebaseから取ってくるのでisImageFromFileはfalse
            CirclePhoto(
              photoUrl: postUserPhotoUrl,
              isImageFromFile: false,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(//右側切れる(Right overflowed)ので
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
                children: [
                  CommentRichText(
                    name: name,
                    text: text,
                  ),
                  Text(
                    createTimeAgoString(postDateTime),
                    style: timeAgoTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
