import 'dart:io';
import 'package:dio/dio.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:charcha/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class customAudioRecorder extends StatefulWidget {
  @override
  _customAudioRecorderState createState() => _customAudioRecorderState();
}

class _customAudioRecorderState extends State<customAudioRecorder> {
  Dio dio;
  bool isRecording = false;
  FlutterSound flutterSound;
  AudioRecorder audioRecorder;
  File defaultFile;
  Recording _recording;
  String finalPath = "/TestFile";
  final titleController = new TextEditingController();
  final captionController = new TextEditingController();
  TextEditingController caption = new TextEditingController();
  TextEditingController description = new TextEditingController();

  stopRecording() async {
    var recording = await flutterSound.stopRecorder();
    print("Recorder Result = ${recording.toString()}");
    var _recording = await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;
    Directory docDir = await getExternalStorageDirectory();
    print(docDir.toString());
    setState(() {
      this.isRecording = isRecording;
      this.defaultFile = File(docDir.path + finalPath);
    });
  }

  startRecording() async {
    Directory docDir = await getExternalStorageDirectory();
    print(docDir.path.toString());
    String newFilePath = docDir.path + finalPath;
    print(newFilePath);
    File tempAudioFile = File(newFilePath);
    print(tempAudioFile);
    print("Checking if file exists");
    if (await tempAudioFile.exists()){
      print("Entered to delete file");
      await tempAudioFile.delete();
    }
    String path = await flutterSound.startRecorder(null);
    print("Path = $path");
    // await AudioRecorder.start(path: newFilePath , audioOutputFormat: AudioOutputFormat.WAV);
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
    audioRecorder = new AudioRecorder();
    flutterSound = new FlutterSound();
    dio = new Dio();
    dio.options.baseUrl = config.baseUrl;
    dio.options.followRedirects = false;
  }

  Future<Null> postRecording(String caption, String title) async {
    Directory docDir = await getExternalStorageDirectory();
    String newFilePath = docDir.path + finalPath;
    File file = File(newFilePath);
    print(file);
    FormData formData = new FormData.from({
      "title": title,
      "caption": caption,
      "voicePost": file
    });
    var request = new http.MultipartRequest("POST", Uri.parse(config.baseUrl+"/voice-posts/upload"));
    request.headers["Authrization"] = "Bearer "+config.jwt;
    request.headers["content-type"] = "multipart/form-data";
    request.fields['title'] = title;
    request.fields['caption'] = caption;
    request.files.add(new http.MultipartFile.fromBytes('voicePost', await file.readAsBytes()));
    request.send().then((response){
      print(response.statusCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        isRecording ? stopRecording() : startRecording();
                        setState(() {
                          this.isRecording = !this.isRecording;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: isRecording ? AssetImage('images/stop.jpg') : AssetImage('images/mic.png'),
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
              child: RaisedButton(
                  child: new Text("Post"),
                  onPressed: () {
                    postRecording(caption.text, titleController.text);
                  },
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
              ),
            )
          ],
        ),
      ),
    );
  }
}
