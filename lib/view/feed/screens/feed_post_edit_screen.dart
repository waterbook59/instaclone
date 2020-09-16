import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/common/components/user_card.dart';
import 'package:instaclone/view/common/dialog/confirm_dialog.dart';
import 'package:instaclone/view/post/components/post_caption_part.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostEditScreen extends StatelessWidget {
  final Post post;
  final User postUser;
  final FeedMode feedMode;

  FeedPostEditScreen(
      {@required this.post, @required this.postUser, @required this.feedMode});

  //Scaffoldがないと（Material widgetがないという）エラー
  //たぶんMaterialPageRouteでこのScreenにこれない

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(builder: (_, model, child) {
      return Scaffold(
        appBar: AppBar(
          leading: model.isProcessing
              ? Container()
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
          title: model.isProcessing
              ? Text(S.of(context).underProcessing)
              : Text(S.of(context).editInfo),
          actions: [
            model.isProcessing
            ? Container()
            : IconButton(
              icon: Icon(Icons.done),
              onPressed: () => showConfirmDialog(
                  context: context,
                  title: S.of(context).editPost,
                  content: S.of(context).editPostConfirm,
                  onConfirmed: (isConfirmed) {
                    if (isConfirmed) {
                      _updatePost(context);
                    }
                  }),
            )
          ],
        ),
        body: model.isProcessing
        ?Center(child: CircularProgressIndicator(),)
        :SingleChildScrollView(
          child: Column(
            children: [
              UserCard(
                photoUrl: postUser.photoUrl,
                title: postUser.inAppUserName,
                subtitle: post.locationString,
                onTap: null,
              ),
              PostCaptionPart(
                from: PostCaptionOpenMode.FROM_FEED,
                post: post,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _updatePost(BuildContext context) async {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    await feedViewModel.updatePost(post, feedMode);
    Navigator.pop(context);
  }
}
