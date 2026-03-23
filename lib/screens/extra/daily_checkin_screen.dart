import 'package:flutter/material.dart';

class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key});

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {

  // 🔹 DATE
  DateTime selectedDate = DateTime.now();

  // 🔹 State variables
  Set<String> symptoms = {};
  String flow = "Medium";
  bool cramps = true;
  Set<String> bodySignals = {};
  String mood = "Neutral";

  String sleep = "Average";
  String activity = "Moderate";
  String water = "Adequate";
  String cravings = "Mild";
  String diet = "Average";

  final List<String> symptomList = [
    "Acne", "Excess Hair Growth", "Hair Loss", "Skin Darkening", "Weight Gain"
  ];

  final List<String> bodyList = ["Fatigue", "Bloating"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      appBar: AppBar(
        title: const Text("Daily Check-in"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Track daily symptoms to improve your insights.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 15),

            // 🔥 DATE CARD (UPDATED)
            card(
              child: GestureDetector(
                onTap: pickDate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today, ${formatDate(selectedDate)}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Physical Symptoms
            sectionCard(
              "Physical Symptoms",
              Wrap(
                spacing: 10,
                children: symptomList.map((s) {
                  return chip(s, symptoms.contains(s), () {
                    setState(() {
                      symptoms.contains(s)
                          ? symptoms.remove(s)
                          : symptoms.add(s);
                    });
                  });
                }).toList(),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Cycle Health
            sectionCard(
              "Cycle Health",
              Column(
                children: [
                  optionRow("Flow Intensity", ["Light", "Medium", "Heavy"],
                      flow, (val) => setState(() => flow = val)),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Cramps"),
                      Switch(
                        value: cramps,
                        onChanged: (val) {
                          setState(() => cramps = val);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Body Signals
            sectionCard(
              "Body Signals",
              Wrap(
                spacing: 10,
                children: bodyList.map((s) {
                  return chip(s, bodySignals.contains(s), () {
                    setState(() {
                      bodySignals.contains(s)
                          ? bodySignals.remove(s)
                          : bodySignals.add(s);
                    });
                  });
                }).toList(),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Mood
            sectionCard(
              "Mood",
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ["Happy", "Calm", "Neutral", "Irritated", "Low"]
                    .map((m) => GestureDetector(
                          onTap: () => setState(() => mood = m),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    mood == m ? Colors.purple : Colors.grey[200],
                                child: const Text("😊"),
                              ),
                              Text(m, style: const TextStyle(fontSize: 10))
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Lifestyle
            sectionCard(
              "Lifestyle",
              Column(
                children: [
                  optionRow("Sleep Quality", ["Poor", "Average", "Good"],
                      sleep, (val) => setState(() => sleep = val)),

                  optionRow("Activity Level", ["Low", "Moderate", "Active"],
                      activity, (val) => setState(() => activity = val)),

                  optionRow("Water Intake", ["Low", "Adequate"],
                      water, (val) => setState(() => water = val)),

                  optionRow("Cravings", ["No", "Mild", "Strong"],
                      cravings, (val) => setState(() => cravings = val)),

                  optionRow("Diet Quality", ["Balanced", "Average", "Unhealthy"],
                      diet, (val) => setState(() => diet = val)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Save Button
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
                  print("Date: $selectedDate");
                  print(symptoms);
                  print(flow);
                  print(cramps);
                  print(bodySignals);
                  print(mood);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Check-in Saved")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text("Save Check-in"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 DATE PICKER
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  // 🔧 UI HELPERS

  Widget card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  Widget sectionCard(String title, Widget child) {
    return card(
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

  Widget chip(String text, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }

  Widget optionRow(
      String title, List<String> options, String selected, Function(String) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children: options.map((o) {
            return ChoiceChip(
              label: Text(o),
              selected: selected == o,
              onSelected: (_) => onTap(o),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}