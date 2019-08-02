import 'dart:ui';

import 'package:flutter/material.dart';

class feedModel {
  ImageProvider thumbnail = AssetImage('images/profile.png');
  String userName = "Default Name";
  String title = "Default Title";
  String description = "This is a description that can be at max 120 charecters long";
  String url = "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp4";
}

enum audioPlayerState{
  Playing,Stopped,None,Loading
}

// Dataclass for the user object that is received from the backend
class User {
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> voicePosts;
  bool profileIsPrivate;
  String id;
  String name;
  String username;
  String email;
  int v;

  User({
    this.followers,
    this.following,
    this.voicePosts,
    this.profileIsPrivate,
    this.id,
    this.name,
    this.username,
    this.email,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
    followers: new List<dynamic>.from(json["followers"].map((x) => x)),
    following: new List<dynamic>.from(json["following"].map((x) => x)),
    voicePosts: new List<dynamic>.from(json["voice_posts"].map((x) => x)),
    profileIsPrivate: json["profile_is_private"],
    id: json["_id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "followers": new List<dynamic>.from(followers.map((x) => x)),
    "following": new List<dynamic>.from(following.map((x) => x)),
    "voice_posts": new List<dynamic>.from(voicePosts.map((x) => x)),
    "profile_is_private": profileIsPrivate,
    "_id": id,
    "name": name,
    "username": username,
    "email": email,
    "__v": v,
  };

}