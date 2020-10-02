import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/common/components/circle_photo.dart';
import 'package:instaclone/view_models/comments_view_model.dart';
import 'package:provider/provider.dart';

//text_field使うからstatefulで
class CommentInputPart extends StatefulWidget {
  final Post post;


  CommentInputPart({@required this.post});

  @override
  _CommentInputPartState createState() => _CommentInputPartState();
}

class _CommentInputPartState extends State<CommentInputPart> {
  final _commentInputController = TextEditingController();
  bool isCommentPostEnabled = false; //コメントしても良い時はボタン押せる

  @override
  void initState() {
    super.initState();
    _commentInputController.addListener(_onCommentChanged);
  }

  @override
  void dispose() {
    _commentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    //ここではlisten:trueでオッケーなのは？？ メソッド呼び出すだけならfalse
    final commentsViewModel = Provider.of<CommentsViewModel>(context);
    final commenter = commentsViewModel.currentUser;

    return Card(
      color: cardColor,
      child: ListTile(
        leading:
            CirclePhoto(photoUrl: commenter.photoUrl, isImageFromFile: false),
        title: TextField(
          maxLines: null,
          controller: _commentInputController,
          style: commentInputTextStyle,
          decoration: InputDecoration(
            border: InputBorder.none, //textFieldの下線消す
            hintText: S.of(context).addComment, //hitText出す
          ),
        ),
        trailing: FlatButton(
          child: Text(
            S.of(context).post,
            style: TextStyle(
                color: isCommentPostEnabled ? Colors.blue : Colors.grey),
          ),
          onPressed: isCommentPostEnabled
              ? () => _postComment(context,widget.post) //押せてコメント投稿
              : null //押せない
          ,
        ),
      ),
    );
  }

  void _onCommentChanged() {
    final viewModel = Provider.of<CommentsViewModel>(context, listen: false);
    //viewModelのプロパティに入力テキストセット
    viewModel.comment = _commentInputController.text;
    print('Comments in CommentsViewModel: ${viewModel.comment}');
    //画面更新
    setState(() {
      //buildメソッドがもう１度回る
      if (_commentInputController.text.length > 0) {
        //テキスト入ってたらボタン押せる
        isCommentPostEnabled = true;
      } else {
        isCommentPostEnabled = false;
      }
    });
  }

  //
  _postComment(BuildContext context, Post post) async{
    final commentViewModel = Provider.of<CommentsViewModel>(context, listen: false);

    await commentViewModel.postComment(post);
    //テキスト投稿が完了したらTextFieldを空に
    _commentInputController.clear();

  }
}
