import 'package:get/get.dart';
import 'package:payin_app/data/models/client_info_model.dart';
import 'package:payin_app/data/repositories/client_repository.dart';

class ClientListController extends GetxController {
  final ClientRepository _repository = ClientRepository();
  var clients = <ClientInfo>[].obs;

  @override
  void onInit() {
    fetchClients();
    super.onInit();
  }

  void fetchClients() async {
    final list = await _repository.getClients();
    clients.value = list;
  }

  void addClient(ClientInfo client) async {
    await _repository.addClient(client);
    fetchClients();
  }

  void deleteClient(String id) async {
    await _repository.deleteClient(id);
    fetchClients();
  }
}
