import 'package:flutter/material.dart';
import 'package:study_vault/pages/landing_launch.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:study_vault/utils/alert_service.dart';
import 'package:study_vault/services/users_services.dart';

class SignUp extends StatefulWidget {
  final String email;

  const SignUp({super.key, required this.email});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _registerUser() async {
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'email': widget.email,
      'name': _nameController.text,
      'last_name': _lastNameController.text,
      'password': _hashPassword(_passwordController.text),
    };

    try {
      final response = await UsersServices.registerUser(headers, body);
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registro exitoso")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LandingLaunch()),
          );
        }
      } else {
        if (mounted) {
          AlertService().showDatabaseErrorAlert(context);
        }
      }
    } catch (e) {
      if (mounted) {
        AlertService().showDatabaseErrorAlert(context);
      }
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nombre(s)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    } else if (value.length > 32) {
                      return 'Ingresa un nombre de menos de 32 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Apellido(s)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    } else if (value.length > 64) {
                      return 'Ingresa un apellido de menos de 64 caracteres';
                    }
                    return null;
                  },
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
                      _registerUser();
                    }
                  },
                  child: const Text(
                      "AppLocalizations.of(context)!.continueString"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
