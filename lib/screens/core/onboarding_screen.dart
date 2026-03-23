import 'package:flutter/material.dart';
import 'health_baseline_screen.dart';
import '../../widgets/progress_bar.dart';

class OnboardingScreen extends StatelessWidget {
  final String userName;

  const OnboardingScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // ✅ FIXED (important)
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🔹 Progress Bar (Step 2)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ProgressBar(currentStep: 2),
              ),

              const SizedBox(height: 30),

              // 🔹 Icon
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.monitor_heart, color: Colors.purple),
              ),

              const SizedBox(height: 20),

              // 🔹 Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Track your cycle\nUnderstand your health",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Track your cycle, understand patterns,\nand get early health insights.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.calendar_month, color: Colors.purple),
                        SizedBox(width: 10),
                        Text(
                          "Understand Your Cycle",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Go beyond basic dates. Log your daily symptoms to uncover your unique hormonal patterns.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    const Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 16),
                        SizedBox(width: 5),
                        Text("Phase-specific insights"),
                      ],
                    ),

                    const SizedBox(height: 5),

                    const Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 16),
                        SizedBox(width: 5),
                        Text("Personalized cycle predictions"),
                      ],
                    ),

                    const SizedBox(height: 5),

                    const Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 16),
                        SizedBox(width: 5),
                        Text("Daily symptom logging"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Info Box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "This feature provides educational insights based on your symptoms. It does not provide medical diagnosis.",
                  style: TextStyle(fontSize: 12),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => HealthBaselineScreen(userName: userName),
    ),
  );
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text("Get Started"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}