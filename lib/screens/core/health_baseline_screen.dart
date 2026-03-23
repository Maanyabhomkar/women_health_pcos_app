import 'package:flutter/material.dart';
import '../../widgets/progress_bar.dart';
import 'home_screen.dart';

class HealthBaselineScreen extends StatefulWidget {
  final String userName;

  const HealthBaselineScreen({super.key, required this.userName});

  @override
  State<HealthBaselineScreen> createState() =>
      _HealthBaselineScreenState();
}

class _HealthBaselineScreenState extends State<HealthBaselineScreen> {

  final ageController = TextEditingController(text: "24");
  final heightController = TextEditingController(text: "165");
  final weightController = TextEditingController(text: "58");
  final cycleController = TextEditingController(text: "28");

  bool severeCramps = false;
  String periodRegularity = "Regular";
  String weightChange = "No Change";

  int periodDuration = 5;

  DateTime? selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔹 Progress Bar
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ProgressBar(currentStep: 3),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Set up your health baseline",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                const Text(
                  "This helps personalize your insights",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                // 🔹 Physical Baseline
                sectionCard(
                  title: "Physical Baseline",
                  child: Column(
                    children: [
                      inputField("Age", ageController),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(child: inputField("Height", heightController, suffix: "cm")),
                          const SizedBox(width: 10),
                          Expanded(child: inputField("Weight", weightController, suffix: "kg")),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Used to calculate BMI for insights.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // 🔹 Cycle Baseline
                sectionCard(
                  title: "Cycle Baseline",
                  child: Column(
                    children: [

                      GestureDetector(
                        onTap: pickDate,
                        child: containerField(
                          "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                        ),
                      ),

                      const SizedBox(height: 10),

                      inputField("Average Cycle Length", cycleController, suffix: "days"),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Period Duration"),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (periodDuration > 1) {
                                    setState(() => periodDuration--);
                                  }
                                },
                              ),
                              Text("$periodDuration"),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() => periodDuration++);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // 🔹 Optional
                sectionCard(
                  title: "Optional",
                  child: Column(
                    children: [

                      optionSelector(
                        "Period Regularity",
                        ["Regular", "Sometimes Irregular", "Irregular"],
                        periodRegularity,
                        (val) => setState(() => periodRegularity = val),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Severe Cramps"),
                          Switch(
                            value: severeCramps,
                            onChanged: (val) {
                              setState(() => severeCramps = val);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      optionSelector(
                        "Recent Weight Change",
                        ["No Change", "Slight Gain", "Significant Gain"],
                        weightChange,
                        (val) => setState(() => weightChange = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Continue Button
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
                    onPressed: () {

                      // 🔥 Data (for ML later)
                      print(ageController.text);
                      print(heightController.text);
                      print(weightController.text);

                      // ✅ Navigate to Home
                      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => HomeScreen(userName: widget.userName),
  ),
);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget inputField(String label, TextEditingController controller,
      {String? suffix}) {
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

  Widget containerField(String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget optionSelector(String title, List<String> options,
      String selected, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selected == option,
              onSelected: (_) => onSelect(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }
}