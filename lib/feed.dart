import 'package:audioplayer/audioplayer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:charcha/dataClasses.dart';
import 'package:flutter/material.dart';

import 'audioControl.dart';

Widget getFeedListWidget(List<feedModel> items , BuildContext context) {
  return Container(
    color: Colors.grey,
    child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context , int i) {
        return Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(8),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.all(16),
                    decoration: new BoxDecoration(shape: BoxShape.circle,color: Colors.white)
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.all(16),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage('images/nature.jpg')),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(items[i].title, style: TextStyle(fontWeight: FontWeight.w900),),
                        ),
                        VerticalDivider(),
                        Flexible(
                          flex: 1,
                          child: Text(items[i].userName, style: TextStyle(color: Colors.lightBlue, fontSize: 12),),
                        )
                      ],
                    ),
                    Container(height: 8,),
                    Center(
                      child: Text(items[i].description, overflow: TextOverflow.ellipsis, maxLines: 3,),
                    ),
                    Container(height: 8,),
                    // audioControl(items[i].url),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Icon(Icons.thumbs_up_down , color: Color(0xFFFF6969),)
                              ),
                              Container(width: 4,),
                              Flexible(
                                flex: 1,
                                child: Text("01" , style: TextStyle(color: Colors.grey),),
                              )
                            ],
                          ) 
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                    flex: 1,
                                    child: Icon(Icons.add_comment , color: Color(0xFFFF6969),)
                                ),
                                Container(width: 4,),
                                Flexible(
                                  flex: 1,
                                  child: Text("01" , style: TextStyle(color: Colors.grey),),
                                )
                              ],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                    flex: 1,
                                    child: Icon(Icons.forward , color: Color(0xFFFF6969),)
                                ),
                                Container(width: 4,),
                                Flexible(
                                  flex: 1,
                                  child: Text("01" , style: TextStyle(color: Colors.grey),),
                                )
                              ],
                            )
                        ),
                      ],
                    )
                  ],
                )
              )
            ],
          ),
        );
      }
    ),
  );
}
