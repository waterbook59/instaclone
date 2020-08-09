import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/models/db/database_manager.dart';

class UserRepository{
  //databaseManagerをDI
  final DatabaseManager dbManager;
  UserRepository({this.dbManager});

  //firebase authを使うためのインスタンス、staticのメソッドでインスタンス取れる
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> isSignIn() async {
   final firebaseUser = await _auth.currentUser();
   if(firebaseUser != null){
     return true;
   }
   return false;
  }
}