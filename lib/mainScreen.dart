import 'package:charcha/profile.dart';
import 'package:flutter/material.dart';

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final _TabPages = <Widget> [
      profile(),
      Center(child: Icon(Icons.comment , color: Colors.cyan, size: 64.0)),
    ];
    final _BottomNavBarItems = <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.perm_identity , color: Colors.white,),
        title: Text("Profile"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.comment , color: Colors.white,),
        title: Text("Feed"),
      )
    ];
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
