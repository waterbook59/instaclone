import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';

class FeedPostLikesPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:12.0),
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
              //todo
              onPressed: null,
            ),
          ]
          ),
          Text('0${S.of(context).likes}',style: numberOfLikesTextStyle,),
        ],
      ),
    );
  }
}
