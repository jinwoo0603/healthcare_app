import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Care App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),  // 초기 화면: 로그인 페이지
        '/home': (context) => HomePage(),  // 로그인 성공 후: 홈 페이지
        '/register': (context) => RegisterPage(),  // 회원가입 페이지
      },
    );
  }
}
