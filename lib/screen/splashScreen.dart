import 'dart:async';

import 'package:flutter/material.dart';
import 'package:j99_mobile_flutter_self_service/screen/dashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 300), (() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
