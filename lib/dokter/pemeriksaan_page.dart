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

  final String label;
  final String value;

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
  final String? hint;
  final String? initialValue;
  final bool requiredField;
  final int minLines;
  final int maxLines;

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

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard();

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
                  onPressed: () {},
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
          const SizedBox(height: 24),
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
          ),
        ],
      ),
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
