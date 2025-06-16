import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/invoice_repository.dart';
import '../../../data/models/invoice_model.dart';
import '../../../data/models/invoice_item_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/repositories/client_repository.dart';

class CreateInvoiceController extends GetxController {
  final InvoiceRepository _invoiceRepository = Get.find<InvoiceRepository>();
  LocalStorageService? _localStorage;
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<InvoiceItem> items = <InvoiceItem>[].obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;
  final RxDouble taxRate = 11.0.obs;

  // Form controllers
  final clientNameController = TextEditingController();
  final clientEmailController = TextEditingController();
  final clientPhoneController = TextEditingController();
  final clientAddressController = TextEditingController();
  final clientCompanyController = TextEditingController();
  final dueDateController = TextEditingController();
  final notesController = TextEditingController();
  final discountController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Save Client
  final ClientRepository _clientRepository = Get.find<ClientRepository>();

  @override
  void onInit() {
    super.onInit();
    _initializeLocalStorage();
    _setDefaultDueDate();
    _loadTaxRate();
  }

  @override
  void onClose() {
    clientNameController.dispose();
    clientEmailController.dispose();
    clientPhoneController.dispose();
    clientAddressController.dispose();
    clientCompanyController.dispose();
    dueDateController.dispose();
    notesController.dispose();
    discountController.dispose();
    super.onClose();
  }

  Future<void> _initializeLocalStorage() async {
    try {
      _localStorage = await LocalStorageService.getInstance();
    } catch (e) {
      print('Error initializing LocalStorage: $e');
    }
  }

  void _setDefaultDueDate() {
    final defaultDueDate = DateTime.now().add(const Duration(days: 30));
    dueDateController.text = '${defaultDueDate.day}/${defaultDueDate.month}/${defaultDueDate.year}';
  }

  void _loadTaxRate() {
    if (_localStorage != null) {
      taxRate.value = _localStorage!.getTaxRate();
    }
  }

  void addItem() {
    Get.dialog(
      _buildAddItemDialog(),
    );
  }

  void editItem(int index) {
    final item = items[index];
    Get.dialog(
      _buildAddItemDialog(item: item, index: index),
    );
  }

  void removeItem(int index) {
    items.removeAt(index);
    calculateTotals();
  }

  void calculateTotals() {
    subtotal.value = items.fold(0.0, (sum, item) => sum + item.total);
    tax.value = (subtotal.value * taxRate.value) / 100;
    
    final discountValue = double.tryParse(discountController.text) ?? 0.0;
    discount.value = discountValue;
    
    total.value = subtotal.value + tax.value - discount.value;
  }

  Future<void> saveInvoice({bool isDraft = true}) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (items.isEmpty) {
      Get.snackbar('Error', 'Tambahkan minimal satu item invoice');
      return;
    }

    try {
      isLoading.value = true;

      final dueDate = _parseDateFromString(dueDateController.text);
      if (dueDate == null) {
        Get.snackbar('Error', 'Format tanggal jatuh tempo tidak valid');
        return;
      }

      await saveClientIfNotExists();

      final invoice = Invoice.create(
        clientName: clientNameController.text.trim(),
        clientEmail: clientEmailController.text.trim(),
        clientPhone: clientPhoneController.text.trim(),
        clientAddress: clientAddressController.text.trim(),
        clientCompany: clientCompanyController.text.trim().isEmpty 
            ? null 
            : clientCompanyController.text.trim(),
        items: items.toList(),
        taxRate: taxRate.value,
        discount: discount.value,
        notes: notesController.text.trim().isEmpty 
            ? null 
            : notesController.text.trim(),
      ).copyWith(
        dueDate: dueDate,
        status: isDraft ? 'draft' : 'sent',
      );

      final invoiceId = await _invoiceRepository.createInvoice(invoice);

      Get.snackbar(
        'Berhasil',
        isDraft ? 'Invoice berhasil disimpan sebagai draft' : 'Invoice berhasil dibuat dan dikirim',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed('/invoice-detail', arguments: invoiceId);
    } catch (e) {
      print('❌ Error saving invoice: $e');
      Get.snackbar('Error', 'Gagal menyimpan invoice');
    } finally {
      isLoading.value = false;
    }
  }

  DateTime? _parseDateFromString(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return null;
  }

  Widget _buildAddItemDialog({InvoiceItem? item, int? index}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final quantityController = TextEditingController(text: item?.quantity.toString() ?? '1');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final itemDiscountController = TextEditingController(text: item?.discount.toString() ?? '0');

    return AlertDialog(
      title: Text(item == null ? 'Tambah Item' : 'Edit Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Harga Satuan',
                      border: OutlineInputBorder(),
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: itemDiscountController,
              decoration: const InputDecoration(
                labelText: 'Diskon',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final description = descriptionController.text.trim();
            final quantity = int.tryParse(quantityController.text) ?? 1;
            final price = double.tryParse(priceController.text) ?? 0.0;
            final itemDiscount = double.tryParse(itemDiscountController.text) ?? 0.0;

            if (name.isEmpty || description.isEmpty || price <= 0) {
              Get.snackbar('Error', 'Lengkapi semua field dengan benar');
              return;
            }

            final newItem = InvoiceItem.create(
              name: name,
              description: description,
              quantity: quantity,
              price: price,
              discount: itemDiscount,
            );

            if (index != null) {
              items[index] = newItem;
            } else {
              items.add(newItem);
            }

            calculateTotals();
            Get.back();
          },
          child: Text(item == null ? 'Tambah' : 'Update'),
        ),
      ],
    );
  }

  Future<void> saveClientIfNotExists() async {
  final name = clientNameController.text.trim();
  final email = clientEmailController.text.trim();
  final phone = clientPhoneController.text.trim();
  final address = clientAddressController.text.trim();
  final company = clientCompanyController.text.trim().isEmpty
      ? null
      : clientCompanyController.text.trim();

  if (email.isEmpty) return;

  final existingClient = await _clientRepository.findByEmail(email);

  if (existingClient == null) {
    await _clientRepository.createClient(
      name: name,
      email: email,
      phone: phone,
      address: address,
      company: company,
    );
  }
}


}
