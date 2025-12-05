import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/assets.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/helper/app_common_methods.dart';
import 'package:sbccapp/stores/attendance_page.store.dart';
import 'package:sbccapp/stores/user.store.dart';
import 'package:sbccapp/utils.dart';

class SideDrawer extends StatefulWidget {
  final bool isHomeSelected;

  const SideDrawer({super.key, this.isHomeSelected = false});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final _userStore = locator<UserStore>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 1. Minimal Header Section
            _DrawerHeader(),

            const SizedBox(height: 20),

            // 2. The Redesigned Attendance Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _AttendanceSection(),
            ),

            const SizedBox(height: 30),

            // 3. Menu Items
            Expanded(
              child: Observer(
                builder: (_) {
                  final role = _userStore.userRole ?? _userStore.currentUser?.role;
                  return _DrawerNavigationItems(isHomeSelected: widget.isHomeSelected, userRole: role);
                },
              ),
            ),

            // 4. Logout Section
            _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

/// Header section of the drawer with logo and user info
class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userStore = locator<UserStore>();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 10),
      child: Observer(
        builder: (_) {
          final userName = userStore.currentUser?.name ?? 'Staff Member';
          final userEmail = userStore.currentUser?.email ?? 'staff@test.com';
          
          return Row(
            children: [
              // Avatar
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: ThemeColors.themeBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          "SBC",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Today's Attendance Section in Drawer
class _AttendanceSection extends StatefulWidget {
  @override
  State<_AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<_AttendanceSection> {
  final _attendanceStore = locator<AttendancePageStore>();

  @override
  void initState() {
    super.initState();
    _attendanceStore.loadAttendances();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final todayAttendance = _attendanceStore.todayAttendance;
        final isCheckedIn = todayAttendance != null && todayAttendance.checkOut == null;
        final isCheckingIn = _attendanceStore.isCheckingInLoading;
        final currentDate = Utils.formatDateToLocalFromDateTime(DateTime.now());

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isCheckedIn ? const Color(0xFFE8F5E9) : ThemeColors.themeBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isCheckedIn ? Colors.green.shade100 : ThemeColors.themeBlue.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentDate,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCheckedIn ? Colors.green : ThemeColors.themeBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCheckedIn ? "Present" : "Absent",
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isCheckedIn ? "Checked In" : "Not Checked In",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCheckedIn ? Colors.green[800] : ThemeColors.themeBlue,
                    ),
                  ),
                  if (isCheckingIn)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCheckedIn ? Colors.green : ThemeColors.themeBlue,
                        ),
                      ),
                    )
                  else
                    Switch.adaptive(
                      value: isCheckedIn,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        if (val) {
                          _attendanceStore.checkIn(context: context);
                        } else {
                          _attendanceStore.checkOut(context: context);
                        }
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Navigation items section
class _DrawerNavigationItems extends StatelessWidget {
  final bool isHomeSelected;
  final String? userRole;

  const _DrawerNavigationItems({required this.isHomeSelected, this.userRole});

  @override
  Widget build(BuildContext context) {
    final normalizedRole = userRole?.toLowerCase();
    final isStaff = normalizedRole == 'staff';
    final isMarketing = normalizedRole == 'marketing';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        // Home - for all roles
        _DrawerMenuItem(
          icon: Icons.home_outlined,
          title: 'Home',
          isSelected: isHomeSelected,
          onTap: () {
            Navigator.pop(context);
            if (!isHomeSelected) {
              context.go('/home');
            }
          },
        ),
        // Profile - for all roles
        _DrawerMenuItem(
          icon: Icons.person_outline,
          title: 'Profile',
          onTap: () {
            Navigator.pop(context);
            context.push('/profile');
          },
        ),
        // Attendance Report - for all roles
        _DrawerMenuItem(
          icon: Icons.calendar_today_outlined,
          title: 'Attendance Report',
          onTap: () {
            Navigator.pop(context);
            context.push('/attendance');
          },
        ),
        // Leads - only for marketing
        if (isMarketing)
          _DrawerMenuItem(
            icon: Icons.people_sharp,
            title: 'Leads',
            onTap: () {
              Navigator.pop(context);
              context.push('/leads');
            },
          ),
        // Staff-specific menus
        if (isStaff) ...[
          _DrawerMenuItem(
            icon: Icons.history_toggle_off,
            title: 'Logged Tickets',
            onTap: () {
              Navigator.pop(context);
              context.push('/logged-tickets');
            },
          ),
          _DrawerMenuItem(
            icon: Icons.qr_code_scanner_rounded,
            title: 'Product Scan',
            onTap: () {
              Navigator.pop(context);
              context.push('/product-scan');
            },
          ),
          _DrawerMenuItem(
            icon: Icons.receipt_long_rounded,
            title: 'Challan Info',
            onTap: () {
              Navigator.pop(context);
              context.push('/challan-info');
            },
          ),
        ],
      ],
    );
  }
}

/// Individual menu item widget
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: ThemeColors.themeBlue, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        onTap: onTap,
        hoverColor: Colors.grey[50],
      ),
    );
  }
}


/// Logout button section
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: InkWell(
        onTap: () async {
          AppCommonMethods.logout(context, isFromSideDrawer: true);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: ThemeColors.themeBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: ThemeColors.themeBlue),
              const SizedBox(width: 8),
              Text(
                "Logout",
                style: TextStyle(
                  color: ThemeColors.themeBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
