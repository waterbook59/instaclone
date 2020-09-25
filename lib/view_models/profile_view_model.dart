import 'package:flutter/material.dart';
import 'package:instaclone/data_models/post.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';
import 'package:instaclone/utils/constants.dart';

class ProfileViewModel extends ChangeNotifier {
  final PostRepository postRepository;
  final UserRepository userRepository;

  ProfileViewModel({this.userRepository, this.postRepository});

  //プロフィールに表示するユーザーが誰か特定するプロパティ
  //他人の場合は渡されたprofileUser
  User profileUser;

  //自分の場合はcurrentUser
  User get currentUser => UserRepository.currentUser;
  bool isProcessing = false;
  List<Post> posts = <Post>[];

  //表示ユーザーを選択
  void setProfileUser(ProfileMode profileMode, User selectedUser) {
    if (profileMode == ProfileMode.MYSELF) {
      profileUser = currentUser;
    } else {
      profileUser = selectedUser;
    }
  }

  //投稿を取ってくる
  Future<void> getPost() async {
    isProcessing = true;
    notifyListeners();
    posts = await postRepository.getPosts(FeedMode.FROM_PROFILE, profileUser);
    isProcessing = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await userRepository.singOut();
    notifyListeners();
  }

  //投稿数
  Future<int> getNumberOfPost() async {
    return (await postRepository.getPosts(FeedMode.FROM_PROFILE, profileUser))
        .length;
  }

  //フォロワーの数
  Future<int> getNumberOfFollowers() async {
    //intで返ってくるので.lengthいらない
    return await userRepository.getNumberOfFollowers(profileUser);
  }

  Future<int> getNumberOfFollowings() async {
    return await userRepository.getNumberOfFollowings(profileUser);
  }

  //プロフィール編集画面のphotoUrl取ってくる
  Future<String> pickProfileImage() async {
    return (await postRepository.pickImage(UploadType.GALLERY)).path;
  }

  Future<void> updateProfile(String nameUpdated, String bioUpdated,
      String photoUrlUpdated, bool isImageFromFile) async {
    isProcessing = true;
    notifyListeners();
    await userRepository.updateProfile(
      profileUser,
      nameUpdated,
      bioUpdated,
      photoUrlUpdated,
      isImageFromFile,
    );
    //更新後にユーザーデータを再取得してstaticに保存(currentUserを更新する)
    await userRepository.getCurrentUserById(profileUser.userId);
    profileUser = currentUser;
    isProcessing = false;
    notifyListeners();
  }
}
