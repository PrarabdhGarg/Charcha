import 'dart:convert';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:charcha/dataClasses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charcha/config.dart';
import 'audioControl.dart';
import 'otherProfile.dart';

class FeedListWidget extends StatefulWidget {

  bool isTrending = false;

  FeedListWidget({this.isTrending});

  @override
  _FeedListWidgetState createState() => _FeedListWidgetState(isTrending: this.isTrending);
}

class _FeedListWidgetState extends State<FeedListWidget> {
  AudioPlayer audioPlayer;
  Posts newsFeed = null;
  String currentSong = "";
  audioPlayerState songState;
  bool isTrending;

  _FeedListWidgetState({this.isTrending});

  @override
  void initState() {
   super.initState();
   getNewsFeed();
   audioPlayer = new AudioPlayer();
   songState = audioPlayerState.None;
  }

  @override
  void dispose() {
    audioPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getFeedListWidget(newsFeed, this.context);
  }

  Future<Null> getNewsFeed() async {
    var appendUrl = "";
    if(isTrending){
      print("Entered Trending");
      appendUrl = "/trending?skip=0&limit=20";
    }
    else {
      print("Entered Normal");
      appendUrl = "/newsfeed?skip=0&limit=20";
    }
    final response = await http.get(config.baseUrl+appendUrl, headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt},);
    print("Response = ${response.body.toString()}");
    if(response.statusCode == 200) {
      setState(() {
        print("Entered Set State");
        // this.newsFeed = Posts(posts: [Post.fromJSON(json.decode(response.body))]);
        this.newsFeed = Posts.fromJSON(json.decode(response.body));
      });
    }else {
      print("Error occoured while fetching newsFeed");
    }
  }

  Widget getFeedListWidget(Posts items , BuildContext context) {
    return Container(
      color: Colors.grey,
      child: newsFeed != null ? ListView.builder(
          itemCount: items.posts.length,
          itemBuilder: (BuildContext context , int i) {
            return GestureDetector(
              onTap: () {
                updateBottomSheet(context);
                play((config.baseUrl+items.posts[i].contentURL) , context);
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
                          child: GestureDetector(
                            onTap: () {
                              openProfile(items.posts[i].author.id);
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.all(16),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(config.baseUrl+items.posts[i].author.avatar)),
                              ),
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
                                  child: Text(items.posts[i].title, style: TextStyle(fontWeight: FontWeight.w900),),
                                ),
                                VerticalDivider(),
                                Flexible(
                                  flex: 1,
                                  child: Text(items.posts[i].author.username, style: TextStyle(color: Colors.lightBlue, fontSize: 12),),
                                )
                              ],
                            ),
                            Container(height: 8,),
                            Text(items.posts[i].caption, overflow: TextOverflow.ellipsis, maxLines: 3,),
                            Container(height: 8,),
                            // audioControl(items[i].url),
                            GestureDetector(
                              onTap: () {
                                print("Row Touched");
                              },
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          print("Like Button Touched");
                                          likePost(newsFeed.posts[i].id, i);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                                flex: 1,
                                                child: Icon(Icons.thumbs_up_down , color: Color(0xFFFF6969),)
                                            ),
                                            Container(width: 4,),
                                            Flexible(
                                              flex: 1,
                                              child: Text(items.posts[i].likes.toString() , style: TextStyle(color: Colors.grey),),
                                            )
                                          ],
                                        ),
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
      ) : Center(
        child: CircularProgressIndicator(),
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

  Future<void> likePost(String id, int position) async {
    print("Entered like function with"+config.baseUrl+"/voice_posts/${id}/like_unlike");
    var request = http.post(config.baseUrl+"/voice_posts/${id}/like_unlike", headers: {HttpHeaders.authorizationHeader: "Bearer " + config.jwt},).then((http.Response response) {
      if(response.statusCode == 200){
        print("Like Successful");
        setState(() {
          newsFeed.posts[position].likes += 1;
        });
      }else{
        print("Response error = ${response.statusCode}");
        print("Response Body = ${response.body}");
      }
    });
  }

  Future<void> openProfile(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => otherProfile(id)));
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

class trendingFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeedListWidget(isTrending: true,);
  }
}


