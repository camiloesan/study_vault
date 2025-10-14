import 'package:flutter/material.dart';
import 'package:study_vault/pages/landing_launch.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.load(fileName: ".env");
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyVault',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
      ),
      home: const LandingLaunch(),
    );
  }
}
