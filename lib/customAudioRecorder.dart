import 'dart:io';
import 'package:dio/dio.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:charcha/config.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:charcha/dataClasses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class customAudioRecorder extends StatefulWidget {
  @override
  _customAudioRecorderState createState() => _customAudioRecorderState();
}

class _customAudioRecorderState extends State<customAudioRecorder> {
  Dio dio;
  AudioPlayer audioPlayer;
  customRecorderAction recorderAction;
  bool isRecording = false;
  AudioRecorder audioRecorder;
  File defaultFile;
  bool recordingCompleted = false;
  bool isPosting = false;
  Recording _recording;
  String finalPath = "/FileTest";
  int fileNumber = 100;
  TextEditingController caption = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController genreTags = new TextEditingController();

  stopRecording() async {
    var _recording = await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;
    Directory docDir = await getExternalStorageDirectory();
    print(docDir.toString());
    saveFileNumber();
    setState(() {
      this.isRecording = isRecording;
      this.recordingCompleted = true;
      this.defaultFile = File(docDir.path + finalPath);
    });
  }

  startRecording() async {
    Directory docDir = await getExternalStorageDirectory();
    print(docDir.path.toString());
    String newFilePath = docDir.path + finalPath + fileNumber.toString();
    print(newFilePath);
    File tempAudioFile = File(newFilePath);
    print(tempAudioFile);
    print("Checking if file exists");
    if (await tempAudioFile.exists()){
      print("Entered to delete file");
      await tempAudioFile.delete();
    }else{
      print("Entered Else");
    }
    await AudioRecorder.start(path: newFilePath , audioOutputFormat: AudioOutputFormat.AAC);
    bool isRec = await AudioRecorder.isRecording;
    setState(() {
      this._recording =  new Recording(duration: new Duration(), path: newFilePath);
      this.isRecording = isRec;
      defaultFile = tempAudioFile;
    });
  }

  @override
  void initState() {
    super.initState();
    recorderAction = customRecorderAction.Record;
    audioRecorder = new AudioRecorder();
    audioPlayer = new AudioPlayer();
    dio = new Dio();
    getFileNumber();
    dio.options.baseUrl = config.baseUrl;
    dio.options.followRedirects = false;
  }

  Future<Null> postRecording(String caption, String title) async {
    Directory docDir = await getExternalStorageDirectory();
    String newFilePath = docDir.path + finalPath + (fileNumber).toString() + ".m4a";
    var postUri = Uri.parse(config.baseUrl+"/voice-posts/upload");
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['title'] = title;
    request.fields['caption'] = caption;
    request.headers["Authorization"] = "Bearer "+config.jwt;
    File audioFile = File(newFilePath);
    var audio = http.ByteStream(DelegatingStream.typed(audioFile.openRead()));
    var length = await audioFile.length();
    print(length);
    print(audio.toString());
    print(request.toString());
    request.files.add(new http.MultipartFile('voicePost', audio, length, filename: basename(audioFile.path)));
    request.send().then((response){
      print(response.statusCode);
      if(response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Succesfully Posted",toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }
    });
    setState(() {
      isPosting = false;
      this.recorderAction = customRecorderAction.Record;
      closeRecorder(this.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var recorderImage;
    switch(recorderAction){
      case customRecorderAction.Record:
        recorderImage = AssetImage('images/mic.png');
        break;
      case customRecorderAction.StopRecording:
        recorderImage = AssetImage('images/stop.jpg');
        break;
      case customRecorderAction.PlayRecording:
        recorderImage = AssetImage('images/play.jpg');
        break;
      case customRecorderAction.PauseRecording:
        recorderImage = AssetImage('images/pause.jpg');
        break;
    }

    return isPosting ? Center(child: CircularProgressIndicator(),) : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
        ),
        backgroundColor: Colors.white,
        title: Center(
          child: Text("Create", style: TextStyle(color: Colors.black, fontSize: 24),),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(this.context).size.width,
            height: MediaQuery.of(this.context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height*0.35),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 3,
                        child: MaterialButton(
                          onPressed: () {
                            switch(recorderAction){
                              case customRecorderAction.Record:
                                startRecording();
                                setState(() {
                                  this.recorderAction = customRecorderAction.StopRecording;
                                });
                                break;
                              case customRecorderAction.StopRecording:
                                stopRecording();
                                setState(() {
                                  this.recorderAction = customRecorderAction.PlayRecording;
                                });
                                break;
                              case customRecorderAction.PlayRecording:
                                startPlaying();
                                setState(() {
                                  this.recorderAction = customRecorderAction.PauseRecording;
                                });
                                break;
                              case customRecorderAction.PauseRecording:
                                pauseRecordedSound();
                                setState(() {
                                  this.recorderAction = customRecorderAction.PlayRecording;
                                });
                                break;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: recorderImage ,
                                )
                              ),
                            )
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Caption",
                      contentPadding: EdgeInsets.all(16)
                    ),
                    controller: caption,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: TextField(
                    maxLength: 183,
                    decoration: InputDecoration(
                      hintText: "Description",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    controller: description,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Hash Tags",
                        contentPadding: EdgeInsets.all(16)
                    ),
                    controller: genreTags,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: RaisedButton(
                      child: new Text("Post"),
                      onPressed: () {
                        setState(() {
                          isPosting = true;
                        });
                        postRecording(caption.text, description.text);
                      },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> startPlaying() async {
    Directory docDir = await getExternalStorageDirectory();
    String newFilePath = docDir.path + finalPath + (fileNumber).toString() + ".m4a";
    await audioPlayer.play(newFilePath , isLocal: true);
  }

  Future<Null> pauseRecordedSound() async {
    await audioPlayer.pause();
  }

  Future<Null> closeRecorder(BuildContext context) async {
    // Navigator.pop(context);
  }
  
  Future<Null> getFileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fileNumber = prefs.getInt("number") ?? 100;
  }
  
  Future<Null> saveFileNumber() async {
    var x = fileNumber + 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("number", x);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer = null;
    audioRecorder = null;
  }
}
