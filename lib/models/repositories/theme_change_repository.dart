
import 'package:shared_preferences/shared_preferences.dart';

const PREF_KEY = 'isDarkOn';

class ThemeChangeRepository{

  //viewModel層のisDarkOnwを参照できないので、repositoryでstaticなプロパティとして格納
  static bool isDarkOn = false;

//書き込み
  Future<void> setTheme(bool isDark) async{
    //DBなので非同期処理、staticメソッドでインスタンス呼び出し
    final prefs = await  SharedPreferences.getInstance();
    await  prefs.setBool(PREF_KEY, isDark);
    isDarkOn = isDark;
  }

  Future<void> getIsDarkOn() async{
    final prefs = await  SharedPreferences.getInstance();
    isDarkOn = prefs.getBool(PREF_KEY) ?? true;
  }

  
}