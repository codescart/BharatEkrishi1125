import 'dart:async';
import 'package:bharatekrishi/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:bharatekrishi/languages/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _languageInit();
  }

  _languageInit() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? '0';
    Timer(
      const Duration(
        seconds: 3,
      ),
      () => user_id == '0'
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()))
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Languages())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/kisan.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Bharatekrishi',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Made in India',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
