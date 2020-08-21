import 'package:flutter/material.dart';

//pubspec.yamlでfamily:に設定した名称
const TitleFont = "Billabong";
const RegularFont = "NotoSansJP_Medium";
const BoldFont = "NotoSansJP_Bold";

//CSS的にfontに間することはここで設定する(viewではここから挿入するだけ)
//Login
const loginTitleTextStyle = TextStyle(fontFamily: TitleFont, fontSize: 48.0);

//Post
const postCaptionTextStyle= TextStyle(fontFamily: RegularFont,fontSize: 18.0);
const postLocationTextStyle = TextStyle(fontFamily: RegularFont,fontSize: 16.0);
