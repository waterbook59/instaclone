import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/common/dialog/confirm_dialog.dart';
import 'package:instaclone/view/post/components/post_caption_part.dart';
import 'package:instaclone/view/post/components/post_location_part.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostUploadScreen extends StatelessWidget {
  final UploadType uploadType;

  PostUploadScreen({this.uploadType});

  @override
  Widget build(BuildContext context) {

    //postUploadScreenが開いた時に画像を取ってくる listen:faluseで投げてConsumerでそれを受ける形
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    if (!postViewModel.isImagePicked && !postViewModel.isProcessing) {
      //画像を取ってきてない場合かつ処理中でない場合だけ取ってくる
      Future(() => postViewModel.pickImage(uploadType));
    }

    return Consumer<PostViewModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          //取得中は画面戻れないようにする
          leading: model.isProcessing
              ? Container()
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _cancelPost(context),
                ),
          title: model.isProcessing
              ? Text(S.of(context).underProcessing)
              : Text(S.of(context).post),
          actions: <Widget>[
            //処理中あるいは画像を取ってこれない時はxボタン、それ以外は投稿
            (model.isProcessing || !model.isImagePicked)
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _cancelPost(context),
                  )
                : IconButton(
                    icon: Icon(Icons.done),
                    //ダイアログ出して投稿処理
                    //メソッド参照使わないときは()=>必須！！！
                    onPressed: ()=>showConfirmDialog(
                        context: context,
                        title: S.of(context).post,
                        content: S.of(context).postConfirm,
                        //onConfirmedがValueChange型なので外に出した関数からisConfirmedにtrue,falseが入ってくる
                        onConfirmed: (isConfirmed){
                        if(isConfirmed){
                          _post(context);
                        }else{

                        }
                        }),
                  )
          ],
        ),
        body: model.isProcessing
            ? Center(
                child: CircularProgressIndicator(),
              )
            : model.isImagePicked
                ? Column(
                    children: <Widget>[
                      Divider(),
                      PostCaptionPart(
                        from: PostCaptionOpenMode.FROM_POST,
                      ),
                      Divider(),
                      PostLocationPart(),
                      Divider(),
                    ],
                  )
                : Container(),
      );
    });
  }

  _cancelPost(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context,listen: false);
    postViewModel.cancelPost();
    Navigator.pop(context);
  }

  void _post(BuildContext context) async{
    print("PostUploadScreen#_post invoked");
    final postViewModel = Provider.of<PostViewModel>(context,listen: false);
    //投稿する中身はpostVieModelがfieldで持ってるので呼び出すだけ
    await postViewModel.post();
    Navigator.pop(context);
  }
}
