import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/pages/side_drawer.dart';
import 'package:sbccapp/pages/widgets/ticket_card.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/stores/home_page.store.dart';
import 'package:sbccapp/utils/composite_reaction_disposer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _store = locator<HomePageStore>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _disposer = CompositeReactionDisposer();

  @override
  void initState() {
    _store.loadOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.primarySand,
      appBar: _HomeAppBar(onMenuPressed: () => _scaffoldKey.currentState?.openDrawer()),
      drawer: const SideDrawer(isHomeSelected: true),
      body: Container(
        decoration: const BoxDecoration(
          color: ThemeColors.primarySand,
        ),
        child: _MainContent(store: _store),
      ),
    );
  }

  @override
  void dispose() {
    _disposer.dispose();
    super.dispose();
  }
}

/// Custom AppBar for the home page
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  const _HomeAppBar({required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.white,
      foregroundColor: ThemeColors.primaryBlack,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: ThemeColors.primaryBlack),
        onPressed: onMenuPressed,
      ),
      title: Text(
        'Active Tickets',
        style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: ThemeColors.primaryBlack),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: ThemeColors.primaryBlack),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main content area with orders
class _MainContent extends StatelessWidget {
  final HomePageStore store;

  const _MainContent({required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return store.orders.maybeWhen(
          (list) => _OrdersContent(orders: list, store: store),
          loading: () => const _LoadingView(),
          error: (error, message) => _ErrorView(error: message ?? error.toString()),
          orElse: () => const SizedBox(),
        );
      },
    );
  }
}

/// Orders content with header and list
class _OrdersContent extends StatelessWidget {
  final List<Ticket> orders;
  final HomePageStore store;

  const _OrdersContent({required this.orders, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.primarySand,
      child: orders.isEmpty
          ? const _EmptyStateView()
          : RefreshIndicator(
              onRefresh: store.loadOrders,
              color: ThemeColors.themeBlue,
              child: _OrdersList(orders: orders),
            ),
    );
  }
}

/// Header for orders section
class _OrdersHeader extends StatelessWidget {
  final int ordersCount;

  const _OrdersHeader({required this.ordersCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeColors.themeYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.assignment_outlined, color: ThemeColors.themeBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Tickets', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
                Text(
                  '$ordersCount ticket${ordersCount != 1 ? 's' : ''} available',
                  style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Orders list with modern styling
class _OrdersList extends StatelessWidget {
  final List<Ticket> orders;

  const _OrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}

/// Loading view with modern design
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
          Text('Loading tickets...', style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
        ],
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
              child: Icon(Icons.assignment_outlined, size: 48, color: ThemeColors.midGrey),
            ),
            const SizedBox(height: 24),
            Text(
              'No Tickets Available',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any active tickets at the moment. Check back later for new assignments.',
              style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ThemeButton(
              text: 'Refresh',
              onPressed: () {
                // Refresh functionality
              },
              leadingIcon: Icons.refresh,
              width: 150,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view with modern design
class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: ThemeColors.notificationRed.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.error_outline, size: 48, color: ThemeColors.notificationRed),
            ),
            const SizedBox(height: 24),

            // Error Title
            Text(
              'Something went wrong',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Error Message
            Text(error, style: ThemeFonts.text14(textColor: ThemeColors.midGrey), textAlign: TextAlign.center),
            const SizedBox(height: 32),

            // Action Buttons
            // ThemeButtonSmall(
            //   text: 'Logout',
            //   onPressed: () {
            //     AppCommonMethods.logout(context);
            //   },
            //   leadingIcon: Icons.logout,
            // ),
          ],
        ),
      ),
    );
  }
}
