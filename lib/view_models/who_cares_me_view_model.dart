import 'package:flutter/material.dart';
import 'package:instaclone/data_models/user.dart';
import 'package:instaclone/models/repositories/user_repository.dart';
import 'package:instaclone/utils/constants.dart';

class WhoCaresMeViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  WhoCaresMeViewModel ({this.userRepository});


  List<User> caresMeUsers =<User>[];

  Future<void> getCaresMeUsers(String id, WhoCaresMeMode mode) async{
    caresMeUsers = await userRepository.getCaresMeUsers(id,mode);
    print('who cares me: $caresMeUsers');
    notifyListeners();

  }




}