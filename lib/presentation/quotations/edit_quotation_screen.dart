import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_quotation_controller.dart';

class EditQuotationScreen extends GetView<EditQuotationController> {
  const EditQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Quotation',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Obx(() {
            if (!controller.canEdit) {
              return IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: controller.showEditRestrictedDialog,
              );
            }

            return controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  )
                : PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'save_draft') {
                        controller.updateQuotation(isDraft: true);
                      } else if (value == 'save_update') {
                        controller.updateQuotation(isDraft: false);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'save_draft',
                        child: Row(
                          children: [
                            Icon(Icons.save, size: 16),
                            SizedBox(width: 8),
                            Text('Simpan sebagai Draft'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'save_update',
                        child: Row(
                          children: [
                            Icon(Icons.update, size: 16),
                            SizedBox(width: 8),
                            Text('Perbarui Quotation'),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.originalQuotation == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.canEdit) {
          return _buildReadOnlyView();
        }

        return Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusInfo(),
                const SizedBox(height: 16),
                _buildClientInfoSection(),
                const SizedBox(height: 24),
                _buildQuotationDetailsSection(),
                const SizedBox(height: 24),
                _buildItemsSection(),
                const SizedBox(height: 24),
                _buildSummarySection(),
                const SizedBox(height: 24),
                _buildNotesSection(),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReadOnlyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              'Quotation Tidak Dapat Diedit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quotation yang sudah diterima, ditolak, atau kedaluwarsa tidak dapat diedit.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Saat Ini: ${_getStatusText(controller.originalStatus.value)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quotation Number: ${controller.originalQuotation?.quotationNumber ?? ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Diterima';
      case 'sent':
        return 'Terkirim';
      case 'rejected':
        return 'Ditolak';
      case 'expired':
        return 'Kedaluwarsa';
      case 'draft':
        return 'Draft';
      default:
        return status;
    }
  }

  Widget _buildClientInfoSection() {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    const borderSide = BorderSide(color: Color(0xFFD1D5DB));

    InputDecoration _inputDecoration({
      required String label,
      required IconData icon,
    }) =>
        InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF374151), // Abu-abu gelap untuk label
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.redAccent),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Client',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827), // Hitam gelap untuk judul
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.clientNameController,
            style: const TextStyle(
              color: Color(0xFF111827), // Teks input hitam gelap
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Nama Client *',
              icon: Icons.person_rounded,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama client harus diisi' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.clientEmailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Email Client *',
              icon: Icons.email_rounded,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email client harus diisi';
              if (!GetUtils.isEmail(v)) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.clientPhoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Nomor Telepon *',
              icon: Icons.phone_rounded,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nomor telepon harus diisi' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.clientCompanyController,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Nama Perusahaan (Opsional)',
              icon: Icons.apartment_rounded,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.clientAddressController,
            maxLines: 3,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Alamat *',
              icon: Icons.location_on_rounded,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Alamat harus diisi' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationDetailsSection() {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    const borderSide = BorderSide(color: Color(0xFFD1D5DB));

    InputDecoration _inputDecoration({
      required String label,
      required IconData icon,
      required String hint,
    }) =>
        InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF), // Hint text abu-abu sedang
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.redAccent),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Quotation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.validUntilController,
            readOnly: true,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Berlaku Sampai *',
              icon: Icons.calendar_today_rounded,
              hint: 'DD/MM/YYYY',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: Get.context!,
                initialDate: controller.originalQuotation?.validUntil ??
                    DateTime.now().add(const Duration(days: 14)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                controller.validUntilController.text =
                    '${date.day}/${date.month}/${date.year}';
              }
            },
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Tanggal berlaku sampai harus diisi'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Item Quotation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              ElevatedButton.icon(
                onPressed: controller.addItem,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  'Tambah Item',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada item',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan item untuk quotation Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.items.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Color(0xFFE5E7EB)),
              itemBuilder: (context, index) {
                final item = controller.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.description.trim().isNotEmpty)
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.quantity} x Rp ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Rp ${item.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                          fontSize: 14,
                        ),
                      ),
                      PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            controller.editItem(index);
                          } else if (value == 'delete') {
                            controller.removeItem(index);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_rounded, size: 16),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_rounded,
                                    size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Hapus'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    const borderSide = BorderSide(color: Color(0xFFD1D5DB));

    InputDecoration _discountDecoration() => const InputDecoration(
          labelText: 'Diskon',
          labelStyle: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixText: 'Rp ',
          prefixStyle: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
                children: [
                  _buildSummaryRow(
                    'Subtotal',
                    'Rp ${controller.subtotal.value.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.discountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _discountDecoration(),
                    onChanged: (_) => controller.calculateTotals(),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    'Pajak (${controller.taxRate.value}%)',
                    'Rp ${controller.tax.value.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 2,
                    color: Color(0xFFE5E7EB),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'TOTAL',
                    'Rp ${controller.total.value.toStringAsFixed(0)}',
                    isTotal: true,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF111827) : const Color(0xFF374151),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? const Color(0xFF059669) : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    const borderSide = BorderSide(color: Color(0xFFD1D5DB));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan (Opsional)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.notesController,
            maxLines: 3,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              labelText: 'Catatan tambahan untuk quotation',
              labelStyle: TextStyle(
                color: Color(0xFF374151),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.white,
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: borderSide,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF6B7280)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.updateQuotation(isDraft: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Simpan Draft',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.updateQuotation(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Perbarui',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
