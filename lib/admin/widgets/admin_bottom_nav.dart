import 'package:flutter/material.dart';

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 1.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            selected: false,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.calendar_today,
            label: 'Appointment',
            selected: false,
            badge: '12',
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.people,
            label: 'Pasien',
            selected: true,
            onTap: () {},
            selectedColor: const Color(0xFFE7000B),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final String? badge;
  final VoidCallback onTap;
  final Color? selectedColor;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? (selectedColor ?? const Color(0xFFE7000B))
        : const Color(0xFF6A7282);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(icon, size: 28, color: color),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFB2C36),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
