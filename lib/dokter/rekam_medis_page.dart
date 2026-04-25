import 'package:flutter/material.dart';
import 'doctor_surface.dart';

String _todayString() {
  final now = DateTime.now();
  const days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  const months = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${days[now.weekday - 1]}, ${now.day} ${months[now.month]} ${now.year}';
}

class DokterRekamMedisPage extends StatefulWidget {
  const DokterRekamMedisPage({super.key, required this.onBackToDashboard});

  final VoidCallback onBackToDashboard;

  @override
  State<DokterRekamMedisPage> createState() => _DokterRekamMedisPageState();
}

class _DokterRekamMedisPageState extends State<DokterRekamMedisPage> {
  bool _showDetail = false;
  String _selectedPatientName = 'Andi Firmansyah';
  String _selectedPatientRecordCount = '1 rekam medis';

  void _openDetail({required String name, required String recordCount}) {
    setState(() {
      _selectedPatientName = name;
      _selectedPatientRecordCount = recordCount;
      _showDetail = true;
    });
  }

  void _backToList() {
    setState(() {
      _showDetail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showDetail) {
      return _RekamMedisDetailPage(
        name: _selectedPatientName,
        recordCount: _selectedPatientRecordCount,
        onBack: _backToList,
      );
    }

    return DoctorScreenBackground(
      child: _RekamMedisListPage(
        onBackToDashboard: widget.onBackToDashboard,
        onOpenDetail: _openDetail,
      ),
    );
  }
}

class _RekamMedisListPage extends StatelessWidget {
  const _RekamMedisListPage({
    required this.onBackToDashboard,
    required this.onOpenDetail,
  });

  final VoidCallback onBackToDashboard;
  final void Function({required String name, required String recordCount})
  onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBackToDashboard,
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF475467)),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rekam Medis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Riwayat pasien yang ditangani',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFF9FAFB),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama pasien...',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF98A2B3),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF98A2B3)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFF155DFC),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 90),
              child: Column(
                children: [
                  _RekamMedisSummaryCard(
                    initial: 'A',
                    name: 'Andi Firmansyah',
                    patientInfo: '32 tahun • Laki-laki',
                    recordCount: '1 rekam medis',
                    lastVisit: 'Terakhir: 10 Apr 2026',
                    onTap: () => onOpenDetail(
                      name: 'Andi Firmansyah',
                      recordCount: '1 rekam medis',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _RekamMedisSummaryCard(
                    initial: 'B',
                    name: 'Budi Pratama',
                    patientInfo: '45 tahun • Laki-laki',
                    recordCount: '1 rekam medis',
                    lastVisit: 'Terakhir: 27 Mar 2026',
                    onTap: () => onOpenDetail(
                      name: 'Budi Pratama',
                      recordCount: '1 rekam medis',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _RekamMedisSummaryCard(
                    initial: 'D',
                    name: 'Dewi Lestari',
                    patientInfo: '55 tahun • Perempuan',
                    recordCount: '1 rekam medis',
                    lastVisit: 'Terakhir: 03 Apr 2026',
                    onTap: () => onOpenDetail(
                      name: 'Dewi Lestari',
                      recordCount: '1 rekam medis',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RekamMedisSummaryCard extends StatelessWidget {
  const _RekamMedisSummaryCard({
    required this.initial,
    required this.name,
    required this.patientInfo,
    required this.recordCount,
    required this.lastVisit,
    required this.onTap,
  });

  final String initial;
  final String name;
  final String patientInfo;
  final String recordCount;
  final String lastVisit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80BEDBFF),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Color(0xFF667085),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        patientInfo,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFBEDBFF),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.description_outlined,
                          size: 14,
                          color: Color(0xFF1447E6),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '1 rekam medis',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1447E6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lastVisit,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6A7282),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RekamMedisDetailPage extends StatelessWidget {
  const _RekamMedisDetailPage({
    required this.name,
    required this.recordCount,
    required this.onBack,
  });

  final String name;
  final String recordCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Container(
            height: 97,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recordCount,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF00BC7D), Color(0xFF009966)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x80A4F4CF),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: Color(0xFF98A2B3),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _todayString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4A5565),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ISPA (Infeksi Saluran Pernapasan Atas)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF101828),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Pemberian obat antipiretik dan antibiotik',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4A5565),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _DetailMeta(text: '120/80'),
                              const SizedBox(width: 12),
                              _DetailMeta(text: '70 kg'),
                              const SizedBox(width: 12),
                              _DetailMeta(text: '2 obat'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailMeta extends StatelessWidget {
  const _DetailMeta({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.favorite_border, size: 14, color: Color(0xFF6A7282)),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A7282),
          ),
        ),
      ],
    );
  }
}
