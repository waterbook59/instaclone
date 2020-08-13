import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/common/components/button_with_icon.dart';
import 'package:instaclone/view/home_screen.dart';
import 'package:instaclone/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginViewModel>(
          builder: (context, model, child) {
            return model.isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Billabongが日本語対応していないのでintl_ja.arb/appTitleは英語に戻す
                      Text(
                        S.of(context).appTitle,
                        style: loginTitleTextStyle,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      ButtonWithIcon(
                        iconData: FontAwesomeIcons.signInAlt,
                        label: S.of(context).signIn,
                        onPressed: () => login(context),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  login(BuildContext context) async {
    final loginVieModel = Provider.of<LoginViewModel>(context, listen: false);
    await loginVieModel.signIn();
    if (!loginVieModel.isSuccessful) {
      //ログイン失敗した場合toast
      Fluttertoast.showToast(msg: S.of(context).signInFailed);
      return;
    }
    //ログイン成功した場合
    _openHomeScreen(context);
  }

  void _openHomeScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }
}
