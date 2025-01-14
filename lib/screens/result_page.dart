import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double hbA1c;
  final bool heartRisk;

  const ResultPage({
    Key? key,
    required this.hbA1c,
    required this.heartRisk,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prediction Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Prediction Results',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'HbA1c Prediction: ${hbA1c.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18.0, color: Colors.black87),
            ),
            SizedBox(height: 10.0),
            Text(
              'Heart Disease Risk: ${heartRisk ? 'High' : 'Low'}',
              style: TextStyle(
                fontSize: 18.0,
                color: heartRisk ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 이전 페이지(HomePage)로 돌아가기
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
