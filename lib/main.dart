import 'package:flutter/material.dart';

import 'patient/patient_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ben Mari Klinik',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF009966),
          brightness: Brightness.light,
        ),
      ),
      home: const PatientHomePage(),
    );
  }
}
