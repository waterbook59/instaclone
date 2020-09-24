import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/pages/feed_sub_page.dart';

class FeedScreen extends StatelessWidget {
  final int index;
  final FeedMode feedMode;
  final User feedUser;

  FeedScreen({@required this.feedUser,@required this.index,@required this.feedMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).post),
      ),
      body: FeedSubPage(
        feedMode: feedMode,
        index: index,
        feedUser: feedUser,
      ),
    );
  }
}
