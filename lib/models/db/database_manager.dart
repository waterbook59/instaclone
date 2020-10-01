//repositoryとfirebaseの仲介(CloudFireStoreから変更するときも便利)
//具体的にはcloudFireStoreを操作するclass

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instaclone/data_models/comments.dart';
import 'package:instaclone/data_models/like.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/repositories/user_repository.dart';

class DatabaseManager {
  //firestoreのインスタンスとってくる
  final Firestore _db = Firestore.instance;

//cloudfirestoreの検索条件を指定して読み込む
  Future<bool> searchUserInDb(FirebaseUser firebaseUser) async {
    //usersというコレクションの中にあるuserIdがfirebaseUserのuidと同じ場合、ドキュメントを取ってくる
    final query = await _db.collection("users").where(
        "userId", isEqualTo: firebaseUser.uid).getDocuments();
    if (query.documents.length > 0) {
      return true;
    }
    //documentがなければ
    return false;
  }

  //登録なのでvoidで良い
  Future<void> insertUser(User user) async {
    //DartDataClassとtoMapのコンボでいい感じにCloud Firestoreに登録される
    await _db.collection("users").document(user.userId).setData(user.toMap());
  }

  //userIdを渡したらそれに紐づくUserデータを取ってくる
  Future<User> getUserInfoFromDbById(String userId) async {
    //検索条件を使ってデータ取ってくる、queryに格納してそれをmap化したものをfromMapでほぐす
    final query = await _db
        .collection("users")
        .where("userId", isEqualTo: userId)
        .getDocuments();
    return User.fromMap(query.documents[0].data);
  }

  Future<String> uploadImageToStorage(File imageFile, String storageId) async {
    //保存場所
    final storageRef = FirebaseStorage.instance.ref().child(storageId);
    //Fileを保存場所にアップロード
    final uploadTask = storageRef.putFile(imageFile);
    //アップロードが終わったらファイルのダウンロードurl取得
    //getDownloadURL()がFuture<dynamic>なのでもう一つawait
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }


  Future<void> insertPost(Post post) async {
    //chapter93 cloud_firestore 0.14.0以降なら対応(document=>doc,setData=>set)
    //await  _db.collection('posts').doc(post.postId).set(post.toMap());
    await _db.collection('posts').document(post.postId).setData(post.toMap());
  }

  // プロフィールの時
  Future<List<Post>> getPostByUser(String userId) async {
    final query = await _db.collection('posts').getDocuments();
    if (query.documents.length == 0) return List();
    var results = List<Post>();
    await _db.collection('posts').where('userId', isEqualTo: userId)
        .orderBy('postDatetime', descending: true).getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        results.add(Post.fromMap(element.data));
      });
    });
    return results;
  }


  Future<List<Post>> getPostsMineAndFollowings(String userId) async {
    //firebaseにデータがない状態でデータ取るとアプリ落ちる
    //データの有無を判定
    //chapter97 cloud_firestore 0.14.0以降なら対応(.getDocuments()=>.get(),.documents=>.docs)
    final query = await _db.collection('posts').getDocuments();
    //firebaseにデータ空のときは空のList返す
    if (query.documents.length == 0) return List();

    //自分がフォローしてるユーザー
    var userIds = await getFollowingUserIds(userId);
    //自分がフォローしてるユーザーに自分を加える
    userIds.add(userId);

    var results = List<Post>();
//chapter99 検索条件複数ある場合の書き方(userIdとpostDateTimeのfield２つ使ってるので複合インデックス),新しいものから降順
    //postsの中からidが自分＋フォローユーザーであるidのリスト(userIds)を取ってきて、postDateTime降順に並び替え、
    //うまくいったらvalueがDocumentSnapshotであり、value.documentsがList<DocumentSnapshot>なのでforEachして
    //1行分のelementがMap型(json型)になってるので、モデルクラス型へ変換しresultsへ格納
    await _db.collection('posts').where('userId', whereIn: userIds).orderBy(
        'postDatetime',
        descending: true).getDocuments().then((value) {
      value.documents.forEach((element) {
        results.add(Post.fromMap(
            element.data)); //Post.fromMapはJson型(element.data)をモデルクラスへ変換
      });
    });
    print('posts:$results');
    return results;
  }


  //自分がフォローしているユーザーIDをリスト形式で取ってくる
  Future<List<String>> getFollowingUserIds(String userId) async {
    //chapter98 cloud_firestore 0.14.0以降なら対応(.documents=>.docs)
    //document(xx).get() xxで指定してドキュメント取得
    final query = await _db.collection('users').document(userId).collection(
        'followings').getDocuments();
    if (query.documents.length == 0) return List();

    var userIds = List<String>();
    query.documents.forEach((id) {
      //cloud_firestore 0.14.0以降なら対応(.data=>.data())
      //userIds.add(id.data()['userId']);
      userIds.add(id.data['userId']); //userIdがキー
    });
    return userIds;
  }

  //フォロワーのユーザーID(String型)をリストで返す
  Future<List<String>> getFollowerUserIds(String userId) async {
    final query = await _db.collection('users')
        .document(userId).collection('followers')
        .getDocuments();
    if (query.documents.length == 0) return List();
    var userIds = List<String>();
    query.documents.forEach((id) {
      //followersの中のフィールドはuserIdにするので、id.data['userId']
      userIds.add(id.data['userId']);
    });
    return userIds;
  }

  //chapter184 いいねしたユーザーを投稿idからとってくる
  Future<List<User>> getLikesUsers(String postId) async{
    //likesコレクションの中の全部のドキュメントからフィールドのpostIdで検索
    //postIdが同じのフィールドデータを全部とってくる
    print('dbManagerにきたpostId:$postId');//cc9f23...
    final query = await _db.collection('likes').where('postId',isEqualTo: postId).getDocuments();
    if(query.documents.length == 0) return List();
    print('postIdで検索した中身：${query.documents}');
    var userIds  =List<String>();
    //postIdで引っ張ってきた全データからforEachで回して、いいねしたユーザーのidのリストを作る
    query.documents.forEach((id) {
      //ここでid.data['likeUserId']とすることでlikeUserIdだけのリストを作れる
      //例えばid.data['likeDateTime']とするとlikeDateTimeだけのリスト作れる
      userIds.add(id.data['likeUserId']);
    });
    print('likeUserIdリスト：$userIds');
    //得られたuserIdからuserコレクションからUserデータのリストを作る
    var likesUsers = List<User>();
    //ループ全体をawaitした時はFuture.forEach
    await Future.forEach(userIds, (userId) async{
      final user = await getUserInfoFromDbById(userId);
      likesUsers.add(user);
    });
    print('誰がいいねしたか？：$likesUsers');
    return likesUsers;
  }


  Future<void> updatePost(Post updatePost) async {
    final reference = _db.collection('posts').document(updatePost.postId);
    await reference.updateData(updatePost.toMap());
  }

  //コメント投稿(commentsコレクション作って、自分で作ったidのところへCommnetをセット）
  Future<void> postComment(Comment comment) async {
    //documentの中のidは自分でuuidで作ったやつをいれる
    await _db.collection('comments').document(comment.commentId).setData(
        comment.toMap());
  }

  //postIdに紐づいたコメント取得(読み込みread) 読み込む時はデータがあるかないかを判別して進める
  Future<List<Comment>> getComments(String postId) async {
    //commentsコレクションの中身を全部取る
    final query = await _db.collection('comments').getDocuments();
    //まずデータがあるかどうか
    if (query.documents.length == 0) return List();
    var results = List<Comment>();
    //where('コレクション内のプロパティ', isEqualTo:引数として持ってきた値）
    await _db.collection('comments').where('postId', isEqualTo: postId).orderBy(
        'commentDateTime').getDocuments()
        .then((
        value) { //valueにgetDocumentsすなわちQuerySnapshotすなわちQuerySnapshot.documents=>List<DocumentSnapshot>が入ってくる
      value.documents.forEach((
          element) { //elementはDocumentSnapshotでelement.dataとするとMap型になる
        results.add(Comment.fromMap(element.data)); //空のresultsに入れていく
      });
    });
    //return resultsはawait=>thenが終わってから
    return results;
  }

  //コメント削除
  Future<void> deleteComment(String deleteCommentId) async {
    final reference = _db.collection('comments').document(deleteCommentId);
    await reference.delete();
  }

  //likeを挿入 セット
  Future<void> likeIt(Like like) async {
    await _db.collection('likes').document(like.likeId).setData(like.toMap());
  }

  //postIdに紐づくいいねのデータ取得
  Future<List<Like>> getLikes(String postId) async {
    final query = await _db.collection('likes').getDocuments();
    if (query.documents.length == 0) return List();
    var results = List<Like>();
    await _db.collection('likes').where('postId', isEqualTo: postId).orderBy(
        'likeDateTime').getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        results.add(Like.fromMap(element.data));
      });
    });
    return results;
  }

  //「いいね」やめる(likes内のデータ削除)時、likeIdを直接指定できる形ではない
  //まずdocumentのidを取得してからlikeIdで指定して削除(参考はコメント削除)
  Future<void> unLikeIt(Post post, User currentUser) async {
    //documentのid取得,postIdが同じかとlikeUserIdが自分かどうかで検索条件設定
    final likeRef = await _db.collection('likes').where(
        'postId', isEqualTo: post.postId)
        .where('likeUserId', isEqualTo: currentUser.userId)
        .getDocuments();
    //likeRefは複数の可能性があるのでforEachで１つにバラして削除
    likeRef.documents.forEach((element) async {
      final ref = _db.collection('likes').document(element.documentID);
      await ref.delete();
    });
  }

  //投稿の削除（それに紐づくコメントやlikesやstorageも削除）
  Future<void> deletePost(String postId, String imageStoragePath) async {
    //Post
    final postRef = _db.collection('posts').document(postId);
    await postRef.delete();
    //Comment
    //postIdでcommentsドキュメント内の検索かけて、postIdが同じデータのcommentIdのものを消す
    final commentsRef = await _db.collection('comments').where(
        'postId', isEqualTo: postId).getDocuments();
    //commentsRefにはpostIdが一致するコメントたちが複数リスト形式で入った状態=>forEachでほぐす
    commentsRef.documents.forEach((element) async {
      //elementは１行分のデータ(element.documentIDはcommentsコレクション直下のID)
      final commentRef = _db.collection('comments').document(
          element.documentID);
      await commentRef.delete();
    });

    //Likes
    final likesRef = await _db.collection('likes').where(
        'postId', isEqualTo: postId).getDocuments();
    //commentsRefにはpostIdが一致するコメントたちが複数リスト形式で入った状態=>forEachでほぐす
    likesRef.documents.forEach((element) async {
      //elementは１行分のデータ(element.documentIDはcommentsコレクション直下のID)
      final likeRef = _db.collection('likes').document(element.documentID);
      await likeRef.delete();
    });

    //Storageから画像削除
    final storageRef = FirebaseStorage.instance.ref().child(imageStoragePath);
    storageRef.delete();
  }

  //プロフィール更新
  Future<void> updateProfile(User updateUser) async {
    final reference = _db.collection('users').document(updateUser.userId);
    await reference.updateData(updateUser.toMap());
  }

  //ユーザー検索
  Future<List<User>> searchUsers(String queryString) async {
    //まずコレクションにデータがあるか
    //検索入力前はinAppUserNameで昇順でユーザーが並んでいる
    //startAtにqueryのリストいれるとquery入力で始まるリストを取ってきてくれる、
    // 終点をuf88で設定しないとstartAtしても候補が結局全部出てきてしまう ???ワイルドカード的な検索???
    final query = await _db.collection('users').orderBy('inAppUserName')
        .startAt([queryString])
        .endAt([queryString + "\uf8ff"])
        .getDocuments();

    if (query.documents.length == 0) return List();
    var soughtUsers = List<User>();
    query.documents.forEach((element) {
      //自分以外のユーザーだけを取ってくる
      final selectedUser = User.fromMap(element.data);
      if (selectedUser.userId != UserRepository.currentUser.userId) {
        soughtUsers.add(selectedUser);
      }
    });
    return soughtUsers;
  }

  //ログインしているcurrentUserがフォローすると、followingコレクション内にprofileUser側のuserIDをセットして、
  //profileUser側のfollowersコレクション内にcurrentUserのIDがセットされる
  Future<void> follow(User profileUser, User currentUser) async{
    //currentUserにとってのfollowingsへセット
  await _db.collection('users').document(currentUser.userId)
      .collection('followings').document(profileUser.userId)
      .setData({'userId':profileUser.userId});

    //profileUserにとってのfollowersへセット
  await _db.collection('users').document(profileUser.userId)
      .collection('followers').document(currentUser.userId)
      .setData({'userId':currentUser.userId});
  }

  Future<void> unFollow(User profileUser, User currentUser) async{
    //currentUserにとってのfollowingsを削除
    await _db.collection('users').document(currentUser.userId)
        .collection('followings').document(profileUser.userId)
        .delete();
    //profileUserにとってのfollowersを削除
    await _db.collection('users').document(profileUser.userId)
        .collection('followers').document(currentUser.userId)
        .delete();
  }




  Future<bool> checkIsFollowing(User profileUser, User currentUser) async{
    //自分の中で自分がフォローした人がいるかどうかチェック
    final query = await _db.collection('users').document(currentUser.userId).collection('followings').getDocuments();
    if(query.documents.length==0) return false;
    //自分(currentUser)のfollowingsコレクション内にpforfileUserと同じuserIdがある場合、trueを返す
    final checkQuery =  await _db.collection('users').document(currentUser.userId).collection('followings')
        .where('userId',isEqualTo: profileUser.userId).getDocuments();
    if(checkQuery.documents.length>0) {
      //フォローしてる
      return true;
    }else{
      //フォローしてない
      return false;
    }
  }

  //プロフィールユーザーIDからフォロワーのユーザー情報をとってくる
  Future<List<User>> getFollowerUsers(String profileUseId) async{
    //フォロワーのidのリストが返ってくる
    final followerUserIds = await getFollowerUserIds(profileUseId);
    //得られたフォロワーidリストからとってきたUser情報をリストに変換
    var followerUsers = List<User>();
    await Future.forEach(followerUserIds, (followerUserId) async{
      final user = await getUserInfoFromDbById(followerUserId);
      followerUsers.add(user);
    });
    return followerUsers;
  }

  //プロフィールユーザーIDから自分がフォローしているのユーザー情報をとってくる
  Future<List<User>> getFollowingUsers(String profileUseId) async{
    final followingUserIds = await getFollowingUserIds(profileUseId);
    var followingUsers = List<User>();
    await Future.forEach(followingUserIds, (followingUserId) async{
      final user = await getUserInfoFromDbById(followingUserId);
      followingUsers.add(user);
    });
    return followingUsers;
  }






}