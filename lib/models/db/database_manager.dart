//repositoryとfirebaseの仲介(CloudFireStoreから変更するときも便利)
//具体的にはcloudFireStoreを操作するclass

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instaclone/data_models/comments.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';

class DatabaseManager {
  //firestoreのインスタンスとってくる
  final Firestore _db = Firestore.instance;

//cloudfirestoreの検索条件を指定して読み込む
  Future<bool> searchUserInDb(FirebaseUser firebaseUser) async {
    //usersというコレクションの中にあるuserIdがfirebaseUserのuidと同じ場合、ドキュメントを取ってくる
    final query = await _db.collection("users").where("userId", isEqualTo: firebaseUser.uid).getDocuments();
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

  Future<User> getUserInfoFromDbById(String userId) async {
    //検索条件を使ってデータ取ってくる、queryに格納してそれをmap化したものをfromMapでほぐす
    final query = await _db
        .collection("users")
        .where("userId", isEqualTo: userId)
        .getDocuments();
    return User.fromMap(query.documents[0].data);
  }

  Future<String> uploadImageToStorage(File imageFile, String storageId) async{
    //保存場所
    final storageRef = FirebaseStorage.instance.ref().child(storageId);
    //Fileを保存場所にアップロード
    final uploadTask = storageRef.putFile(imageFile);
    //アップロードが終わったらファイルのダウンロードurl取得
    //getDownloadURL()がFuture<dynamic>なのでもう一つawait
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }


  Future<void> insertPost(Post post) async{
    //chapter93 cloud_firestore 0.14.0以降なら対応(document=>doc,setData=>set)
    //await  _db.collection('posts').doc(post.postId).set(post.toMap());
    await _db.collection('posts').document(post.postId).setData(post.toMap());
  }

  Future<List<Post>> getPostsMineAndFollowings(String userId) async{
    //firebaseにデータがない状態でデータ取るとアプリ落ちる
    //データの有無を判定
    //chapter97 cloud_firestore 0.14.0以降なら対応(.getDocuments()=>.get(),.documents=>.docs)
    final query = await _db.collection('posts').getDocuments();
    //firebaseにデータ空のときは空のList返す
    if(query.documents.length == 0)return List();

    //自分がフォローしてるユーザー
    var userIds = await getFollowingUserIds(userId);
    //自分がフォローしてるユーザーに自分を加える
    userIds.add(userId);

    var results = List<Post>();
//chapter99 検索条件複数ある場合の書き方(userIdとpostDateTimeのfield２つ使ってるので複合インデックス),新しいものから降順
    //postsの中からidが自分＋フォローユーザーであるidのリスト(userIds)を取ってきて、postDateTime降順に並び替え、
    //うまくいったらvalueがDocumentSnapshotであり、value.documentsがList<DocumentSnapshot>なのでforEachして
    //1行分のelementがMap型(json型)になってるので、モデルクラス型へ変換しresultsへ格納
    await _db.collection('posts').where('userId',whereIn: userIds).orderBy('postDatetime',
        descending: true).getDocuments().then((value) {
        value.documents.forEach((element) { 
          results.add(Post.fromMap(element.data));//Post.fromMapはJson型(element.data)をモデルクラスへ変換
        });
        });
    print('posts:$results');
    return results;

  }

  //todo プロフィールの時
  Future<List<Post>> getPostByUser(String userId) {}

  //自分がフォローしているユーザーを取ってくる
  Future<List<String>>getFollowingUserIds(String userId) async{
    //chapter98 cloud_firestore 0.14.0以降なら対応(.documents=>.docs)
    //document(xx).get() xxで指定してドキュメント取得
    final query = await _db.collection('users').document(userId).collection('followings').getDocuments();
    if(query.documents.length ==0) return List();

    var userIds = List<String>();
    query.documents.forEach((id) {
      //cloud_firestore 0.14.0以降なら対応(.data=>.data())
      //userIds.add(id.data()['userId']);
      userIds.add(id.data['userId']);//userIdがキー
    });
    return userIds;
  }


  Future<void> updatePost(Post updatePost) async{
    final reference = _db.collection('posts').document(updatePost.postId);
    await reference.updateData(updatePost.toMap());
  }

  //コメント投稿(commentsコレクション作って、自分で作ったidのところへCommnetをセット）
  Future<void> postComment(Comment comment) async{
    //documentの中のidは自分でuuidで作ったやつをいれる
    await _db.collection('comments').document(comment.commentId).setData(comment.toMap());
  }
  //postIdに紐づいたコメント取得(読み込みread) 読み込む時はデータがあるかないかを判別して進める
  Future<List<Comment>> getComments(String postId) async{
    //commentsコレクションの中身を全部取る
    final query = await _db.collection('comments').getDocuments();
    if(query.documents.length == 0) return List();
    var results = List<Comment>();
    //where('コレクション内のプロパティ', isEqualTo:引数として持ってきた値）
    await _db.collection('comments').where('postId',isEqualTo: postId).orderBy('commentDateTime').getDocuments()
    .then((value) {//valueにgetDocumentsすなわちQuerySnapshotすなわちQuerySnapshot.documents=>List<DocumentSnapshot>が入ってくる
      value.documents.forEach((element) { //elementはDocumentSnapshotでelement.dataとするとMap型になる
        results.add(Comment.fromMap(element.data));//空のresultsに入れていく
      });
    });
    //return resultsはawait=>thenが終わってから
    return results;
  }
}
