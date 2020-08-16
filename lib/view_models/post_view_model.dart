import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';
import 'package:instaclone/utils/constants.dart';

class PostViewModel extends ChangeNotifier{
  final PostRepository postRepository;
  final UserRepository userRepository;
  PostViewModel({this.userRepository,this.postRepository});

  //Fileのimportはdart.htmlはダメ！、dart.io
  File imageFile;

  bool isProcessing = false;//isLoadingと同じ
  bool isImagePicked = false;

  Future<void> pickImage(UploadType uploadType) async{
    isImagePicked =false;
    isProcessing = true;
    notifyListeners();//グリグリ回す

    imageFile= await postRepository.pickImage(uploadType);
    print("pickedImage: ${imageFile.path}");

    //todo 位置情報

    if(imageFile != null) isImagePicked =true;
    isProcessing =false;
    notifyListeners();

  }//画像が取ってこれたか

}