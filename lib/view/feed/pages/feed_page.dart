import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/pages/feed_sub_page.dart';
import 'package:instaclone/view/post/screens/post_upload_screen.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.cameraRetro),
          //アイコン押したらカメラが立ち上がってPostUploadScreenへ
          onPressed: () => _launchCamera(context),
        ),
        title: Text(
          S.of(context).appTitle,
          style: TextStyle(fontFamily: TitleFont),
        ),
      ),
      body: FeedSubPage(
        feedMode: FeedMode.FROM_FEED,
      ),
    );
  }

  _launchCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostUploadScreen(
          uploadType: UploadType.CAMERA,
        ),
      ),
    );
  }
}
