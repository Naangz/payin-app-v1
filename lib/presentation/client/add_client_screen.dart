import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payin_app/data/models/client_info_model.dart';
import 'package:payin_app/presentation/clients/client_list_controller.dart';
import 'package:uuid/uuid.dart';

class AddClientScreen extends StatefulWidget {
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  String companyName = '';
  String contactEmail = '';

  final controller = Get.find<ClientListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Klien'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Perusahaan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Nama perusahaan wajib diisi' : null,
                onSaved: (value) => companyName = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Kontak',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Email wajib diisi' : null,
                onSaved: (value) => contactEmail = value!,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newClient = ClientInfo(
                      id: const Uuid().v4(),
                      name: companyName,
                      email: contactEmail,
                      phone: '', // Tambah field jika diperlukan
                    );

                    controller.addClient(newClient);

                    Navigator.pop(context, true); // <- Penting: beri return true
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
