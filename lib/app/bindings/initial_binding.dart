import 'package:get/get.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/repositories/analytics_repository.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/pdf_service.dart';
import '../../data/services/email_api_service.dart';
import '../../data/repositories/client_repository.dart';
import '../../data/repositories/quotation_repository.dart';
import '../../presentation/client/client_list_controller.dart';

//import '../../data/services/hive_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services - Lazy loading untuk optimasi performa
    Get.putAsync<LocalStorageService>(() => LocalStorageService.getInstance());
    
    Get.lazyPut<PdfService>(
      () => PdfService(),
      fenix: true,
    );
    
    Get.lazyPut<EmailApiService>(
      () => EmailApiService()
    );
    
    // HiveService sudah di-register di main.dart, jadi tidak perlu di sini
    
    // Repositories - Lazy loading
    Get.lazyPut<InvoiceRepository>(
      () => InvoiceRepository(),
      fenix: true,
    );
    
    Get.lazyPut<AnalyticsRepository>(
      () => AnalyticsRepository(),
      fenix: true,
    );

    //client
    Get.lazyPut<ClientRepository>(() => ClientRepository(), fenix: true);
    Get.lazyPut<QuotationRepository>(() => QuotationRepository(), fenix: true);
    Get.lazyPut<ClientListController>(() => ClientListController(), fenix: true);

    
    print('✅ Initial bindings registered successfully');
  }
}
