import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tabs/main_home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
      CurvedAnimation(parent: buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .set({
        "name": nameController.text.trim(),
        "age": ageController.text.trim(),
        "weight": weightController.text.trim(),
        "phone": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

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
    SnackBar(content: Text(e.message ?? "Signup Failed")),
  );
}

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildField(nameController, "Full Name"),

              _buildField(ageController, "Age",
                  isNumber: true),

              _buildField(weightController, "Weight (kg)",
                  isNumber: true),

              _buildField(phoneController, "Phone Number",
                  isPhone: true),

              _buildField(emailController, "Email",
                  isEmail: true),

              _buildField(passwordController, "Password",
                  isPassword: true),

              _buildField(confirmPasswordController,
                  "Confirm Password",
                  isConfirm: true),

              const SizedBox(height: 30),

              ScaleTransition(
                scale: buttonScale,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: loading ? null : signup,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text(
                          "Create Account",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* =========================================================
     FIELD BUILDER WITH VALIDATION
  ========================================================= */

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isPhone = false,
    bool isEmail = false,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword || isConfirm,
        keyboardType:
            isNumber || isPhone ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }

          if (isPhone &&
              (!RegExp(r'^[0-9]{10}$')
                  .hasMatch(value))) {
            return "Enter valid 10 digit number";
          }

          if (isEmail &&
              (!value.contains("@") ||
                  !value.contains("."))) {
            return "Enter valid email";
          }

          if (isPassword &&
              !RegExp(r'^(?=.*[@#\$%]).{6,}$')
                  .hasMatch(value)) {
            return "Min 6 chars + 1 special (@#\$%)";
          }

          if (isConfirm &&
              value != passwordController.text) {
            return "Passwords do not match";
          }

          return null;
        },
      ),
    );
  }
}
