import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instaclone/models/db/database_manager.dart';

class UserRepository{
  //databaseManagerをDI
  final DatabaseManager dbManager;
  UserRepository({this.dbManager});

  //firebase authを使うためのインスタンス、staticのメソッドでインスタンス取れる
  //pub.devのfirebase_auth_pluginのUse the pluginの箇所を参照
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
   final firebaseUser = await _auth.currentUser();
   if(firebaseUser != null){
     return true;
   }
   return false;
  }

  Future<bool> signIn() async{
    try{
      //step6.サインインしてグーグルアカウントで認証する
    GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication signInAuthentication =await signInAccount.authentication;

    //step7.認証したidでトークン作って信用状にする
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: signInAuthentication.accessToken,
      idToken: signInAuthentication.idToken,
    );

    //step8
    final firebaseUser = (await _auth.signInWithCredential(credential)).user;
    if(firebaseUser ==null){
      return false;
    }
    //todo firebase上にuserがいたらdbに登録
    //まず、dbにuserがいるかどうか：いなかったら登録
      final isUserExistedInDb =await dbManager.searchUserInDb(firebaseUser);


    } catch(error){

    }
  }
}