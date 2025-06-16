import '../models/client_info_model.dart';
import '../services/local_storage_service.dart';

class ClientRepository {
  final _boxKey = 'clients';

  Future<void> addClient(ClientInfo client) async {
    final clients = await getClients();
    clients.add(client);
    await LocalStorageService.saveList(_boxKey, clients);
  }

  Future<List<ClientInfo>> getClients() async {
    final list = await LocalStorageService.getList<ClientInfo>(
      _boxKey,
      (json) => ClientInfo.fromJson(json),
    );
    return list;
  }

  Future<void> deleteClient(String id) async {
    final clients = await getClients();
    clients.removeWhere((c) => c.id == id);
    await LocalStorageService.saveList(_boxKey, clients);
  }
}
