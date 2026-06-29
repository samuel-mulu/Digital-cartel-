import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_i18n.dart';
import 'home_page.dart';
import 'splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppLanguage _language = AppLanguage.english;
  bool _languageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance()
          .timeout(const Duration(seconds: 2));
      final saved = prefs.getString('app_language');
      if (!mounted) return;
      setState(() {
        _language = _languageFromCode(saved);
        _languageLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _languageLoaded = true;
      });
    }
  }

  void _onLanguageChanged(AppLanguage language) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('app_language', _codeFromLanguage(language));
    });
    setState(() {
      _language = language;
    });
  }

  AppLanguage _languageFromCode(String? code) {
    switch (code) {
      case 'am':
        return AppLanguage.amharic;
      case 'ti':
        return AppLanguage.tigrinya;
      case 'en':
      default:
        return AppLanguage.english;
    }
  }

  String _codeFromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.amharic:
        return 'am';
      case AppLanguage.tigrinya:
        return 'ti';
      case AppLanguage.english:
        return 'en';
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n(_language);

    if (!_languageLoaded) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: FriendsBingoSplashView(
            language: _language,
            showLoader: true,
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: i18n.t('app_name'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(
        language: _language,
        onLanguageChanged: _onLanguageChanged,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _splashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    Future.delayed(_splashDuration, _goToHome);
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          language: widget.language,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FriendsBingoSplashView(
        language: widget.language,
        showLoader: true,
      ),
    );
  }
}
