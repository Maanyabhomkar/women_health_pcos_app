import 'package:flutter/material.dart';

class PCOSTab extends StatefulWidget {
  const PCOSTab({super.key});

  @override
  State<PCOSTab> createState() => _PCOSTabState();
}

class _PCOSTabState extends State<PCOSTab>
    with TickerProviderStateMixin {
  int currentStep = 0;
  bool showResult = false;

  final List<Map<String, dynamic>> questions = [
    {"text": "Do you experience irregular periods?", "emoji": "🩸"},
    {"text": "Excess hair growth on face/body?", "emoji": "🪒"},
    {"text": "Persistent acne or oily skin?", "emoji": "✨"},
    {"text": "Unexplained weight gain?", "emoji": "⚖️"},
    {"text": "Hair thinning or hair loss?", "emoji": "💇‍♀️"},
    {"text": "Difficulty getting pregnant?", "emoji": "🤰"},
    {"text": "Pelvic pain?", "emoji": "💜"},
    {"text": "Dark patches on skin?", "emoji": "🌙"},
    {"text": "Frequent fatigue?", "emoji": "😴"},
    {"text": "Mood swings or anxiety?", "emoji": "🎭"},
  ];

  List<bool?> answers = List.filled(10, null);

  int get yesCount =>
      answers.where((e) => e == true).length;

  double get progress =>
      answers.where((e) => e != null).length /
      questions.length;

  String get riskLevel {
    if (yesCount <= 2) return "Low";
    if (yesCount <= 5) return "Moderate";
    return "High";
  }

  Color get riskColor {
    if (yesCount <= 2) return Colors.green;
    if (yesCount <= 5) return Colors.orange;
    return Colors.red;
  }

  void answer(bool value) {
    setState(() {
      answers[currentStep] = value;

      if (currentStep < questions.length - 1) {
        currentStep++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6ECF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: showResult
              ? buildResult()
              : buildQuestion(),
        ),
      ),
    );
  }

  Widget buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: const [
            Icon(Icons.favorite,
                color: Colors.purple),
            SizedBox(width: 10),
            Text(
              "PCOS Risk Check",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text("Progress"),
            Text(
              "${answers.where((e) => e != null).length}/${questions.length}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          borderRadius:
              BorderRadius.circular(10),
          backgroundColor: Colors.white,
          color: Colors.purple,
        ),

        const SizedBox(height: 30),

        AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 400),
          child: Container(
            key: ValueKey(currentStep),
            padding:
                const EdgeInsets.all(25),
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
            child: Column(
              children: [
                Text(
                  questions[currentStep]
                      ["emoji"],
                  style:
                      const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 15),
                Text(
                  questions[currentStep]
                      ["text"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600),
                ),
                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            answer(true),
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              Colors.pink,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(20),
                          ),
                        ),
                        child:
                            const Text("Yes 👍"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            answer(false),
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              Colors.grey,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(20),
                          ),
                        ),
                        child:
                            const Text("No 👎"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        ElevatedButton(
          onPressed: answers
                  .where((e) => e != null)
                  .length ==
              questions.length
              ? () {
                  setState(() {
                    showResult = true;
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize:
                const Size(double.infinity, 55),
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "See My Results ✨",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget buildResult() {
    double percentage =
        yesCount / questions.length;

    return SingleChildScrollView(
      child: Column(
        children: [

          const SizedBox(height: 20),

          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 12,
                  backgroundColor:
                      Colors.grey.shade300,
                  color: riskColor,
                ),
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      riskLevel,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          color: riskColor),
                    ),
                    Text(
                        "$yesCount/${questions.length}")
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 25),

          buildRecommendation(
              "Balanced diet & fiber",
              Icons.apple),
          buildRecommendation(
              "Exercise 150 min/week",
              Icons.fitness_center),
          buildRecommendation(
              "Track symptoms in women_health_pcos_app",
              Icons.monitor_heart),

          if (yesCount > 2)
            buildRecommendation(
                "Visit a gynecologist",
                Icons.local_hospital),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              setState(() {
                showResult = false;
                answers =
                    List.filled(10, null);
                currentStep = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.grey.shade400,
              minimumSize:
                  const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),
            child: const Text("Retake Assessment"),
          )
        ],
      ),
    );
  }

  Widget buildRecommendation(
      String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.w500)))
        ],
      ),
    );
  }
}