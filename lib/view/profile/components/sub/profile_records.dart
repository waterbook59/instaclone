import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileViewModel= Provider.of<ProfileViewModel>(context,listen: false);

    return Row(
      children: [
        FutureBuilder(
          future: profileViewModel.getNumberOfPost(),
          builder: (context,AsyncSnapshot<int> snapshot){
            return  _userRecordWidget(
                context: context,
                score: snapshot.hasData ? snapshot.data : 0,
                title: S.of(context).post
            );
          },
        ),
        FutureBuilder(
          future: profileViewModel.getNumberOfFollowers(),
          builder: (context,AsyncSnapshot<int> snapshot){
            return _userRecordWidget(
                context: context,
                score: snapshot.hasData ? snapshot.data : 0,
                title: S.of(context).followers
            );
          },
        ),
        FutureBuilder(
          future: profileViewModel.getNumberOfFollowings(),
          builder: (context,AsyncSnapshot<int> snapshot){
            return  _userRecordWidget(
                context: context,
                score: snapshot.hasData ? snapshot.data : 0,
                title: S.of(context).followings,
            );
          },
        ),
      ],
    );
  }

  _userRecordWidget({BuildContext context, int score, String title}) {
    return Expanded(
      flex: 1,
      child: Column(children: [
        Text(score.toString(), style: profileRecordScoreTextStyle,),
        Text(title, style: profileRecordTitleTextStyle,),
      ],),
    );
  }
}