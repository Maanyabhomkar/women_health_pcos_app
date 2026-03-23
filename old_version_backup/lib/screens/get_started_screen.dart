import 'package:flutter/material.dart';
import 'register_option_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {

  late AnimationController heartController;
  late AnimationController buttonController;
  late Animation<double> buttonScale;

  @override
  void initState() {
    super.initState();

    /* ---------- HEART FLOATING CONTROLLER ---------- */
    heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    /* ---------- BUTTON BREATHING CONTROLLER ---------- */
    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    buttonScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    heartController.dispose();
    buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /* ---------- BACKGROUND ---------- */
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFD6E7),
                  Color(0xFFF8BBD0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /* ---------- FLOATING HEARTS ---------- */
          AnimatedBuilder(
            animation: heartController,
            builder: (context, child) {
              return Stack(
                children: [

                  Positioned(
                    top: 100 + heartController.value * 20,
                    left: 40,
                    child: const Icon(Icons.favorite,
                        color: Colors.pink, size: 22),
                  ),

                  Positioned(
                    bottom: 150 + heartController.value * 30,
                    right: 50,
                    child: const Icon(Icons.favorite_border,
                        color: Colors.pinkAccent, size: 26),
                  ),

                  Positioned(
                    top: 250 - heartController.value * 25,
                    right: 80,
                    child: const Icon(Icons.favorite,
                        color: Colors.pinkAccent, size: 18),
                  ),

                  Positioned(
                    bottom: 300 - heartController.value * 20,
                    left: 90,
                    child: const Icon(Icons.favorite_border,
                        color: Colors.pink, size: 20),
                  ),
                ],
              );
            },
          ),

          /* ---------- MAIN CONTENT ---------- */
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  "women_health_pcos_app 💜",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Your Cycle Partner ✨",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 60),

                /* ---------- BOUNCING BUTTON ---------- */
                ScaleTransition(
                  scale: buttonScale,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      elevation: 10,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RegisterOptionScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


