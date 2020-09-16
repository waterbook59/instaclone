import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

import '../../../style.dart';

class PostCaptionInputTextField extends StatefulWidget {
  final String cationBeforeUpdated;
  final PostCaptionOpenMode from;//modeによって参照するviewModelが異なるため

  PostCaptionInputTextField({this.cationBeforeUpdated, this.from});

  @override
  _PostCaptionInputTextFieldState createState() =>
      _PostCaptionInputTextFieldState();
}

class _PostCaptionInputTextFieldState extends State<PostCaptionInputTextField> {
  //TextEditionControllerが変更された時のハンドリング方法 step1
  final _cationController = TextEditingController();

  //TextEditionControllerが変更された時のハンドリング方法 step4
  // addListener登録(Stream.listenみたいなもん)
  @override
  void initState() {
    // super.initState();は_cationController.addListenerの前でいいか？
    super.initState();
    _cationController.addListener(() {
      //中身はvoidCallback指定
      _onCationUpdated();
    });
    //メソッド参照的に書くなら
//    _cationController.addListener(_onCationUpdated);
  if(widget.from == PostCaptionOpenMode.FROM_FEED){
    _cationController.text =widget.cationBeforeUpdated;
  }

  }

  @override
  void dispose() {
    //TextEditionControllerが変更された時のハンドリング方法 step5 インスタンス破棄
    _cationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      //TextEditionControllerが変更された時のハンドリング方法 step2
      controller: _cationController,
      style: postCaptionTextStyle,
      //開いたときにすぐフォーカスして入力できる
      autofocus: true,
      //複数行入力可能にする(TextInputType.multiline&maxLinesをnull)
      keyboardType: TextInputType.multiline,
      maxLines: null,
      //ヒントテキスト出す(デコレーション=>InputDecoration=>ヒントテキスト)ボーダーなくす
      decoration: InputDecoration(
          hintText: S.of(context).inputCaption, border: InputBorder.none),
    );
  }

  //TextEditionControllerが変更された時のハンドリング方法 step3
  // viewModelで設定したcation変数へ入力テキストをセット
  _onCationUpdated() {
    if(widget.from == PostCaptionOpenMode.FROM_FEED){//feedから編集の時
      final viewModel = Provider.of<FeedViewModel>(context, listen: false);
      //viewModelのcaptionへview側のcontroller.textをセット
      viewModel.caption = _cationController.text;
      print('caption In FeedViewModel:${viewModel.caption}');
    }else{//postから投稿の時
      final postViewModel = Provider.of<PostViewModel>(context, listen: false);
      postViewModel.caption = _cationController.text;
      print("caption:${postViewModel.caption}");
    }


  }
}
