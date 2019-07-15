import 'package:charcha/dataClasses.dart';
import 'package:charcha/feed.dart';
import 'package:charcha/profile.dart';
import 'package:charcha/Genre.dart';
import 'package:flutter/material.dart';

import 'customAudioRecorder.dart';

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _currentIndex = 1;
  List<feedModel> feedList = [feedModel() , feedModel() , feedModel() , feedModel() , feedModel()];
  GlobalKey<customAudioRecorderState> _keyRecorder = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final _TabPages = <Widget> [
      profile(),
      getFeedListWidget(feedList, context),
      getFeedListWidget(feedList, context),
      Genre(),
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
      appBar: AppBar(
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
              icon: Icon(Icons.add_alert , color: Color(0xFFFF6969),),
              onPressed: () {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Notifications"),
                ));
              }
          ),
          customAudioRecorder(),
          PopupMenuButton(
           child: Icon(Icons.more_vert , color: Color(0xFFFF6969),),
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
          ),
          Container(
            margin: EdgeInsets.all(8),
          )
        ],
      ),
      body: _TabPages[_currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
