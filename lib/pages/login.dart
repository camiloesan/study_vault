import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
              const Center(
                child: Text(
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
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
