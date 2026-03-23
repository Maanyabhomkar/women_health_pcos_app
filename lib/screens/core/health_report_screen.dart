import 'package:flutter/material.dart';

class HealthReportScreen extends StatelessWidget {
  const HealthReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      appBar: AppBar(
        title: const Text("Health Report"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),

        // 🔥 DOWNLOAD BUTTON
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Downloading Health Report...")),
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

            const Text(
              "Health Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              "Monthly summary based on your tracked data.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 15),

            // 🔹 Latest Assessment
            card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("LATEST ASSESSMENT",
                          style: TextStyle(fontSize: 12)),
                      SizedBox(height: 5),
                      Text("Low Risk 12%",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.bolt, color: Colors.purple),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Cycle Summary
            card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  columnItem("AVG LENGTH", "29 days"),
                  columnItem("STATUS", "Regular"),
                  columnItem("VARIATION", "±2 days"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Symptoms
            card(
              child: Column(
                children: const [
                  listItem("Acne", "5 times"),
                  listItem("Weight Gain", "2 times"),
                  listItem("Hair Growth", "2 times"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Key Insights
            card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("KEY INSIGHTS",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("• Your cycle remained stable"),
                  Text("• Acne frequency increased"),
                  Text("• Risk level remained stable"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 DOWNLOAD BUTTON
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "Download Health Report (PDF)",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 UI Helpers

  Widget card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

// 🔹 Small widgets

class columnItem extends StatelessWidget {
  final String title;
  final String value;

  const columnItem(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 10)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class listItem extends StatelessWidget {
  final String title;
  final String value;

  const listItem(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(value),
    );
  }
}