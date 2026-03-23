import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // ⏳ Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD1C4E9), // light purple
              Color(0xFFF8BBD0), // light pink
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔹 Logo
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.show_chart,
                size: 45,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Title
            const Text(
              "Hormonal Health\nCompanion",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Subtitle
            const Text(
              "AI-POWERED WOMEN'S HEALTH COMPANION",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 80),

            // 🔹 Loading text
            const Text(
              "INITIALIZING HEALTH INSIGHTS...",
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Loader
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}