import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/data_models/location.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostLocationPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);

    return ListTile(
      title: Text(
        postViewModel.locationString,
        style: postLocationTextStyle,
      ),
      subtitle: _latLngPart(postViewModel.location, context),
      trailing: IconButton(
        icon: FaIcon(FontAwesomeIcons.mapMarkerAlt),
        //todo
        onPressed: null,
      ),
    );
  }


  _latLngPart(Location location, BuildContext context) {
    const spaceWidth = 8.0;
    //Rowだと解像度が低い(iphoneSE2とか横730x1180)場合ListTileの右が切れる（普通：1080x1920では問題なし）
    //WrapとWrapCrossAxisAlignmentへ変更する
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Chip(
          label: Text(S.of(context).latitude),
        ),
        SizedBox(width: spaceWidth,),
        //小数点第２位までだけ表示したい=>toStringAsFixed
        Text(location.latitude.toStringAsFixed(2)),
        SizedBox(width: spaceWidth,),
        Chip(
          label: Text(S.of(context).longitude),
        ),
        Text(location.longitude.toStringAsFixed(2)),
      ],
    );
  }
}
