import 'package:covid_tracker/tracking.dart';
import 'package:flutter/material.dart';
import 'package:covid_tracker/LoadingScreen.dart';
import 'package:covid_tracker/IndiaScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: LoadingScreen(),
    );
  }
}
