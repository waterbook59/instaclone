import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';

class ProfileSettingPart extends StatelessWidget {
  final ProfileMode mode;
  ProfileSettingPart({@required this.mode});

  @override
  Widget build(BuildContext context) {
    //押したらベローンはPopUpMenuButton
    return PopupMenuButton(
      icon: Icon(Icons.settings),
      onSelected: (value)=>onPopupMenuSelected(context,value),
      itemBuilder: (context){
        //自分自身のときは設定とサインアウト出す
        if(mode == ProfileMode.MYSELF){
          return[
            PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: Text(S.of(context).changeToLightTheme),
            ),
            PopupMenuItem(
              value: ProfileSettingMenu.SIGN_OUT,
              child: Text(S.of(context).signOut),
            ),
          ];
          //他人の場合は設定だけ
        }else{
          return[
          PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: Text(S.of(context).changeToLightTheme),
          ),
          ];
        }
      },
    );
  }

  //todo
  onPopupMenuSelected(BuildContext context, value) {

  }
}
