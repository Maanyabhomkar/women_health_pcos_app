import 'package:flutter/material.dart';

class PeriodTrackerTab extends StatefulWidget {
  const PeriodTrackerTab({super.key});

  @override
  State<PeriodTrackerTab> createState() => _PeriodTrackerTabState();
}

class _PeriodTrackerTabState extends State<PeriodTrackerTab> {

  DateTime currentMonth = DateTime.now();
  DateTime? periodStart;

  final int cycleLength = 28;

  DateTime get firstDayOfMonth =>
      DateTime(currentMonth.year, currentMonth.month, 1);

  int get daysInMonth =>
      DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

  int get startWeekday => firstDayOfMonth.weekday % 7;

  List<DateTime> get periodDays {
    if (periodStart == null) return [];
    return List.generate(5, (i) => periodStart!.add(Duration(days: i)));
  }

  DateTime? get ovulationDay {
    if (periodStart == null) return null;
    return periodStart!.add(const Duration(days: 14));
  }

  List<DateTime> get fertileDays {
    if (ovulationDay == null) return [];
    return List.generate(
        5,
        (i) => ovulationDay!
            .subtract(const Duration(days: 2))
            .add(Duration(days: i)));
  }

  DateTime? get nextPeriod {
    if (periodStart == null) return null;
    return periodStart!.add(Duration(days: cycleLength));
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Color getDayColor(DateTime day) {
    if (periodDays.any((d) => isSameDate(d, day)))
      return const Color(0xFFE91E63);
    if (ovulationDay != null && isSameDate(ovulationDay!, day))
      return const Color(0xFF9C27B0);
    if (fertileDays.any((d) => isSameDate(d, day)))
      return const Color(0xFFFFB74D);
    return Colors.transparent;
  }

  Color getTextColor(DateTime day) {
    return getDayColor(day) == Colors.transparent
        ? Colors.black87
        : Colors.white;
  }

  void changeMonth(int offset) {
    setState(() {
      currentMonth =
          DateTime(currentMonth.year, currentMonth.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 35, 20, 15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8BBD0), Color(0xFFF3E5F5)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Period Tracker 🌸",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Select first day of your period",
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Container(
            width: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F0F6),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(blurRadius: 8, color: Colors.black12)
              ],
            ),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => changeMonth(-1),
                        icon: const Icon(Icons.chevron_left)),
                    Text(
                      "${_monthName(currentMonth.month)} ${currentMonth.year}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        onPressed: () => changeMonth(1),
                        icon: const Icon(Icons.chevron_right)),
                  ],
                ),

                const SizedBox(height: 8),

                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _WeekLabel("Sun"),
                    _WeekLabel("Mon"),
                    _WeekLabel("Tue"),
                    _WeekLabel("Wed"),
                    _WeekLabel("Thu"),
                    _WeekLabel("Fri"),
                    _WeekLabel("Sat"),
                  ],
                ),

                const SizedBox(height: 6),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daysInMonth + startWeekday,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    if (index < startWeekday) {
                      return const SizedBox();
                    }

                    int dayNumber = index - startWeekday + 1;
                    DateTime fullDate = DateTime(
                        currentMonth.year,
                        currentMonth.month,
                        dayNumber);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          periodStart = fullDate;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getDayColor(fullDate),
                        ),
                        child: Text(
                          "$dayNumber",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: getTextColor(fullDate),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    LegendDot(color: Color(0xFFE91E63), label: "Period"),
                    LegendDot(color: Color(0xFFFFB74D), label: "Fertile"),
                    LegendDot(color: Color(0xFF9C27B0), label: "Ovulation"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (nextPeriod != null)
            Container(
              width: 350,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9C27B0),
                    Color(0xFFE91E63),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Next Period: ${nextPeriod!.day} ${_monthName(nextPeriod!.month)}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Ovulation: ${ovulationDay!.day} ${_monthName(ovulationDay!.month)}",
                    style: const TextStyle(
                        color: Colors.white70),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month];
  }
}

class _WeekLabel extends StatelessWidget {
  final String text;
  const _WeekLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const LegendDot({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}