import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

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
              // Top Cards Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DashboardCard(
                    color: const Color(0xFFEFF6FF),
                    icon: Icons.people,
                    title: 'Total Pasien Terdaftar',
                    value: '248',
                    valueColor: const Color(0xFF155DFC),
                  ),
                  _DashboardCard(
                    color: const Color(0xFFFAF5FF),
                    icon: Icons.calendar_today,
                    title: 'Appointment Hari Ini',
                    value: '12',
                    valueColor: const Color(0xFF9810FA),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DashboardCard(
                    color: const Color(0xFFFEF2F2),
                    icon: Icons.receipt_long,
                    title: 'Tagihan Belum Lunas',
                    value: 'Rp 875.000',
                    valueColor: const Color(0xFFE7000B),
                  ),
                  _DashboardCard(
                    color: const Color(0xFFFFF7ED),
                    icon: Icons.medical_services,
                    title: 'Stok Obat Menipis',
                    value: '2',
                    valueColor: const Color(0xFFF54900),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Bar Chart Placeholder
              _ChartCard(title: 'Appointment 7 Hari Terakhir'),
              const SizedBox(height: 24),
              // Pie Chart Placeholder
              _ChartCard(title: 'Status Appointment Hari Ini'),
              const SizedBox(height: 24),
              // Activity List Placeholder
              _ActivityCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;

  const _DashboardCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Container(
        width: 170,
        height: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF4A5565),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  const _ChartCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Container(
        width: double.infinity,
        height: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const Spacer(),
            const Center(child: Text('Chart Placeholder')),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            // Example activity list
            _ActivityItem(
              name: 'Andi Pratama',
              doctor: 'dr. Budi Santoso',
              time: '08:30',
              status: 'Menunggu',
              statusColor: Color(0xFFBB4D00),
            ),
            _ActivityItem(
              name: 'Siti Rahayu',
              doctor: 'drg. Sari Dewi',
              time: '09:00',
              status: 'Sedang Diperiksa',
              statusColor: Color(0xFF1447E6),
            ),
            _ActivityItem(
              name: 'Rudi Hermawan',
              doctor: 'dr. Ahmad Fauzi',
              time: '09:30',
              status: 'Selesai',
              statusColor: Color(0xFF007A55),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String name;
  final String doctor;
  final String time;
  final String status;
  final Color statusColor;

  const _ActivityItem({
    required this.name,
    required this.doctor,
    required this.time,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                doctor,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF4A5565),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6A7282)),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
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
        ],
      ),
    );
  }
}
