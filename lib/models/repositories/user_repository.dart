import 'package:instaclone/models/db/database_manager.dart';

class UserRepository{
  //databaseManagerをDI
  final DatabaseManager dbManager;
  UserRepository({this.dbManager});
}