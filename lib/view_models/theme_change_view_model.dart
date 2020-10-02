import 'package:flutter/material.dart';
import 'package:instaclone/models/repositories/theme_change_repository.dart';
import 'package:instaclone/style.dart';

class ThemeChangeViewModel extends ChangeNotifier{
  final ThemeChangeRepository repository;
  ThemeChangeViewModel({this.repository});

  //テーマが黒か白か
  //viewModelを経由せずに持ってこれるようにゲッター設定、
  //viewModelインスタンス経由せずに格納したisDarkOnプロパティが使える
//  bool isDarkOn = true;
  bool get isDarkOn => ThemeChangeRepository.isDarkOn;

  //main.dartからテーマを持ってくるには
  ThemeData get selectedTheme => isDarkOn ? darkTheme : lightTheme;

  void setTheme(bool isDark) async{
    await repository.setTheme(isDark);
    //isDarkのセットが終わったらisDarkOnへ結果そ挿入
    notifyListeners();
  }

}