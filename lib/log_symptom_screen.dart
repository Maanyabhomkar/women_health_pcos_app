import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogSymptomScreen extends StatefulWidget {
  const LogSymptomScreen({super.key});

  @override
  State<LogSymptomScreen> createState() => _LogSymptomScreenState();
}

class _LogSymptomScreenState extends State<LogSymptomScreen> {
  String flow = "Medium";
  String mood = "Calm";
  String energy = "Moderate";
  String cramps = "Mild";

  Future<void> saveData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final today = DateTime.now();
    final docId = "${today.year}-${today.month}-${today.day}";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('logs')
        .doc(docId)
        .set({
      'flow': flow,
      'mood': mood,
      'energy': energy,
      'cramps': cramps,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  Widget buildDropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Today's Symptoms"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            buildDropdown(
              "Flow",
              flow,
              ["Light", "Medium", "Heavy"],
              (v) => setState(() => flow = v!),
            ),

            buildDropdown(
              "Mood",
              mood,
              ["Happy", "Calm", "Irritated"],
              (v) => setState(() => mood = v!),
            ),

            buildDropdown(
              "Energy",
              energy,
              ["Low", "Moderate", "High"],
              (v) => setState(() => energy = v!),
            ),

            buildDropdown(
              "Cramps",
              cramps,
              ["None", "Mild", "Severe"],
              (v) => setState(() => cramps = v!),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: saveData,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
