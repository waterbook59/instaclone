import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/search/components/search_user_delegete.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        //title押したらsearchDelegateにいく
        title: InkWell(
          //押したらふちに色が出る
          splashColor: Colors.white30,
          //入力したらsearchDelegateへ
          onTap: () => _searchUser(context),
          child: Text(
            S.of(context).search,
            style: searchPageAppBarTitleTextStyle,
          ),
        ),
      ),
      body: Center(
        child: Text("SearchPage"),
      ),
    );
  }

  //todo 入力したらsearchDelegateへ
  _searchUser(BuildContext context) async {
    //戻り値はTで今回Userで返ってくる
    final selectedUser = await showSearch(context: context,
        delegate: SearchUserDelegate());
  }
}
