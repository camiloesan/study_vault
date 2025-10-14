import 'package:flutter/material.dart';
import 'package:study_vault/pages/login.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:study_vault/utils/alert_service.dart';
import 'package:study_vault/services/users_services.dart';

class UpdatePassword extends StatefulWidget {
  final String email;

  const UpdatePassword({super.key, required this.email});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _updaterPassword() async {
    final String email = widget.email;

    final headers = {'Content-Type': 'application/json'};
    final body = {
      'email': email,
      'password': _hashPassword(_passwordController.text),
    };

    try {
      final response = await UsersServices.updatePassword(headers, body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
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
                    "Regístrate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    } else if (value.length > 64) {
                      return 'Ingresa una contraseña de menos de 64 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Confirmar Contraseña',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updaterPassword();
                    }
                  },
                  child: const Text("AppLocalizations.of(context)!.continueString"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
