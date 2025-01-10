import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Care Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Medical Care Dashboard!',
          style: TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
      ),
    );
  }
}
