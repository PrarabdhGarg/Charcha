import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'dataClasses.dart';

class audioControl extends StatefulWidget {
  String url;

  audioControl(this.url);
  @override
  _audioControlState createState() => _audioControlState(url);
}

class _audioControlState extends State<audioControl> {
  audioPlayerState playerState = audioPlayerState.Stopped;
  String url;
  AudioPlayer audioPlayer = new AudioPlayer();

  _audioControlState(this.url);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: FlatButton(
            onPressed: (){
              play();
            },
            child: Icon(Icons.fast_rewind , color: Colors.white,),
            color: Colors.teal,
          ),
        ),
        play_pause_button(),
        Flexible(
          flex: 1,
          child: FlatButton(
              onPressed: (){
                pause();
              },
              child: Icon(Icons.fast_forward , color: Colors.white,),
              color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget play_pause_button(){
    if(playerState == audioPlayerState.Playing){
      return FlatButton(
        child: Icon(Icons.pause , color: Colors.white,),
        color: Colors.teal,
        onPressed: (){
          pause();
        },
      );
    }else{
      return FlatButton(
        child: Icon(Icons.play_arrow , color: Colors.white,),
        color: Colors.teal,
        onPressed: (){
          play();
        },
      );
    }
  }

  Future<void> play() async {
    await audioPlayer.play(url);
    setState(() {
      playerState = audioPlayerState.Playing;
    });
  }

    Future<void> pause() async {
      await audioPlayer.pause();
      setState(() {
        playerState = audioPlayerState.Stopped;
      });
    }
}
