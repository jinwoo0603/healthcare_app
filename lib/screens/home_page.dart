import 'package:flutter/material.dart';
import '../utils/api_service.dart';
import 'result.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodGlucoseController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitHistory() async {
    final weight = double.tryParse(_weightController.text);
    final bloodGlucose = int.tryParse(_bloodGlucoseController.text);
    final bloodPressure = int.tryParse(_bloodPressureController.text);

    if (weight == null || bloodGlucose == null || bloodPressure == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ApiService.createHistory(
      weight: weight,
      bloodGlucose: bloodGlucose,
      bloodPressure: bloodPressure,
    );

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            hbA1c: response['prediction']['hbA1c'],
            heartRisk: response['prediction']['heart'],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _bloodGlucoseController,
              decoration: InputDecoration(labelText: 'Blood Glucose (mg/dL)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _bloodPressureController,
              decoration: InputDecoration(labelText: 'Blood Pressure (mmHg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submitHistory,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
