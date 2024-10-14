import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    final hashedPassword = hashPassword(password);
    final url = Uri.parse('http://127.0.0.1:8080/login');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'email': email,
      'password': hashedPassword,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        int userId = jsonResponse['user_id'];
        int userTypeId = jsonResponse['user_type_id'];
        String name = jsonResponse['name'];
        String lastName = jsonResponse['last_name'];
        String email = jsonResponse['email'];

        Provider.of<UserProvider>(context, listen: false).loginUser(
          userId,
          userTypeId,
          name,
          lastName,
          email,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Channels()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to the server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  child: Image.asset('assets/images/logor.png'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Email',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
