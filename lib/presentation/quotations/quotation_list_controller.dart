import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/quotation_repository.dart';
import '../../../data/models/quotation_model.dart';

class QuotationListController extends GetxController {
  final QuotationRepository _quotationRepository = Get.find<QuotationRepository>();
  
  final RxBool isLoading = false.obs;
  final RxList<Quotation> quotations = <Quotation>[].obs;
  final RxList<Quotation> filteredQuotations = <Quotation>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = 'all'.obs;
  
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadQuotations();
  }

  Future<void> loadQuotations() async {
    try {
      isLoading.value = true;
      
      final allQuotations = _quotationRepository.getAllQuotations();
      allQuotations.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      
      quotations.value = allQuotations;
      filterQuotations();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar quotation');
    } finally {
      isLoading.value = false;
    }
  }

  void filterQuotations() {
    var filtered = quotations.toList();
    
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((quotation) =>
          quotation.quotationNumber.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          quotation.clientName.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    if (selectedStatus.value != 'all') {
      filtered = filtered.where((quotation) => 
          quotation.status.toLowerCase() == selectedStatus.value.toLowerCase()).toList();
    }
    
    filteredQuotations.value = filtered;
  }

  void navigateToCreateQuotation() {
    Get.toNamed('/create-quotation');
  }

  void navigateToQuotationDetail(String quotationId) {
    Get.toNamed('/quotation-detail', arguments: quotationId);
  }

  void confirmDeleteQuotation(String id) {
    Get.defaultDialog(
      title: 'Hapus Quotation',
      middleText: 'Apakah kamu yakin ingin menghapus quotation ini?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      confirmTextColor: const Color.fromARGB(255, 255, 0, 0),
      onConfirm: () async {
        Get.back();
        await deleteQuotation(id);
      },
    );
  }

  Future<void> deleteQuotation(String id) async {
    final success = await _quotationRepository.deleteQuotation(id);
    if (success) {
      quotations.removeWhere((q) => q.id == id);
      filterQuotations();
      Get.snackbar('Berhasil', 'Quotation berhasil dihapus');
    } else {
      Get.snackbar('Gagal', 'Gagal menghapus quotation');
    }
  }

  Future<void> updateQuotationStatus(String quotationId, String status) async {
    try {
      // Update status di database/API
      // Contoh implementasi:
      final index = quotations.indexWhere((q) => q.id == quotationId);
      if (index != -1) {
        quotations[index].status = status;
        quotations.refresh();
        filterQuotations();
      }
      
      // Jika menggunakan API:
      // await quotationService.updateStatus(quotationId, status);
      // await loadQuotations();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengubah status quotation: $e',
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }
}