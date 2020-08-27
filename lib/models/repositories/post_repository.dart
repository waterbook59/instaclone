//postRepositoryはdbManagerとlocationManagerの２つに依存する(ProxyProvider2)

import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/data_models/location.dart';
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
    //return File((await imagePicker.getImage(source:ImageSource.camera)).path);
    final pickedImage  =await imagePicker.getImage(source: ImageSource.camera);
    return File(pickedImage.path);
  }


  }

  Future<Location> getCurrentLocation()async{
    return await locationManager.getCurrentLocation();
  }


  //todo getCurrentLocationをlocationManagerのメソッドにすること
//  Future<Location> getCurrentLocation() async{
//   //disiredAccuracyは情報の精度
//  final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//  final placeMarks =await Geolocator().placemarkFromPosition(position);
//  final placeMark =placeMarks.first;
//  return Future.value(convert(placeMark));
//  //asyncついてればFuture.valueじゃなくても良いかも？？
//  //  return convert(placeMark);
//  }

  //convert自体は非同期出なくて良いのでFutureOrではない
//  Location convert(Placemark placeMark) {
//   return Location(
//     latitude: placeMark.position.latitude,
//     longitude: placeMark.position.longitude,
//     country: placeMark.country,
//     state: placeMark.administrativeArea,
//     city: placeMark.locality,
//   );
//  }

  Future<Location> updateLocation(double latitude, double longitude) async{
   return await locationManager.updateLocation(latitude,longitude);
  }

}