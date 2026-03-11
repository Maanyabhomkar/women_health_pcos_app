import 'package:flutter/material.dart';
import 'screens/auth_gate.dart';

class women_health_pcos_appApp extends StatefulWidget {
  const women_health_pcos_appApp({super.key});

  @override
  State<women_health_pcos_appApp> createState() => _women_health_pcos_appAppState();
}

class _women_health_pcos_appAppState extends State<women_health_pcos_appApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primaryColor: const Color(0xFFE91E63),
        scaffoldBackgroundColor: const Color(0xFFFFF1F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.dark,
        ),
      ),
      home: AuthGate(toggleTheme: toggleTheme),
    );
  }
}