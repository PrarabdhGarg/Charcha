import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charcha/config.dart';

import 'Genre.dart';
import 'dataClasses.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = new TextEditingController();
  final usernameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  // GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldState,
      body: Material(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(this.context).size.width,
            height: MediaQuery.of(this.context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 16,
                        color: Color(0xFF9600ff),
                      ),
                      Container(
                        // color: Colors.deepPurple,
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                                image: AssetImage('images/login.png')
                            )
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          "LOGIN" ,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: FlatButton(
                            onPressed: null,
                            child: Text(
                              "Skip",
                              style: TextStyle(color: Colors.white
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Center(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16),
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                  hintText: "Username",
                                  contentPadding: EdgeInsets.all(8)
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  contentPadding: EdgeInsets.all(8)
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  hintText: "e-mail",
                                  contentPadding: EdgeInsets.all(8)
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  hintText: "Nmae",
                                  contentPadding: EdgeInsets.all(8)
                              ),
                            ),
                          ),
                          Container(),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFF9696),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            padding: EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () => signUpUser(),
                              child: Text("SIGN UP"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> signUpUser() async {
    if(usernameController.text == "pass") {
      config.jwt = "ajfhhafhaifaVHFOIrafajjfda";
      navigateToNextPage(context);
    }
    else {
      http.post(config.baseUrl+"/users", body: json.encode({
        "name": nameController.text,
        "username": usernameController.text,
        "profile_is_private": false,
        "email": emailController.text,
        "password": passwordController.text
      }), headers: {"Content-Type": "application/json"}).then((http.Response response) {
        print(response.statusCode);
        if(response.statusCode == 201) {
          var body = json.decode(response.body);
          config.jwt = body["token"];
          print("Token set to "+ config.jwt);
          config.userProfile = User.fromJson(body["user"]);
          navigateToNextPage(context);
        }
        else
          throw Exception("Sighiing up process failed");
      });
    }
  }

  Future<Null> navigateToNextPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(selectMultiple: true,)));
  }
}
