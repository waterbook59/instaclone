import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';

class CommentsViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final PostRepository postRepository;


  CommentsViewModel({this.userRepository,this.postRepository});

  User get currentUser => UserRepository.currentUser;
  String comment='';

}