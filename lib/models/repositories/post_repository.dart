//postRepositoryはdbManagerとlocationManagerの２つに依存する(ProxyProvider2)

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/db/database_manager.dart';
import 'package:instaclone/models/location/location_manager.dart';
import 'package:instaclone/utils/constants.dart';

class PostRepository{
  final DatabaseManager dbManager;
  final LocationManager locationManager;

  PostRepository({this.dbManager, this.locationManager});

 Future<File> pickImage(UploadType uploadType) async{
  final imagePicker = ImagePicker();

  if(uploadType == UploadType.GALLERY){
    final pickedImage  =await imagePicker.getImage(source: ImageSource.gallery);
    return File(pickedImage.path);
//    return File((await imagePicker.getImage(source:ImageSource.gallery)).path);
  }else{
    return File((await imagePicker.getImage(source:ImageSource.camera)).path);
  }


  }

}