import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'doctor_api.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user, required this.onSaved});

  final Map<String, dynamic> user;
  final void Function(Map<String, dynamic> updatedUser) onSaved;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.user['name']?.toString() ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.user['phone']?.toString() ?? '',
    );
    _addressController = TextEditingController(
      text: widget.user['address']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      setState(() => _error = 'Nama dan telepon wajib diisi');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final pasienId = widget.user['id']?.toString() ?? '1';
      final uri = Uri.parse('${apiBaseUrl()}/api/auth/update-pasien/$pasienId');

      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'phone': phone, 'address': address}),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && decoded['success'] == true) {
        final updatedUser =
            decoded['user'] as Map<String, dynamic>? ?? widget.user;
        widget.onSaved(updatedUser);
        if (mounted) Navigator.of(context).pop();
      } else {
        setState(() => _error = decoded['message'] ?? 'Gagal menyimpan');
      }
    } catch (e) {
      setState(() => _error = 'Koneksi error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF101828),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildField('Nama Lengkap', _nameController, Icons.badge_rounded),
          const SizedBox(height: 16),
          _buildField(
            'Nomor Telepon',
            _phoneController,
            Icons.phone_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildField(
            'Alamat',
            _addressController,
            Icons.location_on_rounded,
            maxLines: 3,
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE4E2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF04438)),
              ),
              child: Text(
                _error!,
                style: const TextStyle(
                  color: Color(0xFFD92D20),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009966),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF98A2B3)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF009966)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
