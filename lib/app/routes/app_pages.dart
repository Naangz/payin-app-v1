import 'package:flutter/material.dart'; // IMPORT INI YANG HILANG
import 'package:get/get.dart';
import 'package:pay_in/presentation/analytics/analytics_screen.dart';
import 'package:pay_in/presentation/invoice/create_invoice_screen.dart';
import 'package:pay_in/presentation/invoice/edit_invoice_screen.dart';
import 'package:pay_in/presentation/invoice/invoice_detail_screen.dart';
import 'package:pay_in/presentation/invoice/invoice_list_screen.dart';
import 'package:pay_in/presentation/quotations/edit_quotation_screen.dart';
import 'package:pay_in/presentation/quotations/quotation_detail_screen.dart';
import 'app_routes.dart';
import '../../presentation/dashboard/dashboard_screen.dart';
import '../../presentation/settings/settings_screen.dart';
//import '../bindings/initial_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/invoice_binding.dart';
import '../bindings/analytics_binding.dart';
import '../bindings/settings_binding.dart';
import '../../presentation/quotations/quotation_list_screen.dart';
import '../../presentation/quotations/create_quotation_screen.dart';
import '../bindings/quotation_binding.dart';
import 'package:pay_in/presentation/client/client_list_screen.dart';
import 'package:pay_in/app/bindings/client_binding.dart';
import 'package:pay_in/presentation/client/add_client_screen.dart';

class AppPages {
  static const INITIAL = AppRoutes.DASHBOARD;

  static final routes = [
    // Dashboard
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),

    // Invoice routes
    GetPage(
      name: AppRoutes.INVOICE_LIST,
      page: () => InvoiceListScreen(),
      binding: InvoiceBinding(),
    ),

    GetPage(
      name: AppRoutes.CREATE_INVOICE,
      page: () => CreateInvoiceScreen(),
      binding: InvoiceBinding(),
    ),

    GetPage(
      name: AppRoutes.INVOICE_DETAIL,
      page: () => InvoiceDetailScreen(),
      binding: InvoiceBinding(),
    ),

    GetPage(
      name: AppRoutes.EDIT_INVOICE,
      page: () => EditInvoiceScreen(),
      binding: InvoiceBinding(),
    ),

    GetPage(
      name: AppRoutes.QUOTATION_LIST,
      page: () => const QuotationListScreen(),
      binding: QuotationBinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_QUOTATION,
      page:
          () =>
              CreateQuotationScreen(), // Ganti dengan screen yang sudah dibuat
      binding: QuotationBinding(),
    ),
    GetPage(
      name: AppRoutes.QUOTATION_DETAIL,
      page: () => QuotationDetailScreen(), // Sementara placeholder
      binding: QuotationBinding(),
    ),
    GetPage(
      name: AppRoutes.EDIT_QUOTATION,
      page: () => EditQuotationScreen(), // Sementara placeholder
      binding: QuotationBinding(),
    ),

    // Analytics
    GetPage(
      name: AppRoutes.ANALYTICS,
      page: () => AnalyticsScreen(),
      binding: AnalyticsBinding(),
    ),

    // Settings
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => SettingsScreen(), // Ganti dari placeholder
      binding: SettingsBinding(),
    ),

    //Client
    GetPage(
      name: AppRoutes.CLIENT_LIST,
      page: () => ClientListScreen(),
      binding: ClientBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_CLIENT,
      page: () => AddClientScreen(), // <- ganti dengan nama class screen kamu
    ),
  ];
}

// Placeholder Widgets untuk halaman yang belum dibuat
class InvoiceListPlaceholder extends StatelessWidget {
  const InvoiceListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Invoice'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Daftar Invoice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman ini sedang dalam pengembangan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateInvoicePlaceholder extends StatelessWidget {
  const CreateInvoicePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Invoice'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Buat Invoice Baru',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman ini sedang dalam pengembangan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceDetailPlaceholder extends StatelessWidget {
  const InvoiceDetailPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Invoice'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Detail Invoice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman ini sedang dalam pengembangan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class EditInvoicePlaceholder extends StatelessWidget {
  const EditInvoicePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Invoice'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, size: 64, color: Colors.purple),
            SizedBox(height: 16),
            Text(
              'Edit Invoice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman ini sedang dalam pengembangan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsPlaceholder extends StatelessWidget {
  const AnalyticsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: Colors.teal),
            SizedBox(height: 16),
            Text(
              'Analytics & Laporan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman ini sedang dalam pengembangan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPlaceholder extends StatelessWidget {
  const SettingsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Pengaturan Aplikasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman ini sedang dalam pengembangan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
