import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/common/components/circle_photo.dart';
import 'package:instaclone/view/profile/screens/edit_profile_screen.dart';
import 'package:instaclone/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileBio extends StatelessWidget {
  final ProfileMode mode;

  ProfileBio({@required this.mode});

  @override
  Widget build(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final profileUser = profileViewModel.profileUser;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profileUser.inAppUserName,
          ),
          // バイオ('bio'は'biography(経歴)'の意味)
          Text(profileUser.bio,style: profileBioTextStyle,),
          SizedBox(
            height: 16,
          ),
          //ボタンいっぱいに広げる SizedBox=>double.infinity
          SizedBox(
            width: double.infinity,
            child: _button(context, profileUser),
          )
        ],
      ),
    );
  }

  _button(BuildContext context, User profileUser) {
    return RaisedButton(
      //プロフィール編集画面
      onPressed: ()=>_openEditProfileScreen(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: mode == ProfileMode.MYSELF
          ? Text(S.of(context).editProfile)
          //todo
          : Text('フォローする'),
    );
  }

  _openEditProfileScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }
}
