import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Added
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';
import 'firebase_options.dart';
import 'services/language_service.dart'; // Added
import 'l10n/app_localizations.dart'; // Added

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Fallback if firebase_options.dart is missing or incorrect
    // This allows the app to run in "offline/demo" mode if needed,
    // or simply logs the error until the user configures it.
    debugPrint('Firebase initialization failed: $e');
    // In a real app, we might show an error screen or just continue if optional
  }
  runApp(const AgroFlowApp());
}

class AgroFlowApp extends StatelessWidget {
  const AgroFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, child) {
        return MaterialApp(
          title: 'AgroFLOW',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: LanguageService().currentLocale, // Use current locale
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('mr', ''), // Marathi
            Locale('hi', ''), // Hindi
          ],
          home: const LoginScreen(),
          routes: {'/login': (context) => const LoginScreen()},
        );
      },
    );
  }
}
