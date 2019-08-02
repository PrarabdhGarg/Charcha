import 'package:charcha/mainScreen.dart';
import 'package:flutter/material.dart';
import 'state.dart';
import 'package:charcha/config.dart';
import 'state_widget.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StateModel appState;

  Widget _buildStories({Widget body}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Home Screen'),
      ),
      body: Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.all(20.0),
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(appState.user.photoUrl.toString()),
                      ),
                    )),

                new Text(
                  'Hello, ' '${appState.user.displayName}' '!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildContent() {
    print("JWT = " + config.jwt);
    if(config.jwt != "") {
      print("First Condioton");
      return mainScreen();
    }
    if (appState.isLoading) {
      print("Second Condition");
      return _buildLoadingIndicator();
    } else if (!appState.isLoading && (appState.user == null && config.jwt == "")) {
      print("Third Condition");
      return new LoginScreen();
    } else {
      print("Fourth Condition");
      return mainScreen();
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}