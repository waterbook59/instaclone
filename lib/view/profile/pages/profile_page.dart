import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/profile/components/profile_setting_part.dart';
import 'package:instaclone/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final ProfileMode profileMode;
  final User selectedUser;

  ProfilePage({@required this.profileMode, this.selectedUser});

  @override
  Widget build(BuildContext context) {
    //プロフィール画面に表示するユーザーの特定
    final profileViewModel = Provider.of<ProfileViewModel>(
        context, listen: false);
    profileViewModel.setProfileUser(profileMode, selectedUser);
    Future(() => profileViewModel.getPost());

    return Scaffold(
        body: Consumer<ProfileViewModel>(
            builder: (context, model, child) {
              final profileUser = model.profileUser;
              print('posts in profile ${model.posts}');
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(profileUser.inAppUserName),
                    pinned: true,
                    floating: true,
                    //todo 設定とか
                    actions: [
                      ProfileSettingPart(mode: profileMode,),
                    ],
                    expandedHeight: 280,
                    flexibleSpace: FlexibleSpaceBar(
                      //todo ProfileDetailPart()
                      background: Container(),
                    ),
                  ),
                ],
              );
            }
        )

    );
  }
}
