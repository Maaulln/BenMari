import 'package:flutter/material.dart';

class AdminAppointmentPage extends StatelessWidget {
  const AdminAppointmentPage({Key? key}) : super(key: key);

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
              // Date Filter
              _LabelInput(label: 'Tanggal'),
              const SizedBox(height: 16),
              // Status and Doctor Filter
              Row(
                children: [
                  Expanded(
                    child: _DropdownFilter(label: 'Status', value: 'Semua'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DropdownFilter(label: 'Dokter', value: 'Semua'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Status Cards Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StatusCard(
                    title: 'Total',
                    value: '5',
                    color: Color(0xFF9810FA),
                  ),
                  _StatusCard(
                    title: 'Menunggu',
                    value: '3',
                    color: Color(0xFFE17100),
                  ),
                  _StatusCard(
                    title: 'Selesai',
                    value: '1',
                    color: Color(0xFF009966),
                  ),
                  _StatusCard(
                    title: 'Batal',
                    value: '0',
                    color: Color(0xFFE7000B),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Appointment List Placeholder
              _AppointmentList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelInput extends StatelessWidget {
  final String label;
  const _LabelInput({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF364153),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFE5E7EB), width: 1.3),
          ),
        ),
      ],
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  final String label;
  final String value;
  const _DropdownFilter({required this.label, required this.value, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Color(0xFF364153),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.transparent, width: 1.3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatusCard({
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
        width: 80,
        height: 86,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF4A5565),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  const _AppointmentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for appointment list
    return Column(
      children: [
        _AppointmentItem(
          code: 'A001',
          name: 'Andi Pratama',
          doctor: 'dr. Budi Santoso, Sp.PD',
          date: '10 Apr 2026',
          time: '08:30',
          status: 'Menunggu',
          statusColor: Color(0xFFBB4D00),
        ),
        // Add more items as needed
      ],
    );
  }
}

class _AppointmentItem extends StatelessWidget {
  final String code;
  final String name;
  final String doctor;
  final String date;
  final String time;
  final String status;
  final Color statusColor;

  const _AppointmentItem({
    required this.code,
    required this.name,
    required this.doctor,
    required this.date,
    required this.time,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFAD46FF), Color(0xFF9810FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
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
                    doctor,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF4A5565),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
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
