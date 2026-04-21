import 'package:flutter/material.dart';

import 'patient/patient_home_page.dart';
import 'dokter/dokter_home_page.dart';
import 'admin/admin_home_page.dart';
import 'login_page.dart';

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
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String? _authToken;
  Map<String, dynamic>? _authUser;
  String? _authRole;

  void _handleLoginSuccess(
    String token,
    Map<String, dynamic> user,
    String role,
  ) {
    setState(() {
      _authToken = token;
      _authUser = user;
      _authRole = role;
    });
  }

  void _handleLogout() {
    setState(() {
      _authToken = null;
      _authUser = null;
      _authRole = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Not authenticated - show login
    if (_authToken == null) {
      return LoginPage(
        onLoginSuccess: _handleLoginSuccess,
      );
    }

    // Authenticated - show appropriate home page based on role
    switch (_authRole) {
      case 'dokter':
        return DokterHomePage(
          token: _authToken!,
          user: _authUser!,
          onLogout: _handleLogout,
        );
      case 'admin':
        return AdminHomePage(
          token: _authToken!,
          user: _authUser!,
          onLogout: _handleLogout,
        );
      case 'pasien':
      default:
        return PatientHomePage(
          token: _authToken!,
          user: _authUser!,
          onLogout: _handleLogout,
        );
    }
  }
}
