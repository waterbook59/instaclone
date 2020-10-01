import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/common/components/user_card.dart';
import 'package:instaclone/view/profile/screens/profile_screen.dart';
import 'package:instaclone/view_models/who_cares_me_view_model.dart';
import 'package:provider/provider.dart';

class WhoCaresMeScreen extends StatelessWidget {
  final WhoCaresMeMode mode;

  //feed画面からなら投稿id,プロフィール画面からならcurrentUserのid
  final String id;

  WhoCaresMeScreen({@required this.mode, @required this.id});

  @override
  Widget build(BuildContext context) {
    //この画面を開く時にデータとってくる
    final whoCaresMeViewModel =
        Provider.of<WhoCaresMeViewModel>(context, listen: false);
    Future(() => whoCaresMeViewModel.getCaresMeUsers(id, mode));

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText(context, mode)),
      ),
      body: Consumer<WhoCaresMeViewModel>(builder: (_, model, child) {
        return model.caresMeUsers.isEmpty
            ? Container()
            : ListView.builder(
                itemCount: model.caresMeUsers.length,
                itemBuilder: (context, int index) {
                  final user = model.caresMeUsers[index];
                  return UserCard(
                    photoUrl: user.photoUrl,
                    title: user.inAppUserName,
                    subtitle: user.bio,
                    onTap: () => _openProfileScreen(context, user),
                  );
                });
      }),
    );
  }

  String _titleText(BuildContext context, WhoCaresMeMode mode) {
    var titleText = '';
    switch (mode) {
      case WhoCaresMeMode.LIKE:
        titleText = S.of(context).likes;
        break;
      case WhoCaresMeMode.FOLLOWINGS:
        titleText = S.of(context).followings;
        break;
      case WhoCaresMeMode.FOLLOWED:
        titleText = S.of(context).followers;
        break;
    }
    return titleText;
  }

  _openProfileScreen(BuildContext context, User user) {
    final whoCaresMeViewModel =
        Provider.of<WhoCaresMeViewModel>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ProfileScreen(
                selectedUser: user,
                profileMode:
                    user.userId == whoCaresMeViewModel.currentUser.userId
                        ? ProfileMode.MYSELF
                        : ProfileMode.OTHER,
              ),
      ),
    );
  }
}
