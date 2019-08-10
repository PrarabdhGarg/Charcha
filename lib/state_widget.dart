import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:charcha/config.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dataClasses.dart';
import 'state.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
    as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount = null;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<Null> manualSignIn(String username , String password) async {
    setState(() {
      state.isLoading = true;
    });
    http.post(config.baseUrl+"/users/login", body: json.encode({"username": username,"password": password}), headers: {"Content-Type": "application/json"}).then((http.Response response){
      if(response.statusCode == 200)
        {
          var body = json.decode(response.body);
          config.jwt = body["token"];
          print("Token set to "+ config.jwt);
          setState(() {
            state.isLoading = false;
          });
          config.userProfile = User.fromJson(body["user"]);
        }else{
        setState(() {
          state.isLoading = false;
        });
        print("Error in signing up "+ response.body.toString() + " " + response.statusCode.toString());
        throw Exception("Error in signing in");
      }
    });
  }

  Future<Null> signInWithGoogle() async {
    print("Entered signing in with google with ${googleAccount}");
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
    await getGoogleJwt(googleAccount);
    state.user = firebaseUser; // new
    setState(() {
      state.isLoading = false;
      state.user = firebaseUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}