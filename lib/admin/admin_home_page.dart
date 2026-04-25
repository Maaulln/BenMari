import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'http://localhost:3000';
const Color _primaryRed = Color(0xFFD32F2F);
const Color _lightRed = Color(0xFFFFEBEE);
const Color _darkRed = Color(0xFFB71C1C);

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    super.key,
    required this.token,
    required this.user,
    required this.onLogout,
  });

  final String token;
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

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
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminName = (widget.user['name'] ?? widget.user['nama'] ?? 'Admin')
        .toString();

    final pages = [
      _DashboardTab(token: widget.token, adminName: adminName),
      _DokterTab(token: widget.token),
      _PasienTab(token: widget.token),
      _AppointmentTab(token: widget.token),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryRed,
        foregroundColor: Colors.white,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: _primaryRed,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_rounded),
            label: 'Dokter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Pasien',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Appointment',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DASHBOARD TAB
// ─────────────────────────────────────────────
class _DashboardTab extends StatefulWidget {
  const _DashboardTab({required this.token, required this.adminName});
  final String token;
  final String adminName;

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/api/admin/stats'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        setState(() {
          _stats = body['data'];
          _loading = false;
        });
      } else {
        setState(() {
          _error = body['message'];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: _primaryRed,
      onRefresh: _loadStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primaryRed, _darkRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.waving_hand_rounded,
                    color: Colors.amber,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selamat datang,',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.adminName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _todayString(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Statistik Klinik',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator(color: _primaryRed))
            else if (_error != null)
              _ErrorBox(message: _error!, onRetry: _loadStats)
            else
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _StatCard(
                    label: 'Total Dokter',
                    value: '${_stats!['totalDokter']}',
                    icon: Icons.medical_services_rounded,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    label: 'Total Pasien',
                    value: '${_stats!['totalPasien']}',
                    icon: Icons.people_rounded,
                    color: Colors.green,
                  ),
                  _StatCard(
                    label: 'Total Appointment',
                    value: '${_stats!['totalAppointment']}',
                    icon: Icons.calendar_month_rounded,
                    color: _primaryRed,
                  ),
                  _StatCard(
                    label: 'Menunggu',
                    value: '${_stats!['appointmentMenunggu']}',
                    icon: Icons.hourglass_empty_rounded,
                    color: Colors.orange,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _todayString() {
    final now = DateTime.now();
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month]} ${now.year}';
  }
}

// ─────────────────────────────────────────────
// DOKTER TAB
// ─────────────────────────────────────────────
class _DokterTab extends StatefulWidget {
  const _DokterTab({required this.token});
  final String token;

  @override
  State<_DokterTab> createState() => _DokterTabState();
}

class _DokterTabState extends State<_DokterTab> {
  List<dynamic> _items = [];
  bool _loading = true;
  String? _error;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({String? search}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final uri = Uri.parse('$_baseUrl/api/admin/doctors').replace(
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final res = await http.get(
        uri,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        setState(() {
          _items = body['data']['items'] ?? [];
          _loading = false;
        });
      } else {
        setState(() {
          _error = body['message'];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _toggleStatus(dynamic dokter) async {
    final currentStatus = dokter['isActive'] ?? dokter['raw']?['STATUS_AKTIF'];
    final newStatus = (currentStatus == 1 || currentStatus == '1') ? '0' : '1';
    final id = dokter['id'];
    try {
      await http.put(
        Uri.parse('$_baseUrl/api/admin/doctors/$id/status'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'statusAktif': newStatus}),
      );
      _load(search: _searchCtrl.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Cari dokter...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
            onChanged: (v) => _load(search: v),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: _primaryRed),
                )
              : _error != null
              ? _ErrorBox(message: _error!, onRetry: _load)
              : _items.isEmpty
              ? const Center(child: Text('Tidak ada data dokter'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _items.length,
                  itemBuilder: (ctx, i) {
                    final d = _items[i];
                    final isActive =
                        d['isActive'] == 1 ||
                        d['isActive'] == '1' ||
                        d['raw']?['STATUS_AKTIF'] == 1 ||
                        d['raw']?['STATUS_AKTIF'] == '1';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isActive
                              ? _lightRed
                              : Colors.grey.shade200,
                          child: Icon(
                            Icons.person_rounded,
                            color: isActive ? _primaryRed : Colors.grey,
                          ),
                        ),
                        title: Text(
                          d['name'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(d['specialization'] ?? '-'),
                        trailing: Switch(
                          value: isActive,
                          activeThumbColor: _primaryRed,
                          onChanged: (_) => _toggleStatus(d),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PASIEN TAB
// ─────────────────────────────────────────────
class _PasienTab extends StatefulWidget {
  const _PasienTab({required this.token});
  final String token;

  @override
  State<_PasienTab> createState() => _PasienTabState();
}

class _PasienTabState extends State<_PasienTab> {
  List<dynamic> _items = [];
  bool _loading = true;
  String? _error;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({String? search}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final uri = Uri.parse('$_baseUrl/api/admin/patients').replace(
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final res = await http.get(
        uri,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        setState(() {
          _items = body['data']['items'] ?? [];
          _loading = false;
        });
      } else {
        setState(() {
          _error = body['message'];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Cari pasien...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
            onChanged: (v) => _load(search: v),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: _primaryRed),
                )
              : _error != null
              ? _ErrorBox(message: _error!, onRetry: _load)
              : _items.isEmpty
              ? const Center(child: Text('Tidak ada data pasien'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _items.length,
                  itemBuilder: (ctx, i) {
                    final p = _items[i];
                    final gender = p['JENIS_KELAMIN'] ?? '-';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _lightRed,
                          child: Text(
                            (p['NAMA_LENGKAP'] ?? 'P')
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: _primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          p['NAMA_LENGKAP'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['EMAIL_PASIEN'] ?? '-'),
                            Text(
                              '${gender == 'L'
                                  ? 'Laki-laki'
                                  : gender == 'P'
                                  ? 'Perempuan'
                                  : gender}'
                              ' • ${p['NO_TELEPON'] ?? '-'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// APPOINTMENT TAB
// ─────────────────────────────────────────────
class _AppointmentTab extends StatefulWidget {
  const _AppointmentTab({required this.token});
  final String token;

  @override
  State<_AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<_AppointmentTab> {
  List<dynamic> _items = [];
  bool _loading = true;
  String? _error;
  String? _filterStatus;
  final _searchCtrl = TextEditingController();

  final _statusOptions = [
    null,
    'MENUNGGU',
    'SEDANG DIPERIKSA',
    'SELESAI',
    'BATAL',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({String? search, String? status}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final params = <String, String>{};
      if (search != null && search.isNotEmpty) params['search'] = search;
      if (status != null) params['status'] = status;
      final uri = Uri.parse(
        '$_baseUrl/api/admin/appointments',
      ).replace(queryParameters: params.isEmpty ? null : params);
      final res = await http.get(
        uri,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        setState(() {
          _items = body['data']['items'] ?? [];
          _loading = false;
        });
      } else {
        setState(() {
          _error = body['message'];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _statusColor(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'SELESAI':
        return Colors.green;
      case 'SEDANG DIPERIKSA':
        return Colors.blue;
      case 'BATAL':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Cari pasien atau dokter...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
            onChanged: (v) => _load(search: v, status: _filterStatus),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: _statusOptions.map((s) {
              final isSelected = _filterStatus == s;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(s ?? 'Semua'),
                  selected: isSelected,
                  selectedColor: _primaryRed,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                  onSelected: (_) {
                    setState(() => _filterStatus = s);
                    _load(search: _searchCtrl.text, status: s);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: _primaryRed),
                )
              : _error != null
              ? _ErrorBox(message: _error!, onRetry: _load)
              : _items.isEmpty
              ? const Center(child: Text('Tidak ada data appointment'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _items.length,
                  itemBuilder: (ctx, i) {
                    final a = _items[i];
                    final status = a['STATUS'] ?? '-';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'No. ${a['NOMOR_ANTRIAN'] ?? '-'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _primaryRed,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(
                                      status,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: _statusColor(status),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              a['NAMA_PASIEN'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${a['NAMA_DOKTER'] ?? '-'} • ${a['SPESIALISASI'] ?? '-'}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${a['TGL_APPOINTMENT'] ?? '-'}  ${a['JAM_APPOINTMENT'] ?? '-'}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            if (a['KELUHAN_AWAL'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Keluhan: ${a['KELUHAN_AWAL']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: _primaryRed, size: 48),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryRed,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
