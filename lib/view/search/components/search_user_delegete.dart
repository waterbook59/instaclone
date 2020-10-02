import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/view/common/components/user_card.dart';
import 'package:instaclone/view_models/search_view_model.dart';
import 'package:provider/provider.dart';

class SearchUserDelegate extends SearchDelegate<User> {
  //テーマをダークモードに変更
  @override
  ThemeData appBarTheme(BuildContext context) {
    //今使っているテーマ
    final theme = Theme.of(context);
    return theme.copyWith(brightness: Brightness.dark);
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        //leadingの戻る矢印押す時は検索結果いらないのでnull
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        //押したら検索候補・入力文字を消す(入力欄はqueryTextControllerになってる)
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults(context);
  }

  // ユーザー検索処理
  Widget _buildResults(BuildContext context) {
    final searchViewModel = Provider.of<SearchViewModel>(context,listen: false);
    //入力文字queryを渡して検索する
    searchViewModel.searchUsers(query);
    
    return ListView.builder(
      itemCount: searchViewModel.soughtUsers.length,
        itemBuilder: (context, int index){
        final user = searchViewModel.soughtUsers[index];
        return UserCard(
        photoUrl: user.photoUrl,
          title: user.inAppUserName,
          subtitle: user.bio,
          onTap: (){
          close(context, user);
          },
        );
        }
        );
  }
}
