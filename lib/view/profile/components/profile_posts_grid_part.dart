import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/feed/components/sub/image_from_url.dart';
import 'package:instaclone/view/feed/screens/feed_screen.dart';
import 'package:instaclone/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePostsGridPart extends StatelessWidget {
  final List<Post> posts;

  ProfilePostsGridPart({@required this.posts});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      children: posts.isEmpty
          ? [Container()] //Listなので[]必要
          : List.generate(//indexごとにImageFromUrlを呼び出して描画
        posts.length,
            (int index) => InkWell(
              onTap:()=>_openFeedScreen(context, index),
              child: ImageFromUrl(
                imageUrl: posts[index].imageUrl,
              ),
            ),
      ),

    );
  }

  _openFeedScreen(BuildContext context, int index) {
    final profileViewModel = Provider.of<ProfileViewModel>(context,listen: false);
    final feedUser = profileViewModel.profileUser;
    Navigator.push(context,MaterialPageRoute(
      builder: (_)=>FeedScreen(feedUser: feedUser,feedMode: FeedMode.FROM_PROFILE,index: index,),
    ));
  }
}
