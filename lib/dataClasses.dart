import 'dart:ui';

import 'package:flutter/material.dart';

class feedModel {
  ImageProvider thumbnail = AssetImage('images/profile.png');
  String name = "Default Name";
  String title = "Default Title";
  String description = "This is a description that can be at max 120 charecters long";
  String url = "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp4";
}

enum audioPlayerState{
  Playing,Stopped
}