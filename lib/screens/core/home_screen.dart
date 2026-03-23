import 'package:flutter/material.dart';
import '../extra/daily_checkin_screen.dart';
import '../core/cycle_tracker_screen.dart';
import '../core/pcos_risk_check_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      homeUI(), 
      CycleTrackerScreen(),        // ✅ FIXED (removed const)
      PCOSRiskCheckScreen(),       // ✅ FIXED (removed const)
      const Center(child: Text("Learn")),
      const Center(child: Text("Profile")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Track"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Risk Check"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Learn"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget homeUI() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Hormonal Health",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Icon(Icons.notifications_none),
                    SizedBox(width: 10),
                    Icon(Icons.settings),
                  ],
                )
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${widget.userName}! 👋",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "It’s day 14 • Follicular Phase",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      NetworkImage("https://i.pravatar.cc/150?img=3"),
                )
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("NEXT PERIOD"),
                  SizedBox(height: 5),
                  Text("Dec 24",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                  Text("in 5 days"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PCOS Risk",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Low Risk • 12%"),
                  SizedBox(height: 5),
                  Text(
                    "Based on cycle trends & symptoms",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text("QUICK ACTIONS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DailyCheckinScreen(),
                      ),
                    );
                  },
                  child: const ActionItem(
                    icon: Icons.add,
                    text: "Daily Check-in",
                  ),
                ),

                const ActionItem(
                  icon: Icons.eco,
                  text: "Guidance",
                ),

                const ActionItem(
                  icon: Icons.description,
                  text: "Health Report",
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's Tip",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(
                    "During your follicular phase, increasing water intake helps reduce cramps.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ActionItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.purple),
        ),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}