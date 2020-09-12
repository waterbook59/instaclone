import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instaclone/data_models/location.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';



class MapScreen extends StatefulWidget {
  //Locationは自分で使ったやつ
  final Location location;
  MapScreen({this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _latLng;
  CameraPosition _cameraPosition;
  GoogleMapController _mapController;
  Map<MarkerId,Marker>_markers=<MarkerId,Marker>{};

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
          //選択した位置情報をviewModel側へ投げて取得
          onPressed: ()=>_onPlaceSelected(),
        ),],
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        onMapCreated: onMapCreated,//メソッド参照の書き方
        //地図をタップするとlatLngが得られる
        onTap: onMapTapped,
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController =controller;
  }

  void onMapTapped(LatLng latLng) {
    _latLng =latLng;
    _createMarker(_latLng);
  }

  void _createMarker(LatLng latLng) {
    //MarkerId('名前')の名前は自由に自分でつける
    final markerId = MarkerId("Selected");
    //上でつけたmarkerIdを元にmarker作成
    final marker = Marker(markerId: markerId, position: latLng);
    setState(() {
      //MapにMarkerId("Selected")のkey名で格納
      //_markers = ["Selected":latLng,key:value]みたいな感じ
      _markers[markerId] = marker;

    });



  }

  _onPlaceSelected() async{
    final postViewModel = Provider.of<PostViewModel>(context,listen: false);
    await postViewModel.updateLocation(_latLng.latitude,_latLng.longitude);
    //地図のupdateが終わったらmapscreen閉じる
    Navigator.pop(context);
  }
}
