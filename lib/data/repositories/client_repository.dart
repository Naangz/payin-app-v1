import 'package:uuid/uuid.dart';
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

  Future<ClientInfo?> findByEmail(String email) async {
    final clients = await getClients();
    try {
      return clients.firstWhere(
        (c) => c.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> createClient({
    required String name,
    required String email,
    required String phone,
    required String address,
    String? company,
  }) async {
    final newClient = ClientInfo(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      address: address,
      company: company,
    );
    await addClient(newClient);
  }
}
