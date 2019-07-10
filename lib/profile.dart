import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {

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
                    child: Text("Prarabdh Garg"),
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
  }
}