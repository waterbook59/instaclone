import 'package:flutter/material.dart';
import 'package:instaclone/view_models/profile_view_model.dart';

//pubspec.yamlでfamily:に設定した名称
const TitleFont = "Billabong";
const RegularFont = "NotoSansJP_Medium";
const BoldFont = "NotoSansJP_Bold";


//テーマ
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  buttonColor: Colors.white30,
  primaryIconTheme: IconThemeData(
    color: Colors.white,//Appbarとかbottomnavbarとかのデフォルト色
  ),
  iconTheme: IconThemeData(
    color: Colors.white,//bodyで使うCardとかのボタンのデフォルト色
  ),
  fontFamily: RegularFont,
);

final lightTheme = ThemeData(
  primaryColor: Colors.white,//AppBarの背景とか
  brightness: Brightness.light,
  buttonColor: Colors.white,
  primaryIconTheme: IconThemeData(
    color: Colors.black,//Appbarとかbottomnavbarとかのデフォルト色
  ),
  iconTheme: IconThemeData(
    color: Colors.black,//bodyで使うCardとかのボタンのデフォルト色
  ),
  fontFamily: RegularFont,
);



//CSS的にfontに間することはここで設定する(viewではここから挿入するだけ)
//Login
const loginTitleTextStyle = TextStyle(fontFamily: TitleFont, fontSize: 48.0);

//Post
const postCaptionTextStyle= TextStyle(fontFamily: RegularFont,fontSize: 18.0);
const postLocationTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 16.0);

//Feed
const userCardTitleTextStyle = TextStyle(fontFamily: BoldFont,fontSize: 14.0);
const userCardSubTitleTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 12.0);
const numberOfLikesTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 14.0);
const numberOfCommentsTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 13.0,color: Colors.grey);
const timeAgoTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 10.0,color: Colors.grey);
const commentNameTextStyle = TextStyle(fontFamily: BoldFont,fontSize: 13.0);
const commentContentTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 13.0);

//Comments
const commentInputTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 14.0,);

//Profile
const profileRecordScoreTextStyle = TextStyle(fontFamily: BoldFont,fontSize: 20);
const profileRecordTitleTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 14);
const changeProfilePhotoTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 18,color: Colors.blueAccent);
const editProfileTitleTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 14);
const profileBioTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 13);

//Search
const searchPageAppBarTitleTextStyle = TextStyle(fontFamily: RegularFont,color: Colors.grey);