import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const YTTApp());
}

class YTTApp extends StatelessWidget {
  const YTTApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [HEALTH CHECK] Test backend connection at startup
    _checkBackend();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
      },
    );
  }

  void _checkBackend() async {
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:3000"));
      print("✅ [BACKEND TEST] Connection Successful! Status: ${response.statusCode}");
    } catch (e) {
      print("❌ [BACKEND TEST] Connection Failed! Error: $e");
    }
  }
}
//yourTechnicalTutorial#38333
//sample_mflix