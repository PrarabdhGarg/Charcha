import 'dart:math';

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
              child: FlatButton(
                padding: EdgeInsets.all(64),
                onPressed: () => StateWidget.of(context).signInWithGoogle(),
                child: Image(
                  image: AssetImage('images/googleLoginButton.jpg')
                )
              ),
            ),
          )
        ],
      )
    );
}}