//postRepositoryはdbManagerとlocationManagerの２つに依存する(ProxyProvider2)

import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/data_models/comments.dart';
import 'package:instaclone/data_models/like.dart';
import 'package:instaclone/data_models/location.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/db/database_manager.dart';
import 'package:instaclone/models/location/location_manager.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:uuid/uuid.dart';

class PostRepository {
  final DatabaseManager dbManager;
  final LocationManager locationManager;

  PostRepository({this.dbManager, this.locationManager});

  Future<File> pickImage(UploadType uploadType) async {
    final imagePicker = ImagePicker();

    if (uploadType == UploadType.GALLERY) {
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.gallery);
      //imagePickerで返ってくる型はPickedFile
      return File(pickedImage.path);
//    return File((await imagePicker.getImage(source:ImageSource.gallery)).path);
    } else {
      //return File((await imagePicker.getImage(source:ImageSource.camera)).path);
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.camera);
      return File(pickedImage.path);
    }
  }

  Future<Location> getCurrentLocation() async {
    return await locationManager.getCurrentLocation();
  }

  //todo getCurrentLocationをlocationManagerのメソッドにすること
//  Future<Location> getCurrentLocation() async{
//   //disiredAccuracyは情報の精度
//  final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//  final placeMarks =await Geolocator().placemarkFromPosition(position);
//  final placeMark =placeMarks.first;
//  return Future.value(convert(placeMark));
//  //asyncついてればFuture.valueじゃなくても良いかも？？
//  //  return convert(placeMark);
//  }

  //convert自体は非同期出なくて良いのでFutureOrではない
//  Location convert(Placemark placeMark) {
//   return Location(
//     latitude: placeMark.position.latitude,
//     longitude: placeMark.position.longitude,
//     country: placeMark.country,
//     state: placeMark.administrativeArea,
//     city: placeMark.locality,
//   );
//  }

  Future<Location> updateLocation(double latitude, double longitude) async {
    return await locationManager.updateLocation(latitude, longitude);
  }

  //投稿するだけなので戻り値void
  Future<void> post(User currentUser, File imageFile, String caption,
      Location location, String locationString) async {
    //一意のId設定
    final storageId = Uuid().v1();
    //最終的にstorageに画像アップしてstorage内の場所のurl(imageUrl)を取ってくる
    final imageUrl = await dbManager.uploadImageToStorage(imageFile, storageId);
    print('storageImageUrl:$imageUrl');
    final post = Post(
      postId: Uuid().v1(),
      userId: currentUser.userId,
      imageUrl: imageUrl,
      imageStoragePath: storageId,
      caption: caption,
      locationString: locationString,
      latitude: location.latitude,
      longitude: location.longitude,
      postDatetime: DateTime.now(),
    );
    await dbManager.insertPost(post);
  }

  //どのユーザー情報を取ってくるかをviewModelからもらっておく
  Future<List<Post>> getPosts(FeedMode feedMode, User feedUser) async {
    if (feedMode == FeedMode.FROM_FEED) {
      // 自分＋フォローしているユーザー
      return dbManager.getPostsMineAndFollowings(feedUser.userId);
    }
    if (feedMode == FeedMode.FROM_PROFILE) {
      //todo  プロフィール画面に表示されているユーザーのみ(自分とは限らない)
//      return dbManager.getPostByUser(feedUser.userId)
    }
  }

  //updateした後、getPostするので戻り値はvoidで良い
  Future<void> updatePost(Post updatePost) async {
    return dbManager.updatePost(updatePost);
  }

  //コメント投稿
  Future<void> postComment(
      Post post, User commentUser, String commentString) async {
    final comment = Comment(
      comment: commentString,
      postId: post.postId,
      commentDateTime: DateTime.now(),
      commentId: Uuid().v1(),
      //任意のId自ら作りたいとき
      commentUserId: commentUser.userId,
    );
    await dbManager.postComment(comment);
  }

  //postIdに紐づいたコメント取得(読み込みread)
  Future<List<Comment>> getComments(String postId) async {
    return dbManager.getComments(postId);
  }

  Future<void> deleteComment(String deleteCommentId) async {
    await dbManager.deleteComment(deleteCommentId);
  }

  //Like登録
  Future<void> likeIt(Post post, User currentUser) async {
    final like = Like(
      likeUserId: currentUser.userId,
      likeId: Uuid().v1(),
      postId: post.postId,
      likeDateTime: DateTime.now()
    );
    await dbManager.likeIt(like);
  }

  Future<void> unLikeIt(Post post, User currentUser) async{
    await dbManager.unLikeIt(post,currentUser);
  }

  //自分が投稿に対していいねをしているかを判定する
  Future<LikeResult> getLikeResult(String postId, User currentUser) async{
    //まずDBに登録されている「いいね」(likesの中のpostIdに紐づくデータ)の取得
    final likes = await dbManager.getLikes(postId);
    //取得したlikes中のデータに対してlikeUserIdが自分かどうかを判定
    var isLikedPost = false;
    for(var like in likes){
      if(like.likeUserId == currentUser.userId){
        isLikedPost= true;//自分がいたら抜けるためbreak
        break;
      }
    }
    return LikeResult(likes: likes, isLikedToThisPost: isLikedPost);
  }

  Future<void> deletePost(String postId, String imageStoragePath) async{
    await dbManager.deletePost(postId,imageStoragePath);
  }


}
