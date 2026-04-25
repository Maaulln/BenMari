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

String _currentWeekRangeString() {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));
  const shortMonths = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${startOfWeek.day} ${shortMonths[startOfWeek.month]} - ${endOfWeek.day} ${shortMonths[endOfWeek.month]} ${endOfWeek.year}';
}

class DokterJadwalPraktikPage extends StatelessWidget {
  const DokterJadwalPraktikPage({super.key, required this.onBackToDashboard});

  final VoidCallback onBackToDashboard;

  @override
  Widget build(BuildContext context) {
    return DoctorScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: onBackToDashboard,
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
                              'Jadwal Praktik',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF101828),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _currentWeekRangeString(),
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
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _WeekNavButton(
                          text: 'Minggu Lalu',
                          icon: Icons.chevron_left_rounded,
                          iconOnRight: false,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _WeekNavButton(
                          text: 'Minggu Depan',
                          icon: Icons.chevron_right_rounded,
                          iconOnRight: true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        _DayColumn(day: 'Sen', date: '6'),
                        SizedBox(width: 8),
                        _DayColumn(day: 'Sel', date: '7'),
                        SizedBox(width: 8),
                        _DayColumn(day: 'Rab', date: '8'),
                        SizedBox(width: 8),
                        _DayColumn(day: 'Kam', date: '9'),
                        SizedBox(width: 8),
                        _DayColumn(
                          day: 'Jum',
                          date: '10',
                          selected: true,
                          bottomNumber: '6',
                        ),
                        SizedBox(width: 8),
                        _DayColumn(day: 'Sab', date: '11'),
                        SizedBox(width: 8),
                        _DayColumn(day: 'Min', date: '12'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text(
                          _todayString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF101828),
                          ),
                        ),
                        SizedBox(width: 8),
                        _TodayChip(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _AppointmentCard(
                      number: '#1',
                      time: '08:00',
                      name: 'Andi Firmansyah',
                      complaint: 'Demam 3 hari',
                      status: 'Selesai',
                      backgroundColor: Color(0xFFEAFBF3),
                      borderColor: Color(0xFFA4F4CF),
                      statusTextColor: Color(0xFF007A55),
                      timeColor: Color(0xFF007A55),
                    ),
                    const SizedBox(height: 10),
                    const _AppointmentCard(
                      number: '#2',
                      time: '09:00',
                      name: 'Siti Rahma',
                      complaint: 'Sakit kepala',
                      status: 'Berjalan',
                      backgroundColor: Color(0xFFEFF6FF),
                      borderColor: Color(0xFFBEDBFF),
                      statusTextColor: Color(0xFF1447E6),
                      timeColor: Color(0xFF155DFC),
                    ),
                    const SizedBox(height: 10),
                    const _AppointmentCard(
                      number: '#3',
                      time: '10:00',
                      name: 'Budi Pratama',
                      complaint: 'Batuk pilek',
                      status: 'Terjadwal',
                      backgroundColor: Color(0xFFEFF6FF),
                      borderColor: Color(0xFFBEDBFF),
                      statusTextColor: Color(0xFF1447E6),
                      timeColor: Color(0xFF155DFC),
                    ),
                    const SizedBox(height: 10),
                    const _AppointmentCard(
                      number: '#4',
                      time: '11:00',
                      name: 'Dewi Lestari',
                      complaint: 'Kontrol hipertensi',
                      status: 'Terjadwal',
                      backgroundColor: Color(0xFFEFF6FF),
                      borderColor: Color(0xFFBEDBFF),
                      statusTextColor: Color(0xFF1447E6),
                      timeColor: Color(0xFF155DFC),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.access_time_rounded,
                            color: Color(0xFF98A2B3),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '12:00 - Tidak ada appointment',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF98A2B3),
                            ),
                          ),
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

class _WeekNavButton extends StatelessWidget {
  const _WeekNavButton({
    required this.text,
    required this.icon,
    required this.iconOnRight,
  });

  final String text;
  final IconData icon;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!iconOnRight) ...[
            Icon(icon, size: 18, color: const Color(0xFF4A5565)),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (iconOnRight) ...[
            const SizedBox(width: 6),
            Icon(icon, size: 18, color: const Color(0xFF4A5565)),
          ],
        ],
      ),
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.date,
    this.selected = false,
    this.bottomNumber,
  });

  final String day;
  final String date;
  final bool selected;
  final String? bottomNumber;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? const Color(0xFF246BFD) : Colors.white;
    final textColor = selected ? Colors.white : const Color(0xFF4B5563);
    final borderColor = selected
        ? const Color(0xFF246BFD)
        : const Color(0xFFE5E7EB);

    return Expanded(
      child: Container(
        height: 104,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              date,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            if (bottomNumber != null) ...[
              const Spacer(),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.18)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  bottomNumber!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : const Color(0xFF155DFC),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TodayChip extends StatelessWidget {
  const _TodayChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBEDBFF), width: 1),
      ),
      child: const Text(
        'Hari Ini',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1447E6),
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.number,
    required this.time,
    required this.name,
    required this.complaint,
    required this.status,
    required this.backgroundColor,
    required this.borderColor,
    required this.statusTextColor,
    required this.timeColor,
  });

  final String number;
  final String time;
  final String name;
  final String complaint;
  final String status;
  final Color backgroundColor;
  final Color borderColor;
  final Color statusTextColor;
  final Color timeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF101828), width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: timeColor),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: timeColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  complaint,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
