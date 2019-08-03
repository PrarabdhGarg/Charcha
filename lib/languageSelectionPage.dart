import 'package:flutter/material.dart';

import 'Genre.dart';

class languageSelectionPage extends StatefulWidget {
  @override
  _languageSelectionPageState createState() => _languageSelectionPageState();
}

class _languageSelectionPageState extends State<languageSelectionPage> {
  List<String> offeredLanguages = ["English", "Hindi", "Marathi"];
  Map<String, bool> postLanguages = {
    'English': false,
    'Hindi': false,
    'Marathi': false,
  };
  int selectedItem = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Please Select Desired Language"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Text("Please Select the app Language"),
          ),
          Container(
            height: (MediaQuery.of(context).size.height*0.4),
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: offeredLanguages.map((language) => RadioListTile<int>(
                groupValue: selectedItem,
                value: offeredLanguages.indexOf(language),
                title: Text(language),
                onChanged: (position){
                  setState(() {
                    selectedItem = position;
                  });
                })
              ).toList()
            ),
          ),
          Center(
            child: Text("Please Select the Language of articles"),
          ),
          Container(
            height: (MediaQuery.of(context).size.height*0.4),
            child: ListView(
                padding: EdgeInsets.all(8.0),
                children: postLanguages.keys.map((language) => CheckboxListTile(
                    title: Text(language),
                    value: postLanguages[language],
                    onChanged: (bool value){
                      setState(() {
                        postLanguages[language] = value;
                      });
                    })
                ).toList()
            ),
          ),
          Flexible(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                navigateToNextPage(context);
              },
              child: Text("Continue")
            ),
          )
        ],
      ),
    );
  }
  Future<Null> navigateToNextPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(selectMultiple: true,)));
  }
}
