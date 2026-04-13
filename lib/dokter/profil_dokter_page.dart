import 'package:flutter/material.dart';
import 'doctor_surface.dart';

class DokterProfilPage extends StatefulWidget {
  const DokterProfilPage({super.key, required this.onBackToDashboard});

  final VoidCallback onBackToDashboard;

  @override
  State<DokterProfilPage> createState() => _DokterProfilPageState();
}

class _DokterProfilPageState extends State<DokterProfilPage> {
  bool _isActive = true;

  Future<void> _showEditDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return const _EditProfileDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoctorScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 18),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onBackToDashboard,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF475467),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Profil Dokter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFF3F4F6),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x80BEDBFF),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.medical_services_rounded,
                              color: Colors.white,
                              size: 56,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'dr. Budi Santoso, Sp.PD',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF101828),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medical_services_outlined,
                                size: 16,
                                color: Color(0xFF155DFC),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Sp.PD',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF155DFC),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Status Praktik:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4A5565),
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      _isActive = value;
                                    });
                                  },
                                  activeTrackColor: const Color(0xFF155DFC),
                                  activeThumbColor: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isActive ? 'Aktif' : 'Nonaktif',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF155DFC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 124,
                            height: 36,
                            child: OutlinedButton.icon(
                              onPressed: _showEditDialog,
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text(
                                'Edit Profil',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1A1A1A),
                                side: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),
                                backgroundColor: const Color(0xFFF8F9FB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFF3F4F6),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Kontak',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _ContactRow(
                            icon: Icons.phone_outlined,
                            label: 'Telepon',
                            value: '081234567890',
                          ),
                          const SizedBox(height: 12),
                          _ContactRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: 'budi.santoso@klinikbenmari.com',
                          ),
                          const SizedBox(height: 12),
                          _ContactRow(
                            icon: Icons.description_outlined,
                            label: 'No. SIP',
                            value: '1234567890/SIP/2020',
                          ),
                          const SizedBox(height: 12),
                          _ContactRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Jadwal Praktik',
                            value: 'Senin, Selasa, Rabu, Kamis, Jumat',
                            extra: '08:00 - 16:00',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEFF6FF), Color(0xFFFFFFFF)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFBEDBFF),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Akses & Batasan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C398E),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '✅ Anda dapat mengakses:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C398E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _Bullet(
                            text: 'Antrian & appointment milik Anda',
                          ),
                          const _Bullet(
                            text:
                                'Input & lihat rekam medis pasien yang ditangani',
                            multiline: true,
                          ),
                          const _Bullet(text: 'Input resep obat'),
                          const _Bullet(text: 'Lihat & edit profil sendiri'),
                          const SizedBox(height: 16),
                          const Text(
                            '❌ Tidak dapat mengakses:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C398E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _Bullet(text: 'Data dokter lain'),
                          const _Bullet(text: 'Manajemen pasien & keuangan'),
                          const _Bullet(text: 'Stok & manajemen obat'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.extra,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: const Color(0xFF155DFC), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A7282),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
              if (extra != null) ...[
                const SizedBox(height: 2),
                Text(
                  extra!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, this.multiline = false});

  final String text;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          const Text(
            '•',
            style: TextStyle(fontSize: 16, color: Color(0xFF193CB8)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF193CB8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog();

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final TextEditingController _phoneController = TextEditingController(
    text: '081234567890',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'budi.santoso@klinikbenmari.com',
  );

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Nomor Telepon',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFF9FAFB),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFF9FAFB),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFEE685),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Catatan: No. SIP dan spesialisasi tidak dapat diubah. Hubungi administrator untuk perubahan data tersebut.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF155DFC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Color(0xFF667085)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
