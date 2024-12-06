import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:study_vault/services/auth_services.dart';
import 'package:study_vault/services/users_services.dart';
import 'dart:convert';
import 'package:study_vault/utils/alert_service.dart';
import 'package:study_vault/pages/update_password.dart';

class VerifyEmailExist extends StatefulWidget {
  const VerifyEmailExist({super.key});

  @override
  State<VerifyEmailExist> createState() => _VerifyEmailExistState();
}

class _VerifyEmailExistState extends State<VerifyEmailExist> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _sendCodeToEmail() async {
    final headers = {'Content-Type': 'application/json'};
    final email = _emailController.text;

    try {
      final response = await AuthService.sendVerificationCode(headers, email);

      if (response.statusCode == 200) {
        _showVerificationCodeDialog();
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  void _showVerificationCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingrese el código de verificación'),
          content: TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Código de verificación',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Enviar'),
              onPressed: () {
                Navigator.of(context).pop();
                _sendVerifyCode(_codeController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _sendVerifyCode(String code) async {
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': _emailController.text, 'code': code};

    try {
      final response = await AuthService.verifyCode(headers, body);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdatePassword(email: _emailController.text),
          ),
        );
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<List<String>> _fetchEmails() async {
    try {
      final response = await UsersServices.fetchEmails();
      if (response.statusCode == 200) {
        List<dynamic> emails = jsonDecode(response.body);
        return emails.cast<String>();
      } else {
        AlertService().showDatabaseErrorAlert(context);
        throw Exception('Error al obtener los correos');
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
      throw Exception('Error al obtener los correos');
    }
  }

  Future<void> _checkEmailExists(String email) async {
    try {
      List<String> emails = await _fetchEmails();
      if (emails.contains(email)) {
        _sendCodeToEmail();
      } else {
        _showEmailExistsAlert();
      }
    } catch (error) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  void _showEmailExistsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ivalid email'),
          content: const Text('The email is not registered.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(34.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.emailRequestInfo,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Insert email for recovery password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _checkEmailExists(_emailController.text);
                  },
                  child: Text(AppLocalizations.of(context)!.continueString),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
