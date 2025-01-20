import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  Map<String, List<dynamic>>? _dataArrays;
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputSection(),
              SizedBox(height: 20.0),
              _buildRecentAndAverages(),
              if (_dataArrays != null) ...[
                _buildHistoryChart(
                  data: _dataArrays!['blood_glucose']!.cast<double>(),
                  label: 'Blood Glucose Over Time',
                  color: Colors.red,
                ),
                _buildHistoryChart(
                  data: _dataArrays!['blood_pressure']!.cast<double>(),
                  label: 'Blood Pressure Over Time',
                  color: Colors.blue,
                ),
                _buildHistoryChart(
                  data: _dataArrays!['weight']!.cast<double>(),
                  label: 'Weight Over Time',
                  color: Colors.green,
                ),
              ],
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

  /// 최근 기록 및 평균값 섹션
  Widget _buildRecentAndAverages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Record',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        _recentRecord != null
            ? Text(
          'Blood Glucose: ${_recentRecord!['blood_glucose']}, '
              'Blood Pressure: ${_recentRecord!['blood_pressure']}, '
              'Weight: ${_recentRecord!['weight']}',
        )
            : Text('No recent record available.'),
        SizedBox(height: 20.0),
        Text(
          'Averages',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        _averages != null
            ? Text(
          'Average Blood Glucose: ${_averages!['avg_blood_glucose']}, '
              'Average Blood Pressure: ${_averages!['avg_blood_pressure']}, '
              'Average Weight: ${_averages!['avg_weight']}',
        )
            : Text('No averages available.'),
      ],
    );
  }

  Widget _buildHistoryChart({
    required List<double> data,
    required String label,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            SizedBox(
              height: 200.0,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: (0.8 * 255)),
                          color,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
