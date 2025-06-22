import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'data/services/hive_service.dart';
import 'data/repositories/client_repository.dart';
import 'data/repositories/invoice_repository.dart';
import 'data/repositories/quotation_repository.dart';
import 'presentation/client/client_list_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set orientasi hanya portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inisialisasi layanan dan dependency
  await _initializeServices();

  // Inisialisasi format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  // Styling status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Jalankan aplikasi (PayInApp sudah mengandung GetMaterialApp)
  runApp(const PayInApp());
}

Future<void> _initializeServices() async {
  try {
    final hiveService = HiveService();
    await hiveService.init();

    Get.put<HiveService>(hiveService, permanent: true);
    Get.put(ClientRepository());
    Get.put(InvoiceRepository());
    Get.put(QuotationRepository());
    Get.put(ClientListController());

    print('✅ Services initialized successfully');
  } catch (e) {
    print('❌ Error initializing services: $e');
  }
}
