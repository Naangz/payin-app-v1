import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quotation_list_controller.dart';
import 'widgets/quotation_card.dart';

class QuotationListScreen extends GetView<QuotationListController> {
  const QuotationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }
              
              if (controller.filteredQuotations.isEmpty) {
                return _buildEmptyState();
              }
              
              return _buildQuotationList();
            }),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Daftar Quotation',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      backgroundColor: const Color(0xFF2563EB),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, size: 20),
            ),
            onPressed: controller.navigateToCreateQuotation,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildStatusFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      // color: Colors.white, // HAPUS atau gunakan transparent
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        style: const TextStyle(
          color: Color(0xFF18181B), // teks utama
          fontSize: 16,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // PENTING: background putih
          hintText: 'Cari quotation...',
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF64748B),
            size: 22,
          ),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.searchQuery.value = '';
                      controller.filterQuotations();
                    },
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          controller.searchQuery.value = value;
          controller.filterQuotations();
        },
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter Status',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () => Row(
              children: _getStatusOptions().map((status) {
                final isSelected = controller.selectedStatus.value == 
                    (status['value'] ?? '');
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildFilterChip(
                    label: status['label'] ?? '',
                    isSelected: isSelected,
                    onTap: () {
                      controller.selectedStatus.value = status['value'] ?? '';
                      controller.filterQuotations();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildQuotationList() {
    return RefreshIndicator(
      onRefresh: controller.loadQuotations,
      color: const Color(0xFF2563EB),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.filteredQuotations.length,
        itemBuilder: (context, index) {
          final quotation = controller.filteredQuotations[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildEnhancedQuotationCard(quotation, index),
          );
        },
      ),
    );
  }

Widget _buildEnhancedQuotationCard(quotation, int index) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => controller.navigateToQuotationDetail(quotation.id),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // PERUBAHAN: Gunakan quotationNumber seperti di detail
                          quotation.quotationNumber ?? 'QUO-000000-0000',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quotation.clientName ?? 'Client',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(quotation.status ?? 'draft'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${_formatCurrency(quotation.total ?? 0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                  _buildActionButtons(quotation),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildActionButtons(quotation) {
    return Row(
      children: [
        // Status Action Buttons (Accept/Reject) - hanya tampil jika status sent
        if (quotation.status?.toLowerCase() == 'sent') ...[
          _buildActionButton(
            icon: Icons.check_circle_outline,
            color: const Color(0xFF059669),
            tooltip: 'Terima',
            onTap: () => _showAcceptDialog(quotation.id),
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.cancel_outlined,
            color: const Color(0xFFDC2626),
            tooltip: 'Tolak',
            onTap: () => _showRejectDialog(quotation.id),
          ),
          const SizedBox(width: 8),
        ],
        
        // Edit Button
        _buildActionButton(
          icon: Icons.edit_outlined,
          color: const Color(0xFF3B82F6),
          tooltip: 'Edit',
          onTap: () => Get.toNamed('/edit-quotation', arguments: quotation.id),
        ),
        const SizedBox(width: 8),
        
        // PDF Button
        _buildActionButton(
          icon: Icons.picture_as_pdf_outlined,
          color: const Color(0xFFDC2626),
          tooltip: 'Download PDF',
          onTap: () => _generatePdf(quotation.id),
        ),
        const SizedBox(width: 8),
        
        // Email Button
        _buildActionButton(
          icon: Icons.email_outlined,
          color: const Color(0xFF059669),
          tooltip: 'Kirim Email',
          onTap: () => _sendEmail(quotation.id),
        ),
        const SizedBox(width: 8),
        
        // Delete Button
        _buildActionButton(
          icon: Icons.delete_outline,
          color: const Color(0xFFEF4444),
          tooltip: 'Hapus',
          onTap: () => _showDeleteDialog(quotation.id),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'draft':
        backgroundColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
        displayText = 'Draft';
        break;
      case 'sent':
        backgroundColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF2563EB);
        displayText = 'Terkirim';
        break;
      case 'accepted':
        backgroundColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        displayText = 'Diterima';
        break;
      case 'rejected':
        backgroundColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        displayText = 'Ditolak';
        break;
      default:
        backgroundColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
        displayText = 'Draft';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF2563EB),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat quotation...',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.request_quote_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum ada quotation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat quotation pertama Anda untuk memulai\nmengelola penawaran bisnis',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: controller.navigateToCreateQuotation,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Buat Quotation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: controller.navigateToCreateQuotation,
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  // Helper Methods
  List<Map<String, String>> _getStatusOptions() {
    return [
      {'value': 'all', 'label': 'Semua'},
      {'value': 'draft', 'label': 'Draft'},
      {'value': 'sent', 'label': 'Terkirim'},
      {'value': 'accepted', 'label': 'Diterima'},
      {'value': 'rejected', 'label': 'Ditolak'},
      {'value': 'expired', 'label': 'Kedaluwarsa'},
    ];
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '0';
    final number = double.tryParse(amount.toString()) ?? 0;
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Dialog Methods - Menggunakan method yang sudah ada di controller
  void _showDeleteDialog(String quotationId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Quotation'),
        content: const Text('Apakah Anda yakin ingin menghapus quotation ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _deleteQuotation(quotationId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAcceptDialog(String quotationId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Terima Quotation'),
        content: const Text('Apakah Anda yakin ingin menerima quotation ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _acceptQuotation(quotationId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
            ),
            child: const Text('Terima'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(String quotationId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Tolak Quotation'),
        content: const Text('Apakah Anda yakin ingin menolak quotation ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _rejectQuotation(quotationId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  // Action Methods - Diperbaiki untuk menggunakan method yang ada
  void _deleteQuotation(String quotationId) {
    // Panggil method yang sudah ada di controller
    controller.deleteQuotation(quotationId);
    Get.snackbar(
      'Berhasil',
      'Quotation berhasil dihapus',
      backgroundColor: const Color(0xFF059669),
      colorText: Colors.white,
    );
  }

  void _acceptQuotation(String quotationId) {
    // Panggil method yang sudah ada di controller
    controller.updateQuotationStatus(quotationId, 'accepted');
    Get.snackbar(
      'Berhasil',
      'Quotation berhasil diterima',
      backgroundColor: const Color(0xFF059669),
      colorText: Colors.white,
    );
  }

  void _rejectQuotation(String quotationId) {
    // Panggil method yang sudah ada di controller
    controller.updateQuotationStatus(quotationId, 'rejected');
    Get.snackbar(
      'Berhasil',
      'Quotation berhasil ditolak',
      backgroundColor: const Color(0xFFDC2626),
      colorText: Colors.white,
    );
  }

  void _generatePdf(String quotationId) {
    Get.snackbar('Info', 'Fitur PDF quotation sedang dikembangkan');
  }

  void _sendEmail(String quotationId) {
    Get.snackbar('Info', 'Fitur kirim email quotation sedang dikembangkan');
  }
}
