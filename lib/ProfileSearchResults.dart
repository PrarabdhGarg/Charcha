
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charcha/config.dart';

import 'dataClasses.dart';
import 'otherProfile.dart';

class ProfileSearchResults extends StatefulWidget {

  String searchedProfile;

  ProfileSearchResults(this.searchedProfile);

  @override
  _ProfileSearchResultsState createState() => _ProfileSearchResultsState();
}

class _ProfileSearchResultsState extends State<ProfileSearchResults> {

  bool isLoading = true;
  Profiles searchedProfiles;

  @override
  void initState() {
    searchProfile(widget.searchedProfile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : searchList(),
    );
  }

  Widget searchList() {
    if(this.searchedProfiles.profiles.length == 0){
      return Center(
        child: Container(
          child: Text("No Results Found"),
        ),
      );
    }else {
      return Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: this.searchedProfiles.profiles.length,
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  onTap: () {
                    openProfile(this.searchedProfiles.profiles[i].id);
                  },
                  child: Container(
                    width: (MediaQuery.of(this.context).size.width),
                    height: (MediaQuery.of(this.context).size.height * 0.15),
                    margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    color: Colors.grey,
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: Text(this.searchedProfiles.profiles[i].name),
                            padding: EdgeInsets.all(8.0),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: Text("@${this.searchedProfiles.profiles[i].username}"),
                            padding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        ),
      );
    }
  }

  Future<Null> searchProfile(String searchedProfile) async {
    print("Entered keyword = $searchedProfile");
    final response = await http.get(config.baseUrl+"/users/search?searchString=$searchedProfile", headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt});
    if(response.statusCode == 200){
      print("Entered Response Code 200");
      print("Body = ${response.body}");
      this.searchedProfiles = Profiles.fromJSON(json.decode(response.body));
      setState(() {
        this.isLoading = false;
      });
    }else{
      print("Error while searching users ${response.statusCode}");
    }
  }

  Future<void> openProfile(String id) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => otherProfile(id)));
  }
}
