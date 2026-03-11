import 'package:flutter/material.dart';
import '../features/log_symptom_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with SingleTickerProviderStateMixin {

  DateTime lastPeriod = DateTime.now().subtract(const Duration(days: 14));
  int cycleLength = 28;

  late AnimationController controller;
  late Animation<double> buttonScale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    buttonScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  DateTime get nextPeriod =>
      lastPeriod.add(Duration(days: cycleLength));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF8D0E6),
            Color(0xFFE1BEE7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              "women_health_pcos_app ✨",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text("Your Cycle Partner 💕"),

            const SizedBox(height: 30),

            Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE91E63),
                    Color(0xFFAB47BC),
                  ],
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Next Period:",
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${nextPeriod.day}/${nextPeriod.month}/${nextPeriod.year}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  infoCard(Icons.calendar_today, "Cycle Length",
                      "$cycleLength Days"),
                  infoCard(Icons.favorite_border,
                      "Fertile Window", "Open: Yes"),
                  infoCard(Icons.water_drop_outlined,
                      "Symptoms", "Log Today"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ScaleTransition(
              scale: buttonScale,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LogSymptomsScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE91E63),
                        Color(0xFFAB47BC),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "+ Log Today's Symptoms",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget infoCard(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE91E63)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}