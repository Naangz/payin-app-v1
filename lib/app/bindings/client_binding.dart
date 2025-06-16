import 'package:get/get.dart';
import 'package:payin_app/presentation/clients/client_list_controller.dart';

class ClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientListController>(() => ClientListController());
  }
}
