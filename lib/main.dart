import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:instaclone/di/providers.dart';
import 'package:instaclone/models/repositories/theme_change_repository.dart';
import 'package:instaclone/view/home_screen.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/login/screens/login_screen.dart';
import 'package:instaclone/view_models/login_view_model.dart';
import 'package:instaclone/view_models/theme_change_view_model.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeAgo;


void main() async{
  //main関数で非同期処理する時はこれが必要(初期化)
  WidgetsFlutterBinding.ensureInitialized();
  //sharedPreferencesから保存したテーマを読み込み
  //runApp前だとbuildContextがないのでviewModel使えない(ChangeNotifierProviderが使えない)
  //=>直接ThemeChangeRepositoryを参照するしかない、main()にasyncつける

  //firebase_core 0.5.0以上ならここで await Firebase.initializeApp();必要

  final themeChangeRepository = ThemeChangeRepository();
  themeChangeRepository.getIsDarkOn();

  timeAgo.setLocaleMessages('ja', timeAgo.JaMessages());


  //runAppが回ることで初めてwidgetツリーができる(buildContextができる)
  runApp(
    MultiProvider(
      providers: globalProviders,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context,listen: false);
    //listen:falseの場合は final loginViewModel =context.read();でも良い
    //ここのlistenはtrue!!(実質Consumerするのと同じ)
    final themeChangeViewModel = Provider.of<ThemeChangeViewModel>(context);

    return MaterialApp(
      title: "DaitaInstagram",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      //themeはwidgetではないのでConsumerは使えない
      //Providerのlisten:trueにしてviewModelのゲッター呼び出し
      theme: themeChangeViewModel.selectedTheme,

      home:FutureBuilder(
        future: loginViewModel.isSignIn(),
        //AsyncSnapshotは返ってくるデータ
        builder: (context, AsyncSnapshot<bool> snapshot ){
          //データがあって且つtrue(snapshot.dataところ)の場合
          if(snapshot.hasData&&snapshot.data){
            return HomeScreen();
          }else{
            return LoginScreen();
          }
        },
      ),
    );
  }
}
