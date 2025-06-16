import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/quotation_model.dart';
import '../dashboard_controller.dart';
import '../../quotations/create_quotation_screen.dart';

class RecentQuotations extends StatelessWidget {
  final DashboardController controller;

  const RecentQuotations({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quotations = controller.recentQuotations;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quotation Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  final result = await Get.to(() => CreateQuotationScreen());
                  if (result == true) {
                    Get.find<DashboardController>().loadDashboardData();
                  }
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          quotations.isEmpty
              ? Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Icon(Icons.description, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Belum ada quotation'),
                      Text('Buat quotation pertama Anda untuk memulai'),
                    ],
                  ),
                ),
              )
              : Column(
                children:
                    quotations.map((q) {
                      return ListTile(
                        title: Text('Quotation #${q.quotationNumber}'),
                        subtitle: Text(
                          'Klien: ${q.clientName}\nTanggal: ${q.createdDate.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(q.formattedTotal),
                            Text(
                              q.status,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
        ],
      );
    });
  }
}
