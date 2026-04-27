import 'package:flutter/material.dart';

class AdminBillPage extends StatelessWidget {
  const AdminBillPage({Key? key}) : super(key: key);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _BillCard(
                    title: 'Pendapatan Bulan Ini',
                    value: 'Rp 0.4jt',
                    color: Color(0xFF155DFC),
                  ),
                  _BillCard(
                    title: 'Belum Dibayar',
                    value: 'Rp 825k',
                    color: Color(0xFFE7000B),
                  ),
                  _BillCard(
                    title: 'Sudah Dibayar',
                    value: 'Rp 1.2jt',
                    color: Color(0xFF00BC7D),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Placeholder for bill list or chart
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 1,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  alignment: Alignment.center,
                  child: const Text('Bill List/Chart Placeholder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _BillCard({
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
        width: 110,
        height: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon placeholder
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.attach_money, color: color, size: 24),
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
                fontSize: 18,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
