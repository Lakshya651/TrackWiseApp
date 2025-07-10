import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'ocr_page.dart';
import 'chatbot_page.dart';
import 'pages/profile_page.dart';
import 'pages/budget_page.dart';
import 'pages/stats_page.dart';
import 'pages/daily_page.dart';
import 'personal_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local database
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox('chats');
  await Hive.openBox('ocr');
  await Hive.openBox('chatbot');

  runApp(const TrackWiseApp());
}

class TrackWiseApp extends StatelessWidget {
  const TrackWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/profile': (context) => ProfilePage(),
        '/ocr': (context) => OCRPage(),
        '/chat': (context) => ChatbotPage(),
        '/budget': (context) => BudgetPage(),
        '/stats': (context) => StatsPage(),
        '/daily': (context) => DailyPage(),
        '/personal_details': (context) => const PersonalDetailsPage(),
      },
    );
  }
}
