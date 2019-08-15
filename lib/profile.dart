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
  bool isFollowing = false;
  List<Post> userPosts;
  bool fetchingPosts = true;

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
    print("Result of is own Profile ${isOwnProfile}");
  }

  @override
  Widget build(BuildContext context) {
    final _TabPages = <Widget> [
      Center(child: getPostsList()),
      Center(child: Text("My Followers\nComing Soon")),
      Center(child: Text("Following\nComing Soon"),)
    ];

    final _Tabs = <Tab>[
      Tab(child: Text(posts.toString() + "\nPost", style: TextStyle(color: Colors.black),),),
      Tab(child: Text("${followers}\nFollowers", style: TextStyle(color: Colors.black),),),
      Tab(child: Text("${following}\nFollowing",style: TextStyle(color: Colors.black),),)
    ];

    posts = profileUser.voicePosts.length;
    followers = profileUser.followers.length;
    following = profileUser.following.length;
    return user == null ? Center(child: CircularProgressIndicator(),) : Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: 125.0,
                      height: 125.0,
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
                onPressed: () {
                  toggleFollowing();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
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
                  child: isFollowing ? Text("Following" , style: TextStyle(color: Colors.white),) : Text("Follow" , style: TextStyle(color: Colors.white),),
                )
            ),
          ),
          Flexible(
            flex: 1,
            child: FlatButton(
                onPressed: null,
                child: Container(
                  padding: EdgeInsets.all(8.0),
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
                  child: Text("Button" , style: TextStyle(color: Color(0xFFFF6969)),),
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

  Widget getPostsList() {
    return fetchingPosts ? Center(child: CircularProgressIndicator(),) : userPosts.length == 0 ? Center(child: Text("You have no posts"),) : ListView.builder(
      itemCount: userPosts.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          height: 100,
          margin: EdgeInsets.all(8.0),
          color: Colors.lightGreenAccent,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(userPosts[i].title),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(userPosts[i].caption),
              )
            ],
          ),
        );
      }
    );
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
        if(profileUser.followers.contains(user.id)){
          this.isFollowing = true;
        }else{
          this.isFollowing = false;
        }
        print("New Following Status = $isFollowing");
        fetchPosts();
      });
    }else{
      print("Error occoured in fetching user profile");
      throw Exception('Failed to load post');
    }
  }

  Future<Null> fetchPosts() async {
    userPosts = new List();
    user.voicePosts.forEach((post) {
      print("Post =  ${post.toString()}");
      getPost(post.toString());
    });
  }

  Future<Null> getPost(String id) async {
    final response = await http.get(config.baseUrl+"/voice_post/get_details/${id.toString()}", headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt});
    if(response.statusCode == 200) {
      userPosts.add(Post.fromJSON(json.decode(response.body)));
      setState(() {
        this.fetchingPosts = false;
      });
    }
  }

  Future<Null> toggleFollowing() async {
    http.post(config.baseUrl+"/users/follow_unfollow/"+user.id, headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt}).then((http.Response response) {
      print("Response for follow is ${response.statusCode}");
      if(response.statusCode == 200) {
        fetchUserData();
        setState(() {
          this.isFollowing = !this.isFollowing;
        });
      }
      else{
        print("Error Occoured in following");
        print(response.body.toString());
      }
    });
  }
}