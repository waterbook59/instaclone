import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/db/database_manager.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  //databaseManagerをDI
  final DatabaseManager dbManager;

  UserRepository({this.dbManager});

  //取得したDBからのデータをUseRepositoryのインスタンスを経由せずにアプリ全体で使えるようにstaticとしてcurrentUserに格納
  static User currentUser;

  //firebase authを使うためのインスタンス、staticのメソッドでインスタンス取れる
  //pub.devのfirebase_auth_pluginのUse the pluginの箇所を参照
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
    final firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      //サインアウトメソッド（disconnectメソッドはうまくいかないみたい）を使って次回ログインした時にログイン履歴があると自動的にログインされてしまう
      //その時currentUserがnullになってしまうので、DBから取ってきたデータをcurrentUserに入れておきたい
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    }
    return false;
  }

  Future<bool> signIn() async {
    try {
      //step6.サインインしてグーグルアカウントで認証する
      GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;

      //step7.認証したidでトークン作って信用状にする
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: signInAuthentication.accessToken,
        idToken: signInAuthentication.idToken,
      );

      //step8
      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return false;
      }
      // firebase上にuserがいたらdbに登録
      //まず、dbにuserがいるかどうか：いなかったら登録
      final isUserExistedInDb = await dbManager.searchUserInDb(firebaseUser);
      if (!isUserExistedInDb) {
        //dbにuserいないとき〜
        //firebaseUser(PlatformUserInfo)をモデルクラスのUserへ変換必要_convertToUser(firebaseUser)してdbに登録
        await dbManager.insertUser(_convertToUser(firebaseUser));
      }
      //DBに登録したユーザーデータを取得＆アプリ全体で使えるように(static!!)する
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    } catch (error) {
      print("sign in error caught!:${error.toString()}");
      return false;
    }
  }

  _convertToUser(FirebaseUser firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      inAppUserName: firebaseUser.displayName,
      //最初はgoogleアカウントのユーザー名でよい
      photoUrl: firebaseUser.photoUrl,
      email: firebaseUser.email,
      bio: "",
    );
  }

  Future<User> getUserById(String userId) async {
    return await dbManager.getUserInfoFromDbById(userId);
  }

  Future<void> singOut() async {
    //googleとfirebase両方のサインアウトが必要
    //googleからサインアウト（現状disconnect使うとアプリが落ちる可能性あり）
    await _googleSignIn.signOut();
    //firebaseからサインアウト
    await _auth.signOut();
    //次起動した時にcurrentUserが残っていると起動前の情報が使われてしまう
    currentUser = null;
  }

  Future<int> getNumberOfFollowers(User profileUser) async {
    //フォロワーのIDリストを取ってくる
    return (await dbManager.getFollowerUserIds(profileUser.userId)).length;
  }

  Future<int> getNumberOfFollowings(User profileUser) async {
    return (await dbManager.getFollowingUserIds(profileUser.userId)).length;
  }

  //プロフィール更新
  Future<void> updateProfile(User profileUser, String nameUpdated,
      String bioUpdated, String photoUrlUpdated, bool isImageFromFile) async{
    var updatePhotoUrl;

    if(isImageFromFile){
     //Fileからの場合のアップデート
      final updatePhotoFile = File(photoUrlUpdated);
      final storagePath = Uuid().v1();
      updatePhotoUrl = await dbManager.uploadImageToStorage(updatePhotoFile, storagePath);
    }
    //そうでない場合、変更前のユーザーデータ持ってくる
    final userBeforeUpdate = await dbManager.getUserInfoFromDbById(profileUser.userId);
    final updateUser = userBeforeUpdate.copyWith(//変えたいところだけcopyWith
      inAppUserName: nameUpdated,
      photoUrl: isImageFromFile ? updatePhotoUrl : userBeforeUpdate.photoUrl,
      bio: bioUpdated
    );
    await dbManager.updateProfile(updateUser);
  }

  //currentUserの更新
  Future<void> getCurrentUserById(String userId) async{
    currentUser = await dbManager.getUserInfoFromDbById(userId);
  }

  //ユーザー検索
  Future<List<User>>searchUsers(String query) async{
    return dbManager.searchUsers(query);
  }

  //フォローするのに、プロフィールユーザーと自分のIDの２つの紐付けが必要
  Future<void> follow(User profileUser) async{
    await dbManager.follow(profileUser,currentUser);
  }

  Future<void> unFollow(User profileUser) async{
    await dbManager.unFollow(profileUser,currentUser);
  }


  //自分じゃない人のプロフィール画面を開いた時のフォロー状態をとってくる
  Future<bool> checkIsFollowing(User profileUser) async{
    return await dbManager.checkIsFollowing(profileUser,currentUser);
  }

  //ここで３つに分岐
  Future<List> getCaresMeUsers(String id, WhoCaresMeMode mode) async{
    var results = List<User>();

    //
    switch (mode){
      case WhoCaresMeMode.LIKE:
        //いいねの場合は投稿id
        final postId = id;
        results = await dbManager.getLikesUsers(postId);
        break;
      case WhoCaresMeMode.FOLLOWINGS:
        final profileUseId = id;
        results = await dbManager.getFollowingUsers(profileUseId);
        break;
      case WhoCaresMeMode.FOLLOWED:
        final profileUseId = id;
        results = await dbManager.getFollowerUsers(profileUseId);
        break;
    }
    return results;
  }


}
