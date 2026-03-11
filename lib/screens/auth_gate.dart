import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../tabs/main_home.dart';
import 'get_started_screen.dart';

class AuthGate extends StatelessWidget {
  final VoidCallback toggleTheme;

  const AuthGate({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return MainHome(toggleTheme: toggleTheme);
        }

        return const GetStartedScreen();
      },
    );
  }
}