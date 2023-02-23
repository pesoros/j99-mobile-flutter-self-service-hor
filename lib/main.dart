// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:j99_mobile_flutter_self_service/screen/dashboardScreen.dart';
import 'package:flutter/foundation.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

  // if (kDebugMode) {
  //   await dotenv.load(fileName: "debug.env");
  // }
  // if (kReleaseMode) {
  //   await dotenv.load(fileName: "release.env");
  // }
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juragan99 Trans Self Service',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DashboardScreen(),
    );
  }
}
