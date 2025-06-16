import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/client_info_model.dart';
import '../../presentation/client/client_list_controller.dart';
import '../../app/routes/app_routes.dart';

class ClientListScreen extends GetView<ClientListController> {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Klien'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.clients.isEmpty) {
          return const Center(child: Text("Belum ada klien"));
        }

        return ListView.builder(
          itemCount: controller.clients.length,
          itemBuilder: (context, index) {
            final client = controller.clients[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.business),
                ),
                title: Text(client.name),
                subtitle: Text(client.email),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.ADD_CLIENT,
          );
          if (result == true) {
            controller.fetchClients(); // Refresh list setelah tambah
          }
        },
      ),
    );
  }
}
