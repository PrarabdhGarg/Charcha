import 'dart:math';
import 'package:charcha/config.dart';
import 'package:charcha/mainScreen.dart';
import 'package:charcha/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'state_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = new TextEditingController(text: "un2");
  final passwordController = new TextEditingController(text: "lolmao12345");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Google Login'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, -5),
                  child: Container(
                    // color: Colors.deepPurple,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: AssetImage('images/login.png')
                        )
                    ),
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
            )
          ),
          Flexible(
            flex: 5,
            child: Center(
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                        child: TextField(
                          controller: userNameController,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: "username"
                          ),
                        ),
                      ),
                    ),
              Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: "password"
                      ),
                    ),
                  )
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: FlatButton(
                    onPressed: () {
                      StateWidget.of(context).manualSignIn(userNameController.text, passwordController.text);
                    },
                    child: Text("Sign In")
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FlatButton(
                    onPressed: () => StateWidget.of(context).signInWithGoogle(),
                    child: Image(
                        image: AssetImage('images/googleLoginButton.jpg')
                    )
                ),
              ),],
              ),
            ),
          )
        ],
      )
    );
}}


/*
Center(
child: Column(
children: <Widget>[


)
],
)
)*/
