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

  String caption ="";
 //グリグリと画像取ってこれたかを初期設定
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

  Future<void> updateLocation(double latitude, double longitude) async{
    location = await postRepository.updateLocation(latitude,longitude);
    locationString =_toLocationString(location);
    print("updateLocation:$locationString");
    notifyListeners();
    //呼び出し元のpostUploadScreenではConsumerしているのでこの変更通知が反映される
  }

  //todo
  Future<void> post() async{
  //投稿ボタン押す=>グリグリ回す
    isProcessing =true;
    notifyListeners();

    await postRepository.post(
       UserRepository.currentUser,
      imageFile,
      caption,
      location,
      locationString,
    );
    //アップロードが終わったらグリグリ回すのストップ
    isProcessing =false;
    //todo もう１回画像を取ってくるのでfalse??
    isImagePicked = false;
    notifyListeners();
  }


}