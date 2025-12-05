import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/pages/side_drawer.dart';
import 'package:sbccapp/stores/product_details.store.dart';

class ProductDetailsPage extends StatefulWidget {
  final String orderId;

  const ProductDetailsPage({super.key, required this.orderId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final _store = locator<ProductDetailsStore>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _store.loadProductDetailsByProductId(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.primarySand,
      appBar: _ProductDetailsAppBar(onBackPressed: () => context.pop()),
      drawer: const SideDrawer(),
      body: Observer(
        builder: (_) {
          return _store.productQr.maybeWhen(
            (productQr) => _ProductDetailsContent(productQr: productQr),
            loading: () => const _LoadingContent(),
            error: (error, _) => _ErrorContent(error: error.toString()),
            orElse: () => const _EmptyContent(),
          );
        },
      ),
    );
  }
}

/// Custom AppBar for the product details page
class _ProductDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const _ProductDetailsAppBar({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.themeBlue,
      foregroundColor: ThemeColors.white,
      elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBackPressed),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Product Details', style: ThemeFonts.text20Bold(textColor: ThemeColors.white))],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main content section showing product details
class _ProductDetailsContent extends StatelessWidget {
  final ProductQr productQr;

  const _ProductDetailsContent({required this.productQr});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header Card
            _OrderHeaderCard(productQr: productQr),
            const SizedBox(height: 24),

            // Customer Information
            if (productQr.customer != null) ...[
              _CustomerInfoCard(customer: productQr.customer!),
              const SizedBox(height: 24),
            ],

            // Order Products
            if (productQr.orderProducts != null && productQr.orderProducts!.isNotEmpty) ...[
              _OrderProductsCard(orderProducts: productQr.orderProducts!),
              const SizedBox(height: 24),
            ],

            // Order Images
            if (productQr.images != null && productQr.images!.isNotEmpty) ...[
              _OrderImagesCard(images: productQr.images!),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

/// Order header information card
class _OrderHeaderCard extends StatelessWidget {
  final ProductQr productQr;

  const _OrderHeaderCard({required this.productQr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.primaryBlack.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2, color: ThemeColors.themeBlue, size: 24),
              const SizedBox(width: 12),
              Text('Information', style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'ID', value: productQr.uuid),
          _InfoRow(label: 'Title', value: productQr.title),
          if (productQr.createdAt != null) _InfoRow(label: 'Created At', value: _formatDateTime(productQr.createdAt!)),
          if (productQr.updatedAt != null) _InfoRow(label: 'Updated At', value: _formatDateTime(productQr.updatedAt!)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.primaryBlack.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: ThemeColors.themeBlue, size: 24),
              const SizedBox(width: 12),
              Text('Customer Information', style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Name', value: customer.name),
          _InfoRow(label: 'Email', value: customer.email),
          _InfoRow(label: 'Phone', value: customer.phoneNumber),
          _InfoRow(label: 'Address', value: customer.address),
        ],
      ),
    );
  }
}

/// Order products card
class _OrderProductsCard extends StatelessWidget {
  final List<OrderProductQr> orderProducts;

  const _OrderProductsCard({required this.orderProducts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.primaryBlack.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //const SizedBox(height: 16),
          ...orderProducts.map((orderProduct) => _OrderProductItem(orderProduct: orderProduct)),
        ],
      ),
    );
  }
}

/// Individual order product item
class _OrderProductItem extends StatelessWidget {
  final OrderProductQr orderProduct;

  const _OrderProductItem({required this.orderProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory, color: ThemeColors.themeBlue, size: 20),
              const SizedBox(width: 8),
              Text('Product Details', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'UUID', value: orderProduct.uuid),
          if (orderProduct.serialNumber != null) _InfoRow(label: 'Serial Number', value: orderProduct.serialNumber!),
          if (orderProduct.modelNumber != null) _InfoRow(label: 'Model Number', value: orderProduct.modelNumber!),
          if (orderProduct.product != null) ...[
            const SizedBox(height: 8),
            Text('Product Information', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
            const SizedBox(height: 8),
            _InfoRow(label: 'Name', value: orderProduct.product!.name),
            _InfoRow(label: 'Description', value: orderProduct.product!.description),
            _InfoRow(label: 'Model Number', value: orderProduct.product!.modelNumber),
          ],
          if (orderProduct.tickets != null && orderProduct.tickets!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Tickets (${orderProduct.tickets!.length})',
              style: ThemeFonts.text16Bold(textColor: ThemeColors.themeYellow),
            ),
            const SizedBox(height: 12),
            ...orderProduct.tickets!.map(
              (ticket) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _TicketCard(ticket: ticket)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Order images card
class _OrderImagesCard extends StatelessWidget {
  final List<OrderImage> images;

  const _OrderImagesCard({required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.primaryBlack.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image, color: ThemeColors.themeBlue, size: 24),
              const SizedBox(width: 12),
              Text(
                'Order Images (${images.length})',
                style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _OrderImageItem(image: images[index]);
            },
          ),
        ],
      ),
    );
  }
}

/// Individual order image item
class _OrderImageItem extends StatelessWidget {
  final OrderImage image;

  const _OrderImageItem({required this.image});

  @override
  Widget build(BuildContext context) {
    // Only show the image if imagePath is available
    if (image.imagePath == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.lightGrey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://erp.sbccindia.com/storage/${image.imagePath!}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 100,
              color: ThemeColors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue)),
                    const SizedBox(height: 8),
                    Text('Loading image...', style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
                  ],
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              color: ThemeColors.lightGrey.withOpacity(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 48, color: ThemeColors.midGrey),
                  const SizedBox(height: 8),
                  Text('Failed to load image', style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Reusable info row widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: ThemeFonts.text14(textColor: ThemeColors.midGrey))),
          Expanded(child: Text(value, style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack))),
        ],
      ),
    );
  }
}

/// Loading content widget
class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue)),
          const SizedBox(height: 16),
          Text('Loading product details...', style: ThemeFonts.text16Bold(textColor: ThemeColors.themeBlue)),
        ],
      ),
    );
  }
}

/// Error content widget
class _ErrorContent extends StatelessWidget {
  final String error;

  const _ErrorContent({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error Loading Product Details', style: ThemeFonts.text20Bold(textColor: Colors.red)),
            const SizedBox(height: 8),
            Text(error, style: ThemeFonts.text14(textColor: ThemeColors.midGrey), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Retry loading
                final store = locator<ProductDetailsStore>();
                store.loadProductDetailsByProductId(
                  store.productQr.maybeWhen((productQr) => productQr.uuid, orElse: () => ''),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.themeBlue,
                foregroundColor: ThemeColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Retry', style: ThemeFonts.text14Bold(textColor: ThemeColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty content widget
class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: ThemeColors.midGrey),
            const SizedBox(height: 16),
            Text('No Product Details', style: ThemeFonts.text20Bold(textColor: ThemeColors.midGrey)),
            const SizedBox(height: 8),
            Text('No product information available', style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
          ],
        ),
      ),
    );
  }
}

/// Ticket card widget with expandable content
class _TicketCard extends StatefulWidget {
  final Ticket ticket;

  const _TicketCard({required this.ticket});

  @override
  State<_TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<_TicketCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.lightGrey),
        boxShadow: [
          BoxShadow(color: ThemeColors.primaryBlack.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header - always visible
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.ticket.state.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.ticket.state.displayName,
                      style: ThemeFonts.text12Bold(textColor: widget.ticket.state.color),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.ticket.subject ?? 'No Subject',
                          style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack),
                        ),
                        const SizedBox(height: 4),
                        Text('Type: ${widget.ticket.type}', style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
                      ],
                    ),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: ThemeColors.midGrey),
                ],
              ),
            ),
          ),
          // Expandable content
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic ticket info
                  _InfoRow(label: 'UUID', value: widget.ticket.uuid),
                  _InfoRow(label: 'Type', value: widget.ticket.type),
                  if (widget.ticket.start != null)
                    _InfoRow(label: 'Start', value: _formatDateTime(widget.ticket.start!)),
                  if (widget.ticket.end != null) _InfoRow(label: 'End', value: _formatDateTime(widget.ticket.end!)),
                  _InfoRow(label: 'Created', value: _formatDateTime(widget.ticket.createdAt)),
                  _InfoRow(label: 'Updated', value: _formatDateTime(widget.ticket.updatedAt)),

                  // Assigned to
                  if (widget.ticket.assignedTo != null) ...[
                    const SizedBox(height: 12),
                    Text('Assigned To', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 8),
                    _UserInfo(user: widget.ticket.assignedTo!),
                  ],

                  // Attended by
                  if (widget.ticket.attendedBy != null) ...[
                    const SizedBox(height: 12),
                    Text('Attended By', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 8),
                    _UserInfo(user: widget.ticket.attendedBy!),
                  ],

                  // Contact person
                  if (widget.ticket.contactPerson != null) ...[
                    const SizedBox(height: 12),
                    Text('Contact Person', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 8),
                    _ContactPersonInfo(contactPerson: widget.ticket.contactPerson!),
                  ],

                  // Additional staff
                  if (widget.ticket.additionalStaff != null && widget.ticket.additionalStaff!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Additional Staff (${widget.ticket.additionalStaff!.length})',
                      style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue),
                    ),
                    const SizedBox(height: 8),
                    ...widget.ticket.additionalStaff!.map(
                      (staff) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _UserInfo(user: staff)),
                    ),
                  ],

                  // Ticket images
                  if (widget.ticket.images != null && widget.ticket.images!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Ticket Images (${widget.ticket.images!.length})',
                      style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue),
                    ),
                    const SizedBox(height: 8),
                    _TicketImagesGrid(images: widget.ticket.images!),
                  ],

                  // Services
                  if (widget.ticket.services != null && widget.ticket.services!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Services (${widget.ticket.services!.length})',
                      style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue),
                    ),
                    const SizedBox(height: 8),
                    ...widget.ticket.services!.map(
                      (service) =>
                          Padding(padding: const EdgeInsets.only(bottom: 12), child: _ServiceCard(service: service)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// User info widget
class _UserInfo extends StatelessWidget {
  final User user;

  const _UserInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: ThemeColors.lightGrey.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.name ?? 'No Name', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
          if (user.email != null) Text(user.email!, style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
          if (user.phoneNumber != null)
            Text(user.phoneNumber!, style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
          if (user.role != null) Text('Role: ${user.role!}', style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
        ],
      ),
    );
  }
}

/// Contact person info widget
class _ContactPersonInfo extends StatelessWidget {
  final ContactPerson contactPerson;

  const _ContactPersonInfo({required this.contactPerson});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: ThemeColors.lightGrey.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contactPerson.name ?? 'No Name', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
          if (contactPerson.email != null)
            Text(contactPerson.email!, style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
          if (contactPerson.phoneNumber != null)
            Text(contactPerson.phoneNumber!, style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
          if (contactPerson.alternatePhoneNumber != null)
            Text(
              'Alt: ${contactPerson.alternatePhoneNumber!}',
              style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
            ),
        ],
      ),
    );
  }
}

/// Ticket images grid widget
class _TicketImagesGrid extends StatelessWidget {
  final List<TicketImage> images;

  const _TicketImagesGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _TicketImageItem(image: images[index]);
      },
    );
  }
}

/// Individual ticket image item
class _TicketImageItem extends StatelessWidget {
  final TicketImage image;

  const _TicketImageItem({required this.image});

  @override
  Widget build(BuildContext context) {
    if (image.imagePath == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.lightGrey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          'https://erp.sbccindia.com/storage/${image.imagePath!}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(color: ThemeColors.white, child: const Center(child: CircularProgressIndicator()));
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: ThemeColors.lightGrey.withOpacity(0.3),
              child: const Center(child: Icon(Icons.broken_image, color: ThemeColors.midGrey)),
            );
          },
        ),
      ),
    );
  }
}

/// Service card widget
class _ServiceCard extends StatefulWidget {
  final Service service;

  const _ServiceCard({required this.service});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.lightGrey),
      ),
      child: Column(
        children: [
          // Service header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ThemeColors.themeBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.service.serviceType,
                      style: ThemeFonts.text12Bold(textColor: ThemeColors.themeBlue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.service.contactPersonName ?? 'No Contact Person',
                          style: ThemeFonts.text12Bold(textColor: ThemeColors.primaryBlack),
                        ),
                        if (widget.service.startDateTime != null)
                          Text(
                            _formatDateTime(widget.service.startDateTime!),
                            style: ThemeFonts.text10(textColor: ThemeColors.midGrey),
                          ),
                      ],
                    ),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: ThemeColors.midGrey, size: 16),
                ],
              ),
            ),
          ),
          // Expandable service details
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service details
                  _InfoRow(label: 'Service Type', value: widget.service.serviceType),
                  if (widget.service.startDateTime != null)
                    _InfoRow(label: 'Start Time', value: _formatDateTime(widget.service.startDateTime!)),
                  if (widget.service.endDateTime != null)
                    _InfoRow(label: 'End Time', value: _formatDateTime(widget.service.endDateTime!)),
                  if (widget.service.paymentType != null)
                    _InfoRow(label: 'Payment Type', value: widget.service.paymentType!),
                  if (widget.service.paymentStatus != null)
                    _InfoRow(label: 'Payment Status', value: widget.service.paymentStatus!),
                  if (widget.service.unitModelNumber != null)
                    _InfoRow(label: 'Unit Model', value: widget.service.unitModelNumber!),
                  if (widget.service.unitSrNo != null) _InfoRow(label: 'Unit Serial', value: widget.service.unitSrNo!),

                  // Service logs
                  if (widget.service.log != null && widget.service.log!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Service Log', style: ThemeFonts.text12Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ThemeColors.lightGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(widget.service.log!, style: ThemeFonts.text12(textColor: ThemeColors.primaryBlack)),
                    ),
                  ],

                  // Service description
                  if (widget.service.serviceDescription != null && widget.service.serviceDescription!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Description', style: ThemeFonts.text12Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ThemeColors.lightGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.service.serviceDescription!,
                        style: ThemeFonts.text12(textColor: ThemeColors.primaryBlack),
                      ),
                    ),
                  ],

                  // Service user
                  if (widget.service.user != null) ...[
                    const SizedBox(height: 8),
                    Text('Service Technician', style: ThemeFonts.text12Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 4),
                    _UserInfo(user: widget.service.user!),
                  ],

                  // Technical readings
                  if (_hasTechnicalReadings(widget.service)) ...[
                    const SizedBox(height: 8),
                    Text('Technical Readings', style: ThemeFonts.text12Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 4),
                    _TechnicalReadingsCard(service: widget.service),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool _hasTechnicalReadings(Service service) {
    return service.refrigerant != null ||
        service.voltage != null ||
        service.ampR != null ||
        service.ampY != null ||
        service.ampB != null ||
        service.standingPressure != null ||
        service.suctionPressure != null ||
        service.dischargePressure != null ||
        service.suctionTemp != null ||
        service.dischargeTemp != null ||
        service.chilledWaterIn != null ||
        service.chilledWaterOut != null ||
        service.conWaterIn != null ||
        service.conWaterOut != null ||
        service.waterTankTemp != null ||
        service.cabinetTemp != null ||
        service.roomTemp != null;
  }
}

/// Technical readings card
class _TechnicalReadingsCard extends StatelessWidget {
  final Service service;

  const _TechnicalReadingsCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: ThemeColors.lightGrey.withOpacity(0.3), borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          if (service.refrigerant != null) _InfoRow(label: 'Refrigerant', value: service.refrigerant!),
          if (service.voltage != null) _InfoRow(label: 'Voltage', value: service.voltage!),
          if (service.ampR != null) _InfoRow(label: 'Amp R', value: service.ampR!),
          if (service.ampY != null) _InfoRow(label: 'Amp Y', value: service.ampY!),
          if (service.ampB != null) _InfoRow(label: 'Amp B', value: service.ampB!),
          if (service.standingPressure != null) _InfoRow(label: 'Standing Pressure', value: service.standingPressure!),
          if (service.suctionPressure != null) _InfoRow(label: 'Suction Pressure', value: service.suctionPressure!),
          if (service.dischargePressure != null)
            _InfoRow(label: 'Discharge Pressure', value: service.dischargePressure!),
          if (service.suctionTemp != null) _InfoRow(label: 'Suction Temp', value: service.suctionTemp!),
          if (service.dischargeTemp != null) _InfoRow(label: 'Discharge Temp', value: service.dischargeTemp!),
          if (service.chilledWaterIn != null) _InfoRow(label: 'Chilled Water In', value: service.chilledWaterIn!),
          if (service.chilledWaterOut != null) _InfoRow(label: 'Chilled Water Out', value: service.chilledWaterOut!),
          if (service.conWaterIn != null) _InfoRow(label: 'Con Water In', value: service.conWaterIn!),
          if (service.conWaterOut != null) _InfoRow(label: 'Con Water Out', value: service.conWaterOut!),
          if (service.waterTankTemp != null) _InfoRow(label: 'Water Tank Temp', value: service.waterTankTemp!),
          if (service.cabinetTemp != null) _InfoRow(label: 'Cabinet Temp', value: service.cabinetTemp!),
          if (service.roomTemp != null) _InfoRow(label: 'Room Temp', value: service.roomTemp!),
        ],
      ),
    );
  }
}
