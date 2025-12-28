import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';
import 'package:sbccapp/pages/attendance_report_page.dart';
import 'package:sbccapp/pages/challan_info_page.dart';
import 'package:sbccapp/pages/confirmation_page.dart';
import 'package:sbccapp/pages/create_lead_page.dart';
import 'package:sbccapp/pages/delivery_challan_page.dart';
import 'package:sbccapp/pages/home_page.dart';
import 'package:sbccapp/pages/lead_detail_page.dart';
import 'package:sbccapp/pages/lead_page.dart';
import 'package:sbccapp/pages/logged_tickets_page.dart';
import 'package:sbccapp/pages/login_page.dart';
import 'package:sbccapp/pages/order_details.dart';
import 'package:sbccapp/pages/product_scan_page.dart';
import 'package:sbccapp/pages/profile_page.dart';
import 'package:sbccapp/pages/profile_photo_page.dart';
import 'package:sbccapp/pages/service_challan_page.dart';
import 'package:sbccapp/pages/expense_page.dart';
import 'package:universal_platform/universal_platform.dart';

class RouteName {
  static const String root = '/';
  static const String login = '/login';
  static const String confirmation = '/confirmation';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String profilePhotos = '/profile-photos';
  static const String attendance = '/attendance';
  static const String loggedTickets = '/logged-tickets';
  static const String orderDetails = '/order-details/:uuid';
  static const String productScan = '/product-scan';
  static const String challanInfo = '/challan-info';
  static const String leads = '/leads';
  static const String expenses = '/expenses';
  static const String expenseForm = '/expense-form';
  static const String createLeads = '/create-leads';
  static const String leadDetail = '/lead-detail';
  static const String deliveryChallan = '/delivery-challan/:uuid';
  static const String serviceChallan = '/service-challan/:uuid';
}

class AppRoutes {
  static const String root = "/";
  static const String login = "/login";
  static const String confirmation = "/confirmation";
  static const String home = "/home";
  static const String profile = "/profile";
  static const String profilePhotos = "/profile-photos";
  static const String attendance = "/attendance";
  static const String loggedTickets = "/logged-tickets";
  static const String orderDetails = "/order-details/:uuid";
  static const String productScan = "/product-scan";
  static const String challanInfo = "/challan-info";
  static const String leads = '/leads';
  static const String expenses = '/expenses';
  static const String expenseForm = '/expense-form';
  static const String createLeads = '/create-leads';
  static const String leadDetail = '/lead-detail';
  static const String deliveryChallan = "/delivery-challan/:uuid";
  static const String serviceChallan = "/service-challan/:uuid";
}

// GoRouter root navigator key.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Navigation router.
final GoRouter kRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/",
  redirect: (context, state) async {
    final bearerToken = await locator<InstantLocalPersistenceService>()
        .getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    final isLoggedIn = bearerToken != null && bearerToken.isNotEmpty;

    // If we're on the login page and have a token, redirect to home
    if (isLoggedIn && state.matchedLocation == AppRoutes.root) {
      return AppRoutes.home;
    }

    // If we're not logged in and trying to access protected routes, redirect to login
    if (!isLoggedIn &&
        state.matchedLocation != AppRoutes.root &&
        state.matchedLocation != AppRoutes.login) {
      return AppRoutes.root;
    }

    // No redirection needed
    return null;
  },
  routes: <RouteBase>[
    // Login page
    GoRoute(
      name: RouteName.root,
      path: AppRoutes.root,
      pageBuilder:
          (context, state) =>
              _fadeTransitionPage(state, context, const LoginPage()),
    ),
    // Confirmation page
    GoRoute(
      name: RouteName.confirmation,
      path: AppRoutes.confirmation,
      builder: (_, routerState) {
        return const ConfirmationPage();
      },
    ),
    // Home page with tabs
    GoRoute(
      name: RouteName.home,
      path: AppRoutes.home,
      builder: (_, routerState) {
        return const HomePage();
      },
    ),
    // Profile page with push navigation
    GoRoute(
      name: RouteName.profile,
      path: AppRoutes.profile,
      builder: (_, routerState) {
        return const ProfilePage();
      },
      // pageBuilder: (_, routerState) {
      //   return const ProfilePage();
      //   // return CustomTransitionPage(
      //   //   key: state.pageKey,
      //   //   child: const ProfilePage(),
      //   //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //   //     return SlideTransition(
      //   //       position: Tween<Offset>(
      //   //         begin: const Offset(1.0, 0.0),
      //   //         end: Offset.zero,
      //   //       ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      //   //       child: child,
      //   //     );
      //     },
      //   );
      // },
    ),
    // Profile Photos page
    GoRoute(
      name: RouteName.profilePhotos,
      path: AppRoutes.profilePhotos,
      builder: (_, routerState) {
        return ProfilePhotoPage();
      },
    ),
    // Attendance page
    GoRoute(
      name: RouteName.attendance,
      path: AppRoutes.attendance,
      builder: (_, routerState) {
        return const AttendanceReportPage();
      },
    ),

    // Expense Report Page
    GoRoute(
      name: RouteName.expenses,
      path: AppRoutes.expenses,
      builder: (_, routerState) {
        return const ExpensePage(); // This is the UI page we created earlier
      },
    ),

    // Expense Form Page
    // GoRoute(
    //   name: RouteName.expenseForm,
    //   path: AppRoutes.expenseForm,
    //   pageBuilder: (context, state) {
    //     // If editing, an Expense object is passed via 'extra'
    //     final expense = state.extra as Expense?;
    //     return _slideUpTransitionPage(
    //       state,
    //       context,
    //       ExpenseFormPage(expense: expense),
    //     );
    //   },
    // ),

    // Order Details page
    GoRoute(
      name: RouteName.orderDetails,
      path: AppRoutes.orderDetails,
      builder: (context, state) {
        final uuid = state.pathParameters['uuid']!;
        return OrderDetailsPage(ticketUuid: uuid);
      },
    ),
    // Overtime page
    GoRoute(
      name: RouteName.loggedTickets,
      path: AppRoutes.loggedTickets,
      builder: (_, routerState) {
        return const LoggedTicketsPage();
      },
    ),
    // Product Scan page
    GoRoute(
      name: RouteName.productScan,
      path: AppRoutes.productScan,
      builder: (_, routerState) {
        return const ProductScanPage();
      },
    ),
    // Lead Page
    GoRoute(
      name: RouteName.leads,
      path: AppRoutes.leads,
      builder: (_, routerState) {
        return const LeadPage();
      },
    ),
    // Create Lead Page
    GoRoute(
      name: RouteName.createLeads,
      path: AppRoutes.createLeads,
      builder: (_, routerState) {
        return CreateLeadPage();
      },
    ),
    //Map Picker
    GoRoute(
      path: '/mapPicker',
      builder: (context, state) => const MapPickerScreen(),
    ),
    // Create Lead Page
    GoRoute(
      name: RouteName.leadDetail,
      path: "/lead-detail/:id/:name",
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final name = state.pathParameters['name'];
        return LeadDetailPage(leadId: id!, name: name!);
      },
    ),
    // Challan Info page
    GoRoute(
      name: RouteName.challanInfo,
      path: AppRoutes.challanInfo,
      builder: (_, routerState) {
        return const ChallanInfoPage();
      },
    ),
    // Challan page with slide up transition
    GoRoute(
      name: RouteName.deliveryChallan,
      path: AppRoutes.deliveryChallan,
      pageBuilder: (context, state) {
        final uuid = state.pathParameters['uuid']!;
        return _slideUpTransitionPage(
          state,
          context,
          DeliveryChallanPage(ticketUuid: uuid),
        );
      },
    ),
    GoRoute(
      name: RouteName.serviceChallan,
      path: AppRoutes.serviceChallan,
      pageBuilder: (context, state) {
        final uuid = state.pathParameters['uuid']!;
        final extraData = state.extra as Map<String, dynamic>?;
        return _slideUpTransitionPage(
          state,
          context,
          ServiceChallanPage(
            ticketUuid: uuid,
            initialContactName: extraData?['name'],
            initialContactNumber: extraData?['phone'],
            initialModelNumber: extraData?['model'],
            initialSerialNumber: extraData?['serial'],
          ),
        );
      },
    ),
  ],
);

GlobalKey<NavigatorState> get rootKey => _rootNavigatorKey;

Page<T> _fadeTransitionPage<T>(
  GoRouterState state,
  BuildContext context,
  Widget child, {
  bool opaque = true,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key ?? state.pageKey,
    name: state.name,
    arguments: state,
    child:
        UniversalPlatform.isAndroid
            ? PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  return;
                }
                context.pop(result);
              },
              child: child,
            )
            : child,
    opaque: opaque,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) => FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        ),
  );
}

Page<T> _slideUpTransitionPage<T>(
  GoRouterState state,
  BuildContext context,
  Widget child, {
  bool opaque = true,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key ?? state.pageKey,
    child:
        UniversalPlatform.isAndroid
            ? PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  return;
                }
                context.pop(result);
              },
              child: child,
            )
            : child,
    name: state.name,
    arguments: state,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    opaque: opaque,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCirc,
              reverseCurve: Curves.easeOutSine,
            ),
          ),
          child: child,
        ),
  );
}
