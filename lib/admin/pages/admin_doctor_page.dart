import 'package:flutter/material.dart';

class AdminDoctorPage extends StatelessWidget {
  const AdminDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.3,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'SEMUA',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Status Card
              Row(
                children: const [
                  _DoctorStatusCard(
                    title: 'Total Dokter',
                    value: '4',
                    color: Color(0xFF155DFC),
                  ),
                  SizedBox(width: 16),
                  _DoctorStatusCard(
                    title: 'Praktik Hari Ini',
                    value: '3',
                    color: Color(0xFF009966),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Doctor List Placeholder
              _DoctorList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorStatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _DoctorStatusCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 1,
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF4A5565),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorList extends StatelessWidget {
  const _DoctorList();

  @override
  Widget build(BuildContext context) {
    // Placeholder for doctor list
    return Column(
      children: [
        _DoctorItem(
          name: 'dr. Budi Santoso',
          specialization: 'Sp.PD',
          status: 'Praktik',
          statusColor: Color(0xFF009966),
        ),
        // Add more items as needed
      ],
    );
  }
}

class _DoctorItem extends StatelessWidget {
  final String name;
  final String specialization;
  final String status;
  final Color statusColor;

  const _DoctorItem({
    required this.name,
    required this.specialization,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: statusColor.withValues(alpha: 0.1),
              child: Icon(Icons.person, color: statusColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF101828),
                    ),
                  ),
                  Text(
                    specialization,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF4A5565),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withValues(alpha: 0.2)),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
