import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:instaclone/di/providers.dart';
import 'package:instaclone/view/home_screen.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/login/screens/login_screen.dart';
import 'package:instaclone/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

void main() {
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
      theme: ThemeData(
        brightness: Brightness.dark,
        buttonColor: Colors.white30,
        primaryIconTheme: IconThemeData(
          color: Colors.white,//Appbarとかbottomnavbarとかのデフォルト色
        ),
        iconTheme: IconThemeData(
          color: Colors.white,//bodyで使うCardとかのボタンのデフォルト色
        ),
        fontFamily: RegularFont,
      ),

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
