import 'package:flutter/material.dart';
import 'package:instaclone/data_models/comments.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';

class CommentsViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final PostRepository postRepository;

  CommentsViewModel({this.userRepository,this.postRepository});

  User get currentUser => UserRepository.currentUser;
  String comment='';
  List<Comment> comments = <Comment>[];//firebaseから取ってきたcommentを格納
  bool isLoading =false;

  //コメント投稿(登録create)
  Future<void> postComment(Post post) async{
    await postRepository.postComment(post,currentUser,comment);
    //投稿が終わったらコメント取得
    await getComments(post.postId);
    notifyListeners();
  }

  //postIdに紐づいたコメント取得(読み込みread)
  Future<void> getComments(String postId) async{
    isLoading = true;
    notifyListeners();
    comments =  await postRepository.getComments(postId);
    print('comments from DB: $comments');

    isLoading =false;
    notifyListeners();

  }

  Future<User>getCommentUserInfo(String commentUserId) async{
    return await userRepository.getUserById(commentUserId);
  }

  Future<void> deleteComment(Post post, int commentIndex) async{
    final deleteCommentId = comments[commentIndex].commentId;
    await postRepository.deleteComment(deleteCommentId);
    getComments(post.postId);
    notifyListeners();
  }

}