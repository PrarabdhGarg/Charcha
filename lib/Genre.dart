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
    return getFeedListWidget(feedList, this.context);
  }

  Widget genreListView() {
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      children: genreList.map((data) =>
          Container(
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
                  selectedGenre = data;
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
          )
      ).toList(),
    );
  }

}