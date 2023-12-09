import 'package:daily_journal_apps/auth/auth.dart';
import 'package:daily_journal_apps/auth/login_or_register.dart';
import 'package:daily_journal_apps/firebase_options.dart';
import 'package:daily_journal_apps/pages/attendance_page.dart';
import 'package:daily_journal_apps/pages/journal_page.dart';
import 'package:daily_journal_apps/pages/profile_page.dart';
import 'package:daily_journal_apps/themes/light_mode.dart';
import 'package:daily_journal_apps/themes/dark_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightmode,
      darkTheme: darkmode,
      home: const AuthPage(),
      routes: {
        '/login_page': (context) => const LogInOrRegister(),
        '/profile_page': (context) => const ProfilePage(),
        '/attendance_page': (context) => const AttendancePage(),
        '/journal_page': (context) => const JournalPage(),
      },
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}
