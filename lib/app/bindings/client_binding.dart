import 'package:get/get.dart';
import '../../presentation/client/client_list_controller.dart';

class ClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientListController>(() => ClientListController());
  }
}
