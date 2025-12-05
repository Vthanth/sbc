import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/shared_widgets/theme_text_field.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  static Future<Item?> show(BuildContext context) {
    return showDialog<Item>(context: context, builder: (context) => const AddItemDialog());
  }

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _onAdd() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter item name')));
      return;
    }
    if (_rateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter rate')));
      return;
    }
    final rate = double.tryParse(_rateController.text);
    if (rate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid rate')));
      return;
    }
    Navigator.pop(
      context,
      Item(item: _nameController.text, qty: _quantity, rate: rate.toInt(), amount: (rate * _quantity).toInt()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: ThemeColors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _DialogHeader(),
            const SizedBox(height: 24),

            // Form Content
            _DialogContent(
              nameController: _nameController,
              rateController: _rateController,
              quantity: _quantity,
              onQuantityChanged: (value) => setState(() => _quantity = value),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _DialogActions(onAdd: _onAdd),
          ],
        ),
      ),
    );
  }
}

/// Dialog Header
class _DialogHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ThemeColors.themeBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.add_shopping_cart, color: ThemeColors.themeBlue, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Item', style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack)),
              Text('Enter item details', style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: ThemeColors.midGrey),
          style: IconButton.styleFrom(
            backgroundColor: ThemeColors.lightGrey.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

/// Dialog Content
class _DialogContent extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController rateController;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const _DialogContent({
    required this.nameController,
    required this.rateController,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Item Name Field
        ThemeTextField(
          controller: nameController,
          label: 'Item Name',
          hint: 'Enter item name',
          leadingIcon: Icons.inventory,
        ),
        const SizedBox(height: 20),

        // Quantity Section
        _QuantitySection(quantity: quantity, onQuantityChanged: onQuantityChanged),
        const SizedBox(height: 20),

        // Rate Field
        ThemeTextField(
          controller: rateController,
          label: 'Rate',
          hint: '0.00',
          leadingIcon: Icons.currency_rupee,
          inputType: TextInputType.number,
        ),
        const SizedBox(height: 20),

        // Amount Display
        if (rateController.text.isNotEmpty && quantity > 0) ...[
          _AmountDisplay(rate: double.tryParse(rateController.text) ?? 0, quantity: quantity),
        ],
      ],
    );
  }
}

/// Quantity Section
class _QuantitySection extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const _QuantitySection({required this.quantity, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quantity', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeColors.primarySand,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.lightGrey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _QuantityButton(
                icon: Icons.remove,
                onPressed: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
                isDisabled: quantity <= 1,
              ),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.lightGrey),
                ),
                child: Text(
                  '$quantity',
                  style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
                  textAlign: TextAlign.center,
                ),
              ),
              _QuantityButton(icon: Icons.add, onPressed: () => onQuantityChanged(quantity + 1), isDisabled: false),
            ],
          ),
        ),
      ],
    );
  }
}

/// Quantity Button
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const _QuantityButton({required this.icon, required this.onPressed, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDisabled ? ThemeColors.lightGrey.withOpacity(0.3) : ThemeColors.themeBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: isDisabled ? ThemeColors.midGrey : ThemeColors.white, size: 20),
        style: IconButton.styleFrom(padding: const EdgeInsets.all(8), minimumSize: const Size(32, 32)),
      ),
    );
  }
}

/// Amount Display
class _AmountDisplay extends StatelessWidget {
  final double rate;
  final int quantity;

  const _AmountDisplay({required this.rate, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final amount = rate * quantity;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.themeBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.calculate, color: ThemeColors.themeBlue, size: 20),
          const SizedBox(width: 12),
          Text('Total Amount: ', style: ThemeFonts.text14(textColor: ThemeColors.themeBlue)),
          Text('₹${amount.toStringAsFixed(2)}', style: ThemeFonts.text16Bold(textColor: ThemeColors.themeBlue)),
        ],
      ),
    );
  }
}

/// Dialog Actions
class _DialogActions extends StatelessWidget {
  final VoidCallback onAdd;

  const _DialogActions({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ThemeButton(text: 'Add Item', onPressed: onAdd, leadingIcon: Icons.add);
  }
}
