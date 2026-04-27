import 'package:flutter/material.dart';

class AdminDrugPage extends StatelessWidget {
  const AdminDrugPage({Key? key}) : super(key: key);

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
              // Status Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _DrugStatusCard(
                    title: 'Tersedia',
                    value: '3',
                    color: Color(0xFF009966),
                  ),
                  _DrugStatusCard(
                    title: 'Menipis',
                    value: '1',
                    color: Color(0xFFF54900),
                  ),
                  _DrugStatusCard(
                    title: 'Habis',
                    value: '0',
                    color: Color(0xFFE7000B),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Drug List Placeholder
              _DrugList(),
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
            'Cari nama obat...',
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

class _DrugStatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _DrugStatusCard({
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
        height: 90,
        padding: const EdgeInsets.all(16),
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

class _DrugList extends StatelessWidget {
  const _DrugList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for drug list
    return Column(
      children: [
        _DrugItem(
          name: 'Paracetamol',
          stock: 'Tersedia',
          stockColor: Color(0xFF009966),
        ),
        // Add more items as needed
      ],
    );
  }
}

class _DrugItem extends StatelessWidget {
  final String name;
  final String stock;
  final Color stockColor;

  const _DrugItem({
    required this.name,
    required this.stock,
    required this.stockColor,
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
              backgroundColor: stockColor.withOpacity(0.1),
              child: Icon(Icons.medical_services, color: stockColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF101828),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: stockColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: stockColor.withOpacity(0.2)),
              ),
              child: Text(
                stock,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: stockColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
