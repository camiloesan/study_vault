import 'package:flutter/material.dart';
import 'package:study_vault/pages/sign_up.dart';
import 'package:study_vault/services/users_services.dart';
import 'dart:convert';
import 'package:study_vault/utils/alert_service.dart';

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
    try {
      final response = await UsersServices.fetchEmails();
      if (response.statusCode == 200) {
        List<dynamic> emails = jsonDecode(response.body);
        return emails.cast<String>();
      } else {
        if (mounted) {
          AlertService().showDatabaseErrorAlert(context);
        }
        throw Exception('Error al obtener los correos');
      }
    } catch (e) {
      if (mounted) {
        AlertService().showDatabaseErrorAlert(context);
      }
      throw Exception('Error al obtener los correos');
    }
  }

  Future<void> _checkEmailExists(String email) async {
    try {
      List<String> emails = await _fetchEmails();
      if (emails.contains(email)) {
        _showEmailExistsAlert();
      } else {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUp(email: email),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        AlertService().showDatabaseErrorAlert(context);
      }
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your email",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'user@example.com',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo';
                    } else if (value.length > 64) {
                      return 'Ingresa un correo de menos de 64 caracteres';
                    } else if (!RegExp(
                            r'^(zS\d{8}@estudiantes\.uv\.mx|[a-zA-Z]+@uv\.mx)$')
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
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
