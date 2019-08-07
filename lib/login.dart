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
      body: SingleChildScrollView(
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
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                          Navigator.pushNamed(context, "/main");
                        },
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
                        child: Text("Sign In"),
                        color: Color(0xFFFF6969),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.all(16),
                                child: Divider(
                                  height: 5,
                                  color: Colors.black,
                                ),
                            )
                        ),
                        Text("OR"),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Divider(
                              height: 5,
                              color: Colors.black,
                            ),
                          )
                        )
                      ],
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
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Container(),
                              ),
                              Flexible(
                                flex:2,
                                fit: FlexFit.tight,
                                child: Text(
                                  "Don't have an account?",
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Container(width: 4,),
                              Flexible(
                                flex:2,
                                fit: FlexFit.tight,
                                child: GestureDetector(
                                  onTap: (){
                                    print("Entrers Gesture detector");
                                    Navigator.of(context).popAndPushNamed("/signUp");
                                  },
                                  child: Text(
                                    "SignUp" ,
                                    style: TextStyle(color: Colors.lightBlue[400]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}