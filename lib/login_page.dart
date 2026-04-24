import 'package:flutter/material.dart';
import 'auth_api.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLoginSuccess});

  final Function(String token, Map<String, dynamic> user, String role)
      onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedRole = 'pasien'; // pasien, dokter, admin
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _setDemoCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setDemoCredentials() {
    setState(() {
      if (_selectedRole == 'pasien') {
        _emailController.text = 'andi@email.com';
        _passwordController.text = 'password123';
      } else if (_selectedRole == 'dokter') {
        _emailController.text = 'dr.budi@klinik.com';
        _passwordController.text = 'password123';
      } else if (_selectedRole == 'admin') {
        _emailController.text = 'admin@klinik.com';
        _passwordController.text = 'password123';
      }
      _errorMessage = null;
    });
  }

  void _changeRole(String newRole) {
    setState(() {
      _selectedRole = newRole;
      _errorMessage = null;
    });
    _setDemoCredentials();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password harus diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final endpoint = '/api/auth/login-$_selectedRole';
      final response = await _performLogin(endpoint, email, password);

      if (!mounted) return;

      if (response['success'] == true) {
        final token = response['token'] as String;
        final user = response['user'] as Map<String, dynamic>;
        widget.onLoginSuccess(token, user, _selectedRole);
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Login gagal';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Kesalahan: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> _performLogin(
      String endpoint, String email, String password) async {
    try {
      late LoginResponse response;

      if (_selectedRole == 'pasien') {
        response = await AuthApi.loginPasien(
          email: email,
          password: password,
        );
      } else if (_selectedRole == 'dokter') {
        response = await AuthApi.loginDokter(
          email: email,
          password: password,
        );
      } else if (_selectedRole == 'admin') {
        response = await AuthApi.loginAdmin(
          email: email,
          password: password,
        );
      }

      return {
        'success': response.success,
        'message': response.message,
        'token': response.token,
        'user': response.user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<void> _openRegisterPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      ),
    );

    if (!mounted || result is! Map<String, dynamic>) {
      return;
    }

    final email = result['email']?.toString() ?? '';
    final password = result['password']?.toString() ?? '';
    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _selectedRole = 'pasien';
        _emailController.text = email;
        _passwordController.text = password;
        _errorMessage = null;
      });
    }
  }

  Color _getRoleColor() {
    switch (_selectedRole) {
      case 'dokter':
        return const Color(0xFF155DFC); // Blue
      case 'admin':
        return const Color(0xFFD0142A); // Red
      case 'pasien':
      default:
        return const Color(0xFF009966); // Green
    }
  }

  String _getRoleLabel() {
    switch (_selectedRole) {
      case 'dokter':
        return 'Dokter';
      case 'admin':
        return 'Admin';
      case 'pasien':
      default:
        return 'Pasien';
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor();
    final roleLabel = _getRoleLabel();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Logo & Title
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: roleColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Klinik BenMari',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sistem Informasi Manajemen Klinik',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 40),

              // Role Selector Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login Sebagai',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6A7282),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Role Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: roleColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _selectedRole == 'dokter'
                                    ? Icons.medical_services_outlined
                                    : _selectedRole == 'admin'
                                        ? Icons.admin_panel_settings_outlined
                                        : Icons.person_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                roleLabel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Change Role Button
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _showRoleMenu,
                          icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                          label: const Text('Ganti Role'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF667085),
                            side: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Login Form
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF344054),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: 'email@example.com',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF98A2B3),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF344054),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF98A2B3),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Error Message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE4E2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFF04438),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFD92D20),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFD92D20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_errorMessage != null) const SizedBox(height: 16),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: roleColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: const Color(0xFFD0D5DD),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF667085),
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : _openRegisterPage,
                        child: const Text('Daftar'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Demo Credentials
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFBEDBFF),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Demo Credentials:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1447E6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedRole == 'pasien') ...[
                      const Text(
                        'Email: andi@email.com',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                      const Text(
                        'Password: password123',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                    ] else if (_selectedRole == 'dokter') ...[
                      const Text(
                        'Email: dr.budi@klinik.com',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                      const Text(
                        'Password: password123',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                    ] else if (_selectedRole == 'admin') ...[
                      const Text(
                        'Email: admin@klinik.com',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                      const Text(
                        'Password: password123',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoleMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Role Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 20),
            _RoleOption(
              title: 'Pasien',
              subtitle: 'Pasien Klinik',
              icon: Icons.person_outline,
              color: const Color(0xFF009966),
              selected: _selectedRole == 'pasien',
              onTap: () {
                Navigator.pop(context);
                _changeRole('pasien');
              },
            ),
            const SizedBox(height: 12),
            _RoleOption(
              title: 'Dokter',
              subtitle: 'Tenaga Medis',
              icon: Icons.medical_services_outlined,
              color: const Color(0xFF155DFC),
              selected: _selectedRole == 'dokter',
              onTap: () {
                Navigator.pop(context);
                _changeRole('dokter');
              },
            ),
            const SizedBox(height: 12),
            _RoleOption(
              title: 'Admin',
              subtitle: 'Administrator Klinik',
              icon: Icons.admin_panel_settings_outlined,
              color: const Color(0xFFD0142A),
              selected: _selectedRole == 'admin',
              onTap: () {
                Navigator.pop(context);
                _changeRole('admin');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : const Color(0xFFF9FAFB),
          border: Border.all(
            color: selected ? color : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101828),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6A7282),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: color,
                size: 24,
              )
            else
              const Icon(
                Icons.circle_outlined,
                color: Color(0xFFD0D5DD),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
