import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    super.key,
    required this.token,
    required this.user,
    required this.onLogout,
  });

  final String token;
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminName = (widget.user['name'] ?? widget.user['nama'] ?? 'Admin').toString();
    final adminEmail = (widget.user['email'] ?? '-').toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Tooltip(
                message: 'Logout',
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: _showLogoutDialog,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, $adminName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              adminEmail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6A7282),
                  ),
            ),
            const SizedBox(height: 24),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline_rounded),
                title: Text('Modul admin siap digunakan'),
                subtitle: Text(
                  'Halaman ini bisa dikembangkan untuk manajemen dokter, pasien, dan jadwal.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
