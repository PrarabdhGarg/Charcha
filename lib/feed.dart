import 'package:charcha/dataClasses.dart';
import 'package:flutter/material.dart';

Widget getFeedWidget(feedModel item) {
  return Row(
    children: <Widget>[
      Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.all(16),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage('images/profile.png')),
        ),
      ),
      Flexible(
        flex: 3,
        fit: FlexFit.tight,
        child: Column(
          children: <Widget>[
            Center(
              child: Text(item.title),
            ),
            Center(
              child: Text(item.description),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      child: RawMaterialButton(
                        child: Text("Like"),
                        fillColor: Colors.cyan,
                        onPressed: null,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      margin: EdgeInsets.all(5.0),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: RawMaterialButton(
                        child: Text("Comment"),
                        fillColor: Colors.cyan,
                        onPressed: null,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      margin: EdgeInsets.all(5.0),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: RawMaterialButton(
                        child: Text("Share"),
                        onPressed: null,
                        fillColor: Colors.cyan,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      margin: EdgeInsets.all(5.0),
                    )
                ),
              ],
            )
          ],
        )
      )
    ],
  );
}
