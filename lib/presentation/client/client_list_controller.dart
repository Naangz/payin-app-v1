import 'package:get/get.dart';
import '../../../data/models/client_info_model.dart';
import '../../../data/repositories/client_repository.dart';

class ClientListController extends GetxController {
  final ClientRepository _repository = ClientRepository();
  var clients = <ClientInfo>[].obs;

  @override
  void onInit() {
    loadClients();
    super.onInit();
  }

  Future<void> loadClients() async {
    final list = await _repository.getClients();
    clients.assignAll(list);
  }

  void addClient(ClientInfo client) async {
    await _repository.addClient(client);
    loadClients();
  }

  void deleteClient(String id) async {
    await _repository.deleteClient(id);
    loadClients();
  }
}
