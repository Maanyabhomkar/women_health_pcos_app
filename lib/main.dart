import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint(' Firebase init error: $e');
  }

  runApp(const WomenHealthApp());
}


/* ================= USER DATA (GLOBAL) ================= */

class AppUser {
  static String name = '';
  static String age = '';
  static String weight = '';
  static String phone = '';
  static String email = '';
  static String password = '';
}

/* ================= APP ROOT ================= */

class WomenHealthApp extends StatelessWidget {
  const WomenHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women Health Companion',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF1F6),
      ),
      home: const GetStartedScreen(),
    );
  }
}

/* ================= GET STARTED ================= */

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 90, color: Colors.pink),
              const SizedBox(height: 20),
              const Text(
                'Women Health Companion',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: const Text('Get Started'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthChoiceScreen(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= AUTH CHOICE ================= */

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'New users must Sign Up first.\nLogin is only for registered users.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                child: const Text('Login'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= SIGN UP ================= */


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final age = TextEditingController();
  final weight = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field('Name', name),
              _field('Age', age, number: true),
              _field('Weight (kg)', weight, number: true),
              _field('Phone', phone, number: true),
              _emailField(),
              _passwordField(password, 'Password'),
              _confirmPasswordField(),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _signUpUser,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ---------------- SIGN UP LOGIC (FIREBASE) ---------------- */

  Future<void> _signUpUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 1️⃣ Create user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // 2️⃣ Store extra details in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name.text.trim(),
        'age': age.text.trim(),
        'weight': weight.text.trim(),
        'phone': phone.text.trim(),
        'email': email.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3️⃣ Store locally for profile display
      AppUser.name = name.text;
      AppUser.age = age.text;
      AppUser.weight = weight.text;
      AppUser.phone = phone.text;
      AppUser.email = email.text;
      AppUser.password = password.text;

      // 4️⃣ Navigate to Home
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Something went wrong';

      if (e.code == 'email-already-in-use') {
        msg = 'Email already registered';
      } else if (e.code == 'weak-password') {
        msg = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        msg = 'Invalid email address';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  /* ---------------- FORM FIELDS ---------------- */

  Widget _field(String label, TextEditingController c,
      {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        inputFormatters:
            number ? [FilteringTextInputFormatter.digitsOnly] : null,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (!v.contains('@') || !v.contains('.')) {
            return 'Enter valid email';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _passwordField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        obscureText: true,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (v.length < 6) return 'Minimum 6 characters';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: confirm,
        obscureText: true,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (v != password.text) return 'Passwords do not match';
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
/* ================= LOGIN ================= */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _emailField(),
              _passwordField(),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _loginUser,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ---------------- LOGIN LOGIC (FIREBASE) ---------------- */

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 1️⃣ Login with Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // 2️⃣ Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      // 3️⃣ Store data locally for profile
      AppUser.name = userDoc['name'];
      AppUser.age = userDoc['age'];
      AppUser.weight = userDoc['weight'];
      AppUser.phone = userDoc['phone'];
      AppUser.email = userDoc['email'];

      // 4️⃣ Navigate to Home
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Login failed';

      if (e.code == 'user-not-found') {
        msg = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        msg = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        msg = 'Invalid email';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  /* ---------------- FORM FIELDS ---------------- */

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (!v.contains('@') || !v.contains('.')) {
            return 'Enter valid email';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: password,
        obscureText: true,
        validator: (v) =>
            v == null || v.isEmpty ? 'Required' : null,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
/* ================= RISK ASSESSMENT ================= */

class RiskAssessmentScreen extends StatefulWidget {
  const RiskAssessmentScreen({super.key});

  @override
  State<RiskAssessmentScreen> createState() => _RiskAssessmentScreenState();
}

class _RiskAssessmentScreenState extends State<RiskAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final age = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();

  final Map<String, bool> yesNo = {
    'Period Regularity': false,
    'Recent Weight Gain': false,
    'Excessive Hair Growth': false,
    'Skin Darkening': false,
    'Hair Loss / Thinning': false,
    'Acne': false,
  };

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PCOS Risk Assessment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _numberField('Age (years)', age),
              _numberField('Height (cm)', height),
              _numberField('Weight (kg)', weight),
              const SizedBox(height: 20),

              ...yesNo.keys.map((q) {
                return SwitchListTile(
                  title: Text(q),
                  value: yesNo[q]!,
                  activeColor: Colors.pink,
                  onChanged: (v) => setState(() => yesNo[q] = v),
                );
              }),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitAssessment,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('View Result'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ---------------- LOGIC ---------------- */

  Future<void> _submitAssessment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    int score = yesNo.values.where((v) => v).length;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) throw Exception('User not logged in');

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('risk_assessments')
          .doc(user.uid)
          .set({
        'age': age.text,
        'height': height.text,
        'weight': weight.text,
        'answers': yesNo,
        'score': score,
        'risk': _riskLevel(score),
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: score),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _riskLevel(int score) {
    if (score <= 2) return 'Low Risk';
    if (score <= 4) return 'Moderate Risk';
    return 'High Risk';
  }

  /* ---------------- FIELDS ---------------- */

  Widget _numberField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/* ================= RESULT ================= */

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({super.key, required this.score});

  String get risk {
    if (score <= 2) return 'Low Risk';
    if (score <= 4) return 'Moderate Risk';
    return 'High Risk';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              risk,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'PCOS Risk Score: $score',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              child: const Text('Go to Home'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}


/* ================= HOME WITH BOTTOM NAV ================= */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final List<Widget> screens = const [
    HomeTab(),
    AboutTab(),
    ChatTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------------- APP BAR ----------------
      appBar: AppBar(
        title: const Text('Women Health Companion'),
        backgroundColor: Colors.pink,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: SafeArea(
        child: screens[index],
      ),

      // ---------------- BOTTOM NAV ----------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.pink.shade300,
        selectedFontSize: 12,
        unselectedFontSize: 12,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
/* ================= TABS ================= */

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome 👋',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Take care of your health today',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          _homeCard(
            context,
            icon: Icons.favorite,
            title: 'PCOS Risk Assessment',
            subtitle: 'Check your PCOS risk level',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RiskAssessmentScreen(),
                ),
              );
            },
          ),

          _homeCard(
            context,
            icon: Icons.calendar_month,
            title: 'Period Tracker',
            subtitle: 'Track your period dates',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PeriodTrackerScreen(),
                ),
              );
            },
          ),

          _homeCard(
            context,
            icon: Icons.analytics,
            title: 'View Results',
            subtitle: 'See your assessment result',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Result already shown after assessment'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _homeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade100,
          child: Icon(icon, color: Colors.pink),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  Widget infoCard(String title, String content, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.pink),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Text(content),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        infoCard(
          'What is PCOS?',
          'Polycystic Ovary Syndrome (PCOS) is a hormonal disorder affecting women of reproductive age.',
          Icons.favorite,
        ),
        infoCard(
          'Common Symptoms',
          '• Irregular periods\n• Weight gain\n• Acne\n• Hair thinning\n• Excess hair growth',
          Icons.warning,
        ),
        infoCard(
          'Causes',
          'Hormonal imbalance, insulin resistance, genetics, and lifestyle factors.',
          Icons.science,
        ),
        infoCard(
          'Prevention & Management',
          'Healthy diet, regular exercise, stress control, and medical guidance.',
          Icons.health_and_safety,
        ),
      ],
    );
  }
}


class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages = [
    {'bot': 'Hi 💕 I’m here for you. You can talk to me about PCOS or your health.'}
  ];

  String reply(String msg) {
    msg = msg.toLowerCase();

    if (msg.contains('pcos')) {
      return 'PCOS is a hormonal condition. Many women manage it successfully 💗';
    } else if (msg.contains('period')) {
      return 'Irregular periods are common in PCOS. Tracking helps a lot.';
    } else if (msg.contains('diet')) {
      return 'A balanced diet with low sugar and regular exercise is helpful.';
    } else if (msg.contains('stress')) {
      return 'Stress can worsen symptoms. Take care of yourself 🌸';
    } else {
      return 'I’m listening. Tell me more 💬';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: messages.map((m) {
              final isBot = m.containsKey('bot');
              return Align(
                alignment:
                    isBot ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isBot
                        ? Colors.grey.shade300
                        : Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(isBot ? m['bot']! : m['user']!),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(hintText: 'Type your message...'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.pink),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      messages.add({'user': controller.text});
                      messages.add({'bot': reply(controller.text)});
                    });
                    controller.clear();
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}


class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.pink,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(AppUser.name),
          Text(AppUser.email),
          Text(AppUser.phone),
          Text('Age: ${AppUser.age}'),
          Text('Weight: ${AppUser.weight} kg'),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.pink),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const GetStartedScreen()),
                (r) => false,
              );
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.color_lens, color: Colors.pink),
            title: Text('Theme'),
            subtitle: Text('Light / Dark (future scope)'),
          ),
        ],
      ),
    );
  }
}

/* ================= PERIOD TRACKER ================= */

class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({super.key});

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime? predictedNextPeriod;

  static const int averageCycleLength = 28;

  Future<void> _pickDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          predictedNextPeriod = null;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _calculateNextPeriod() {
    if (startDate == null) return;

    predictedNextPeriod =
        startDate!.add(const Duration(days: averageCycleLength));
  }

  Future<void> _savePeriodToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await FirebaseFirestore.instance
        .collection('periods')
        .doc(user.uid)
        .collection('records')
        .add({
      'startDate': Timestamp.fromDate(startDate!),
      'endDate': Timestamp.fromDate(endDate!),
      'predictedNextPeriod': Timestamp.fromDate(predictedNextPeriod!),
      'cycleLength': averageCycleLength,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track Your Period 🌸',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            _dateCard(
              title: 'Period Start Date',
              date: _formatDate(startDate),
              onTap: () => _pickDate(true),
            ),

            _dateCard(
              title: 'Period End Date',
              date: _formatDate(endDate),
              onTap: () => _pickDate(false),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text('Predict Next Period'),
                onPressed: () async {
                  if (startDate == null || endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select both dates'),
                      ),
                    );
                    return;
                  }

                  try {
                    _calculateNextPeriod();
                    await _savePeriodToFirestore();

                    int duration =
                        endDate!.difference(startDate!).inDays + 1;

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Period Prediction'),
                        content: Text(
                          'Next Period: ${_formatDate(predictedNextPeriod)}\n'
                          'Duration: $duration days',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateCard({
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_month, color: Colors.pink),
        title: Text(title),
        subtitle: Text(date),
        trailing: const Icon(Icons.edit, color: Colors.pink),
        onTap: onTap,
      ),
    );
  }
}
