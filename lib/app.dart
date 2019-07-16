import 'package:charcha/mainScreen.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'home.dart';
import 'login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoogleSignIn',
      debugShowCheckedModeBanner: true,
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUp()
      },
    );
  }
}
