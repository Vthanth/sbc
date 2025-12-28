import 'dart:io';
import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/shared_widgets/theme_text_field.dart';
import 'package:sbccapp/stores/expense.store.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? existingExpense;

  const AddExpensePage({super.key, this.existingExpense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _store = locator<ExpenseStore>();
  final _amountController = TextEditingController();
  final _detailsController = TextEditingController();
  final _paidByController = TextEditingController();
  final _dateController = TextEditingController();

  // Image related variables
  File? _selectedImage;
  final _imagePicker = ImagePicker();

  bool _isSaving = false;
  DateTime _selectedDate = DateTime.now();

  bool get isEditing => widget.existingExpense != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _amountController.text = widget.existingExpense!.amount;
      _detailsController.text = widget.existingExpense!.details ?? '';
      _dateController.text = widget.existingExpense!.expenseDate?.split('T').first ?? '';
      _paidByController.text = "Vishal";
    } else {
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: ThemeColors.themeBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _onSave() async {
    if (_amountController.text.isEmpty || _detailsController.text.isEmpty || _paidByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bhai, saari details bharna zaroori hai!')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (isEditing) {
        await _store.updateExpense(
          id: widget.existingExpense!.id,
          amount: _amountController.text,
          details: _detailsController.text,
          paidBy: _paidByController.text,
        );
      } else {
        await _store.createExpense(
          date: _dateController.text,
          amount: _amountController.text,
          details: _detailsController.text,
          paidBy: _paidByController.text,
          imageFile: _selectedImage,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditing ? 'Expense updated!' : 'Expense added!')),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primarySand,
      appBar: AppBar(
        backgroundColor: ThemeColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColors.primaryBlack),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Expense' : 'Add Expense',
          style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Receipt Photo', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
                    const SizedBox(height: 12),
                    _buildImagePicker(),
                    const SizedBox(height: 24),

                    if (!isEditing) ...[
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: ThemeTextField(
                            label: 'Expense Date',
                            controller: _dateController,
                            hint: 'Select Date',
                            leadingIcon: Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    ThemeTextField(
                      label: 'Amount (₹)',
                      controller: _amountController,
                      hint: 'Enter amount',
                      inputType: TextInputType.number,
                      leadingIcon: Icons.currency_rupee,
                    ),
                    const SizedBox(height: 20),

                    ThemeTextField(
                      label: 'Paid By',
                      controller: _paidByController,
                      hint: 'Who paid?',
                      leadingIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),

                    ThemeTextField(
                      label: 'Details',
                      controller: _detailsController,
                      hint: 'Describe the expense...',
                      maxLines: 3,
                      leadingIcon: Icons.description_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: ThemeButton(
                text: isEditing ? 'Update Claim' : 'Submit Claim',
                onPressed: _isSaving ? null : _onSave,
                isLoading: _isSaving,
                leadingIcon: isEditing ? Icons.check_circle_outline : Icons.send_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: ThemeColors.primarySand.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeColors.lightGrey, style: BorderStyle.solid),
        ),
        child: _selectedImage != null
            ? Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_selectedImage!, fit: BoxFit.cover),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.8),
                radius: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                  onPressed: () => setState(() => _selectedImage = null),
                ),
              ),
            )
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_enhance_outlined, size: 40, color: ThemeColors.themeBlue),
            const SizedBox(height: 8),
            Text('Tap to upload bill/receipt',
                style: ThemeFonts.text12(textColor: ThemeColors.themeBlue)),
          ],
        ),
      ),
    );
  }
}