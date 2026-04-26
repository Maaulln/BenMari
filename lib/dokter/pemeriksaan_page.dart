import 'package:flutter/material.dart';

class DokterPemeriksaanPage extends StatelessWidget {
  const DokterPemeriksaanPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PemeriksaanHeader(onBack: onBack),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              children: const [
                _PatientDataCard(),
                SizedBox(height: 20),
                _ExaminationCard(),
                SizedBox(height: 20),
                _PrescriptionCard(),
                SizedBox(height: 20),
                _FinishButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PemeriksaanHeader extends StatelessWidget {
  const _PemeriksaanHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Color(0xFF475467)),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budi Pratama',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Antrian #3',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A5565),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBEDBFF)),
            ),
            child: const Text(
              'Pemeriksaan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1447E6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientDataCard extends StatelessWidget {
  const _PatientDataCard();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data Pasien',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Icon(Icons.expand_less_rounded, color: Color(0xFF667085)),
            ],
          ),
          SizedBox(height: 16),
          _PatientInfoGrid(),
          SizedBox(height: 16),
          Divider(color: Color(0xFFF3F4F6), height: 1),
          SizedBox(height: 16),
          Text(
            'Riwayat Kunjungan:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A7282),
            ),
          ),
          SizedBox(height: 12),
          _VisitHistoryItem(),
        ],
      ),
    );
  }
}

class _PatientInfoGrid extends StatelessWidget {
  const _PatientInfoGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.35,
      children: const [
        _PatientInfoTile(label: 'Nama Lengkap', value: 'Budi Pratama'),
        _PatientInfoTile(label: 'Usia', value: '45 tahun'),
        _PatientInfoTile(label: 'Jenis Kelamin', value: 'Laki-laki'),
        _PatientInfoTile(label: 'Golongan Darah', value: 'B'),
      ],
    );
  }
}

class _PatientInfoTile extends StatelessWidget {
  const _PatientInfoTile({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
      ),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitHistoryItem extends StatelessWidget {
  const _VisitHistoryItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDBEAFE), width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '27/3/2026',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF155DFC),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Gastritis',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExaminationCard extends StatelessWidget {
  const _ExaminationCard();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Pemeriksaan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _InputBlock(
                  label: 'Tekanan Darah',
                  initialValue: '120/80',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InputBlock(
                  label: 'Berat Badan (kg)',
                  initialValue: '70',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _InputBlock(
            label: 'Keluhan',
            hint: 'Keluhan pasien...',
            minLines: 2,
            maxLines: 2,
          ),
          SizedBox(height: 16),
          _InputBlock(
            label: 'Diagnosis',
            hint: 'Diagnosis...',
            requiredField: true,
            minLines: 2,
            maxLines: 2,
          ),
          SizedBox(height: 16),
          _InputBlock(
            label: 'Tindakan',
            hint: 'Tindakan yang dilakukan...',
            minLines: 2,
            maxLines: 2,
          ),
          SizedBox(height: 16),
          _InputBlock(
            label: 'Catatan Tambahan',
            hint: 'Catatan tambahan (opsional)...',
            minLines: 2,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _InputBlock extends StatelessWidget {
  const _InputBlock({
    required this.label,
    this.hint,
    this.initialValue,
    this.requiredField = false,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String label;
  final String? hint, initialValue;
  final bool requiredField;
  final int minLines, maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF364153),
              ),
            ),
            if (requiredField)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFB2C36),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          minLines: minLines,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 16, color: Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF155DFC), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PRESCRIPTION CARD — StatefulWidget
// ─────────────────────────────────────────────

class _PrescriptionCard extends StatefulWidget {
  const _PrescriptionCard();

  @override
  State<_PrescriptionCard> createState() => _PrescriptionCardState();
}

class _PrescriptionCardState extends State<_PrescriptionCard> {
  final List<Map<String, String>> _obatList = [];

  void _showTambahObatDialog() {
    final namaCtrl = TextEditingController();
    final dosisCtrl = TextEditingController();
    final aturanCtrl = TextEditingController();
    final catatanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Tambah Obat',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(
                ctrl: namaCtrl,
                label: 'Nama Obat',
                hint: 'cth: Paracetamol 500mg',
                required: true,
              ),
              const SizedBox(height: 12),
              _DialogField(ctrl: dosisCtrl, label: 'Dosis', hint: 'cth: 3x1'),
              const SizedBox(height: 12),
              _DialogField(
                ctrl: aturanCtrl,
                label: 'Aturan Pakai',
                hint: 'cth: Sesudah makan',
              ),
              const SizedBox(height: 12),
              _DialogField(
                ctrl: catatanCtrl,
                label: 'Catatan',
                hint: 'opsional',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaCtrl.text.trim().isEmpty) return;
              setState(() {
                _obatList.add({
                  'nama': namaCtrl.text.trim(),
                  'dosis': dosisCtrl.text.trim(),
                  'aturan': aturanCtrl.text.trim(),
                  'catatan': catatanCtrl.text.trim(),
                });
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF155DFC),
              foregroundColor: Colors.white,
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _hapusObat(int index) {
    setState(() => _obatList.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Resep Obat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(
                height: 32,
                child: ElevatedButton.icon(
                  onPressed: _showTambahObatDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF155DFC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text(
                    'Tambah',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_obatList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Belum ada obat ditambahkan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _obatList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final obat = _obatList[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication_rounded,
                        color: Color(0xFF155DFC),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              obat['nama'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF101828),
                              ),
                            ),
                            if ((obat['dosis'] ?? '').isNotEmpty)
                              Text(
                                'Dosis: ${obat['dosis']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4A5565),
                                ),
                              ),
                            if ((obat['aturan'] ?? '').isNotEmpty)
                              Text(
                                'Aturan: ${obat['aturan']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4A5565),
                                ),
                              ),
                            if ((obat['catatan'] ?? '').isNotEmpty)
                              Text(
                                'Catatan: ${obat['catatan']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6A7282),
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _hapusObat(i),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFFB2C36),
                          size: 20,
                        ),
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.ctrl,
    required this.label,
    this.hint,
    this.required = false,
  });
  final TextEditingController ctrl;
  final String label;
  final String? hint;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF364153),
              ),
            ),
            if (required)
              const Text(' *', style: TextStyle(color: Color(0xFFFB2C36))),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
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
              borderSide: const BorderSide(color: Color(0xFF155DFC)),
            ),
          ),
        ),
      ],
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
        label: const Text(
          'Selesaikan Pemeriksaan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF009966),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0x80A4F4CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
