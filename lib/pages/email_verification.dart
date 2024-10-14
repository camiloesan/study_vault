import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:study_vault/pages/sign_up.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _verificationCode;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationEmail(String email) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8080/request_verification'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(email),
    );

    if (response.statusCode == 200) {
      setState(() {
        _verificationCode = "";
      });
      _showVerificationDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al enviar el correo")),
      );
    }
  }

  Future<void> _verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8080/verify_code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      Constants.email = email;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Código de verificación incorrecto")),
      );
    }
  }

  void _showVerificationDialog() {
    final TextEditingController _codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Revisa tu correo"),
          content: TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Ingresa tu código de verificación',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String code = _codeController.text;
                _verifyCode(_emailController.text, code);
                Navigator.of(context).pop();
              },
              child: const Text('Verificar'),
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
                      _sendVerificationEmail(_emailController.text);
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
