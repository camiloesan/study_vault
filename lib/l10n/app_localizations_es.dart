// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get continueString => 'Continuar';

  @override
  String get signUp => 'Registrarse ahora';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get emailRequestInfo => 'Igresa tu dirección de correo electrónico:';
}
