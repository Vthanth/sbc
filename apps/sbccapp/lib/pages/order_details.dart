import 'dart:convert';

import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/pages/side_drawer.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/stores/order_details.store.dart';
import 'package:sbccapp/utils.dart';

class OrderDetailsPage extends StatefulWidget {
  final String ticketUuid;
  const OrderDetailsPage({super.key, required this.ticketUuid});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _store = locator<OrderDetailsStore>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _store.loadTicketDetails(widget.ticketUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.primarySand,
      appBar: _OrderDetailsAppBar(onBackPressed: () => context.pop()),
      drawer: const SideDrawer(isHomeSelected: false),
      body: Observer(
        builder: (_) {
          return _store.ticket.maybeWhen(
            (ticket) => _TicketDetailsContent(
              ticket: ticket,
              onStartDelivery: () {
                _store.startDeliveryTicket(context: context, ticketUuid: ticket.uuid);
              },
              onEndDelivery: (deliveryChallanData) {
                _store.endDeliveryTicket(
                  context: context,
                  ticketUuid: ticket.uuid,
                  deliveryChallanData: deliveryChallanData,
                );
              },
              onStartService: () {
                _store.startServiceTicket(context: context, ticketUuid: ticket.uuid);
              },
              onEndService: (serviceChallanData) {
                _store.endServiceTicket(
                  context: context,
                  ticketUuid: ticket.uuid,
                  serviceChallanData: serviceChallanData,
                );
              },
              isUpdatingTicket: _store.isUpdatingTicket,
            ),
            loading: () => const _LoadingView(),
            error: (error, stackTrace) => _ErrorView(error: error.toString()),
            orElse: () => const _EmptyStateView(),
          );
        },
      ),
    );
  }
}

/// Custom AppBar for order details
class _OrderDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const _OrderDetailsAppBar({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.white,
      foregroundColor: ThemeColors.primaryBlack,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ThemeColors.primaryBlack),
        onPressed: onBackPressed,
      ),
      title: Text(
        'Ticket Details',
        style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main content area for ticket details
class _TicketDetailsContent extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onStartDelivery;
  final VoidCallback onStartService;
  final Function(DeliveryChallanData) onEndDelivery;
  final Function(ServiceChallanData) onEndService;
  final bool isUpdatingTicket;

  const _TicketDetailsContent({
    required this.ticket,
    required this.onStartDelivery,
    required this.onStartService,
    required this.onEndDelivery,
    required this.onEndService,
    required this.isUpdatingTicket,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header Section
          _TicketHeaderCard(ticket: ticket),
          const SizedBox(height: 16),

          // Customer Section
          if (ticket.customer != null) ...[_CustomerInfoCard(customer: ticket.customer!), const SizedBox(height: 16)],

          if (ticket.orderProduct != null) ...[
            // Product Section
            _ProductInfoCard(orderProduct: ticket.orderProduct!),
            const SizedBox(height: 16),
          ],

          // Action Button
          if (ticket.state == TicketState.start || ticket.state == TicketState.inProgress) ...[
            _ActionButton(
              ticket: ticket,
              isUpdatingTicket: isUpdatingTicket,
              onStartDelivery: onStartDelivery,
              onEndDelivery: onEndDelivery,
              onStartService: onStartService,
              onEndService: onEndService,
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Ticket header card with modern design
class _TicketHeaderCard extends StatelessWidget {
  final Ticket ticket;

  const _TicketHeaderCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Type and State
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category with icon
              Row(
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
                      ticket.type.toLowerCase() == 'service' ? Icons.build : Icons.local_shipping,
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
                      ticket.type.toUpperCase(),
                      style: ThemeFonts.text12(textColor: ThemeColors.themeBlue),
                    ),
                  ),
                ],
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.state).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getStatusColor(ticket.state),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      ticket.state.displayName,
                      style: ThemeFonts.text12(textColor: _getStatusColor(ticket.state)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Product Title
          if (ticket.orderProduct?.product != null)
            Text(
              ticket.orderProduct!.product.name,
              style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 12),
          // Customer Info
          if (ticket.customer != null)
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: ThemeColors.midGrey),
                const SizedBox(width: 6),
                Text(
                  ticket.customer!.name,
                  style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          const SizedBox(height: 12),
          // Date & Time
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: ThemeColors.midGrey),
              const SizedBox(width: 6),
              Text(
                '${Utils.formatDateToLocalFromDateTime(ticket.createdAt)} • ${Utils.formatTimeToLocalFromDateTime(ticket.createdAt)}',
                style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TicketState state) {
    switch (state) {
      case TicketState.start:
        return const Color(0xFFFF9500); // Orange
      case TicketState.finished:
        return const Color(0xFF34C759); // Green
      case TicketState.inProgress:
        return ThemeColors.themeBlue;
      case TicketState.unknown:
      default:
        return ThemeColors.midGrey;
    }
  }
}

/// Customer information card
class _CustomerInfoCard extends StatelessWidget {
  final Customer customer;

  const _CustomerInfoCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                child: Icon(Icons.person_outline, color: ThemeColors.themeBlue, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Customer Information',
                style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Name', value: customer.name),
          _InfoRow(label: 'Company', value: customer.companyName),
          _InfoRow(label: 'Phone', value: customer.phoneNumber),
          _InfoRow(label: 'Email', value: customer.email),
          _InfoRow(label: 'Address', value: customer.address),
        ],
      ),
    );
  }
}

/// Product information card
class _ProductInfoCard extends StatelessWidget {
  final OrderProduct orderProduct;

  const _ProductInfoCard({required this.orderProduct});

  Map<String, dynamic> _parseConfigurations(String configJson) {
    try {
      return Map<String, dynamic>.from(json.decode(configJson));
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final configurations = _parseConfigurations(orderProduct.configurations);

    return Container(
      padding: const EdgeInsets.all(20),
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
                child: Icon(Icons.inventory_2_outlined, color: ThemeColors.themeBlue, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Product Information',
                style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Product', value: orderProduct.product.name),
          _InfoRow(label: 'Model', value: orderProduct.product.modelNumber),
          _InfoRow(label: 'Serial Number', value: orderProduct.serialNumber),
          if (configurations.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ConfigurationsSection(configurations: configurations),
          ],
        ],
      ),
    );
  }
}

/// Configurations section
class _ConfigurationsSection extends StatelessWidget {
  final Map<String, dynamic> configurations;

  const _ConfigurationsSection({required this.configurations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.settings_outlined, size: 16, color: ThemeColors.midGrey),
            const SizedBox(width: 6),
            Text('Configurations', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
          ],
        ),
        const SizedBox(height: 12),
        ...configurations.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _InfoRow(label: entry.key, value: entry.value.toString()),
          ),
        ),
      ],
    );
  }
}




/// Action button for ticket operations
class _ActionButton extends StatelessWidget {
  final Ticket ticket;
  final bool isUpdatingTicket;
  final VoidCallback onStartDelivery;
  final VoidCallback onStartService;
  final Function(DeliveryChallanData) onEndDelivery;
  final Function(ServiceChallanData) onEndService;

  const _ActionButton({
    required this.ticket,
    required this.isUpdatingTicket,
    required this.onStartDelivery,
    required this.onStartService,
    required this.onEndDelivery,
    required this.onEndService,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeButton(
      text: ticket.state == TicketState.start ? 'Start' : 'End',
      onPressed:
          isUpdatingTicket
              ? null
              : () async {
                if (ticket.type.toLowerCase() == 'service') {
                  if (ticket.state == TicketState.start) {
                    onStartService();
                  } else {
                    final challanData = await context.push<ServiceChallanData>('/service-challan/${ticket.uuid}',extra: {
                      'name': ticket.customer?.name ?? '',
                      'phone': ticket.customer?.phoneNumber ?? '',
                      'model': ticket.orderProduct?.modelNumber ?? ticket.orderProduct?.product.modelNumber ?? '',
                      'serial': ticket.orderProduct?.serialNumber ?? '',
                    },);
                    if (challanData != null) {
                      onEndService(challanData);
                    }
                  }
                } else {
                  if (ticket.state == TicketState.start) {
                    onStartDelivery();
                  } else {
                    final challanData = await context.push<DeliveryChallanData>('/delivery-challan/${ticket.uuid}');
                    if (challanData != null) {
                      onEndDelivery(challanData);
                    }
                  }
                }
              },
      isLoading: isUpdatingTicket,
      leadingIcon: ticket.state == TicketState.start ? Icons.play_arrow : Icons.stop,
    );
  }
}

/// Loading view
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: ThemeColors.themeBlue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text('Loading ticket details...', style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
        ],
      ),
    );
  }
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: ThemeColors.notificationRed.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.error_outline, size: 48, color: ThemeColors.notificationRed),
            ),
            const SizedBox(height: 24),
            Text(
              'Error Loading Ticket',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(error, style: ThemeFonts.text14(textColor: ThemeColors.midGrey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Empty state view
class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: ThemeColors.lightGrey.withOpacity(0.3), shape: BoxShape.circle),
              child: Icon(Icons.receipt_outlined, size: 48, color: ThemeColors.midGrey),
            ),
            const SizedBox(height: 24),
            Text(
              'No Ticket Found',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'The requested ticket could not be found or has been removed.',
              style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


/// Info row widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
          const SizedBox(height: 4),
          Text(value, style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack)),
        ],
      ),
    );
  }
}
