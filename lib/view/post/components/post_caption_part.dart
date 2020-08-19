import 'package:flutter/material.dart';
import 'package:instaclone/utils/constants.dart';

class PostCaptionPart extends StatelessWidget {
  final PostCaptionOpenMode from;

  PostCaptionPart({@required this.from});

  @override
  Widget build(BuildContext context) {

    if(from == PostCaptionOpenMode.FROM_POST){
      return ListTile(
        //todo
//        leading: HeroImage(),
        //todo
//        title: PostCationInputTextField(),
      );
    }else{
      //todo
      return Container();
    }


  }
}
