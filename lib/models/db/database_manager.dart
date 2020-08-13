//repositoryとfirebaseの仲介(CloudFireStoreから変更するときも便利)
//具体的にはcloudFireStoreを操作するclass

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/data_models/user.dart';

class DatabaseManager {
  //firestoreのインスタンスとってくる
  final Firestore _db = Firestore.instance;

//cloudfirestoreの検索条件を指定して読み込む
  Future<bool> searchUserInDb(FirebaseUser firebaseUser) async {
    //usersというコレクションの中にあるuserIdがfirebaseUserのuidと同じ場合、ドキュメントを取ってくる
    final query = await _db
        .collection("users")
        .where("userId", isEqualTo: firebaseUser.uid)
        .getDocuments();
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
}
