import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogSymptomsScreen extends StatefulWidget {
  const LogSymptomsScreen({super.key});

  @override
  State<LogSymptomsScreen> createState() => _LogSymptomsScreenState();
}

class _LogSymptomsScreenState extends State<LogSymptomsScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  bool cramps = false;
  bool moodSwings = false;
  bool headache = false;
  bool acne = false;
  String notes = "";

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  Future<void> saveSymptoms() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("symptoms")
        .add({
      "uid": user.uid,
      "cramps": cramps,
      "moodSwings": moodSwings,
      "headache": headache,
      "acne": acne,
      "notes": notes,
      "date": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Symptoms Saved 💕")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Today's Symptoms"),
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              CheckboxListTile(
                title: const Text("Cramps"),
                value: cramps,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => cramps = val!);
                },
              ),

              CheckboxListTile(
                title: const Text("Mood Swings"),
                value: moodSwings,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => moodSwings = val!);
                },
              ),

              CheckboxListTile(
                title: const Text("Headache"),
                value: headache,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => headache = val!);
                },
              ),

              CheckboxListTile(
                title: const Text("Acne"),
                value: acne,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => acne = val!);
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Additional Notes",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => notes = val,
              ),

              const SizedBox(height: 30),

              ScaleTransition(
                scale: scaleAnimation,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: saveSymptoms,
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}