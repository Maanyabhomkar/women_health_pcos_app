import 'package:flutter/material.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> messages = [
    {
      "role": "assistant",
      "content":
          "Hi! I'm women_health_companion AI 💕 I can help you with period tracking, PCOS questions, fertility insights, and wellness tips. How can I help you today?"
    }
  ];

  final List<String> quickPrompts = [
    "Why is my period late?",
    "PCOS symptoms to watch",
    "Tips for period cramps",
    "Fertility window explained",
  ];

  String getAIResponse(String question) {
    String q = question.toLowerCase();

    if (q.contains("pcos")) {
      return "PCOS (Polycystic Ovary Syndrome) is a hormonal condition that may cause irregular periods, weight gain, acne, and hair growth. Balanced diet, exercise, and stress control help manage it. 💜";
    }

    if (q.contains("late")) {
      return "A late period can happen due to stress, hormonal imbalance, thyroid issues, weight changes, or PCOS. If it's more than 2 weeks late, consider consulting a doctor.";
    }

    if (q.contains("fertile") || q.contains("ovulation")) {
      return "Ovulation usually happens about 14 days before your next period. Your fertile window is 5 days before ovulation plus ovulation day.";
    }

    if (q.contains("cramps")) {
      return "Cramps are caused by uterine contractions. Heat pads, hydration, light exercise, and magnesium-rich foods may help reduce pain. 🌸";
    }

    return "Tracking your cycle regularly helps detect patterns. If symptoms continue, please consult a gynecologist. I'm here to help! 💕";
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": text});
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        messages.add({
          "role": "assistant",
          "content": getAIResponse(text)
        });
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FF),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8BBD0), Color(0xFFE1BEE7)],
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.smart_toy, color: Colors.white),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("women_health_pcos_app AI 🤖",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text("Your Health Assistant",
                        style: TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
          ),

          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: quickPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ActionChip(
                    label: Text(prompt, style: const TextStyle(fontSize: 11)),
                    backgroundColor: const Color(0xFFEDE7F6),
                    onPressed: () => sendMessage(prompt),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isUser = msg["role"] == "user";

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 260),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF9C27B0),
                                Color(0xFFE91E63)
                              ],
                            )
                          : null,
                      color:
                          isUser ? null : const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg["content"]!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isUser
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText:
                            "Ask women_health_pcos_app about PMS, tracking, or PCOS...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () =>
                      sendMessage(_controller.text),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF9C27B0),
                          Color(0xFFE91E63)
                        ],
                      ),
                    ),
                    child: const Icon(Icons.send,
                        color: Colors.white, size: 18),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}