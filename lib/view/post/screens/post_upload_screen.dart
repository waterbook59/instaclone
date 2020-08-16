import 'package:flutter/material.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostUploadScreen extends StatelessWidget {
  final UploadType uploadType;
  PostUploadScreen({this.uploadType});

  @override
  Widget build(BuildContext context) {
    final postViewModel =Provider.of<PostViewModel>(context,listen: false);
    if(!postViewModel.isImagePicked && !postViewModel.isProcessing){//画像を取ってきてない場合かつ処理中でない場合だけ取ってくる
      Future(()=>postViewModel.pickImage(uploadType));
    }

    return Scaffold(
      body: Container(),
    );
  }
}
