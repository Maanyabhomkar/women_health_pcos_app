import 'package:flutter/material.dart';
import '../extra/daily_checkin_screen.dart'; // ✅ for update daily check-in
import 'health_report_screen.dart';

class HealthInsightsScreen extends StatelessWidget {
  final double risk;
  final int cycleLength;
  final double bmi;
  final String regularity;
  final List<String> symptoms;

  const HealthInsightsScreen({
    super.key,
    required this.risk,
    required this.cycleLength,
    required this.bmi,
    required this.regularity,
    required this.symptoms,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      appBar: AppBar(
        title: const Text("Health Insights"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),

        // 🔥 DOWNLOAD BUTTON
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Report Downloaded")),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 TOP CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PCOS RISK LEVEL",
                      style: TextStyle(color: Colors.white70)),

                  const SizedBox(height: 5),

                  Text(
                    getRiskLabel(),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Based on your inputs and tracked data, there is a moderate likelihood of PCOS patterns.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Influencing Factors
            sectionCard(
              "Influencing Factors",
              Column(
                children: [
                  factorTile("Cycle Length", "$cycleLength Days",
                      cycleLength > 35 ? "High" : "Normal"),
                  factorTile("BMI Index", bmi.toStringAsFixed(1),
                      bmi > 25 ? "Moderate" : "Normal"),
                  factorTile("Period Regularity", regularity,
                      regularity == "irregular" ? "Low" : "Normal"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Symptoms
            sectionCard(
              "Symptom Profile",
              Wrap(
                spacing: 10,
                children: symptoms
                    .map((s) => Chip(label: Text(s)))
                    .toList(),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Understanding
            sectionCard(
              "Understanding Your Risk",
              const Text(
                "Your risk is mainly influenced by irregular cycles, BMI level, and reported symptoms.",
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Actions
            sectionCard(
              "Recommended Actions",
              Column(
                children: const [
                  ListTile(title: Text("Maintain a balanced diet")),
                  ListTile(title: Text("Exercise regularly")),
                  ListTile(title: Text("Track cycles")),
                  ListTile(title: Text("Consult doctor if needed")),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 BUTTONS

            // Save to report
            GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HealthReportScreen(),
      ),
    );
  },
  child: gradientButton("Save to Health Report"),
),

            const SizedBox(height: 10),

            // Chatbot
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening Chatbot...")),
                );
              },
              child: outlineButton("Ask Health Chatbot"),
            ),

            const SizedBox(height: 10),

            // Daily check-in
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DailyCheckinScreen(),
                  ),
                );
              },
              child: outlineButton("Update Daily Check-in"),
            ),
          ],
        ),
      ),
    );
  }

  String getRiskLabel() {
    if (risk < 40) return "Low";
    if (risk < 70) return "Moderate";
    return "High";
  }

  Widget sectionCard(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget factorTile(String title, String value, String level) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title : $value"),
          Text(level,
              style: const TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }

  Widget gradientButton(String text) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(text,
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget outlineButton(String text) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(child: Text(text)),
    );
  }
}