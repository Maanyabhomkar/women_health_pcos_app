import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'period_tracker_tab.dart';
import 'chat_tab.dart';
import 'pcos_tab.dart';
import 'profile_tab.dart';

class MainHome extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MainHome({super.key, required this.toggleTheme});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {

  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeTab(),
    const PeriodTrackerTab(),
    const ChatTab(),
    const PCOSTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE91E63),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Tracker"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "AI Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.monitor_heart_outlined),
              label: "PCOS"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile"),
        ],
      ),
    );
  }
}