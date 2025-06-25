import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/client_info_model.dart';
import '../../presentation/client/client_list_controller.dart';
import 'package:uuid/uuid.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  String clientName = '';
  String clientPhone = '';
  String contactEmail = '';
  String address = '';
  String companyName = '';

  final controller = Get.find<ClientListController>();

  InputDecoration buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      prefixIcon: Icon(icon, color: Colors.blue),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFDCE0E4)),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFDCE0E4)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        title: const Text('Tambah Klien'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.black87),
                  decoration: buildInputDecoration(
                    label: 'Nama Klien *',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama klien wajib diisi' : null,
                  onSaved: (value) => clientName = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.black87),
                  decoration: buildInputDecoration(
                    label: 'Nomor Telepon *',
                    icon: Icons.phone_outlined,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Nomor telepon wajib diisi' : null,
                  onSaved: (value) => clientPhone = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.black87),
                  decoration: buildInputDecoration(
                    label: 'Nama Perusahaan',
                    icon: Icons.business_outlined,
                  ),
                  onSaved: (value) => companyName = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.black87),
                  decoration: buildInputDecoration(
                    label: 'Email Kontak *',
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Email wajib diisi' : null,
                  onSaved: (value) => contactEmail = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.black87),
                  decoration: buildInputDecoration(
                    label: 'Alamat Perusahaan *',
                    icon: Icons.location_on_outlined,
                  ),
                  onSaved: (value) => address = value ?? '',
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final newClient = ClientInfo(
                        id: const Uuid().v4(),
                        name: clientName,
                        email: contactEmail,
                        phone: clientPhone,
                        address: address,
                        company: companyName,
                      );

                      controller.addClient(newClient);

                      Navigator.pop(context, true);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
