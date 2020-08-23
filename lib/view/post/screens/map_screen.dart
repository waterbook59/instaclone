import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instaclone/data_models/location.dart';
import 'package:instaclone/generated/l10n.dart';

class MapScreen extends StatefulWidget {
  //Locationは自分で使ったやつ
  final Location location;
  MapScreen({this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //todo chapter83 3:40~
  LatLng _latLng;
  CameraPosition _cameraPosition;
  GoogleMapController _mapController;

  @override
  void initState() {
    _latLng = LatLng(widget.location.latitude,widget.location.longitude);
    _cameraPosition =CameraPosition(target: _latLng,zoom:10.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectPlace),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.done),
          //todo
          onPressed: null,
        ),],
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        onMapCreated: onMapCreated,//メソッド参照の書き方
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController =controller;
  }
}
