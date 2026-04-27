import 'package:flutter/material.dart';

class AdminPatientPage extends StatelessWidget {
  const AdminPatientPage({Key? key}) : super(key: key);

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
              // Search Input
              _SearchInput(),
              const SizedBox(height: 16),
              // Filter Buttons
              Row(
                children: const [
                  _FilterButton(label: 'SEMUA', active: true),
                  SizedBox(width: 8),
                  _FilterButton(label: 'AKTIF'),
                  SizedBox(width: 8),
                  _FilterButton(label: 'NONAKTIF'),
                ],
              ),
              const SizedBox(height: 24),
              // Status Card
              Row(
                children: const [
                  _PatientStatusCard(
                    title: 'Total Pasien',
                    value: '5',
                    color: Color(0xFFE7000B),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Patient List Placeholder
              _PatientList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFE5E7EB), width: 1.3),
          ),
          padding: const EdgeInsets.only(left: 48, right: 12),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Cari nama atau NIK...',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const Positioned(
          left: 16,
          top: 14,
          child: Icon(Icons.search, size: 20, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool active;
  const _FilterButton({required this.label, this.active = false, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE7000B) : const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? Colors.transparent : const Color(0xFFD1D5DC),
          width: 1.3,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xFF1A1A1A),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PatientStatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _PatientStatusCard({
    required this.title,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      child: Container(
        width: 160,
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
    );
  }
}

class _PatientList extends StatelessWidget {
  const _PatientList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for patient list
    return Column(
      children: [
        _PatientItem(
          name: 'Andi Pratama',
          nik: '1234567890',
          status: 'Aktif',
          statusColor: Color(0xFF009966),
        ),
        // Add more items as needed
      ],
    );
  }
}

class _PatientItem extends StatelessWidget {
  final String name;
  final String nik;
  final String status;
  final Color statusColor;

  const _PatientItem({
    required this.name,
    required this.nik,
    required this.status,
    required this.statusColor,
    Key? key,
  }) : super(key: key);

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
              backgroundColor: statusColor.withOpacity(0.1),
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
                    nik,
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
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withOpacity(0.2)),
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
