import 'package:flutter/material.dart';
import 'package:instaclone/view/common/components/circle_photo.dart';
import 'package:instaclone/view_models/comments_view_model.dart';
import 'package:provider/provider.dart';

//text_field使うからstatefulで
class CommentInputPart extends StatefulWidget {

//  CommentInputPart({});
  @override
  _CommentInputPartState createState() => _CommentInputPartState();
}

class _CommentInputPartState extends State<CommentInputPart> {
  final _commentInputController = TextEditingController();

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
    final commenter =commentsViewModel.currentUser;

    return Card(
      color: cardColor,
      child: ListTile(
        leading: CirclePhoto(photoUrl: commenter.photoUrl, isImageFromFile: false),
        title:   TextField(
          controller: _commentInputController,
        ),
      ),
    );
  }

  void _onCommentChanged() {
    final viewModel = Provider.of<CommentsViewModel>(context,listen: false);
    viewModel.comment = _commentInputController.text;
    print('Comments in CommentsViewModel: ${viewModel.comment}');
  }
}

