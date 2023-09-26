import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bharatekrishi/SplashScreen/splash_screen.dart';
import 'package:bharatekrishi/Dashbord/dashbord_screen.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id') ?? '0';
  runApp(MyApp(userId: userId));
}

class MyApp extends StatefulWidget {
  final String? userId;
  const MyApp({super.key, this.userId});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    saveLanguage();
    super.initState();
  }

  saveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var lan = prefs.getString('choosenlan') ?? 'hi';
    setState(() {
      choosenLanguage = lan;
      languageDirection = 'ltr';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bharat eKrishi',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: widget.userId == '0' ? SplashScreen() : BottomNavBar(),
    );
  }
}
