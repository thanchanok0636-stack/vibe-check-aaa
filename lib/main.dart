import 'package:flutter/material.dart';
import 'theme/hospital_theme.dart';
import 'screens/home_screen.dart';


void main() {
  runApp(const VibeCheckAAA());
}

class VibeCheckAAA extends StatelessWidget {
  const VibeCheckAAA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe-check AAA',
      debugShowCheckedModeBanner: false,
      theme: HospitalTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
