import 'dart:convert';
import 'dart:io';

import 'package:charcha/dataClasses.dart';
import 'package:charcha/feed.dart';
import 'package:charcha/profile.dart';
import 'package:charcha/Genre.dart';
import 'package:flutter/material.dart';
import 'package:charcha/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ProfileSearchResults.dart';
import 'customAudioRecorder.dart';
import 'otherProfile.dart';

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _currentIndex = 1;
  User currentUser;
  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey();
  bool activeSearch = false;
  TextEditingController searchedProfile = new TextEditingController();
  bool searchedResult = false;

  @override
  void initState() {
    super.initState();
    if(config.userProfile == null)
      fetchUserData();
    else
      currentUser = config.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    final _TabPages = <Widget> [
      profile(currentUser),
      FeedListWidget(isTrending: false,),
      trendingFeed(),
      Genre(selectMultiple: false,),
    ];
    final _BottomNavBarItems = <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.perm_identity , color: Colors.grey,),
        title: Text("Profile"),
        activeIcon: Icon(Icons.perm_identity , color: Color(0xFFFF6969),)
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.comment , color: Colors.grey,),
        title: Text("Feed"),
        activeIcon: Icon(Icons.comment , color: Color(0xFFFF6969),)
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.trending_up, color: Colors.grey,),
        title: Text("Trending"),
        activeIcon: Icon(Icons.trending_up , color: Color(0xFFFF6969),)
      ),
    BottomNavigationBarItem(
        icon: Icon(Icons.category , color: Colors.grey,),
        title: Text("Genre"),
        activeIcon: Icon(Icons.category , color: Color(0xFFFF6969),)
      ),
    ];
    assert(_TabPages.length == _BottomNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: _BottomNavBarItems,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      backgroundColor: Colors.white,
    );

    return Scaffold(
      key: _scaffoldState,
      appBar: getAppBar(activeSearch),
      body: searchedResult ? searchProfile(searchedProfile.text) : _TabPages[_currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }

  Future<Null> logoutUser() async {
    if(config.jwt != ""){
      http.post(config.baseUrl+"/users/logout" , headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt}).then((http.Response response){
        print(response.statusCode.toString()+"\n"+response.body);
        if(response.statusCode == 200) {
          config.jwt = "";
          config.userProfile = null;
          deleteJWT();
          // Todo : Handle navigation properly
          Navigator.popAndPushNamed(context, "/login");
        }
      });
    }
  }

  Future<Null> deleteJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("JWT", " ");
  }

  Future<Null> fetchUserData() async {
    print("Entered Profile request");
    final response = await http.get(config.baseUrl+"/users/me", headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt},);
    print("Profile Response = ${response.body.toString()}");
    if(response.statusCode == 200){
      config.userProfile = User.fromJson(json.decode(response.body));
      setState(() {
        this.currentUser = config.userProfile;
      });
    }else{
      print("Error occoured in fetching user profile");
      throw Exception('Failed to load post');
    }
  }

  AppBar getAppBar(bool isSearchEnabled) {
    return isSearchEnabled ?  AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => setState(() => this.activeSearch = false),),
      title: TextField(
        controller: searchedProfile,
        decoration: InputDecoration(
          hintText: "Search Profile",
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              this.activeSearch = false;
            });
            searchProfile(searchedProfile.text);
          },
        )
      ],
    ) : AppBar(
      backgroundColor: Colors.white,
      // There is an empty container passed as I don't want the default back button that appears on the app bar
      leading: Container(),
      title: Text(
        'Charcha',
        style: TextStyle(
            color: Colors.black,
            fontSize: 24
        ),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search, color: Color(0xFFFF6969)),
          onPressed: () => setState(() => this.activeSearch = true),
        ),
        IconButton(
            icon: Icon(Icons.add_alert , color: Color(0xFFFF6969),),
            onPressed: () {
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Notifications"),
              ));
            }
        ),
        IconButton(
            icon: Icon(Icons.add_circle , color: Color(0xFFFF6969),),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => customAudioRecorder()));
            }
        ),
        PopupMenuButton(
          child: Icon(Icons.more_vert , color: Color(0xFFFF6969),),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text('Settings'),
              ),
              PopupMenuItem(
                child: GestureDetector(child: Text('Logout'),onTap:() => logoutUser(),),
              ),
            ];
          },
        ),
        Container(
          margin: EdgeInsets.all(8),
        )
      ],
    );
  }

  Future<Null> searchProfile(String string) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSearchResults(string)));
  }

}