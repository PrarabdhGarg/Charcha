import 'package:charcha/feed.dart';
import 'package:flutter/material.dart';

import 'dataClasses.dart';

class Genre extends StatefulWidget {
  @override
  _Genre createState() => _Genre();
}

class _Genre extends State<Genre> {
  String selectedGenre = null;
  List<feedModel> feedList = [new feedModel() , new feedModel() , new feedModel(), new feedModel(),  new feedModel()];
  List<String> genreList = ["Politics" , "Sports" , "Science" , "Technlogy" , "Terrorism" , "Religion" , "Astrnomy"];

  @override
  Widget build(BuildContext context) {
    if(selectedGenre == null) {
      return genreListView();
    }
    return ListView.builder(
      itemCount: feedList.length,
      itemBuilder: (BuildContext context , int i) {
        return getFeedWidget(feedList[i]);
      }
    );
  }

  Widget genreListView() {
    return GridView.count(
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      children: genreList.map((data) =>
          RaisedButton(
            onPressed:(){
              setState(() {
                selectedGenre = data;
              });
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                      image: AssetImage('images/profile.png')
                  ),
                  flex: 1,
                ),
                Center(
                  child: Text(data),
                )
              ],
            ),
          )
      ).toList(),
    );
  }

}