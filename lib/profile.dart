import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:charcha/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dataClasses.dart';

class profile extends StatefulWidget {
  User user;

  profile(this.user);

  @override
  _profileState createState() => _profileState(user);
}

class _profileState extends State<profile> {
  User profileUser;
  bool isOwnProfile;
  static int posts,followers,following;
  User user = null;

  _profileState(this.profileUser);

  @override
  void initState() {
    fetchUserData();
    super.initState();
    if(profileUser.username == config.userProfile.username){
      isOwnProfile = true;
    } else {
      isOwnProfile = false;
    }
  }

  final _TabPages = <Widget> [
    Center(child: Text("My Posts")),
    Center(child: Text("My Followers")),
    Center(child: Text("Following"),)
  ];

  final _Tabs = <Tab>[
    Tab(child: Text(posts.toString() + "\nPost", style: TextStyle(color: Colors.black),),),
    Tab(child: Text("${followers}\nFollowers", style: TextStyle(color: Colors.black),),),
    Tab(child: Text("${following}\nFollowing",style: TextStyle(color: Colors.black),),)
  ];

  @override
  Widget build(BuildContext context) {
    posts = profileUser.voicePosts.length;
    followers = profileUser.followers.length;
    following = profileUser.following.length;
    return user == null ? Center(child: CircularProgressIndicator(),) : Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: 150.0,
                      height: 150.0,
                      padding: EdgeInsets.all(16),
                      child: Container(
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('images/profile.png'),
                            )
                        ),
                      )
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            profileUser.name ,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "@${profileUser.username}",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        getButtonRow(),
                      ],
                    ),
                  )
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              Flexible(
                child: DefaultTabController(
                  length: _Tabs.length,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: Container(),
                      title: Text(
                        "Some Text here" ,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      bottom: TabBar(tabs: _Tabs),
                    ),
                    body: TabBarView(children: _TabPages),
                  ),
                ),
                fit: FlexFit.tight,
              )
            ],
          );
        }

  Widget getButtonRow() {
    if(!this.isOwnProfile) {
      return Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: FlatButton(
                onPressed: null,
                child: Container(
                  padding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 16,
                      right: 16
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.lightGreenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFFF6969),
                          spreadRadius: 1,
                          blurRadius: 2
                      ),
                    ],
                  ),
                  child: Text("Following" , style: TextStyle(color: Colors.white),),
                )
            ),
          ),
          Flexible(
            flex: 1,
            child: FlatButton(
                onPressed: null,
                child: Container(
                  padding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 16,
                      right: 16
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFFF6969),
                          spreadRadius: 1,
                          blurRadius: 2
                      ),
                    ],
                  ),
                  child: Text("Following" , style: TextStyle(color: Color(0xFFFF6969)),),
                )
            ),
          )
        ],
      );
    } else {
      return FlatButton(
        onPressed: null,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
              right: 16
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF6969),
                  spreadRadius: 1,
                  blurRadius: 2
                ),
              ]
            ),
            child: Text(
              "Edit Profile",
              style: TextStyle(
                color: Color(0xFFFF6969),
              ),
            ),
          ),
        )
      );
    }
  }

  Future<Null> fetchUserData() async {
    print("Entered Profile request");
    final response = await http.get(config.baseUrl+"/users/me", headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt},);
    print("Profile Response = ${response.body.toString()}");
    if(response.statusCode == 200){
      config.userProfile = User.fromJson(json.decode(response.body));
      print("Profile = ${config.userProfile.following.toString()}\n${config.userProfile.followers.toString()}\n${config.userProfile.voicePosts.toString()}");
      setState(() {
        this.user = config.userProfile;
      });
    }else{
      print("Error occoured in fetching user profile");
      throw Exception('Failed to load post');
    }
  }
}