import 'package:flutter/material.dart';
import '../utils/api_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _smokingHistoryController =
  TextEditingController();
  final TextEditingController _socialIdController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final height = double.tryParse(_heightController.text);
    final birthdate = _birthdateController.text;
    final gender = _genderController.text;
    final smokingHistory = int.tryParse(_smokingHistoryController.text);
    final socialId = _socialIdController.text;

    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        height == null ||
        birthdate.isEmpty ||
        gender.isEmpty ||
        smokingHistory == null ||
        socialId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ApiService.registerUser(
      email: email,
      password: password,
      name: name,
      height: height,
      birthdate: birthdate,
      gender: gender,
      smokingHistory: smokingHistory,
      socialId: socialId,
    );

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      Navigator.pop(context);
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
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _birthdateController,
                decoration: InputDecoration(labelText: 'Birthdate (YYYY-MM-DD)'),
              ),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender (M/F)'),
              ),
              TextField(
                controller: _smokingHistoryController,
                decoration: InputDecoration(labelText: 'Smoking History (0/1)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _socialIdController,
                decoration: InputDecoration(labelText: 'Social ID'),
              ),
              SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
