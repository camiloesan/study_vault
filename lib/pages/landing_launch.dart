import 'package:flutter/material.dart';
import 'package:study_vault/pages/email_verification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingLaunch extends StatelessWidget {
  const LandingLaunch({super.key});

  void _go_email_verification(BuildContext context) {}

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
            Text("Small description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
                child: Text(
                  AppLocalizations.of(context)!.signUp,
                  style: const TextStyle(fontSize: 16),
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
                      builder: (context) => const EmailVerification(),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.logIn,
                  style: const TextStyle(fontSize: 16),
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
