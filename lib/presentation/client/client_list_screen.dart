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
      backgroundColor: Colors.white, // Latar belakang putih
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
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDCE0E4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.business, color: Colors.blue),
                ),
                title: Text(
                  client.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  client.email,
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Tampilkan detail atau navigasi
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: Text(client.name),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (client.company != null &&
                                  client.company!.isNotEmpty)
                                Text('Perusahaan: ${client.company}'),
                              Text('Email: ${client.email}'),
                              Text('Telepon: ${client.phone}'),
                              Text('Alamat: ${client.address}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                  );
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
            controller.loadClients(); // Refresh list setelah tambah
          }
        },
      ),
    );
  }
}
