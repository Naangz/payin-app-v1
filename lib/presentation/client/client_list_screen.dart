import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/client_info_model.dart';
import '../../presentation/client/client_list_controller.dart';

class ClientListScreen extends GetView<ClientListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Klien'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.clients.isEmpty) {
          return Center(child: Text("Belum ada klien"));
        }

        return ListView.builder(
          itemCount: controller.clients.length,
          itemBuilder: (context, index) {
            final client = controller.clients[index];
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
                title: Text(client.name),
                subtitle: Text(client.email),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Aksi ketika klien diklik (misal detail)
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-client');
          if (result == true) {
            controller.fetchClients(); // Refresh list setelah tambah
          }
        },
      ),
    );
  }
}
