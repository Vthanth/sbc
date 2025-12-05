import 'dart:io';

import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/helper/challan_multi_image_uploader_helper.dart';
import 'package:sbccapp/pages/widgets/add_item_dialog.dart';
import 'package:sbccapp/pages/widgets/image_upload_section.dart';
import 'package:sbccapp/pages/widgets/items_section.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/shared_widgets/theme_text_field.dart';

class DeliveryChallanPage extends StatefulWidget {
  final String ticketUuid;

  const DeliveryChallanPage({super.key, required this.ticketUuid});

  @override
  State<DeliveryChallanPage> createState() => _DeliveryChallanPageState();
}

class _DeliveryChallanPageState extends State<DeliveryChallanPage> {
  final _challanNoController = TextEditingController();
  final _vehicleNoController = TextEditingController();
  final _logController = TextEditingController();
  DeliveryChallanData? _challanData;
  String? _errorMessage;
  final List<Item> _items = [];
  final List<File> _images = [];
  bool _imagesUploaded = false;

  @override
  void initState() {
    super.initState();
    _setupControllers();
  }

  void _setupControllers() {
    _challanNoController.addListener(_updateChallanData);
    _vehicleNoController.addListener(_updateChallanData);
    _logController.addListener(_updateChallanData);
  }

  void _updateChallanData() {
    setState(() {
      _errorMessage = null;
      _challanData = DeliveryChallanData(
        challanNo: _challanNoController.text,
        vehicleNo: _vehicleNoController.text,
        log: _logController.text,
      );
    });
  }

  Future<void> _showAddItemDialog() async {
    final item = await AddItemDialog.show(context);
    if (item != null) {
      setState(() => _items.add(item));
    }
  }

  bool _validateData() {
    if (_challanNoController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter challan number');
      return false;
    }
    if (_vehicleNoController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter vehicle number');
      return false;
    }
    if (_logController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter log details');
      return false;
    }
    if (_items.isEmpty) {
      setState(() => _errorMessage = 'Please add at least one item');
      return false;
    }
    return true;
  }

  Future<void> _uploadImages() async {
    await ChallanMultiImageUploaderHelper.uploadImages(
      context: context,
      images: _images,
      ticketUuid: widget.ticketUuid,
      onImagesUploaded: () {
        setState(() {
          _imagesUploaded = true;
        });
      },
    );
  }

  void _onSave() async {
    if (_validateData()) {
      if (_images.isNotEmpty) {
        await _uploadImages();
      }
      _challanData = DeliveryChallanData(
        challanNo: _challanData?.challanNo,
        vehicleNo: _challanData?.vehicleNo,
        log: _challanData?.log,
        items: _items,
      );
      Navigator.pop(context, _challanData);
    }
  }

  @override
  void dispose() {
    _challanNoController.dispose();
    _vehicleNoController.dispose();
    _logController.dispose();
    super.dispose();
  }

  void _onClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primarySand,
      appBar: _DeliveryChallanAppBar(onClose: _onClose),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challan Details - No Section Container
                  _ChallanDetailsSection(
                    challanNoController: _challanNoController,
                    vehicleNoController: _vehicleNoController,
                    logController: _logController,
                  ),
                  const SizedBox(height: 20),

                  // Items Section
                  ItemsSection(items: _items, onAddItem: _showAddItemDialog),

                  const SizedBox(height: 20),

                  // Images Section
                  ImageUploadSection(
                    images: _images,
                    onImagesChanged: (images) {
                      setState(() {
                        _images.clear();
                        _images.addAll(images);
                      });
                    },
                    isUploaded: _imagesUploaded,
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _ErrorMessageView(errorMessage: _errorMessage!),
                  ],
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          _SaveButtonSection(onSave: _onSave),
        ],
      ),
    );
  }
}

/// Custom AppBar for delivery challan
class _DeliveryChallanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClose;

  const _DeliveryChallanAppBar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.white,
      foregroundColor: ThemeColors.primaryBlack,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: ThemeColors.primaryBlack),
        onPressed: onClose,
      ),
      title: Text(
        'Delivery Challan',
        style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Challan Details Section
class _ChallanDetailsSection extends StatelessWidget {
  final TextEditingController challanNoController;
  final TextEditingController vehicleNoController;
  final TextEditingController logController;

  const _ChallanDetailsSection({
    required this.challanNoController,
    required this.vehicleNoController,
    required this.logController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompactTextField(
          controller: challanNoController,
          label: 'Challan No',
          hint: 'Enter challan number',
        ),
        const SizedBox(height: 12),
        _CompactTextField(
          controller: vehicleNoController,
          label: 'Vehicle No',
          hint: 'Enter vehicle number',
        ),
        const SizedBox(height: 12),
        _CompactTextField(
          controller: logController,
          label: 'Log',
          hint: 'Enter any notes or remarks',
          maxLines: 3,
        ),
      ],
    );
  }
}

/// Compact Text Field without borders
class _CompactTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int? maxLines;

  const _CompactTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: ThemeFonts.text14(textColor: ThemeColors.midGrey),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Error Message View
class _ErrorMessageView extends StatelessWidget {
  final String errorMessage;

  const _ErrorMessageView({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.notificationRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.notificationRed.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: ThemeColors.notificationRed, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(errorMessage, style: ThemeFonts.text14(textColor: ThemeColors.notificationRed))),
        ],
      ),
    );
  }
}

/// Save Button Section
class _SaveButtonSection extends StatelessWidget {
  final VoidCallback onSave;

  const _SaveButtonSection({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).add(EdgeInsets.only(bottom: 20)),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: ThemeButton(text: 'Save Delivery Challan', onPressed: onSave, leadingIcon: Icons.save),
    );
  }
}

