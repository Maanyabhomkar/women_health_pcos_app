import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'log_symptom_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const women_health_pcos_appApp());
}

/* =========================================================
   MAIN APP WITH THEME SUPPORT
========================================================= */

class women_health_pcos_appApp extends StatefulWidget {
  const women_health_pcos_appApp({super.key});

  @override
  State<women_health_pcos_appApp> createState() => _women_health_pcos_appAppState();
}

class _women_health_pcos_appAppState extends State<women_health_pcos_appApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primaryColor: const Color(0xFFE91E63),
        scaffoldBackgroundColor: const Color(0xFFFFF1F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.dark,
        ),
      ),
      home: AuthGate(toggleTheme: toggleTheme),
    );
  }
}

/* =========================================================
   AUTH GATE (AUTO LOGIN CHECK)
========================================================= */

class AuthGate extends StatelessWidget {
  final VoidCallback toggleTheme;

  const AuthGate({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return MainHome(toggleTheme: toggleTheme);
        }

        return const GetStartedScreen();
      },
    );
  }
}


/* =========================================================
   GET STARTED SCREEN
========================================================= */
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
/* =========================================================
   REGISTER OPTION SCREEN
========================================================= */

class RegisterOptionScreen extends StatelessWidget {
  const RegisterOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Welcome 💜",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "New users must Sign Up first.\nLogin is only for registered users.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  SignUpScreen(),
                  ),
                );
              },
              child: const Text("Sign Up"),
            ),

            const SizedBox(height: 15),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================================================
   MAIN HOME 
========================================================= */

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

/*home tab */
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

            /* ---------- CIRCLE ---------- */

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

            /* ---------- LOG SYMPTOMS BUTTON ---------- */

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
/* =========================================================
   LOG SYMPTOMS SCREEN*/
   class LogSymptomsScreen extends StatefulWidget {
  const LogSymptomsScreen({super.key});

  @override
  State<LogSymptomsScreen> createState() => _LogSymptomsScreenState();
}

class _LogSymptomsScreenState extends State<LogSymptomsScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  bool cramps = false;
  bool moodSwings = false;
  bool headache = false;
  bool acne = false;
  String notes = "";

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  Future<void> saveSymptoms() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("symptoms")
        .add({
      "uid": user.uid,
      "cramps": cramps,
      "moodSwings": moodSwings,
      "headache": headache,
      "acne": acne,
      "notes": notes,
      "date": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Symptoms Saved 💕")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Today's Symptoms"),
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              CheckboxListTile(
                title: const Text("Cramps"),
                value: cramps,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => cramps = val!);
                },
              ),

              CheckboxListTile(
                title: const Text("Mood Swings"),
                value: moodSwings,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => moodSwings = val!);
                },
              ),

              CheckboxListTile(
                title: const Text("Headache"),
                value: headache,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => headache = val!);
                },
              ),

              CheckboxListTile(
                title: const Text("Acne"),
                value: acne,
                activeColor: Colors.pink,
                onChanged: (val) {
                  setState(() => acne = val!);
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Additional Notes",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => notes = val,
              ),

              const SizedBox(height: 30),

              ScaleTransition(
                scale: scaleAnimation,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: saveSymptoms,
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* Risk assessment screen*/
class RiskAssessmentScreen extends StatefulWidget {
  const RiskAssessmentScreen({super.key});

  @override
  State<RiskAssessmentScreen> createState() =>
      _RiskAssessmentScreenState();
}

class _RiskAssessmentScreenState
    extends State<RiskAssessmentScreen> {

  final ageController = TextEditingController();
  final weightController = TextEditingController();

  bool irregular = false;
  bool weightGain = false;
  bool hairGrowth = false;
  bool acne = false;

  String result = "";

  void calculateRisk() {
    int score = 0;

    if (irregular) score++;
    if (weightGain) score++;
    if (hairGrowth) score++;
    if (acne) score++;

    if (score <= 1) {
      result = "Low Risk";
    } else if (score == 2) {
      result = "Moderate Risk";
    } else {
      result = "High Risk";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PCOS Risk")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: ageController,
              decoration:
                  const InputDecoration(labelText: "Age"),
            ),

            TextField(
              controller: weightController,
              decoration:
                  const InputDecoration(labelText: "Weight"),
            ),

            SwitchListTile(
              title: const Text("Irregular Period"),
              value: irregular,
              onChanged: (v) => setState(() => irregular = v),
            ),

            SwitchListTile(
              title: const Text("Recent Weight Gain"),
              value: weightGain,
              onChanged: (v) =>
                  setState(() => weightGain = v),
            ),

            SwitchListTile(
              title:
                  const Text("Excessive Hair Growth"),
              value: hairGrowth,
              onChanged: (v) =>
                  setState(() => hairGrowth = v),
            ),

            SwitchListTile(
              title: const Text("Acne"),
              value: acne,
              onChanged: (v) =>
                  setState(() => acne = v),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateRisk,
              child: const Text("Check Risk"),
            ),

            const SizedBox(height: 20),

            Text(
              result,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================================================
   LOGIN SCREEN
========================================================= */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController buttonController;
  late Animation<double> buttonScale;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    buttonScale = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => MainHome(
      toggleTheme: () {},
    ),
  ),
  (route) => false,
);


    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login Failed")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(height: 20),

              const Text(
                "Welcome Back 💜",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /* ---------- EMAIL FIELD ---------- */
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!value.contains("@") ||
                      !value.contains(".")) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /* ---------- PASSWORD FIELD ---------- */
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Minimum 6 characters required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 35),

              /* ---------- BOUNCING LOGIN BUTTON ---------- */
              ScaleTransition(
                scale: buttonScale,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: loading ? null : login,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   SIGN UP SCREEN
========================================================= */

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late AnimationController buttonController;
  late Animation<double> buttonScale;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    buttonScale = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .set({
        "name": nameController.text.trim(),
        "age": ageController.text.trim(),
        "weight": weightController.text.trim(),
        "phone": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => MainHome(
      toggleTheme: () {},
    ),
  ),
  (route) => false,
);


    } on FirebaseAuthException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message ?? "Signup Failed")),
  );
}

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildField(nameController, "Full Name"),

              _buildField(ageController, "Age",
                  isNumber: true),

              _buildField(weightController, "Weight (kg)",
                  isNumber: true),

              _buildField(phoneController, "Phone Number",
                  isPhone: true),

              _buildField(emailController, "Email",
                  isEmail: true),

              _buildField(passwordController, "Password",
                  isPassword: true),

              _buildField(confirmPasswordController,
                  "Confirm Password",
                  isConfirm: true),

              const SizedBox(height: 30),

              ScaleTransition(
                scale: buttonScale,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: loading ? null : signup,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text(
                          "Create Account",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* =========================================================
     FIELD BUILDER WITH VALIDATION
  ========================================================= */

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isPhone = false,
    bool isEmail = false,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword || isConfirm,
        keyboardType:
            isNumber || isPhone ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }

          if (isPhone &&
              (!RegExp(r'^[0-9]{10}$')
                  .hasMatch(value))) {
            return "Enter valid 10 digit number";
          }

          if (isEmail &&
              (!value.contains("@") ||
                  !value.contains("."))) {
            return "Enter valid email";
          }

          if (isPassword &&
              !RegExp(r'^(?=.*[@#\$%]).{6,}$')
                  .hasMatch(value)) {
            return "Min 6 chars + 1 special (@#\$%)";
          }

          if (isConfirm &&
              value != passwordController.text) {
            return "Passwords do not match";
          }

          return null;
        },
      ),
    );
  }
}

/*chat tab */

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

  // ================= AI LOGIC =================

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

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FF),
      body: Column(
        children: [

          /// HEADER
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

          /// QUICK PROMPTS
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

          /// CHAT AREA
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

          /// INPUT
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
/*Period tracker tab */

class PeriodTrackerTab extends StatefulWidget {
  const PeriodTrackerTab({super.key});

  @override
  State<PeriodTrackerTab> createState() => _PeriodTrackerTabState();
}

class _PeriodTrackerTabState extends State<PeriodTrackerTab> {

  DateTime currentMonth = DateTime.now();
  DateTime? periodStart;

  final int cycleLength = 28;

  // ----------- DATE HELPERS ------------

  DateTime get firstDayOfMonth =>
      DateTime(currentMonth.year, currentMonth.month, 1);

  int get daysInMonth =>
      DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

  int get startWeekday => firstDayOfMonth.weekday % 7;

  // ----------- CYCLE CALCULATIONS ------------

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
        5, (i) => ovulationDay!.subtract(const Duration(days: 2)).add(Duration(days: i)));
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

          /// HEADER
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

          /// CALENDAR CARD
          Container(
            width: 350, // <<< FIXED SMALL WIDTH
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

                /// MONTH HEADER
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

                /// WEEKDAYS
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: const [
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

                /// DAYS GRID
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

                /// LEGEND
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

          /// RESULT
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

/// WEEK LABEL
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

/// LEGEND
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

/* =========================================================
   PROFILE TAB*/
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

  // 🔥 FETCH LOGGED IN USER DATA FROM FIRESTORE
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

              /// HEADER
              const Text(
                "Profile 👩",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// USER CARD
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

              /// QUICK STATS
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

              /// LOGOUT
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

  // ---------- STAT CARD ----------
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

  // ---------- MENU ITEM ----------
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


/*-------========------------PCOSTAB --------=======-------------*/

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

  // ---------------- QUESTION SCREEN ----------------

  Widget buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADER
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

        /// PROGRESS
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

        /// QUESTION CARD
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

        /// RESULT BUTTON
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

  // ---------------- RESULT SCREEN ----------------

  Widget buildResult() {
    double percentage =
        yesCount / questions.length;

    return SingleChildScrollView(
      child: Column(
        children: [

          const SizedBox(height: 20),

          /// CIRCLE INDICATOR
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

          /// RECOMMENDATIONS
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

