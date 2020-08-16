import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:instaclone/utils/constants.dart';

class PostRepository{
  //todo コンストラクタ

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