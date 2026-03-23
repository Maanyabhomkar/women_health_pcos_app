import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../core/onboarding_screen.dart';
import '../../widgets/progress_bar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // 🔐 Email Validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";

    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) return "Enter valid email";
    return null;
  }

  // 🔐 Password Validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password required";

    if (value.length < 8) return "Min 8 characters required";

    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}$');

    if (!passwordRegex.hasMatch(value)) {
      return "Must include letter, number & special char";
    }
    return null;
  }

  // 🔐 Confirm Password
  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void handleSignup() {
  if (_formKey.currentState!.validate()) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OnboardingScreen(
          userName: nameController.text, // ✅ pass name
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // 🔥 Progress Bar (Step 1)
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ProgressBar(currentStep: 1),
              ),

              const SizedBox(height: 20),

              // 🔹 Logo
              Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB39DDB), Color(0xFF9575CD)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.show_chart,
                        color: Colors.white, size: 35),
                  ),
                  const SizedBox(height: 10),
                  const Text("Hormonal Health",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Companion",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 30),

              // 🔹 Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text("Create Account",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),

                      const SizedBox(height: 5),

                      const Text("Start your wellness journey today",
                          style: TextStyle(color: Colors.grey)),

                      const SizedBox(height: 20),

                      // Name
                      const Text("Full Name"),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: nameController,
                        validator: (value) =>
                            value!.isEmpty ? "Enter name" : null,
                        decoration: inputDecoration(
                            "Enter your name", Icons.person_outline),
                      ),

                      const SizedBox(height: 15),

                      // Email
                      const Text("Email Address"),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: emailController,
                        validator: validateEmail,
                        decoration: inputDecoration(
                            "name@example.com", Icons.email_outlined),
                      ),

                      const SizedBox(height: 15),

                      // Password
                      const Text("Password"),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        validator: validatePassword,
                        decoration: inputDecoration(
                          "Min. 8 characters",
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Confirm Password
                      const Text("Confirm Password"),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !isConfirmPasswordVisible,
                        validator: validateConfirmPassword,
                        decoration: inputDecoration(
                          "Repeat your password",
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text("Create Account"),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR SIGNUP WITH"),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      socialButton("Continue with Google",
                          Icons.g_mobiledata, () {}),

                      const SizedBox(height: 10),

                      socialButton("Continue with Apple",
                          Icons.apple, () {}),

                      const SizedBox(height: 20),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text("Log In",
                                style: TextStyle(color: Colors.purple)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget socialButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}