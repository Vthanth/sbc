import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/utils.dart';

class OrderCard extends StatelessWidget {
  final Ticket order;
  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push('/order-details/${order.uuid}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Category and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category with icon
                    _CategoryTag(type: order.type),
                    // Status badge
                    _StateLabel(state: order.state),
                  ],
                ),
                const SizedBox(height: 16),
                // Product Title
                if (order.orderProduct?.product != null)
                  Text(
                    order.orderProduct!.product.name,
                    style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),
                // Customer Info
                if (order.customer != null) _CustomerInfo(customer: order.customer!),
                const SizedBox(height: 12),
                // Date & Time
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: ThemeColors.midGrey),
                    const SizedBox(width: 6),
                    Text(
                      '${Utils.formatDateToLocalFromDateTime(order.createdAt)} • ${Utils.formatTimeToLocalFromDateTime(order.createdAt)}',
                      style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String type;
  const _CategoryTag({required this.type});

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'delivery':
        return Icons.local_shipping;
      case 'service':
        return Icons.build;
      default:
        return Icons.inventory_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: ThemeColors.themeBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconForType(type),
            size: 16,
            color: ThemeColors.themeBlue,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: ThemeColors.themeBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type.toUpperCase(),
            style: ThemeFonts.text12(textColor: ThemeColors.themeBlue),
          ),
        ),
      ],
    );
  }
}

class _CustomerInfo extends StatelessWidget {
  final Customer customer;
  const _CustomerInfo({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person_outline, size: 14, color: ThemeColors.midGrey),
        const SizedBox(width: 6),
        Text(
          customer.name,
          style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _StateLabel extends StatelessWidget {
  final TicketState state;
  const _StateLabel({required this.state});

  Color _getStatusColor() {
    switch (state) {
      case TicketState.start:
        return const Color(0xFFFF9500); // Orange for "Not Started" / Pending
      case TicketState.finished:
        return const Color(0xFF34C759); // Green for "Finished" / Completed
      case TicketState.inProgress:
        return ThemeColors.themeBlue;
      case TicketState.unknown:
      default:
        return ThemeColors.midGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        state.displayName,
        style: ThemeFonts.text12(textColor: statusColor),
      ),
    );
  }
}
