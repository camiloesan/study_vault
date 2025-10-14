import 'package:flutter/material.dart';
import 'package:study_vault/pages/email_verification.dart';
import 'package:study_vault/pages/login.dart';
import 'package:study_vault/pages/verify_email_exist.dart';

class LandingLaunch extends StatelessWidget {
  const LandingLaunch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              height: 165,
              child: Image.asset('assets/images/logor.png'),
            ),
            const Spacer(),
            Transform.scale(
              scale: 1.2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailVerification(),
                    ),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Transform.scale(
              scale: 1.2,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Transform.scale(
              scale: 1.2,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerifyEmailExist(),
                    ),
                  );
                },
                child: const Opacity(
                  opacity: 0.5,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
