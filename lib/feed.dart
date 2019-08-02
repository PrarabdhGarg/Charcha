import 'package:audioplayer/audioplayer.dart';
import 'package:charcha/dataClasses.dart';
import 'package:flutter/material.dart';
import 'package:charcha/config.dart';
import 'audioControl.dart';

class FeedListWidget extends StatefulWidget {
  List<feedModel> feedItems;

  FeedListWidget(this.feedItems,);

  @override
  _FeedListWidgetState createState() => _FeedListWidgetState(feedItems);
}

class _FeedListWidgetState extends State<FeedListWidget> {
  List<feedModel> feedItems;
  AudioPlayer audioPlayer;
  String currentSong = "";
  audioPlayerState songState;

  _FeedListWidgetState(this.feedItems);

  @override
  void initState() {
   super.initState();
   audioPlayer = new AudioPlayer();
   songState = audioPlayerState.None;
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer = null;
  }

  @override
  Widget build(BuildContext context) {
    return getFeedListWidget(feedItems, this.context);
  }

  Widget getFeedListWidget(List<feedModel> items , BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context , int i) {
            return GestureDetector(
              onTap: () {
                updateBottomSheet(context);
                play(items[i].url , context);
              } ,
              child: Container(
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
                            GestureDetector(
                              onTap: () {
                                print("Row Touvhed");
                              },
                              child: Row(
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
                              ),
                            )
                          ],
                        )
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  Future<void> play(String url, BuildContext context) async {
    if(currentSong != url){
      currentSong = url;
      print("Stop Started");
      await audioPlayer.stop();
      print("Stop Finished");
      setState(() {
        songState = audioPlayerState.Stopped;
        updateBottomSheet(context);
      });
    }
    if(songState == audioPlayerState.None || songState == audioPlayerState.Stopped){
      setState(() {
        songState = audioPlayerState.Loading;
        updateBottomSheet(context);
      });
      print("Play Started");
      await audioPlayer.play(currentSong);
      print("Playing Song");
      setState(() {
        songState = audioPlayerState.Playing;
        updateBottomSheet(context);
      });
    }else {
      print("Pause Started");
      await audioPlayer.pause();
      print("Pause Finished");
      setState(() {
        songState = audioPlayerState.Stopped;
        updateBottomSheet(context);
      });
    }

  }

  void updateBottomSheet(BuildContext context) {
    Widget icon;
    if(songState == audioPlayerState.Playing)
      icon = Icon(Icons.pause);
    else if(songState == audioPlayerState.Stopped)
      icon = Icon(Icons.play_arrow);
    else
      icon = SizedBox(child: RefreshProgressIndicator(),width: 45, height: 45,);
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 60,
        width: 350,
        color: Colors.white,
        child: Center(
          child: Row(
            children: <Widget>[
              Container(
                width: 55,
                height: 55,
                padding: EdgeInsets.all(8),
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/profile.png'),
                    )
                  ),
                )
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(currentSong.substring(10)),
                )
              ),
              Flexible(
                flex: 1,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          child: Icon(Icons.fast_rewind),
                        )
                      ),
                      GestureDetector(
                        onTap: () {
                          play(currentSong, context);
                        },
                        child: icon
                      ),
                      Flexible(
                          flex: 1,
                          child: GestureDetector(
                            child: Icon(Icons.fast_forward),
                          )
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

