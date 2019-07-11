import 'package:charcha/dataClasses.dart';
import 'package:charcha/feed.dart';
import 'package:charcha/profile.dart';
import 'package:charcha/Genre.dart';
import 'package:flutter/material.dart';

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _currentIndex = 1;
  List<feedModel> feedList = [feedModel() , feedModel() , feedModel() , feedModel() , feedModel()];

  @override
  Widget build(BuildContext context) {
    final _TabPages = <Widget> [
      profile(),
      ListView.builder(
        itemCount: feedList.length,
        itemBuilder: (BuildContext context , int i) {
          return getFeedWidget(feedList[i]);
        },
      ),
      ListView.builder(
        itemCount: feedList.length,
        itemBuilder: (BuildContext context , int i) {
          return getFeedWidget(feedList[i]);
        }
      ),
      Genre(),
    ];
    final _BottomNavBarItems = <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.perm_identity , color: Colors.white,),
        title: Text("Profile"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.comment , color: Colors.white,),
        title: Text("Feed"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.trending_up),
        title: Text("Trending")
      ),
    BottomNavigationBarItem(
        icon: Icon(Icons.category , color: Colors.white,),
        title: Text("Genre")
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
      backgroundColor: Colors.redAccent,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        // There is an empty container passed as I don't want the default back button that appears on the app bar
        leading: Container(),
        title: Text(
          'Charcha',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_alert , color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Notifications"),
                ));
              }
          ),
          IconButton(
            icon: Icon(Icons.mic , color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Add Content"),
                ));
              }
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Settings'),
                ),
                PopupMenuItem(
                  child: Text('More'),
                ),
              ];
            },
          )
        ],
      ),
      body: _TabPages[_currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
