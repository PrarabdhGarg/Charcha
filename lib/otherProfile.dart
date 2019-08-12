import 'dart:convert';
import 'dart:io';

import 'package:charcha/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charcha/config.dart';

import 'dataClasses.dart';

class otherProfile extends StatefulWidget {
  String id;
  otherProfile(this.id);

  @override
  _otherProfileState createState() => _otherProfileState(id);
}

class _otherProfileState extends State<otherProfile> {
  String id;
  User user = null;

  _otherProfileState(this.id);

  @override
  void initState() {
    fetchOtherUser(this.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: user == null ? Center(
        child: CircularProgressIndicator(),
      ) : profile(user) ,
    );
  }

  Future<Null> fetchOtherUser(String id) async {
    final response = await http.get(config.baseUrl+"/users/view_profile/$id", headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt},);
    print("Response = ${response.body.toString()}");
    if(response.statusCode == 200){
      User user = User.fromJson(json.decode(response.body));
      setState(() {
        this.user = user;
      });
    }else{
      print("Error occoured in fetching user profile");
      throw Exception('Failed to load post');
    }
  }
}
