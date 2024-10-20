import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:study_vault/pages/sign_up.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<List<String>> _fetchEmails() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8080/user/email/all'),
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
        _showEmailExistsAlert();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUp(),
          ),
        );
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
          title: const Text('Correo ya registrado'),
          content: const Text('El correo ingresado ya está registrado.'),
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
                    labelText: 'Ingresa tu correo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@(estudiantes\.uv\.mx|uv\.mx)$')
                        .hasMatch(value)) {
                      return 'El correo debe ser de la Universidad Veracruzana';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _checkEmailExists(_emailController.text);
                    }
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
