
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:instatag/view/splashscreen.dart';

void main() {
  FirebaseAdMob.instance.initialize(appId: getAppId());
  runApp(MaterialApp(
    title: 'HashTags#',
    home: SplashScreen(),
  ));
}

String getAppId() {
  return "ca-app-pub-9079381335168661~3899962858";
}
