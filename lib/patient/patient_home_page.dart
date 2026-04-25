import 'package:flutter/material.dart';

import 'doctor_api.dart';
import 'patient_surface.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({
    super.key,
    required this.token,
    required this.user,
    required this.onLogout,
  });

  final String token;
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _selectedIndex = 0;
  bool _showNotifications = false;
  bool _showSearchDoctor = false;
  bool _showRekamDetail = false;
  bool _showBillDetail = false;
  final GlobalKey<_AppointmentsPageState> _appointmentsPageKey =
      GlobalKey<_AppointmentsPageState>();

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      _showNotifications = false;
      if (index != 1) {
        _showSearchDoctor = false;
      }
      if (index != 2) {
        _showRekamDetail = false;
      }
      if (index != 3) {
        _showBillDetail = false;
      }
    });
  }

  Widget _currentPage() {
    if (_showNotifications) {
      return _NotificationsPage(
        onBack: () => setState(() => _showNotifications = false),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return _PatientDashboardPage(
          user: widget.user,
          onOpenNotifications: () => setState(() => _showNotifications = true),
          onOpenAppointments: () {
            setState(() {
              _selectedIndex = 1;
              _showSearchDoctor = false;
            });
          },
          onOpenAppointmentHistory: () {
            setState(() {
              _selectedIndex = 1;
              _showSearchDoctor = false;
            });
          },
          onOpenMedicalRecords: () {
            setState(() {
              _selectedIndex = 2;
              _showRekamDetail = false;
            });
          },
          onOpenBills: () {
            setState(() {
              _selectedIndex = 3;
              _showBillDetail = false;
            });
          },
        );
      case 1:
        if (_showSearchDoctor) {
          return _SearchDoctorPage(
            onBack: () => setState(() => _showSearchDoctor = false),
            onAppointmentCreated: () =>
                _appointmentsPageKey.currentState?.reloadAppointments(),
          );
        }
        return _AppointmentsPage(
          key: _appointmentsPageKey,
          onOpenSearchDoctor: () => setState(() => _showSearchDoctor = true),
        );
      case 2:
        if (_showRekamDetail) {
          return _RekamMedisDetailPage(
            onBack: () => setState(() => _showRekamDetail = false),
          );
        }
        return _RekamMedisListPage(
          onOpenDetail: () => setState(() => _showRekamDetail = true),
        );
      case 3:
        if (_showBillDetail) {
          return _BillDetailDialogPage(
            onBack: () => setState(() => _showBillDetail = false),
          );
        }
        return _BillsPage(
          onOpenDetail: () => setState(() => _showBillDetail = true),
        );
      case 4:
      default:
        return _ProfilePage(
          user: widget.user,
          onLogout: widget.onLogout,
        );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ben Mari Klinik'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF8F9FB),
        foregroundColor: const Color(0xFF101828),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Tooltip(
                message: 'Logout',
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: _showLogoutDialog,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: _currentPage(),
      bottomNavigationBar: _PatientBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onSelected: _selectTab,
      ),
    );
  }
}

class _PatientDashboardPage extends StatelessWidget {
  const _PatientDashboardPage({
    required this.onOpenNotifications,
    required this.onOpenAppointments,
    required this.onOpenAppointmentHistory,
    required this.onOpenMedicalRecords,
    required this.onOpenBills,
    required this.user,
  });

  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenAppointmentHistory;
  final VoidCallback onOpenMedicalRecords;
  final VoidCallback onOpenBills;
  final Map<String, dynamic> user;

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
                            _GreetingBlock(
                              userName: user['name']?.toString() ?? 'Pengguna',
                            ),
                            _NotificationButton(
                              onTap: onOpenNotifications,
                              badgeCount: 1,
                            ),
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
                    _QuickMenuGrid(
                      onOpenAppointments: onOpenAppointments,
                      onOpenAppointmentHistory: onOpenAppointmentHistory,
                      onOpenMedicalRecords: onOpenMedicalRecords,
                      onOpenBills: onOpenBills,
                    ),
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

class _AppointmentsPage extends StatefulWidget {
  const _AppointmentsPage({super.key, required this.onOpenSearchDoctor});

  final VoidCallback onOpenSearchDoctor;

  @override
  State<_AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<_AppointmentsPage> {
  static const int _defaultPasienId = int.fromEnvironment(
    'PASIEN_ID',
    defaultValue: 1,
  );

  late Future<List<AppointmentItem>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = const DoctorApi().fetchAppointmentsByPatient(
      _defaultPasienId,
    );
  }

  void reloadAppointments() {
    setState(() {
      _appointmentsFuture = const DoctorApi().fetchAppointmentsByPatient(
        _defaultPasienId,
      );
    });
  }

  String _formatApiDate(String apiDate) {
    final parts = apiDate.split('-');
    if (parts.length != 3) {
      return apiDate;
    }

    final monthNames = [
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
      'Des'
    ];

    final monthIndex = int.tryParse(parts[1]) ?? 0;
    final month = (monthIndex >= 1 && monthIndex <= 12)
        ? monthNames[monthIndex]
        : parts[1];

    return '${parts[2]} $month ${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _SimpleTopHeader(
              title: 'Appointment Saya',
              subtitle: '2 appointment selesai',
            ),
            Expanded(
              child: FutureBuilder<List<AppointmentItem>>(
                future: _appointmentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Gagal memuat appointment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF101828),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF6A7282)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: reloadAppointments,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF009966),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final appointments = snapshot.data ?? const [];

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                    itemCount: appointments.length + 1,
                    separatorBuilder: (_, index) {
                      if (index == appointments.length - 1) {
                        return const SizedBox(height: 24);
                      }

                      return const SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      if (index == appointments.length) {
                        return SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: widget.onOpenSearchDoctor,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Buat Appointment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF009966),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        );
                      }

                      final item = appointments[index];

                      return _AppointmentCard(
                        doctorName: item.doctorName,
                        specialization: item.specialization,
                        status: item.statusLabel,
                        date: _formatApiDate(item.date),
                        time: item.time,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchDoctorPage extends StatefulWidget {
  const _SearchDoctorPage({
    required this.onBack,
    required this.onAppointmentCreated,
  });

  final VoidCallback onBack;
  final VoidCallback onAppointmentCreated;

  @override
  State<_SearchDoctorPage> createState() => _SearchDoctorPageState();
}

class _SearchDoctorPageState extends State<_SearchDoctorPage> {
  static const int _defaultPasienId = int.fromEnvironment(
    'PASIEN_ID',
    defaultValue: 1,
  );

  late Future<List<DoctorItem>> _doctorFuture;
  String? _submittingDoctorId;

  @override
  void initState() {
    super.initState();
    _doctorFuture = const DoctorApi().fetchDoctors();
  }

  void _reloadDoctors() {
    setState(() {
      _doctorFuture = const DoctorApi().fetchDoctors();
    });
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');

    return '${value.year}-$month-$day';
  }

  String _formatTime(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> _onPickDoctor(DoctorItem doctor) async {
    final dokterId = int.tryParse(doctor.id);
    if (dokterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID dokter tidak valid. Coba refresh data.'),
        ),
      );
      return;
    }

    final today = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
      helpText: 'Pilih tanggal appointment',
    );

    if (!mounted || selectedDate == null) {
      return;
    }

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Pilih jam appointment',
    );

    if (!mounted || selectedTime == null) {
      return;
    }

    final keluhanController = TextEditingController();
    final catatanController = TextEditingController();

    final submit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dokter: ${doctor.name}'),
                const SizedBox(height: 4),
                Text('Tanggal: ${_formatDate(selectedDate)}'),
                const SizedBox(height: 4),
                Text('Jam: ${_formatTime(selectedTime)}'),
                const SizedBox(height: 12),
                TextField(
                  controller: keluhanController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Keluhan awal',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: catatanController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009966),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (!mounted || submit != true) {
      return;
    }

    setState(() {
      _submittingDoctorId = doctor.id;
    });

    try {
      final response = await const DoctorApi().createAppointment(
        AppointmentPayload(
          pasienId: _defaultPasienId,
          dokterId: dokterId,
          tanggalAppointment: _formatDate(selectedDate),
          jamAppointment: _formatTime(selectedTime),
          keluhanAwal: keluhanController.text.trim(),
          catatan: catatanController.text.trim(),
        ),
      );

      if (!mounted) {
        return;
      }

      final queue = response['NOMOR_ANTRIAN'];
      widget.onAppointmentCreated();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            queue != null
                ? 'Appointment berhasil dibuat. Nomor antrian: $queue'
                : 'Appointment berhasil dibuat.',
          ),
          backgroundColor: const Color(0xFF009966),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: const Color(0xFFBB4D00),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submittingDoctorId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SimpleTopHeader(
              title: 'Cari Dokter',
              subtitle: 'Data dokter dari backend',
              leading: IconButton(
                onPressed: widget.onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF4A5565),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<DoctorItem>>(
                future: _doctorFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Gagal memuat data dokter',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF101828),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF6A7282)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _reloadDoctors,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF009966),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final doctors = snapshot.data ?? const [];
                  if (doctors.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada data dokter.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6A7282),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                    itemCount: doctors.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];

                      return _DoctorSearchCard(
                        nameInitial: doctor.initial,
                        name: doctor.name,
                        specialization: doctor.specialization,
                        schedule: doctor.schedule,
                        fee: doctor.fee,
                        available: doctor.available,
                        isSubmitting: _submittingDoctorId == doctor.id,
                        onSelect: () => _onPickDoctor(doctor),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RekamMedisListPage extends StatelessWidget {
  const _RekamMedisListPage({required this.onOpenDetail});

  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _SimpleTopHeader(
              title: 'Rekam Medis Saya',
              subtitle: '1 rekam medis tersimpan',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                children: [
                  GestureDetector(
                    onTap: onOpenDetail,
                    child: const _MedicalRecordCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RekamMedisDetailPage extends StatelessWidget {
  const _RekamMedisDetailPage({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SimpleTopHeader(
              title: 'Detail Rekam Medis',
              subtitle: '09 April 2026',
              leading: IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF4A5565),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                children: const [
                  _DoctorSummaryCard(),
                  SizedBox(height: 16),
                  _VitalSignsCard(),
                  SizedBox(height: 16),
                  _DetailTextCard(
                    title: 'Diagnosis',
                    content: 'ISPA (Infeksi Saluran Pernapasan Atas).',
                  ),
                  SizedBox(height: 16),
                  _DetailTextCard(
                    title: 'Resep Obat',
                    content: 'Paracetamol 500mg 3x1 dan Ambroxol 30mg 2x1.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillsPage extends StatelessWidget {
  const _BillsPage({required this.onOpenDetail});

  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _SimpleTopHeader(
              title: 'Tagihan Saya',
              subtitle: '2 tagihan tercatat',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                children: [
                  GestureDetector(
                    onTap: onOpenDetail,
                    child: const _BillCard(status: 'Lunas'),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: onOpenDetail,
                    child: const _BillCard(status: 'Belum Bayar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillDetailDialogPage extends StatelessWidget {
  const _BillDetailDialogPage({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _BillsPage(onOpenDetail: _noop),
        Container(color: const Color(0x80000000)),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 700,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Detail Tagihan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onBack,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const _DetailInfoRow(
                      iconBg: Color(0xFFF3E8FF),
                      icon: Icons.medical_services_rounded,
                      label: 'Dokter',
                      value: 'dr. Budi Santoso, Sp.PD',
                    ),
                    const SizedBox(height: 12),
                    const _DetailInfoRow(
                      iconBg: Color(0xFFDBEAFE),
                      icon: Icons.calendar_month_rounded,
                      label: 'Tanggal',
                      value: '05 Apr 2026',
                    ),
                    const SizedBox(height: 16),
                    const _BillBreakdownCard(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Metode Pembayaran',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF155DFC),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Transfer Bank BCA',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1C398E),
                                ),
                              ),
                            ],
                          ),
                          _StatusChip(label: 'Lunas'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFA4F4CF)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF007A55),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Pembayaran berhasil diverifikasi oleh sistem.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007A55),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Unduh Invoice'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009966),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationsPage extends StatelessWidget {
  const _NotificationsPage({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SimpleTopHeader(
              title: 'Notifikasi',
              subtitle: '3 notifikasi terbaru',
              leading: IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF4A5565),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                children: const [
                  _NotificationCard(
                    highlighted: true,
                    title: 'Appointment Besok',
                    message:
                        'Reminder: Anda memiliki appointment dengan dr. Budi Santoso besok pukul 09:00.',
                    time: 'sekitar 2 jam yang lalu',
                  ),
                  SizedBox(height: 12),
                  _NotificationCard(
                    highlighted: false,
                    title: 'Pembayaran Berhasil',
                    message:
                        'Pembayaran tagihan kunjungan tanggal 05 Apr 2026 sudah lunas.',
                    time: 'kemarin',
                  ),
                  SizedBox(height: 12),
                  _NotificationCard(
                    highlighted: false,
                    title: 'Rekam Medis Baru',
                    message:
                        'Rekam medis Anda sudah tersedia dan dapat diakses sekarang.',
                    time: '2 hari lalu',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({
    required this.user,
    required this.onLogout,
  });

  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return PatientScreenBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: [
            _ProfileHeroCard(user: user),
            const SizedBox(height: 20),
            _ProfileInfoCard(user: user),
            const SizedBox(height: 20),
            _ProfileSettingsCard(
              onLogout: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleTopHeader extends StatelessWidget {
  const _SimpleTopHeader({
    required this.title,
    required this.subtitle,
    this.leading,
  });

  final String title;
  final String subtitle;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 4)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A5565),
                    height: 1.2,
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

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.doctorName,
    required this.specialization,
    required this.status,
    required this.date,
    required this.time,
  });

  final String doctorName;
  final String specialization;
  final String status;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  doctorName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(label: status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Spesialis $specialization',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: Color(0xFF4A5565),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5565),
                ),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Color(0xFF99A1AF))),
              const SizedBox(width: 8),
              const Icon(
                Icons.schedule_outlined,
                size: 16,
                color: Color(0xFF4A5565),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorSearchCard extends StatelessWidget {
  const _DoctorSearchCard({
    required this.nameInitial,
    required this.name,
    required this.specialization,
    required this.schedule,
    required this.fee,
    required this.available,
    required this.isSubmitting,
    required this.onSelect,
  });

  final String nameInitial;
  final String name;
  final String specialization;
  final String schedule;
  final String fee;
  final bool available;
  final bool isSubmitting;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00BC7D), Color(0xFF009966)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80A4F4CF),
                  blurRadius: 15,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              nameInitial,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusChip(label: available ? 'Tersedia' : 'Penuh'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  specialization,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A5565),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jadwal Praktik:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF155DFC),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C398E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  fee,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF009966),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: available && !isSubmitting ? onSelect : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009966),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF009966),
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Pilih Dokter'),
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

class _MedicalRecordCard extends StatelessWidget {
  const _MedicalRecordCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFF3E8FF),
                    child: Icon(
                      Icons.description_rounded,
                      color: Color(0xFF9810FA),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '09 April 2026',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                      Text(
                        'dr. Budi Santoso, Sp.PD',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _StatusChip(label: 'Resep'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnosis',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A7282),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ISPA (Infeksi Saluran Pernapasan Atas)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101828),
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

class _BillCard extends StatelessWidget {
  const _BillCard({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFFEF3C6),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFFE17100),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '05 Apr 2026',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                      Text(
                        'dr. Budi Santoso, Sp.PD',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _StatusChip(label: status),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFF9FAFB), Color(0xFFF3F4F6)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Column(
              children: [
                _BillLine(label: 'Biaya Konsultasi', value: 'Rp 150.000'),
                SizedBox(height: 8),
                _BillLine(label: 'Biaya Obat', value: 'Rp 200.000'),
                SizedBox(height: 12),
                Divider(height: 1, color: Color(0xFFD1D5DC)),
                SizedBox(height: 12),
                _BillLine(label: 'Total', value: 'Rp 350.000', large: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BillLine extends StatelessWidget {
  const _BillLine({
    required this.label,
    required this.value,
    this.large = false,
  });

  final String label;
  final String value;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: large ? 16 : 12,
      fontWeight: large ? FontWeight.w700 : FontWeight.w600,
      color: const Color(0xFF4A5565),
    );
    final valueStyle = TextStyle(
      fontSize: large ? 20 : 12,
      fontWeight: FontWeight.w700,
      color: large ? const Color(0xFF009966) : const Color(0xFF101828),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isPending = label == 'Belum Bayar' || label == 'Penuh';
    final bg = isPending ? const Color(0xFFFFFBEB) : const Color(0xFFECFDF5);
    final border = isPending
        ? const Color(0xFFFEE685)
        : const Color(0xFFA4F4CF);
    final text = isPending ? const Color(0xFFBB4D00) : const Color(0xFF007A55);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.highlighted,
    required this.title,
    required this.message,
    required this.time,
  });

  final bool highlighted;
  final String title;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? const Color(0x4DECFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted
              ? const Color(0xFFA4F4CF)
              : const Color(0xFFF3F4F6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(21, 21, 16, 21),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: highlighted
                  ? const Color(0xFFFEF3C6)
                  : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              highlighted
                  ? Icons.calendar_month_rounded
                  : Icons.notifications_active_rounded,
              color: highlighted
                  ? const Color(0xFFE17100)
                  : const Color(0xFF155DFC),
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
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                    ),
                    if (highlighted)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFF009966),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF364153),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A7282),
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

class _DoctorSummaryCard extends StatelessWidget {
  const _DoctorSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.fromLTRB(21, 21, 16, 21),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFAD46FF), Color(0xFF9810FA)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diperiksa oleh',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A7282),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'dr. Budi Santoso, Sp.PD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Spesialis Penyakit Dalam',
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
    );
  }
}

class _VitalSignsCard extends StatelessWidget {
  const _VitalSignsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite_rounded, color: Color(0xFFFB2C36), size: 20),
              SizedBox(width: 8),
              Text(
                'Tanda Vital',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _VitalTile(
                  title: 'Tekanan Darah',
                  value: '120/80',
                  unit: 'mmHg',
                  bg: Color(0xFFEFF6FF),
                  border: Color(0xFFDBEAFE),
                  accent: Color(0xFF155DFC),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _VitalTile(
                  title: 'Berat Badan',
                  value: '72',
                  unit: 'kg',
                  bg: Color(0xFFECFDF5),
                  border: Color(0xFFD0FAE5),
                  accent: Color(0xFF009966),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  const _VitalTile({
    required this.title,
    required this.value,
    required this.unit,
    required this.bg,
    required this.border,
    required this.accent,
  });

  final String title;
  final String value;
  final String unit;
  final Color bg;
  final Color border;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTextCard extends StatelessWidget {
  const _DetailTextCard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5565),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({
    required this.iconBg,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color iconBg;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: const Color(0xFF4A5565)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A7282),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BillBreakdownCard extends StatelessWidget {
  const _BillBreakdownCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Column(
        children: [
          _BillLine(label: 'Biaya Konsultasi', value: 'Rp 150.000'),
          SizedBox(height: 8),
          _BillLine(label: 'Biaya Obat', value: 'Rp 200.000'),
          SizedBox(height: 12),
          Divider(height: 1, color: Color(0xFFD1D5DC)),
          SizedBox(height: 12),
          _BillLine(label: 'Total', value: 'Rp 350.000', large: true),
        ],
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final userName = user['name']?.toString() ?? 'Pengguna';

    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.fromLTRB(25, 33, 25, 24),
      child: Column(
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00BC7D), Color(0xFF009966)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80A4F4CF),
                  blurRadius: 25,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 56,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID Pasien: ${user['id']?.toString() ?? '-'}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Jenis Kelamin: ${user['gender']?.toString() ?? '-'}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A7282),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Edit Profil'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1A1A1A),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final userName = user['name']?.toString() ?? '-';
    final userEmail = user['email']?.toString() ?? '-';
    final userPhone = user['phone']?.toString() ?? '-';
    final userAddress = user['address']?.toString() ?? '-';

    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pribadi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            iconBg: const Color(0xFFEFF6FF),
            icon: Icons.badge_rounded,
            label: 'Nama Lengkap',
            value: userName,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            iconBg: const Color(0xFFFAF5FF),
            icon: Icons.phone_rounded,
            label: 'Nomor Telepon',
            value: userPhone,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            iconBg: const Color(0xFFECFDF5),
            icon: Icons.email_rounded,
            label: 'Email',
            value: userEmail,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            iconBg: const Color(0xFFFEF3C6),
            icon: Icons.location_on_rounded,
            label: 'Alamat',
            value: userAddress,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.iconBg,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color iconBg;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: const Color(0xFF4A5565)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A7282),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileSettingsCard extends StatelessWidget {
  const _ProfileSettingsCard({this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _SettingRow(
            icon: Icons.notifications_rounded,
            label: 'Notifikasi',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Notifikasi sedang dikembangkan')),
              );
            },
          ),
          const SizedBox(height: 12),
          _SettingRow(
            icon: Icons.lock_rounded,
            label: 'Keamanan Akun',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Keamanan Akun sedang dikembangkan')),
              );
            },
          ),
          const SizedBox(height: 12),
          _SettingRow(
            icon: Icons.logout_rounded,
            label: 'Keluar',
            danger: true,
            onTap: onLogout ?? () {},
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFFB2C36) : const Color(0xFF101828);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _QuickMenuGrid extends StatelessWidget {
  const _QuickMenuGrid({
    required this.onOpenAppointments,
    required this.onOpenAppointmentHistory,
    required this.onOpenMedicalRecords,
    required this.onOpenBills,
  });

  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenAppointmentHistory;
  final VoidCallback onOpenMedicalRecords;
  final VoidCallback onOpenBills;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 180 / 134,
      children: [
        _QuickMenuCard(
          title: 'Buat Appointment',
          icon: Icons.add_rounded,
          iconGradient: const [Color(0xFF00BC7D), Color(0xFF009966)],
          shadowColor: const Color(0x80A4F4CF),
          onTap: onOpenAppointments,
        ),
        _QuickMenuCard(
          title: 'Riwayat Kunjungan',
          icon: Icons.history_rounded,
          iconGradient: const [Color(0xFF2B7FFF), Color(0xFF155DFC)],
          shadowColor: const Color(0x80BEDBFF),
          onTap: onOpenAppointmentHistory,
        ),
        _QuickMenuCard(
          title: 'Rekam Medis',
          icon: Icons.folder_open_rounded,
          iconGradient: const [Color(0xFFAD46FF), Color(0xFF9810FA)],
          shadowColor: const Color(0x80E9D4FF),
          onTap: onOpenMedicalRecords,
        ),
        _QuickMenuCard(
          title: 'Tagihan Saya',
          icon: Icons.receipt_long_rounded,
          iconGradient: const [Color(0xFFFE9A00), Color(0xFFE17100)],
          shadowColor: const Color(0x80FEE685),
          onTap: onOpenBills,
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
    this.onTap,
  });

  final String title;
  final IconData icon;
  final List<Color> iconGradient;
  final Color shadowColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: _cardDecoration,
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
      ),
    );
  }
}

class _ActiveAppointmentCard extends StatelessWidget {
  const _ActiveAppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration.copyWith(
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 25,
            offset: Offset(0, 20),
          ),
          BoxShadow(
            color: Color(0x14000000),
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
              children: const [
                Text(
                  'Appointment Aktif',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A7282),
                    height: 1.2,
                  ),
                ),
                _StatusChip(label: 'Menunggu'),
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dr. Budi Santoso, Sp.PD',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Spesialis Penyakit Dalam',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5565),
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
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

class _GreetingBlock extends StatelessWidget {
  const _GreetingBlock({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selamat pagi 👋',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: const TextStyle(
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
    const Color activeColor = Color(0xFF009966);
    const Color inactiveColor = Color(0xFF99A1AF);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

const BoxDecoration _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(BorderSide(color: Color(0xFFF3F4F6), width: 1)),
  boxShadow: [
    BoxShadow(color: Color(0x1A000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
  ],
);

void _noop() {}
