import 'package:flutter/material.dart';

class ClientListScreen extends StatelessWidget {
  final List<Map<String, String>> dummyClients = [
    {'name': 'PT Maju Jaya', 'email': 'contact@majujaya.com'},
    {'name': 'CV Sinar Terang', 'email': 'info@sinarterang.co.id'},
    {'name': 'UD Sukses Selalu', 'email': 'admin@suksesselalu.id'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Klien'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: dummyClients.length,
        itemBuilder: (context, index) {
          final client = dummyClients[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.business),
                backgroundColor: Colors.blue.shade100,
              ),
              title: Text(client['name']!),
              subtitle: Text(client['email']!),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aksi ketika client diklik
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add-client');
        },
      ),
    );
  }
}
