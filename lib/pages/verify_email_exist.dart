import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8085/user/verification/request'),
        headers: {'Content-Type': 'application/json'},
        body: '"${_emailController.text}"');

    if (response.statusCode == 200) {
      _showVerificationCodeDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: ${'Error al enviar correo'}" +
                response.statusCode.toString() +
                _emailController.text)),
      );
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
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8085/user/verify'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': _emailController.text, 'code': code}),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdatePassword(email: _emailController.text)),
      );
    } else {
      final errorResponse = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Error: ${errorResponse['message'] ?? 'Error al enviar correo'}")),
      );
    }
  }

  Future<List<String>> _fetchEmails() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8083/user/email/all'),
    );

    if (response.statusCode == 200) {
      List<dynamic> emails = jsonDecode(response.body);
      return emails.cast<String>();
    } else {
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
      print('Error fetching emails: $error');
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
