import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'doctor_api.dart';
import 'patient_surface.dart';

// ─────────────────────────────────────────────
// NOTIFIKASI SETTINGS PAGE
// ─────────────────────────────────────────────

class NotifikasiSettingsPage extends StatefulWidget {
  const NotifikasiSettingsPage({super.key});

  @override
  State<NotifikasiSettingsPage> createState() => _NotifikasiSettingsPageState();
}

class _NotifikasiSettingsPageState extends State<NotifikasiSettingsPage> {
  bool _appointment = true;
  bool _pengingat = true;
  bool _pembayaran = false;
  bool _rekamMedis = true;
  bool _promosi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF101828),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA4F4CF)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF009966),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Aktifkan notifikasi yang ingin kamu terima.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF007A55),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Notifikasi Medis
          _SectionLabel(label: 'Notifikasi Medis'),
          const SizedBox(height: 12),
          _NotifToggleTile(
            icon: Icons.calendar_month_rounded,
            iconBg: const Color(0xFFECFDF5),
            iconColor: const Color(0xFF009966),
            title: 'Appointment',
            subtitle: 'Pengingat jadwal dokter yang akan datang',
            value: _appointment,
            onChanged: (v) => setState(() => _appointment = v),
          ),
          const SizedBox(height: 10),
          _NotifToggleTile(
            icon: Icons.alarm_rounded,
            iconBg: const Color(0xFFFEF3C6),
            iconColor: const Color(0xFFE17100),
            title: 'Pengingat Obat',
            subtitle: 'Notifikasi waktu minum obat',
            value: _pengingat,
            onChanged: (v) => setState(() => _pengingat = v),
          ),
          const SizedBox(height: 10),
          _NotifToggleTile(
            icon: Icons.folder_open_rounded,
            iconBg: const Color(0xFFFAF5FF),
            iconColor: const Color(0xFF9810FA),
            title: 'Rekam Medis',
            subtitle: 'Notifikasi saat rekam medis tersedia',
            value: _rekamMedis,
            onChanged: (v) => setState(() => _rekamMedis = v),
          ),

          const SizedBox(height: 24),

          // Notifikasi Transaksi
          _SectionLabel(label: 'Notifikasi Transaksi'),
          const SizedBox(height: 12),
          _NotifToggleTile(
            icon: Icons.receipt_long_rounded,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF155DFC),
            title: 'Pembayaran & Tagihan',
            subtitle: 'Info status pembayaran dan tagihan baru',
            value: _pembayaran,
            onChanged: (v) => setState(() => _pembayaran = v),
          ),

          const SizedBox(height: 24),

          // Lainnya
          _SectionLabel(label: 'Lainnya'),
          const SizedBox(height: 12),
          _NotifToggleTile(
            icon: Icons.campaign_rounded,
            iconBg: const Color(0xFFFFF1F2),
            iconColor: const Color(0xFFFB2C36),
            title: 'Promosi & Info Klinik',
            subtitle: 'Berita terbaru dan penawaran dari klinik',
            value: _promosi,
            onChanged: (v) => setState(() => _promosi = v),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan notifikasi disimpan!'),
                    backgroundColor: Color(0xFF009966),
                  ),
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009966),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Simpan Pengaturan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6A7282),
        letterSpacing: 0.5,
      ),
    );
  }
}

class _NotifToggleTile extends StatelessWidget {
  const _NotifToggleTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF009966),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// KEAMANAN AKUN PAGE (GANTI PASSWORD)
// ─────────────────────────────────────────────

class KeamananAkunPage extends StatefulWidget {
  const KeamananAkunPage({super.key, required this.user});
  final Map<String, dynamic> user;

  @override
  State<KeamananAkunPage> createState() => _KeamananAkunPageState();
}

class _KeamananAkunPageState extends State<KeamananAkunPage> {
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isLoading = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final oldPass = _oldPassCtrl.text.trim();
    final newPass = _newPassCtrl.text.trim();
    final confirmPass = _confirmPassCtrl.text.trim();

    setState(() {
      _error = null;
      _success = null;
    });

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      setState(() => _error = 'Semua field wajib diisi');
      return;
    }
    if (newPass.length < 6) {
      setState(() => _error = 'Password baru minimal 6 karakter');
      return;
    }
    if (newPass != confirmPass) {
      setState(() => _error = 'Konfirmasi password tidak cocok');
      return;
    }
    if (oldPass == newPass) {
      setState(
        () => _error = 'Password baru tidak boleh sama dengan password lama',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pasienId = widget.user['id']?.toString() ?? '1';
      final uri = Uri.parse('${apiBaseUrl()}/api/auth/update-pasien/$pasienId');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'oldPassword': oldPass,
          'newPassword': newPass,
          'name': widget.user['name'],
          'phone': widget.user['phone'],
          'address': widget.user['address'],
        }),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && decoded['success'] == true) {
        setState(() {
          _success = 'Password berhasil diubah!';
          _oldPassCtrl.clear();
          _newPassCtrl.clear();
          _confirmPassCtrl.clear();
        });
      } else {
        setState(
          () => _error = decoded['message'] ?? 'Gagal mengubah password',
        );
      }
    } catch (e) {
      setState(() => _error = 'Koneksi error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Keamanan Akun'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF101828),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Color(0xFF009966),
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Ubah Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Pastikan password baru kamu kuat dan mudah diingat',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF6A7282)),
            ),
          ),
          const SizedBox(height: 28),

          _PasswordField(
            label: 'Password Lama',
            controller: _oldPassCtrl,
            show: _showOld,
            onToggle: () => setState(() => _showOld = !_showOld),
          ),
          const SizedBox(height: 16),
          _PasswordField(
            label: 'Password Baru',
            controller: _newPassCtrl,
            show: _showNew,
            onToggle: () => setState(() => _showNew = !_showNew),
          ),
          const SizedBox(height: 8),
          // Password strength indicator
          if (_newPassCtrl.text.isNotEmpty)
            _PasswordStrength(password: _newPassCtrl.text),
          const SizedBox(height: 16),
          _PasswordField(
            label: 'Konfirmasi Password Baru',
            controller: _confirmPassCtrl,
            show: _showConfirm,
            onToggle: () => setState(() => _showConfirm = !_showConfirm),
          ),

          const SizedBox(height: 16),

          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE4E2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF04438)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFD92D20),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Color(0xFFD92D20),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (_success != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA4F4CF)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF009966),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _success!,
                      style: const TextStyle(
                        color: Color(0xFF007A55),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009966),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Ubah Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // Tips keamanan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFEE685)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      color: Color(0xFFE17100),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tips Keamanan',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFBB4D00),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _TipItem(text: 'Gunakan minimal 8 karakter'),
                _TipItem(text: 'Kombinasikan huruf besar, kecil, dan angka'),
                _TipItem(text: 'Jangan gunakan informasi pribadi'),
                _TipItem(text: 'Jangan bagikan password ke siapapun'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.show,
    required this.onToggle,
  });

  final String label;
  final TextEditingController controller;
  final bool show;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !show,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF98A2B3),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: const Color(0xFF98A2B3),
              ),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF009966)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});
  final String password;

  int get _strength {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final s = _strength;
    final color = s <= 1
        ? const Color(0xFFFB2C36)
        : s == 2
        ? const Color(0xFFE17100)
        : const Color(0xFF009966);
    final label = s <= 1
        ? 'Lemah'
        : s == 2
        ? 'Sedang'
        : 'Kuat';
    return Row(
      children: [
        ...List.generate(
          4,
          (i) => Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: i < s ? color : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.check_rounded, size: 14, color: Color(0xFFE17100)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF92400E)),
          ),
        ],
      ),
    );
  }
}
