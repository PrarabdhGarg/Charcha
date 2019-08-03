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

class Author {
  String name;
  String username;
  String avatar;

  Author({
    this.name,
    this.username,
    this.avatar
  });

  factory Author.fromJSON(Map<String, dynamic> json) => new Author(
    name: json["name"],
    username: json["username"],
    avatar: json["avatarURL"]
  );

  Map<String, dynamic> toJSON() => {
    "nsme":name,
    "usernsme": username,
    "avatarURL": avatar
  };
}

class Post {
  String id;
  String title;
  String caption;
  int likes;
  List<dynamic> tags;
  List<dynamic> hashTags;
  String creationTime;
  String contentURL;
  Author author;

  Post({
    this.author,
    this.caption,
    this.title,
    this.id,
    this.contentURL,
    this.creationTime,
    this.hashTags,
    this.likes,
    this.tags
  });

  factory Post.fromJSON(Map<String, dynamic> json) => new Post(
    id: json["_id"],
    title: json["title"],
    caption: json["caption"],
    contentURL: json["contentURL"],
    creationTime: json["creationTime"],
    likes: json["num_likes"],
    tags: new List<dynamic>.from(json["tags"].map((x) => x)),
    hashTags: new List<dynamic>.from(json["hashTags"].map((x) => x)),
    author: new Author.fromJSON(json["author"])
  );

  //The to JSON method is missing as I will never upload a json like this
}

class Posts {
  List<Post> posts;

  Posts({
    this.posts
  });

  factory Posts.fromJSON(List<dynamic> json) => new Posts(
    posts: json.map((postJSON) => Post.fromJSON(postJSON)).toList()
  );
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