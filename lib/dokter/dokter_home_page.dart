import 'package:flutter/material.dart';
import 'antrian_appointment_page.dart';
import 'jadwal_praktik_page.dart';
import 'rekam_medis_page.dart';
import 'profil_dokter_page.dart';
import 'pemeriksaan_page.dart';
import '../widgets/doctor_shared_widgets.dart';

class DokterHomePage extends StatefulWidget {
  const DokterHomePage({super.key});

  @override
  State<DokterHomePage> createState() => _DokterHomePageState();
}

class _DokterHomePageState extends State<DokterHomePage> {
  int _selectedIndex = 0;
  bool _isInPemeriksaanFlow = false;

  void _setPageState(int index, {bool inPemeriksaanFlow = false}) {
    setState(() {
      _selectedIndex = index;
      _isInPemeriksaanFlow = inPemeriksaanFlow;
    });
  }

  void _goToDashboard() => _setPageState(0);

  void _openPemeriksaan() {
    _setPageState(1, inPemeriksaanFlow: true);
  }

  void _backToAntrianList() => _setPageState(1);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardPage(),
      _isInPemeriksaanFlow
          ? DokterPemeriksaanPage(onBack: _backToAntrianList)
          : DokterAntrianAppointmentPage(
              onBack: _goToDashboard,
              onStartExam: _openPemeriksaan,
            ),
      DokterRekamMedisPage(onBackToDashboard: _goToDashboard),
      DokterJadwalPraktikPage(onBackToDashboard: _goToDashboard),
      DokterProfilPage(onBackToDashboard: _goToDashboard),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
              if (index != 1) {
                _isInPemeriksaanFlow = false;
              }
            });
          },
          height: 76,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          indicatorColor: const Color(0xFFEFF6FF),
          indicatorShape: const StadiumBorder(),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF1E63F3)),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('4'),
                child: Icon(Icons.format_list_bulleted_rounded),
              ),
              selectedIcon: Badge(
                label: Text('4'),
                child: Icon(
                  Icons.format_list_bulleted_rounded,
                  color: Color(0xFF1E63F3),
                ),
              ),
              label: 'Antrian',
            ),
            NavigationDestination(
              icon: Icon(Icons.description_outlined),
              selectedIcon: Icon(
                Icons.description_rounded,
                color: Color(0xFF1E63F3),
              ),
              label: 'Rekam Medis',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF1E63F3),
              ),
              label: 'Jadwal',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: Color(0xFF1E63F3),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat pagi 👋',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF101828),
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Jumat, 10 April 2026',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF667085),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 28),
            const _DoctorStatusCard(),
            const SizedBox(height: 32),
            const Text(
              'Ringkasan Hari Ini',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: const [
                SummaryCard(
                  icon: Icons.groups_2_outlined,
                  value: '6',
                  label: 'Pasien Hari Ini',
                  accent: Color(0xFF1E63F3),
                  badgeColor: Color(0xFFEAF1FF),
                ),
                SummaryCard(
                  icon: Icons.access_time_rounded,
                  value: '4',
                  label: 'Menunggu',
                  accent: Color(0xFFE57A00),
                  badgeColor: Color(0xFFFFF4E6),
                ),
                SummaryCard(
                  icon: Icons.check_circle_outline_rounded,
                  value: '1',
                  label: 'Selesai',
                  accent: Color(0xFF029E6D),
                  badgeColor: Color(0xFFE8FAF4),
                ),
                SummaryCard(
                  icon: Icons.assignment_outlined,
                  value: '3',
                  label: 'Rekam Medis',
                  accent: Color(0xFF9810FA),
                  badgeColor: Color(0xFFF5ECFF),
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.monitor_heart_outlined, size: 16),
                label: const Text(
                  'Mulai Pemeriksaan Pasien #3',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF155DFC),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0x80BEDBFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'Antrian Hari Ini',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Lihat Semua →',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF155DFC),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const QueuePatientCard(
              number: '1',
              name: 'Andi Firmansyah',
              age: '32 tahun',
              status: 'Selesai',
              statusColor: Color(0xFF007A55),
              statusBackground: Color(0xFFECFDF5),
              statusBorder: Color(0xFFA4F4CF),
            ),
            const SizedBox(height: 12),
            const QueuePatientCard(
              number: '2',
              name: 'Sari Mahendra',
              age: '28 tahun',
              status: 'Menunggu',
              statusColor: Color(0xFFE17100),
              statusBackground: Color(0xFFFFFBEB),
              statusBorder: Color(0xFFFAD7A0),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorStatusCard extends StatelessWidget {
  const _DoctorStatusCard();

  @override
  Widget build(BuildContext context) {
    return DoctorCardContainer(
      padding: EdgeInsets.fromLTRB(20, 20, 18, 20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 32,
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
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sp.PD',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF667085),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 18,
                      child: FittedBox(
                        child: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeTrackColor: const Color(0xFF155DFC),
                          activeThumbColor: Colors.white,
                          thumbColor: WidgetStateProperty.all(
                            const Color(0xFFFFFFFF),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sedang Praktik',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF155DFC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
    required this.badgeColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return DoctorCardContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: accent, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              height: 1,
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}

class QueuePatientCard extends StatelessWidget {
  const QueuePatientCard({
    super.key,
    required this.number,
    required this.name,
    required this.age,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
    required this.statusBorder,
  });

  final String number;
  final String name;
  final String age;
  final String status;
  final Color statusColor;
  final Color statusBackground;
  final Color statusBorder;

  @override
  Widget build(BuildContext context) {
    return DoctorCardContainer(
      padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
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
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: statusBorder, width: 1),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  age,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6A7282),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: Color(0xFF98A2B3),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '09:30 WIB',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}
