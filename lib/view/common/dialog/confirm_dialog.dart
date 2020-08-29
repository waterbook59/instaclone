import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';

//ダイアログを表示させる関数をトップレベル関数でつくる
showConfirmDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  @required ValueChanged<bool> onConfirmed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => ConfirmDialog(
      title: title,
      content: content,
      onConfirmed: onConfirmed,
    ),
  );
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;

//YES,NOのboolを変数として持っておきたいのでvalueChange
  //メソッド参照的にコンストラクタ作るときは関数側に引数書かずに戻り値の型に書くvalueChanged<bool> onConfirmed;
  final ValueChanged<bool> onConfirmed;

  ConfirmDialog({this.title, this.content, this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text(S.of(context).yes),
          onPressed: () {
            Navigator.pop(context);
            onConfirmed(true);
          },
        ),
        FlatButton(
          child: Text(S.of(context).no),
          onPressed: () {
            Navigator.pop(context);
            onConfirmed(false);
          },
        ),
      ],
    );
  }
}
