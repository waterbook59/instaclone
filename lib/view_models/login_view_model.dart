import 'package:flutter/material.dart';
import 'package:instaclone/models/repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier{
  final UserRepository userRepository;

  LoginViewModel({this.userRepository});


}