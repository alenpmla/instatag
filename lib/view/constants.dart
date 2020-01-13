import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

final TextStyle splashScreenTitle = TextStyle(
    fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white70);

final TextStyle splashScreenSubTitle = TextStyle(
    fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white70);
final TextStyle styleCardText = TextStyle(
    fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white70);
final TextStyle styleCardTextCat = TextStyle(
    fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black87);
final Color mainThemeColor = Colors.pinkAccent[400];

final titleString = "# Insta Tags #";
final subtitleString = "HashTags for Instagram";

final EdgeInsets paddingSubtitle = EdgeInsets.fromLTRB(0, 20, 0, 0);

final splashBackground = BoxDecoration(
  // Box decoration takes a gradient
  gradient: LinearGradient(
    // Where the linear gradient begins and ends
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    // Add one stop for each color. Stops should increase from 0 to 1
    stops: [0.1, 0.3, 0.5, 0.7, 0.9],
    colors: [
      // Colors are easy thanks to Flutter's Colors class.
      Color.fromRGBO(254, 218, 117, 1.0),
      Color.fromRGBO(250, 126, 30, 1.0),
      Color.fromRGBO(214, 41, 118, 1.0),
      Color.fromRGBO(150, 47, 191, 1.0),
      Color.fromRGBO(79, 91, 213, 1.0)
    ],
  ),
);
