// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get continueString => 'Continue';

  @override
  String get signUp => 'Sign up now';

  @override
  String get logIn => 'Log in';

  @override
  String get emailRequestInfo => 'You will need to enter your email address:';
}
