import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_invoice_controller.dart';
import '../../core/constants/app_colors.dart';

class EditInvoiceScreen extends GetView<EditInvoiceController> {
  const EditInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildModernAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.originalInvoice == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.canEdit) {
          return _buildReadOnlyView();
        }

        return Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(),
                const SizedBox(height: 24),
                _buildModernCard(
                  title: 'Informasi Client',
                  icon: Icons.person_outline,
                  color: AppColors.primary,
                  children: _buildClientFields(),
                ),
                const SizedBox(height: 24),
                _buildModernCard(
                  title: 'Detail Invoice',
                  icon: Icons.receipt_long_outlined,
                  color: AppColors.warning,
                  children: _buildInvoiceDetailFields(),
                ),
                const SizedBox(height: 24),
                _buildItemsCard(),
                const SizedBox(height: 24),
                _buildSummaryCard(),
                const SizedBox(height: 24),
                _buildNotesCard(),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: const Text(
        'Edit Invoice',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.1),
      actions: [
        Obx(() {
          if (!controller.canEdit) {
            return IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: controller.showEditRestrictedDialog,
            );
          }

          return controller.isLoading.value
              ? Container(
                margin: const EdgeInsets.all(16),
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
              : Container(
                margin: const EdgeInsets.only(right: 8),
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'save_draft') {
                      controller.updateInvoice(isDraft: true);
                    } else if (value == 'save_update') {
                      controller.updateInvoice(isDraft: false);
                    }
                  },
                  itemBuilder:
                      (context) => [
                        _buildPopupMenuItem(
                          'save_draft',
                          Icons.save_outlined,
                          'Simpan sebagai Draft',
                          AppColors.warning,
                        ),
                        _buildPopupMenuItem(
                          'save_update',
                          Icons.update,
                          'Perbarui Invoice',
                          AppColors.success,
                        ),
                      ],
                ),
              );
        }),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoice #${controller.originalInvoice?.invoiceNumber ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusText(controller.originalStatus.value),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dapat diedit',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required List<Widget> children,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.05), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(title, style: AppTextStyles.h3),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildClientFields() {
    return [
      const SizedBox(height: 8),
      _buildModernTextField(
        label: 'Nama Client',
        controller: controller.clientNameController,
        icon: Icons.person_outline,
        hint: 'Masukkan nama lengkap client',
        isRequired: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Nama client harus diisi';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      _buildModernTextField(
        label: 'Email Client',
        controller: controller.clientEmailController,
        icon: Icons.email_outlined,
        hint: 'contoh@email.com',
        isRequired: true,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Email client harus diisi';
          }
          if (!GetUtils.isEmail(value)) {
            return 'Format email tidak valid';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      _buildModernTextField(
        label: 'Nomor Telepon',
        controller: controller.clientPhoneController,
        icon: Icons.phone_outlined,
        hint: '+62 xxx-xxxx-xxxx',
        isRequired: true,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Nomor telepon harus diisi';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      _buildModernTextField(
        label: 'Nama Perusahaan',
        controller: controller.clientCompanyController,
        icon: Icons.business_outlined,
        hint: 'Nama perusahaan (opsional)',
      ),
      const SizedBox(height: 20),
      _buildModernTextField(
        label: 'Alamat',
        controller: controller.clientAddressController,
        icon: Icons.location_on_outlined,
        hint: 'Alamat lengkap client',
        maxLines: 3,
        isRequired: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Alamat harus diisi';
          }
          return null;
        },
      ),
    ];
  }

  List<Widget> _buildInvoiceDetailFields() {
    return [
      const SizedBox(height: 8),
      _buildModernTextField(
        label: 'Tanggal Jatuh Tempo',
        controller: controller.dueDateController,
        icon: Icons.calendar_today_outlined,
        hint: 'DD/MM/YYYY',
        isRequired: true,
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: Get.context!,
            initialDate:
                controller.originalInvoice?.dueDate ??
                DateTime.now().add(const Duration(days: 30)),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (date != null) {
            controller.dueDateController.text =
                '${date.day}/${date.month}/${date.year}';
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Tanggal jatuh tempo harus diisi';
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildModernTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    bool isRequired = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.labelMedium,
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          validator: validator,
          onTap: onTap,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.borderFocus,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsCard() {
    return _buildModernCard(
      title: 'Item Invoice',
      icon: Icons.inventory_2_outlined,
      color: AppColors.success,
      children: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: controller.addItem,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.items.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.items.length,
            separatorBuilder:
                (context, index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.border,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
            itemBuilder: (context, index) => _buildItemTile(index),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada item',
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan item untuk invoice Anda',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(int index) {
    final item = controller.items[index];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.border.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.editItem(index);
                  } else if (value == 'delete') {
                    controller.removeItem(index);
                  }
                },
                itemBuilder:
                    (context) => [
                      _buildPopupMenuItem(
                        'edit',
                        Icons.edit_outlined,
                        'Edit',
                        AppColors.primary,
                      ),
                      _buildPopupMenuItem(
                        'delete',
                        Icons.delete_outline,
                        'Hapus',
                        AppColors.error,
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.description, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${item.quantity} x Rp ${item.price.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                'Rp ${item.total.toStringAsFixed(0)}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return _buildModernCard(
      title: 'Ringkasan Pembayaran',
      icon: Icons.calculate_outlined,
      color: AppColors.success,
      children: [
        const SizedBox(height: 8),
        Obx(
          () => Column(
            children: [
              _buildSummaryRow('Subtotal', controller.subtotal.value),
              const SizedBox(height: 16),
              _buildModernTextField(
                label: 'Diskon',
                controller: controller.discountController,
                icon: Icons.local_offer_outlined,
                hint: 'Masukkan nominal diskon',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildSummaryRow(
                'Pajak (${controller.taxRate.value}%)',
                controller.tax.value,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.border,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      'Rp ${controller.total.value.toStringAsFixed(0)}',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyLarge),
        Text(
          'Rp ${value.toStringAsFixed(0)}',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return _buildModernCard(
      title: 'Catatan (Opsional)',
      icon: Icons.note_outlined,
      color: AppColors.warning,
      children: [
        const SizedBox(height: 8),
        _buildModernTextField(
          label: 'Catatan tambahan',
          controller: controller.notesController,
          icon: Icons.edit_note_outlined,
          hint: 'Tambahkan catatan untuk invoice ini...',
          maxLines: 3,
        ),
      ],
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
              side: const BorderSide(color: AppColors.border, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Batal',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.updateInvoice(isDraft: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
            onPressed: () => controller.updateInvoice(isDraft: false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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

  Widget _buildReadOnlyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Invoice Tidak Dapat Diedit',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Invoice yang sudah lunas tidak dapat diedit untuk menjaga integritas data.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
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
}
