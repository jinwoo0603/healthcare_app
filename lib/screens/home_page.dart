import 'package:flutter/material.dart';
import '../utils/api_service.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodGlucoseController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  Map<String, dynamic>? _recentRecord;
  Map<String, dynamic>? _averages;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistorySummary();
  }
  Future<void> _fetchHistorySummary() async {
    final response = await ApiService.viewHistorySummary();

    if (response['success']) {
      setState(() {
        _recentRecord = response['recent_record'];
        _averages = response['averages'];
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to fetch data')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputSection(),
              SizedBox(height: 20.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecentRecordSection(),
                  SizedBox(height: 20.0),
                  _buildAveragesSection(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 입력 폼 섹션
  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _weightController,
          decoration: InputDecoration(labelText: 'Weight (kg)'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: _bloodGlucoseController,
          decoration: InputDecoration(labelText: 'Blood Glucose (mg/dL)'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10.0),
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
    );
  }

  /// 최근 기록 섹션
  Widget _buildRecentRecordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Record',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        _recentRecord != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Blood Glucose: ${_recentRecord!['blood_glucose']} mg/dL'),
            Text('Blood Pressure: ${_recentRecord!['blood_pressure']} mmHg'),
            Text('Weight: ${_recentRecord!['weight']} kg'),
            Text('Timestamp: ${_recentRecord!['timestamp']}'),
          ],
        )
            : Text('No recent record available.'),
      ],
    );
  }

  /// 평균 값 섹션
  Widget _buildAveragesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Averages',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        _averages != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Average Blood Glucose: ${_averages!['avg_blood_glucose'] ?? 'N/A'} mg/dL'),
            Text('Average Blood Pressure: ${_averages!['avg_blood_pressure'] ?? 'N/A'} mmHg'),
            Text('Average Weight: ${_averages!['avg_weight'] ?? 'N/A'} kg'),
          ],
        )
            : Text('No averages available.'),
      ],
    );
  }

}
