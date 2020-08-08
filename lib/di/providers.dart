import 'package:flutter/material.dart';
import 'package:instaclone/models/db/database_manager.dart';
import 'package:instaclone/models/repositories/user_repository.dart';
import 'package:instaclone/view_models/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

List<SingleChildWidget> independentModels =[
  Provider<DatabaseManager>(
    create: (_)=>DatabaseManager(),
  )
];

List<SingleChildWidget> dependentModels =[
  ProxyProvider<DatabaseManager,UserRepository>(
    update: (context,dbManager,userRepo) =>UserRepository(dbManager: dbManager),
  )
];

List<SingleChildWidget> viewModels =[
  ChangeNotifierProvider<LoginViewModel>(
    create: (context)=>LoginViewModel(
      userRepository: Provider.of<UserRepository>(context,listen:false),
    ),
  )
];