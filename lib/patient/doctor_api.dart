import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String apiBaseUrl() {
  const override = String.fromEnvironment('API_BASE_URL');
  if (override.isNotEmpty) {
    return override;
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000';
  }

  return 'http://localhost:3000';
}

class DoctorItem {
  const DoctorItem({
    required this.id,
    required this.name,
    required this.specialization,
    required this.schedule,
    required this.fee,
    required this.phone,
    required this.available,
  });

  final String id;
  final String name;
  final String specialization;
  final String schedule;
  final String fee;
  final String phone;
  final bool available;

  String get initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }

    return trimmed.substring(0, 1).toUpperCase();
  }

  factory DoctorItem.fromApi(Map<String, dynamic> json) {
    final raw = (json['raw'] is Map<String, dynamic>)
        ? json['raw'] as Map<String, dynamic>
        : <String, dynamic>{};

    final feeRaw = raw['BIAYA_KONSULTASI'];
    final parsedFee = feeRaw is num ? feeRaw.toInt() : int.tryParse('$feeRaw');

    return DoctorItem(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? '-'}',
      specialization: '${json['specialization'] ?? '-'}',
      schedule: '${raw['JADWAL_PRAKTIK'] ?? '-'}',
      fee: parsedFee != null ? 'Rp ${parsedFee.toString()}' : '-',
      phone: '${json['phone'] ?? '-'}',
      available: () {
        final v = json['isActive'];
        if (v == null) return false;
        if (v == true || v == 1) return true;
        final s = '$v'.toUpperCase();
        return s == 'Y' || s == '1' || s == 'TRUE' || s == 'ACTIVE';
      }(),
    );
  }
}

class DoctorApi {
  const DoctorApi();

  Future<List<DoctorItem>> fetchDoctors({int limit = 20}) async {
    final uri = Uri.parse('${apiBaseUrl()}/api/doctors?limit=$limit&offset=0');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal ambil data dokter: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>?;
    final items = data?['items'] as List<dynamic>? ?? const [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(DoctorItem.fromApi)
        .toList();
  }

  Future<Map<String, dynamic>> createAppointment(
    AppointmentPayload payload,
  ) async {
    final uri = Uri.parse('${apiBaseUrl()}/api/appointments');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload.toJson()),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      final message = decoded['message'] ?? 'Gagal membuat appointment.';
      throw Exception('$message');
    }

    final data = decoded['data'] as Map<String, dynamic>?;
    return data ?? <String, dynamic>{};
  }

  Future<List<AppointmentItem>> fetchAppointmentsByPatient(int pasienId) async {
    final uri = Uri.parse(
      '${apiBaseUrl()}/api/appointments?pasienId=$pasienId',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal ambil data appointment: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>?;
    final items = data?['items'] as List<dynamic>? ?? const [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(AppointmentItem.fromApi)
        .toList();
  }
}

class AppointmentItem {
  const AppointmentItem({
    required this.id,
    required this.doctorName,
    required this.specialization,
    required this.status,
    required this.date,
    required this.time,
  });

  final int id;
  final String doctorName;
  final String specialization;
  final String status;
  final String date;
  final String time;

  String get statusLabel {
    final normalized = status.toUpperCase();
    if (normalized == 'MENUNGGU') {
      return 'Menunggu';
    }
    if (normalized == 'SELESAI') {
      return 'Selesai';
    }
    if (normalized == 'BATAL') {
      return 'Batal';
    }

    return status;
  }

  factory AppointmentItem.fromApi(Map<String, dynamic> json) {
    return AppointmentItem(
      id: int.tryParse('${json['APPOINTMENT_ID'] ?? 0}') ?? 0,
      doctorName: '${json['NAMA_DOKTER'] ?? 'dr. -'}',
      specialization: '${json['SPESIALISASI'] ?? '-'}',
      status: '${json['STATUS'] ?? 'MENUNGGU'}',
      date: '${json['TANGGAL_APPOINTMENT'] ?? '-'}',
      time: '${json['JAM_APPOINTMENT'] ?? '-'}',
    );
  }
}

class AppointmentPayload {
  const AppointmentPayload({
    required this.pasienId,
    required this.dokterId,
    required this.tanggalAppointment,
    required this.jamAppointment,
    this.keluhanAwal,
    this.catatan,
  });

  final int pasienId;
  final int dokterId;
  final String tanggalAppointment;
  final String jamAppointment;
  final String? keluhanAwal;
  final String? catatan;

  Map<String, dynamic> toJson() {
    return {
      'pasienId': pasienId,
      'dokterId': dokterId,
      'tanggalAppointment': tanggalAppointment,
      'jamAppointment': jamAppointment,
      'keluhanAwal': keluhanAwal,
      'catatan': catatan,
    };
  }
}
