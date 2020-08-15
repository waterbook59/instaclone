import 'package:flutter/material.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';

class PostViewModel extends ChangeNotifier{
  final PostRepository postRepository;
  final UserRepository userRepository;
  PostViewModel({this.userRepository,this.postRepository});

  bool isProcessing = false;//isLoadingと同じ
  bool isImagePicked = false;//画像が取ってこれたか

}