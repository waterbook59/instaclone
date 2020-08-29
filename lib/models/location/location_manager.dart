//位置情報を司るモデルクラス

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:instaclone/data_models/location.dart';



class LocationManager {

  //chapter66
  Future<Location> getCurrentLocation() async{
    //disiredAccuracyは情報の精度,Geolocatorはインスタンスのいらないstaticメソッド
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    //List形式で返ってくる
    final placeMarks =await Geolocator().placemarkFromPosition(position);
    //Listの最初持ってくる
    final placeMark =placeMarks.first;
    return Future.value(convert(placeMark));
    //asyncついてればFuture.valueじゃなくても良いかも？？
    //  return convert(placeMark);
  }

  Future<Location> updateLocation(double latitude, double longitude) async{
    //何も情報を持ってないときはgetCurrentPosition
    //今回緯度・経度の情報持ってるのでplacemarkFromCoordinates
    final placeMarks = await Geolocator().placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks.first;
    return Future.value(convert(placeMark));
  }



  //convert自体は非同期出なくて良いのでFutureOrではない
  Location convert(Placemark placeMark) {
    return Location(
      latitude: placeMark.position.latitude,
      longitude: placeMark.position.longitude,
      country: placeMark.country,
      state: placeMark.administrativeArea,
      city: placeMark.locality,
    );
  }





}