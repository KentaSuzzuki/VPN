import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/onboard.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Color(0xFFF6FAFC),
      ),
      // home: MainScreen(),
      home: VPNApp(),

    );
  }
}
