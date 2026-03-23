import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../tabs/main_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController buttonController;
  late Animation<double> buttonScale;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    buttonScale = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => MainHome(
      toggleTheme: () {},
    ),
  ),
  (route) => false,
);


    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login Failed")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(height: 20),

              const Text(
                "Welcome Back 💜",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /* ---------- EMAIL FIELD ---------- */
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!value.contains("@") ||
                      !value.contains(".")) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /* ---------- PASSWORD FIELD ---------- */
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Minimum 6 characters required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 35),

              /* ---------- BOUNCING LOGIN BUTTON ---------- */
              ScaleTransition(
                scale: buttonScale,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: loading ? null : login,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
