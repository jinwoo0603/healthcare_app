import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Care',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
      ),
      home: LoginPage(),
    );
  }
}
