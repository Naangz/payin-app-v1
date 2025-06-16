import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/invoice_repository.dart';
import '../../../data/models/invoice_model.dart';

class InvoiceListController extends GetxController {
  final InvoiceRepository _invoiceRepository = Get.find<InvoiceRepository>();
  
  final RxBool isLoading = false.obs;
  final RxList<Invoice> invoices = <Invoice>[].obs;
  final RxList<Invoice> filteredInvoices = <Invoice>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = 'all'.obs;
  
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    try {
      isLoading.value = true;
      
      final allInvoices = _invoiceRepository.getAllInvoices();
      allInvoices.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      
      invoices.value = allInvoices;
      filterInvoices();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar invoice');
    } finally {
      isLoading.value = false;
    }
  }

  void filterInvoices() {
    var filtered = invoices.toList();
    
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((invoice) =>
          invoice.invoiceNumber.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          invoice.clientName.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    if (selectedStatus.value != 'all') {
      filtered = filtered.where((invoice) => 
          invoice.status.toLowerCase() == selectedStatus.value.toLowerCase()).toList();
    }
    
    filteredInvoices.value = filtered;
  }

  // PERBAIKAN: Tambahkan method yang hilang sesuai memory entries[2]
  void editInvoice(String invoiceId) {
    Get.toNamed('/edit-invoice', arguments: invoiceId);
  }

  void navigateToCreateInvoice() {
    Get.toNamed('/create-invoice');
  }

  void navigateToInvoiceDetail(String invoiceId) {
    Get.toNamed('/invoice-detail', arguments: invoiceId);
  }

  // TAMBAHAN: Method untuk actions lainnya sesuai memory entries[2] dan [3]
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus invoice ini?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        isLoading.value = true;
        
        final success = await _invoiceRepository.deleteInvoice(invoiceId);
        if (success) {
          await loadInvoices(); // Reload data
          Get.snackbar(
            'Berhasil',
            'Invoice berhasil dihapus',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print('❌ Error deleting invoice: $e');
      Get.snackbar('Error', 'Gagal menghapus invoice');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> duplicateInvoice(String invoiceId) async {
    try {
      isLoading.value = true;
      
      final newInvoiceId = await _invoiceRepository.duplicateInvoice(invoiceId);
      
      await loadInvoices(); // Reload data
      
      Get.snackbar(
        'Berhasil',
        'Invoice berhasil diduplikasi',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to edit the duplicated invoice
      editInvoice(newInvoiceId);
    } catch (e) {
      print('❌ Error duplicating invoice: $e');
      Get.snackbar('Error', 'Gagal menduplikasi invoice');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInvoiceStatus(String invoiceId, String newStatus) async {
    try {
      isLoading.value = true;
      
      final success = await _invoiceRepository.updateInvoiceStatus(invoiceId, newStatus);
      if (success) {
        await loadInvoices(); // Reload data
        Get.snackbar(
          'Berhasil',
          'Status invoice berhasil diubah',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error updating status: $e');
      Get.snackbar('Error', 'Gagal mengubah status invoice');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsPaid(String invoiceId) async {
    await updateInvoiceStatus(invoiceId, 'paid');
  }

  Future<void> markAsSent(String invoiceId) async {
    await updateInvoiceStatus(invoiceId, 'sent');
  }

  Future<void> generatePdf(String invoiceId) async {
    // Implementation akan ditambahkan ketika PDF service siap
    Get.snackbar('Info', 'Fitur PDF invoice sedang dikembangkan');
  }

  Future<void> sendEmail(String invoiceId) async {
    // Implementation akan ditambahkan ketika email service siap
    Get.snackbar('Info', 'Fitur kirim email invoice sedang dikembangkan');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
