import 'package:flutter/material.dart';

class CycleTrackerScreen extends StatefulWidget {
  const CycleTrackerScreen({super.key});

  @override
  State<CycleTrackerScreen> createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends State<CycleTrackerScreen> {

  DateTime selectedMonth = DateTime(2026, 10);
  DateTime selectedDay = DateTime(2026, 10, 14);

  DateTime lastPeriodDate = DateTime(2026, 10, 1);
  int cycleLength = 28;
  int periodLength = 5;

  List<DateTime> periodDays = [];
  List<DateTime> fertileDays = [];
  DateTime? ovulationDay;
  List<DateTime> predictedDays = [];

  @override
  void initState() {
    super.initState();
    calculateCycle();
  }

  void calculateCycle() {
    periodDays.clear();
    fertileDays.clear();
    predictedDays.clear();

    for (int i = 0; i < periodLength; i++) {
      periodDays.add(lastPeriodDate.add(Duration(days: i)));
    }

    ovulationDay = lastPeriodDate.add(Duration(days: cycleLength - 14));

    for (int i = -4; i <= 1; i++) {
      fertileDays.add(ovulationDay!.add(Duration(days: i)));
    }

    for (int i = 0; i < periodLength; i++) {
      predictedDays.add(
        lastPeriodDate.add(Duration(days: cycleLength + i)),
      );
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.day == b.day &&
        a.month == b.month &&
        a.year == b.year;
  }

  Color? getFillColor(DateTime day) {
    if (periodDays.any((d) => isSameDay(d, day))) {
      return Colors.deepPurple;
    }
    if (fertileDays.any((d) => isSameDay(d, day))) {
      return Colors.pink.shade200;
    }
    if (predictedDays.any((d) => isSameDay(d, day))) {
      return Colors.purple.shade100;
    }
    return null;
  }

  bool isOvulation(DateTime day) {
    return ovulationDay != null && isSameDay(ovulationDay!, day);
  }

  @override
  Widget build(BuildContext context) {

    int daysInMonth =
        DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month);

    DateTime nextPeriod =
        lastPeriodDate.add(Duration(days: cycleLength));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cycle Tracker"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            // 🔥 CALENDAR CARD
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  // Month + Phase
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back_ios, size: 16),
                      Column(
                        children: const [
                          Text("October 2026",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text("Current Phase: Follicular",
                              style: TextStyle(color: Colors.purple)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Weekdays
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("S"), Text("M"), Text("T"),
                      Text("W"), Text("T"), Text("F"), Text("S"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Calendar Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: daysInMonth,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7),
                    itemBuilder: (context, index) {

                      DateTime day = DateTime(
                          selectedMonth.year,
                          selectedMonth.month,
                          index + 1);

                      Color? fill = getFillColor(day);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = day;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: fill,
                            shape: BoxShape.circle,
                            border: isSameDay(day, selectedDay)
                                ? Border.all(color: Colors.purple, width: 2)
                                : null,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                              Text("${index + 1}",
                                  style: const TextStyle(fontSize: 12)),

                              // 🔴 Ovulation Ring
                              if (isOvulation(day))
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.red, width: 2),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Legend(color: Colors.deepPurple, text: "PERIOD"),
                      Legend(color: Colors.pink, text: "FERTILE"),
                      Legend(color: Colors.red, text: "OVULATION"),
                      Legend(color: Colors.grey, text: "PREDICTED"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 NEXT PERIOD CARD
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text("Next Period Expected"),
                  const SizedBox(height: 5),
                  Text(
                    "Oct ${nextPeriod.day}",
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text("Likely window: Oct 26 – Nov 2"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 STATS
            Row(
              children: [
                Expanded(
                  child: statCard("Average Cycle Length", "$cycleLength Days"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: statCard("Average Period Length", "$periodLength Days"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}