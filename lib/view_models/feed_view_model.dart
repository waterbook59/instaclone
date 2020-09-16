import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';
import 'package:instaclone/utils/constants.dart';

class FeedViewModel extends ChangeNotifier{
  final PostRepository postRepository;
  final UserRepository userRepository;

  FeedViewModel({this.userRepository,this.postRepository});

  bool isProcessing = false;
  List<Post> posts=<Post>[];
  User feedUser;//どのユーザーを表示するかのユーザー情報
  User get currentUser => UserRepository.currentUser;//ログインしているユーザー(UserRepositoryのstaticプロパティ)
  String caption= '';//初期値空文字

  void setFeedUser(FeedMode feedMode, User user){
    if(feedMode == FeedMode.FROM_FEED){
      feedUser= currentUser;
    }else{
      feedUser = user;
    }
  }

  Future<void> getPosts(FeedMode feedMode) async{
    //データ取れ終わるまでtrue
    isProcessing = true;
    notifyListeners();

    //userRepoじゃなくてpostRepositoryから
   posts = await postRepository.getPosts(feedMode,feedUser);
  //データが取れたらグリグリ消す
  isProcessing =false;
  notifyListeners();
  }

  Future<User> getPostUserInfo(String userId) async{
    return await userRepository.getUserById(userId);
  }
}