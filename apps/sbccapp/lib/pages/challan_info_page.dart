import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/pages/challan_info_detail_page.dart';
import 'package:sbccapp/pages/side_drawer.dart';
import 'package:sbccapp/stores/challan_info_page.store.dart';

class ChallanInfoPage extends StatefulWidget {
  const ChallanInfoPage({super.key});

  @override
  State<ChallanInfoPage> createState() => _ChallanInfoPageState();
}

class _ChallanInfoPageState extends State<ChallanInfoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _store = ChallanInfoPageStore();

  @override
  void initState() {
    super.initState();
    _store.loadChallanServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.primarySand,
      appBar: _ChallanInfoAppBar(onBackPressed: () => context.pop()),
      drawer: const SideDrawer(),
      body: Column(
        children: [
          // Main Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: _MainContent(store: _store),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom AppBar for the challan info page
class _ChallanInfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const _ChallanInfoAppBar({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.themeBlue,
      foregroundColor: ThemeColors.white,
      elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBackPressed),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Challan Info', style: ThemeFonts.text20Bold(textColor: ThemeColors.white)),
          Text('View your challan history', style: ThemeFonts.text12(textColor: ThemeColors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main content section with challan list
class _MainContent extends StatelessWidget {
  final ChallanInfoPageStore store;

  const _MainContent({required this.store});

  void _navigateToDetail(ChallanService challanService, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ChallanInfoDetailPage(
              serviceUuid: challanService.serviceUuid,
              customerName: challanService.customerName,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder:
          (_) => store.challanServices.maybeWhen(
            (challanServices) =>
                challanServices.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: ThemeColors.lightGrey),
                          const SizedBox(height: 16),
                          Text('No challans found', style: ThemeFonts.text16(textColor: ThemeColors.midGrey)),
                          Text(
                            'You don\'t have any challan services yet',
                            style: ThemeFonts.text14(textColor: ThemeColors.lightGrey),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      itemCount: challanServices.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final challanService = challanServices[index];
                        return _ChallanCard(
                          challanService: challanService,
                          onTap: () => _navigateToDetail(challanService, context),
                        );
                      },
                    ),

            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => const Center(child: Text('No more data available')),
          ),
    );
  }
}

/// Individual challan card - Professional and minimal design
class _ChallanCard extends StatelessWidget {
  final ChallanService challanService;
  final VoidCallback onTap;

  const _ChallanCard({required this.challanService, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ThemeColors.lightGrey.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.lightGrey.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challanService.customerName,
              style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Product Info - Compact
            Row(
              children: [
                Icon(Icons.model_training, size: 14, color: ThemeColors.midGrey),
                const SizedBox(width: 6),
                Text(
                  'Model: ${challanService.productModelNo}',
                  style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                ),
                const SizedBox(width: 16),
                Icon(Icons.qr_code, size: 14, color: ThemeColors.midGrey),
                const SizedBox(width: 6),
                Text(
                  'SN: ${challanService.productSerialNo.substring(0, 8)}',
                  style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ticket Subject - Truncated
            Text(
              challanService.ticketSubject,
              style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Bottom Row - Date and Action
            Row(
              children: [
                // Creation Date
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: ThemeColors.midGrey),
                    const SizedBox(width: 4),
                    Text(
                      challanService.ticketCreatedAt.split(' ')[0],
                      style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ThemeColors.themeBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.arrow_forward_ios, size: 12, color: ThemeColors.themeBlue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
