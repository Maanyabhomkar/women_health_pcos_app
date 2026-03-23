import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String name = "";
  int cycleLength = 28;
  DateTime? periodStart;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          name = doc["username"] ?? "User";
          cycleLength = doc["cycleLength"] ?? 28;

          if (doc["periodStart"] != null) {
            periodStart =
                (doc["periodStart"] as Timestamp).toDate();
          }
        });
      }
    }
  }

  int get cycleDay {
    if (periodStart == null) return 0;
    return DateTime.now()
            .difference(periodStart!)
            .inDays %
        cycleLength +
        1;
  }

  String get phase {
    if (cycleDay >= 12 && cycleDay <= 16) {
      return "Fertile Phase 🌸";
    } else if (cycleDay <= 5) {
      return "Period Phase 🩸";
    }
    return "Cycle Day $cycleDay";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6ECF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Text(
                "Profile 👩",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12)
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFBA68C8),
                            Color(0xFFE91E63)
                          ],
                        ),
                      ),
                      child: const Icon(Icons.person,
                          size: 35,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty
                              ? "Loading..."
                              : name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          periodStart == null
                              ? "No cycle data"
                              : "Cycle Day $cycleDay · $phase",
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  buildStatCard("12", "Cycles Tracked"),
                  buildStatCard(
                      "$cycleLength d", "Avg Length"),
                  buildStatCard("45 days", "Streak"),
                ],
              ),

              const SizedBox(height: 30),

              buildMenuItem(Icons.calendar_today,
                  "Cycle Settings",
                  "Adjust cycle length & reminders"),

              buildMenuItem(Icons.notifications,
                  "Notifications",
                  "Period & fertile alerts"),

              buildMenuItem(Icons.lock,
                  "Privacy & Data",
                  "Manage your health data"),

              buildMenuItem(Icons.dark_mode,
                  "Appearance",
                  "Theme & display settings"),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signOut();

                  Navigator.pushReplacementNamed(
                      context, "/login");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey.shade300,
                  minimumSize: const Size(
                      double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight:
                          FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color: Colors.purple),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget buildMenuItem(
      IconData icon,
      String title,
      String subtitle) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  Colors.purple.shade100,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: Colors.purple),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight:
                            FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}