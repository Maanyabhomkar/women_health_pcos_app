import 'package:flutter/material.dart';
import 'prediction_result_screen.dart'; 

class PCOSRiskCheckScreen extends StatefulWidget {
  const PCOSRiskCheckScreen({super.key});

  @override
  State<PCOSRiskCheckScreen> createState() => _PCOSRiskCheckScreenState();
}

class _PCOSRiskCheckScreenState extends State<PCOSRiskCheckScreen> {

  // 🔹 Personal Metrics
  final ageController = TextEditingController(text: "25");
  final heightController = TextEditingController(text: "165");
  final weightController = TextEditingController(text: "60");

  // 🔹 Menstrual
  final cycleController = TextEditingController(text: "28");
  final periodController = TextEditingController(text: "5");
  String periodRegularity = "regular";

  // 🔹 Symptoms
  Set<String> symptoms = {};

  final List<String> symptomList = [
    "Weight Gain",
    "Excess Hair Growth",
    "Severe Acne",
    "Thinning Hair",
    "Skin Darkening"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      appBar: AppBar(
        title: const Text("PCOS Risk Check"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 10),
          Icon(Icons.settings),
          SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Health Assessment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              "Complete this comprehensive form to help our AI analyze your hormonal patterns and identify potential PCOS risk factors.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 🔹 PERSONAL METRICS
            sectionCard(
              "Personal Metrics",
              Column(
                children: [
                  inputField("Age", ageController, "yrs"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: inputField("Height", heightController, "cm")),
                      const SizedBox(width: 10),
                      Expanded(child: inputField("Weight", weightController, "kg")),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 MENSTRUAL PATTERNS
            sectionCard(
              "Menstrual Patterns",
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: inputField("Cycle Length", cycleController, "days")),
                      const SizedBox(width: 10),
                      Expanded(child: inputField("Period Duration", periodController, "days")),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children: ["regular", "irregular", "no period"]
                        .map((r) => ChoiceChip(
                              label: Text(r),
                              selected: periodRegularity == r,
                              onSelected: (_) {
                                setState(() => periodRegularity = r);
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 SYMPTOMS
            sectionCard(
              "Symptoms experienced frequently",
              Wrap(
                spacing: 10,
                children: symptomList.map((s) {
                  return ChoiceChip(
                    label: Text(s),
                    selected: symptoms.contains(s),
                    onSelected: (_) {
                      setState(() {
                        if (symptoms.contains(s)) {
                          symptoms.remove(s);
                        } else {
                          symptoms.add(s);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 PREDICT BUTTON
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {

                  double risk = calculateRisk();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PredictionResultScreen(riskScore: risk),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  "Predict Risk",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Medical Disclaimer\nThis tool is designed to increase health awareness and does not provide a clinical diagnosis.",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 RISK LOGIC
  double calculateRisk() {
    double score = 0;

    int cycle = int.tryParse(cycleController.text) ?? 0;
    int weight = int.tryParse(weightController.text) ?? 0;

    if (cycle > 35) score += 30;
    if (weight > 70) score += 20;
    if (periodRegularity == "irregular") score += 20;
    if (symptoms.length >= 3) score += 30;

    return score.clamp(0, 100).toDouble(); // ✅ FIXED TYPE
  }

  // 🔧 UI COMPONENTS

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

  Widget inputField(
      String label, TextEditingController controller, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: suffix,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}