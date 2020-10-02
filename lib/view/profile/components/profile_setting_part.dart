import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/login/screens/login_screen.dart';
import 'package:instaclone/view_models/profile_view_model.dart';
import 'package:instaclone/view_models/theme_change_view_model.dart';
import 'package:provider/provider.dart';

class ProfileSettingPart extends StatelessWidget {
  final ProfileMode mode;

  ProfileSettingPart({@required this.mode});

  @override
  Widget build(BuildContext context) {
    //main.dartでMyAppのところと同じようにConsumer使わないでlisten:trueにする
    final themeChangeViewModel =
        Provider.of<ThemeChangeViewModel>(context);
    final isDarkOn = themeChangeViewModel.isDarkOn;

    //押したらベローンはPopUpMenuButton
    return PopupMenuButton(
      icon: Icon(Icons.settings),
      onSelected: (value) => onPopupMenuSelected(context, value,isDarkOn),
      itemBuilder: (context) {
        //自分自身のときは設定とサインアウト出す
        if (mode == ProfileMode.MYSELF) {
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: Text(isDarkOn
                  ? S.of(context).changeToLightTheme
                  : S.of(context).changeToDarkTheme),
            ),
            PopupMenuItem(
              value: ProfileSettingMenu.SIGN_OUT,
              child: Text(S.of(context).signOut),
            ),
          ];
          //他人の場合は設定だけ
        } else {
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: Text(S.of(context).changeToLightTheme),
            ),
          ];
        }
      },
    );
  }

  //プロフィールが自分自身の時
  onPopupMenuSelected(BuildContext context, ProfileSettingMenu selectedMenu, bool isDarkOn) {
    switch (selectedMenu) {
      case ProfileSettingMenu.THEME_CHANGE:
        final themeChangeViewModel =
            Provider.of<ThemeChangeViewModel>(context, listen: false);
        //isDarkOnをひっくり返す
        themeChangeViewModel.setTheme(!isDarkOn);
        break;
      case ProfileSettingMenu.SIGN_OUT:
        _signOut(context);
        break;
    }
  }

  void _signOut(BuildContext context) async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }
}
