import 'package:flutter/material.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/common/components/circle_photo.dart';

class UserCard extends StatelessWidget {
  final VoidCallback onTap;
  final String photoUrl;
  final String title;
  final String subtitle;
  final Widget trailing;

  UserCard(
      {@required this.onTap, @required this.photoUrl, @required this.title, @required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: onTap,
      child: ListTile(
        leading: CirclePhoto(
          photoUrl: photoUrl,  isImageFromFile: false,),
        title: Text(title,style: userCardTitleTextStyle,),
        subtitle: Text(subtitle,style: userCardSubTitleTextStyle,),
        trailing:trailing,
      ),
    );
  }
}
