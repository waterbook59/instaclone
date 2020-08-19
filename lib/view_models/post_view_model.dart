import 'dart:io';//File型を使うためのimport

import 'package:flutter/material.dart';
import 'package:instaclone/data_models/location.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';
import 'package:instaclone/utils/constants.dart';

class PostViewModel extends ChangeNotifier{
  final PostRepository postRepository;
  final UserRepository userRepository;
  PostViewModel({this.userRepository,this.postRepository});

  //Fileのimportはdart.htmlはダメ！、dart.io
  File imageFile;

  Location location;
  String locationString ="";

  bool isProcessing = false;//isLoadingと同じ
  bool isImagePicked = false;

  Future<void> pickImage(UploadType uploadType) async{
    isImagePicked =false;
    isProcessing = true;
    notifyListeners();//グリグリ回す

    imageFile= await postRepository.pickImage(uploadType);
    print("pickedImage: ${imageFile.path}");

    // 位置情報
    location = await postRepository.getCurrentLocation();
    //１行に変換
    locationString =_toLocationString(location);
    print("location:$locationString");

    if(imageFile != null) isImagePicked =true;
    isProcessing =false;
    notifyListeners();//画像が取ってこれたか

  }

  String _toLocationString(Location location) {
    return location.country+" "+location.state+" "+location.city;
  }


}