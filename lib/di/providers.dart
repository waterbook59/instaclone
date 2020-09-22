
import 'package:flutter/material.dart';
import 'package:instaclone/models/db/database_manager.dart';
import 'package:instaclone/models/location/location_manager.dart';
import 'package:instaclone/models/repositories/post_repository.dart';
import 'package:instaclone/models/repositories/user_repository.dart';
import 'package:instaclone/view_models/comments_view_model.dart';
import 'package:instaclone/view_models/feed_view_model.dart';
import 'package:instaclone/view_models/login_view_model.dart';
import 'package:instaclone/view_models/post_view_model.dart';
import 'package:instaclone/view_models/profile_view_model.dart';
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
  ),
  Provider<LocationManager>(
    create: (_)=>LocationManager(),
  ),

];

List<SingleChildWidget> dependentModels =[
  ProxyProvider<DatabaseManager,UserRepository>(
    update: (context,dbManager,userRepo) =>UserRepository(dbManager: dbManager),
  ),
  ProxyProvider2<DatabaseManager,LocationManager,PostRepository>(
    update: (_,dbManager,locationManager,postRepo)=>PostRepository(
        dbManager: dbManager,locationManager: locationManager),
  )
];

List<SingleChildWidget> viewModels =[
  ChangeNotifierProvider<LoginViewModel>(
    create: (context)=>LoginViewModel(
      userRepository: Provider.of<UserRepository>(context,listen:false),
    ),
  ),
  ChangeNotifierProvider<PostViewModel>(
    create: (context)=>PostViewModel(
      userRepository: Provider.of<UserRepository>(context,listen:false),
      postRepository: Provider.of<PostRepository>(context,listen:false),
    ),
  ),
  ChangeNotifierProvider<FeedViewModel>(
    create: (context)=>FeedViewModel(
      userRepository:Provider.of<UserRepository>(context,listen:false),
      postRepository: Provider.of<PostRepository>(context,listen:false),
    ),
  ),
  ChangeNotifierProvider<CommentsViewModel>(
    create: (context)=>CommentsViewModel(
      userRepository:Provider.of<UserRepository>(context,listen:false),
      postRepository: Provider.of<PostRepository>(context,listen:false),
    ),
  ),
  ChangeNotifierProvider<ProfileViewModel>(
    create: (context)=>ProfileViewModel(
      userRepository:Provider.of<UserRepository>(context,listen:false),
      postRepository: Provider.of<PostRepository>(context,listen:false),
    ),
  ),
];