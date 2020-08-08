import 'package:flutter/material.dart';

class User {

  final String userId;
  final String displayName;//Firebaseに登録したuser情報に紐づいているユーザー名(今回はGoogle有効にしたのでgoogleアカウントのユーザー名)
  final String inAppUserName;//このアプリの中で編集できるユーザー名(はじめはdisplayNameと同じ)
  final String photoUrl;
  final String email;
  final String bio;//プロフィール詳細

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const User({
    @required this.userId,
    @required this.displayName,
    @required this.inAppUserName,
    @required this.photoUrl,
    @required this.email,
    @required this.bio,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          displayName == other.displayName &&
          inAppUserName == other.inAppUserName &&
          photoUrl == other.photoUrl &&
          email == other.email &&
          bio == other.bio);

  @override
  int get hashCode =>
      userId.hashCode ^
      displayName.hashCode ^
      inAppUserName.hashCode ^
      photoUrl.hashCode ^
      email.hashCode ^
      bio.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' userId: $userId,' +
        ' displayName: $displayName,' +
        ' inAppUserName: $inAppUserName,' +
        ' photoUrl: $photoUrl,' +
        ' email: $email,' +
        ' bio: $bio,' +
        '}';
  }

  User copyWith({
    String userId,
    String displayName,
    String inAppUserName,
    String photoUrl,
    String email,
    String bio,
  }) {
    return new User(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      inAppUserName: inAppUserName ?? this.inAppUserName,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'displayName': this.displayName,
      'inAppUserName': this.inAppUserName,
      'photoUrl': this.photoUrl,
      'email': this.email,
      'bio': this.bio,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return new User(
      userId: map['userId'] as String,
      displayName: map['displayName'] as String,
      inAppUserName: map['inAppUserName'] as String,
      photoUrl: map['photoUrl'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String,
    );
  }

//</editor-fold>
}