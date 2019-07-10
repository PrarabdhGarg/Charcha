import 'package:flutter/material.dart';

class Genre extends StatefulWidget {
  @override
  _Genre createState() => _Genre();
}

class _Genre extends State<Genre> {
  String selectedGenre = null;
  List<String> genreList = ["Politics" , "Sports" , "Science" , "Technlogy" , "Terrorism" , "Religion" , "Astrnomy"];

  @override
  Widget build(BuildContext context) {
    if(selectedGenre == null) {
      return genreListView();
    }
    return genreFeedView();
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

  Widget genreFeedView() {
    
  }

}