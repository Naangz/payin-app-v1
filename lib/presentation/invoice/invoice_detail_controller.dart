import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/invoice_repository.dart';
import '../../../data/models/invoice_model.dart';
import '../../../data/services/pdf_service.dart';
import '../../../data/services/email_service.dart';

class InvoiceDetailController extends GetxController {
  final InvoiceRepository _invoiceRepository = Get.find<InvoiceRepository>();
  final PdfService _pdfService = Get.find<PdfService>();
  final EmailService _emailService = Get.find<EmailService>();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final Rx<Invoice?> invoice = Rx<Invoice?>(null);
  
  String? invoiceId;

  @override
  void onInit() {
    super.onInit();
    invoiceId = Get.arguments as String?;
    if (invoiceId != null) {
      loadInvoice();
    }
  }

  void loadInvoice() {
    try {
      isLoading.value = true;
      
      if (invoiceId != null) {
        final loadedInvoice = _invoiceRepository.getInvoiceById(invoiceId!);
        invoice.value = loadedInvoice;
        
        if (loadedInvoice == null) {
          Get.snackbar('Error', 'Invoice tidak ditemukan');
          Get.back();
        }
      }
    } catch (e) {
      print('❌ Error loading invoice: $e');
      Get.snackbar('Error', 'Gagal memuat invoice');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String newStatus) async {
    try {
      if (invoiceId == null) return;
      
      isLoading.value = true;
      
      final success = await _invoiceRepository.updateInvoiceStatus(invoiceId!, newStatus);
      if (success) {
        loadInvoice(); // Reload to get updated data
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

  Future<void> generatePdf() async {
    try {
      if (invoice.value == null) return;
      
      isLoading.value = true;
      
      final pdfBytes = await _pdfService.generateInvoicePdf(invoice.value!);
      await _pdfService.sharePdf(pdfBytes, 'Invoice_${invoice.value!.invoiceNumber}');
      
      Get.snackbar(
        'Berhasil',
        'PDF invoice berhasil dibuat',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Error generating PDF: $e');
      Get.snackbar('Error', 'Gagal membuat PDF invoice');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendEmail() async {
    try {
      if (invoice.value == null) return;
      
      isLoading.value = true;
      
      final pdfBytes = await _pdfService.generateInvoicePdf(invoice.value!);
      final success = await _emailService.sendInvoiceEmail(
        invoice: invoice.value!,
        pdfBytes: pdfBytes,
      );
      
      if (success) {
        await updateStatus('sent');
        Get.snackbar(
          'Berhasil',
          'Invoice berhasil dikirim via email',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Gagal mengirim email invoice');
      }
    } catch (e) {
      print('❌ Error sending email: $e');
      Get.snackbar('Error', 'Gagal mengirim email invoice');
    } finally {
      isLoading.value = false;
    }
  }

  void editInvoice() {
    if (invoiceId != null && canEdit) {
      Get.toNamed('/edit-invoice', arguments: invoiceId);
    } else {
      showEditRestrictedDialog();
    }
  }

  Future<void> deleteInvoice() async {
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
      
      if (confirmed == true && invoiceId != null) {
        isLoading.value = true;
        
        final success = await _invoiceRepository.deleteInvoice(invoiceId!);
        if (success) {
          Get.snackbar(
            'Berhasil',
            'Invoice berhasil dihapus',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAllNamed('/invoice-list');
        }
      }
    } catch (e) {
      print('❌ Error deleting invoice: $e');
      Get.snackbar('Error', 'Gagal menghapus invoice');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> duplicateInvoice() async {
    try {
      if (invoiceId == null) return;
      
      isLoading.value = true;
      
      final newInvoiceId = await _invoiceRepository.duplicateInvoice(invoiceId!);
      
      Get.snackbar(
        'Berhasil',
        'Invoice berhasil diduplikasi',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to edit the duplicated invoice
      Get.toNamed('/edit-invoice', arguments: newInvoiceId);
    } catch (e) {
      print('❌ Error duplicating invoice: $e');
      Get.snackbar('Error', 'Gagal menduplikasi invoice');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'sent':
        return Colors.blue;
      case 'overdue':
        return Colors.red;
      case 'draft':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Lunas';
      case 'sent':
        return 'Terkirim';
      case 'overdue':
        return 'Jatuh Tempo';
      case 'draft':
        return 'Draft';
      default:
        return status;
    }
  }

  bool get canEdit {
    if (invoice.value == null) return false;
    // Can edit if status is draft or sent (not paid/overdue)
    final status = invoice.value!.status.toLowerCase();
    return status == 'draft' || status == 'sent';
  }

  bool get isOverdue {
    if (invoice.value == null) return false;
    return invoice.value!.isOverdue;
  }

  void showEditRestrictedDialog() {
    String message = 'Invoice ini tidak dapat diedit.';
    
    if (invoice.value != null) {
      final status = invoice.value!.status.toLowerCase();
      if (status == 'paid') {
        message = 'Invoice yang sudah lunas tidak dapat diedit.';
      } else if (status == 'overdue') {
        message = 'Invoice yang sudah jatuh tempo tidak dapat diedit.';
      }
    }
    
    Get.dialog(
      AlertDialog(
        title: const Text('Tidak Dapat Mengedit'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Quick actions for different statuses
  void markAsPaid() {
    updateStatus('paid');
  }

  void markAsSent() {
    updateStatus('sent');
  }

  void markAsOverdue() {
    updateStatus('overdue');
  }

  // Get available actions based on current status
  List<Map<String, dynamic>> getAvailableActions() {
    if (invoice.value == null) return [];
    
    final status = invoice.value!.status.toLowerCase();
    final actions = <Map<String, dynamic>>[];
    
    // Edit action
    if (canEdit) {
      actions.add({
        'title': 'Edit',
        'icon': Icons.edit,
        'color': Colors.blue,
        'action': editInvoice,
      });
    }
    
    // Send action
    if (status == 'draft') {
      actions.add({
        'title': 'Kirim',
        'icon': Icons.send,
        'color': Colors.green,
        'action': sendEmail,
      });
    }
    
    // PDF action
    actions.add({
      'title': 'PDF',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
      'action': generatePdf,
    });
    
    // Duplicate action
    actions.add({
      'title': 'Duplikasi',
      'icon': Icons.copy,
      'color': Colors.orange,
      'action': duplicateInvoice,
    });
    
    // Status actions
    if (status != 'paid') {
      actions.add({
        'title': 'Tandai Lunas',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'action': markAsPaid,
      });
    }
    
    if (status == 'draft') {
      actions.add({
        'title': 'Tandai Terkirim',
        'icon': Icons.send,
        'color': Colors.blue,
        'action': markAsSent,
      });
    }
    
    // Delete action (only for draft)
    if (status == 'draft') {
      actions.add({
        'title': 'Hapus',
        'icon': Icons.delete,
        'color': Colors.red,
        'action': deleteInvoice,
      });
    }
    
    return actions;
  }

  // Get days until due date
  int get daysUntilDue {
    if (invoice.value == null) return 0;
    return invoice.value!.dueDate.difference(DateTime.now()).inDays;
  }

  // Get due status text
  String get dueStatusText {
    if (invoice.value == null) return '';
    
    final days = daysUntilDue;
    if (days < 0) {
      return 'Jatuh tempo ${days.abs()} hari yang lalu';
    } else if (days == 0) {
      return 'Jatuh tempo hari ini';
    } else if (days == 1) {
      return 'Jatuh tempo besok';
    } else {
      return 'Jatuh tempo dalam $days hari';
    }
  }
}
