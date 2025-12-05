import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';

/// Common Items Section Widget
class ItemsSection extends StatelessWidget {
  final List<Item> items;
  final VoidCallback onAddItem;

  const ItemsSection({super.key, required this.items, required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      title: 'Items',
      icon: Icons.inventory,
      children: [
        ThemeButton(text: 'Add Item', onPressed: onAddItem, leadingIcon: Icons.add),
        if (items.isNotEmpty) ...[const SizedBox(height: 16), ItemsTable(items: items)],
      ],
    );
  }
}

/// Common Items Table Widget
class ItemsTable extends StatelessWidget {
  final List<Item> items;

  const ItemsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Item', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
                ),
                Expanded(child: Text('Qty', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack))),
                Expanded(child: Text('Rate', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack))),
                Expanded(child: Text('Amount', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack))),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: ThemeColors.lightGrey),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(item.item ?? '', style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack)),
                    ),
                    Expanded(child: Text('${item.qty}', style: ThemeFonts.text14(textColor: ThemeColors.midGrey))),
                    Expanded(child: Text('₹${item.rate}', style: ThemeFonts.text14(textColor: ThemeColors.midGrey))),
                    Expanded(
                      child: Text(
                        '₹${(item.qty ?? 0) * (item.rate ?? 0)}',
                        style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: ThemeColors.lightGrey),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Total', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
                ),
                Expanded(
                  child: Text(
                    '₹${items.fold(0.0, (sum, item) => sum + ((item.qty ?? 0) * (item.rate ?? 0)))}',
                    style: ThemeFonts.text16Bold(textColor: ThemeColors.themeBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Form Section Container (internal helper)
class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _FormSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.themeBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: ThemeColors.themeBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
