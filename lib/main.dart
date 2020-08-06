import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:instaclone/screens/home_screen.dart';
import 'package:instaclone/style.dart';

import 'generated/l10n.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      //TODO
      home:HomeScreen(),
    );
  }
}
