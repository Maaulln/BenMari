import 'package:flutter/material.dart';

import 'patient_surface.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _PatientDashboardPage(),
          _PatientPlaceholderPage(
            title: 'Appointment',
            subtitle: 'Belum ada layout tambahan untuk tab ini.',
          ),
          _PatientPlaceholderPage(
            title: 'Rekam Medis',
            subtitle: 'Belum ada layout tambahan untuk tab ini.',
          ),
          _PatientPlaceholderPage(
            title: 'Tagihan',
            subtitle: 'Belum ada layout tambahan untuk tab ini.',
          ),
          _PatientPlaceholderPage(
            title: 'Profil',
            subtitle: 'Belum ada layout tambahan untuk tab ini.',
          ),
        ],
      ),
      bottomNavigationBar: _PatientBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onSelected: _selectTab,
      ),
    );
  }
}

class _PatientDashboardPage extends StatelessWidget {
  const _PatientDashboardPage();

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00BC7D), Color(0xFF009966)],
                ),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: -128,
                    right: -96,
                    child: _HeroBlob(size: 256),
                  ),
                  const Positioned(
                    top: 124,
                    left: -96,
                    child: _HeroBlob(size: 192),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const _GreetingBlock(),
                            _NotificationButton(onTap: () {}, badgeCount: 1),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Jumat, 10 April 2026',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD0FAE5),
                            height: 1.2,
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 112),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -24),
                      child: const _ActiveAppointmentCard(),
                    ),
                    const SizedBox(height: 8),
                    const _SectionHeader(title: 'Menu Cepat'),
                    const SizedBox(height: 16),
                    const _QuickMenuGrid(),
                    const SizedBox(height: 24),
                    const _ClinicInfoCard(),
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

class _GreetingBlock extends StatelessWidget {
  const _GreetingBlock();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat pagi 👋',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Andi Pratama',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD0FAE5),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap, required this.badgeCount});

  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFFFB2C36),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveAppointmentCard extends StatelessWidget {
  const _ActiveAppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 25,
            offset: Offset(0, 20),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Appointment Aktif',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A7282),
                    height: 1.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFEE685)),
                  ),
                  child: const Text(
                    'Menunggu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFBB4D00),
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF00BC7D), Color(0xFF009966)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x80A4F4CF),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Color(0x80A4F4CF),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '1',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'dr. Budi Santoso, Sp.PD',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Spesialis Penyakit Dalam',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5565),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: const [
                          _MetaChip(
                            icon: Icons.calendar_month_outlined,
                            text: '09 Apr 2026',
                          ),
                          _MetaChip(
                            icon: Icons.schedule_outlined,
                            text: '09:00',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keluhan:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6A7282),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Demam tinggi sejak 2 hari yang lalu, disertai batuk kering',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E2939),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF009966),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Lihat Detail',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4A5565)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5565),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF101828),
        height: 1.2,
      ),
    );
  }
}

class _QuickMenuGrid extends StatelessWidget {
  const _QuickMenuGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 180 / 134,
      children: const [
        _QuickMenuCard(
          title: 'Buat Appointment',
          icon: Icons.add_rounded,
          iconGradient: [Color(0xFF00BC7D), Color(0xFF009966)],
          shadowColor: Color(0x80A4F4CF),
        ),
        _QuickMenuCard(
          title: 'Riwayat Kunjungan',
          icon: Icons.history_rounded,
          iconGradient: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
          shadowColor: Color(0x80BEDBFF),
        ),
        _QuickMenuCard(
          title: 'Rekam Medis',
          icon: Icons.folder_open_rounded,
          iconGradient: [Color(0xFFAD46FF), Color(0xFF9810FA)],
          shadowColor: Color(0x80E9D4FF),
        ),
        _QuickMenuCard(
          title: 'Tagihan Saya',
          icon: Icons.receipt_long_rounded,
          iconGradient: [Color(0xFFFE9A00), Color(0xFFE17100)],
          shadowColor: Color(0x80FEE685),
        ),
      ],
    );
  }
}

class _QuickMenuCard extends StatelessWidget {
  const _QuickMenuCard({
    required this.title,
    required this.icon,
    required this.iconGradient,
    required this.shadowColor,
  });

  final String title;
  final IconData icon;
  final List<Color> iconGradient;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 25,
            offset: Offset(0, 20),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: iconGradient,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClinicInfoCard extends StatelessWidget {
  const _ClinicInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF6FF), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Informasi Klinik',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
                height: 1.2,
              ),
            ),
            SizedBox(height: 16),
            _ClinicInfoRow(
              icon: Icons.access_time_rounded,
              title: 'Jam Operasional',
              value: 'Senin - Sabtu: 07:00 - 20:00\nMinggu: Tutup',
            ),
            SizedBox(height: 12),
            _ClinicInfoRow(
              icon: Icons.call_rounded,
              title: 'Telepon',
              value: '(021) 1234-5678',
            ),
            SizedBox(height: 12),
            _ClinicInfoRow(
              icon: Icons.location_on_rounded,
              title: 'Alamat',
              value: 'Jl. Kesehatan No. 99, Jakarta Pusat, DKI Jakarta 10110',
            ),
          ],
        ),
      ),
    );
  }
}

class _ClinicInfoRow extends StatelessWidget {
  const _ClinicInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: const Color(0xFF155DFC), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A7282),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PatientBottomNavigationBar extends StatelessWidget {
  const _PatientBottomNavigationBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 15,
            offset: Offset(0, -10),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _BottomNavItem(
              label: 'Beranda',
              selected: selectedIndex == 0,
              icon: Icons.home_rounded,
              onTap: () => onSelected(0),
            ),
            _BottomNavItem(
              label: 'Appointment',
              selected: selectedIndex == 1,
              icon: Icons.calendar_month_rounded,
              onTap: () => onSelected(1),
              badgeCount: 2,
            ),
            _BottomNavItem(
              label: 'Rekam Medis',
              selected: selectedIndex == 2,
              icon: Icons.folder_open_rounded,
              onTap: () => onSelected(2),
            ),
            _BottomNavItem(
              label: 'Tagihan',
              selected: selectedIndex == 3,
              icon: Icons.receipt_long_rounded,
              onTap: () => onSelected(3),
            ),
            _BottomNavItem(
              label: 'Profil',
              selected: selectedIndex == 4,
              icon: Icons.person_rounded,
              onTap: () => onSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF009966);
    final Color inactiveColor = const Color(0xFF99A1AF);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        icon,
                        size: 24,
                        color: selected ? activeColor : inactiveColor,
                      ),
                      if (badgeCount != null)
                        Positioned(
                          right: -10,
                          top: -10,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFB2C36),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$badgeCount',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? activeColor : inactiveColor,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientPlaceholderPage extends StatelessWidget {
  const _PatientPlaceholderPage({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 25,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.construction_rounded,
                      color: Color(0xFF155DFC),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A5565),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBlob extends StatelessWidget {
  const _HeroBlob({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
    );
  }
}
