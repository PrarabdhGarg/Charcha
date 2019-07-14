import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dataClasses.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  Future<User> currentUser;
  String baseUrl = "https://dush-t-pprvoice.herokuapp.com";
  String authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDJhY2JlODc2NTA3MzAwMTc5MGNiZjAiLCJpYXQiOjE1NjMwOTc2NTR9.6U5FIArEk-M_356plCGqNsax_vAx0Mru9PGpm-8H4OI";

  @override
  void initState() {
    super.initState();
    currentUser = fetchUserData();
  }

  final _TabPages = <Widget> [
    Center(child: Text("My Activities")),
    Center(child: Text("Some other feature")),
  ];

  final _Tabs = <Tab>[
    Tab(text: "My Activites",),
    Tab(text: "Tab 2",)
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: currentUser,
      builder: (context , snapshot){
        if(snapshot.hasData){
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('images/profile.png')
                          )
                      )
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text(snapshot.data.name),
                        alignment: Alignment.center,
                      ),
                      Container(
                        child: Text("Other Information about the user"),
                      )
                    ],
                  )
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              Flexible(
                child: DefaultTabController(
                  length: _Tabs.length,
                  child: Scaffold(
                    appBar: AppBar(
                      leading: Container(),
                      title: Text(
                        "Some Text here" ,
                        textAlign: TextAlign.center,
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
        }else if(snapshot.hasError){
          return Center(
            child: Text("An Error Occoured ${snapshot.error}"),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Future<User> fetchUserData() async {
    final response = await http.get(baseUrl+"/users/me", headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"},);
    print("Response = ${response.body.toString()}");
    if(response.statusCode == 200){
      return User.fromJson(json.decode(response.body));
    }else{
      print("Error occoured in fetching user profile");
      throw Exception('Failed to load post');
    }
  }
}