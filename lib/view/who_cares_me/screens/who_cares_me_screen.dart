import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view_models/who_cares_me_view_model.dart';
import 'package:provider/provider.dart';

class WhoCaresMeScreen extends StatelessWidget {
  final WhoCaresMeMode mode;
  //feed画面からなら投稿id,プロフィール画面からならcurrentUserのid
  final String id;

  WhoCaresMeScreen({@required this.mode,@required this.id});

  @override
  Widget build(BuildContext context) {
    //この画面を開く時にデータとってくる
    final whoCaresMeViewModel = Provider.of<WhoCaresMeViewModel>(context, listen: false);
    Future(()=>whoCaresMeViewModel.getCaresMeUsers(id,mode));

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText(context,mode)),

      ),
    );
  }

  String _titleText(BuildContext context, WhoCaresMeMode mode) {
    var titleText = '';
    switch(mode){
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
}
