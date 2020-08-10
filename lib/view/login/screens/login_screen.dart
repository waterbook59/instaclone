import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/common/components/button_with_icon.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Billabongが日本語対応していないのでintl_ja.arb/appTitleは英語に戻す
            Text(
              S.of(context).appTitle,
              style: loginTitleTextStyle,
            ),
            SizedBox(height: 8.0,),
            ButtonWithIcon(
              iconData: FontAwesomeIcons.signInAlt,
              label:S.of(context).signIn,
              onPressed: ()=>login(context),
            ),
          ],
        ),
      ),
    );
  }

  login(BuildContext context) {
    //todo
  }
}
