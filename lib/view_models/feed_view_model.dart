import 'package:flutter/material.dart';
import 'package:instaclone/data_models/comments.dart';
import 'package:instaclone/data_models/like.dart';
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

  Future<void> updatePost(Post post, FeedMode feedMode) async{
    isProcessing = true;
//    notifyListeners();
    await postRepository.updatePost(
      //dart data classを使ってpostの中のcaptionだけを変えて渡す
      post.copyWith(caption: caption)
    );
    //更新後改めてデータ取得
    await getPosts(feedMode);
    isProcessing =false;
    notifyListeners();
  }

  Future<List<Comment>> getComments(String postId) async{
    return await postRepository.getComments(postId);
  }

  Future<void> likeIt(Post post) async{
    await postRepository.likeIt(post,currentUser);
    notifyListeners();
  }

  Future<void>unLikeIt(Post post) async{
    await postRepository.unLikeIt(post,currentUser);
    notifyListeners();
  }

  Future<LikeResult> getLikeResult(String postId) async{
    //自分がこの投稿(postIdに対していいねをしてるかを判別するのにcurrentUser渡す
   return await postRepository.getLikeResult(postId,currentUser);
  }

  //投稿削除
  Future<void>deletePost(Post post, FeedMode feedMode) async{
    isProcessing =true;
    notifyListeners();
    await postRepository.deletePost(post.postId,post.imageStoragePath);
    await getPosts(feedMode);
    isProcessing =false;
    notifyListeners();
  }


}