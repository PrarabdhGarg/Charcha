import 'package:charcha/feed.dart';
import 'package:flutter/material.dart';

import 'dataClasses.dart';

class Genre extends StatefulWidget {
  bool selectMultiple;

  Genre({this.selectMultiple});
  @override
  _Genre createState() => _Genre(this.selectMultiple, key);
}

class _Genre extends State<Genre> {
  bool selectMultiple;
  bool buttonEnabled;
  GlobalKey<ScaffoldState> key;
  List<String> selectedGenre = [];
  List<feedModel> feedList = [new feedModel() , new feedModel() , new feedModel(), new feedModel(),  new feedModel()];
  List<String> genreList = ["Politics" , "Sports" , "Science" , "Technlogy" , "Terrorism" , "Religion" , "Astrnomy"];

  _Genre(this.selectMultiple, this.key);

  @override
  Widget build(BuildContext context) {
    if(selectMultiple == false && selectedGenre.isEmpty) {
      return genreListView();
    } else if(selectMultiple == true){
      if(selectedGenre.isEmpty)
        buttonEnabled = false;
      else
        buttonEnabled = true;
      return multipleGenreListView();
    }
    return FeedListWidget();
  }

  Widget genreListView() {
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      children: genreList.map((data) =>
          getGenreCard(data)
      ).toList(),
    );
  }

  Widget getGenreCard(String data) {
    if(selectedGenre.isNotEmpty && selectedGenre.contains(data)) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(4),
            child: RaisedButton(
              onPressed:(){
                setState(() {
                  if(selectedGenre.contains(data))
                    selectedGenre.remove(data);
                  else
                  selectedGenre.add(data);
                });
              },
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Image(
                        image: AssetImage('images/profile.png')
                    ),
                    flex: 1,
                  ),
                  Center(
                    child: Text(data , style: TextStyle(color: Color(0xFFFF6969)),),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            width: 30.0,
            height: 30.0,
            child: Container(
                child: Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/check.png'),
                      )
                  ),
                )
            ),
          ),
        ],
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFFF6969),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(5,5)
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        margin: EdgeInsets.all(16),
        child: RaisedButton(
          onPressed:(){
            setState(() {
              selectedGenre.add(data);
            });
          },
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Image(
                    image: AssetImage('images/profile.png')
                ),
                flex: 1,
              ),
              Center(
                child: Text(data , style: TextStyle(color: Color(0xFFFF6969)),),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget multipleGenreListView() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Prefered Genre"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: genreListView(),
          ),
          Container(
            child: RaisedButton(
              color: Colors.lightGreenAccent[400],
              disabledColor: Colors.grey[400],
              onPressed: buttonEnabled ? (){
                Navigator.popUntil(context, ModalRoute.withName("/"));
                Navigator.pushNamed(context, "/main");
              } : null,
              child: Text("Continue")
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

}