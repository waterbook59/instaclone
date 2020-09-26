import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/repositories/user_repository.dart';

class SearchViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  SearchViewModel({this.userRepository});

  List<User> soughtUsers = <User>[];

  Future<void> searchUsers(String query) async{
    //結果のUserリストを格納
    soughtUsers= await userRepository.searchUsers(query);
  }



}