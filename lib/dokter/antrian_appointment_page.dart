import 'package:flutter/material.dart';
import 'doctor_surface.dart';

class DokterAntrianAppointmentPage extends StatelessWidget {
  const DokterAntrianAppointmentPage({
    super.key,
    required this.onBack,
    required this.onStartExam,
  });

  final VoidCallback onBack;
  final VoidCallback onStartExam;

  @override
  Widget build(BuildContext context) {
    return DoctorScreenBackground(
      child: SafeArea(
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
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF475467),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Antrian & Appointment',
                              style: TextStyle(
                                fontSize: 38,
                                height: 1,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF101828),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '4',
                                    style: TextStyle(color: Color(0xFF155DFC)),
                                  ),
                                  TextSpan(
                                    text: ' pasien menunggu',
                                    style: TextStyle(color: Color(0xFF4A5565)),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(
                        child: _SegmentButton(text: 'Hari Ini', selected: true),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _SegmentButton(
                          text: 'Minggu Ini',
                          selected: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
                child: Column(
                  children: [
                    const _AntrianCard(
                      no: '1',
                      name: 'Andi Firmansyah',
                      patientInfo: '32 tahun • Laki-laki',
                      time: '08:00',
                      complaint: 'Demam 3 hari',
                      statusLabel: 'Selesai',
                      statusTextColor: Color(0xFF007A55),
                      statusBorderColor: Color(0xFFA4F4CF),
                      statusBgColor: Color(0xFFECFDF5),
                    ),
                    const SizedBox(height: 16),
                    const _AntrianCard(
                      no: '2',
                      name: 'Siti Rahma',
                      patientInfo: '28 tahun •\nPerempuan',
                      time: '09:00',
                      complaint: 'Sakit kepala',
                      statusLabel: 'Sedang Diperiksa',
                      statusTextColor: Color(0xFF1447E6),
                      statusBorderColor: Color(0xFFBEDBFF),
                      statusBgColor: Color(0xFFEFF6FF),
                    ),
                    const SizedBox(height: 16),
                    _AntrianCard(
                      no: '3',
                      name: 'Budi Pratama',
                      patientInfo: '45 tahun • Laki-laki',
                      time: '10:00',
                      complaint: 'Batuk pilek',
                      statusLabel: 'Menunggu',
                      statusTextColor: const Color(0xFFBB4D00),
                      statusBorderColor: const Color(0xFFFEE685),
                      statusBgColor: const Color(0xFFFFFBEB),
                      showStartButton: true,
                      onStartExam: onStartExam,
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

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({required this.text, required this.selected});

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF155DFC) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x80BEDBFF),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF4B5563),
        ),
      ),
    );
  }
}

class _AntrianCard extends StatelessWidget {
  const _AntrianCard({
    required this.no,
    required this.name,
    required this.patientInfo,
    required this.time,
    required this.complaint,
    required this.statusLabel,
    required this.statusTextColor,
    required this.statusBorderColor,
    required this.statusBgColor,
    this.showStartButton = false,
    this.onStartExam,
  });

  final String no;
  final String name;
  final String patientInfo;
  final String time;
  final String complaint;
  final String statusLabel;
  final Color statusTextColor;
  final Color statusBorderColor;
  final Color statusBgColor;
  final bool showStartButton;
  final VoidCallback? onStartExam;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: 80,
            height: 80,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  no,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          const SizedBox(height: 2),
                          Text(
                            patientInfo,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.3,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6A7282),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: statusBorderColor),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: Color(0xFF667085),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A5565),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(13, 13, 13, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFF3F4F6),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Keluhan:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6A7282),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        complaint,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E2939),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showStartButton) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: onStartExam,
                      icon: const Icon(Icons.monitor_heart_outlined, size: 16),
                      label: const Text(
                        'Mulai Pemeriksaan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF155DFC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
