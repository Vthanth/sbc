import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/pages/side_drawer.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/stores/attendance_page.store.dart';
import 'package:sbccapp/utils.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  final _attendanceStore = locator<AttendancePageStore>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _attendanceStore.loadAttendances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.primarySand,
      appBar: _AttendanceReportAppBar(
        onBackPressed: () => context.pop(),
        onRefresh: () => _attendanceStore.loadAttendances(),
      ),
      drawer: const SideDrawer(isHomeSelected: false),
      body: Observer(
        builder: (_) {
          return _attendanceStore.attendances.maybeWhen(
            (list) => _AttendanceReportContent(attendanceStore: _attendanceStore, attendances: list),
            loading: () => const _LoadingView(),
            error:
                (error, stackTrace) =>
                    _ErrorView(error: error.toString(), onRetry: () => _attendanceStore.loadAttendances()),
            orElse: () => const _EmptyStateView(),
          );
        },
      ),
    );
  }
}

/// Custom AppBar for attendance report
class _AttendanceReportAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onRefresh;

  const _AttendanceReportAppBar({required this.onBackPressed, required this.onRefresh});

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
        'Attendance Report',
        style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: ThemeColors.primaryBlack),
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main attendance report content
class _AttendanceReportContent extends StatelessWidget {
  final AttendancePageStore attendanceStore;
  final List<Attendance> attendances;

  const _AttendanceReportContent({required this.attendanceStore, required this.attendances});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Location tracking status widget
        Observer(
          builder: (_) {
            if (attendanceStore.isLocationTracking) {
              return _LocationTrackingStatusWidget(attendanceStore: attendanceStore);
            }
            return const SizedBox.shrink();
          },
        ),
        // Attendance list
        Expanded(
          child:
              attendances.isEmpty
                  ? const _EmptyAttendanceView()
                  : _AttendanceListView(attendanceStore: attendanceStore, attendances: attendances),
        ),
      ],
    );
  }
}

/// Location tracking status widget
class _LocationTrackingStatusWidget extends StatelessWidget {
  final AttendancePageStore attendanceStore;

  const _LocationTrackingStatusWidget({required this.attendanceStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeColors.themeBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: ThemeColors.themeBlue, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.location_on, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location Tracking Active', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
                    const SizedBox(height: 2),
                    Text(
                      'Capturing location every 20 seconds',
                      style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                    ),
                    if (attendanceStore.lastKnownLocation != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Last: ${attendanceStore.lastKnownLocation!.address}',
                        style: ThemeFonts.text10(textColor: ThemeColors.midGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () => attendanceStore.captureLocationNow(context),
                icon: const Icon(Icons.refresh, color: ThemeColors.themeBlue),
                tooltip: 'Capture location now',
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Attendance list view
class _AttendanceListView extends StatelessWidget {
  final AttendancePageStore attendanceStore;
  final List<Attendance> attendances;

  const _AttendanceListView({required this.attendanceStore, required this.attendances});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => attendanceStore.refreshAttendances(),
      color: ThemeColors.themeBlue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          final attendance = attendances[index];
          final attendanceId = attendance.id.toString();

          return Observer(
            builder: (_) {
              final isDeleting = attendanceStore.deletingAttendanceId == attendanceId;
              return _AttendanceCard(
                attendance: attendance,
                isDeleting: isDeleting,
                onDelete: () => attendanceStore.deleteAttendance(attendanceId),
              );
            },
          );
        },
      ),
    );
  }
}

/// Individual attendance card
class _AttendanceCard extends StatelessWidget {
  final Attendance attendance;
  final bool isDeleting;
  final VoidCallback? onDelete;

  const _AttendanceCard({required this.attendance, required this.isDeleting, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final checkInDate = Utils.dateFromString(attendance.checkIn!);
    final checkOutDate = attendance.checkOut != null ? Utils.dateFromString(attendance.checkOut!) : null;
    final isToday =
        checkInDate.year == DateTime.now().year &&
        checkInDate.month == DateTime.now().month &&
        checkInDate.day == DateTime.now().day;
    final workingHours = attendance.workingHours;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Date and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                            child: Icon(
                              Icons.calendar_today,
                              color: ThemeColors.themeBlue,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Utils.formatDateToLocalFromDateTime(checkInDate),
                                  style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _getDayName(checkInDate),
                                  style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeColors.themeBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.3)),
                    ),
                    child: Text(
                      'Today',
                      style: ThemeFonts.text12Bold(textColor: ThemeColors.themeBlue),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Check-in and Check-out Times
            Row(
              children: [
                // Check-in
                Expanded(
                  child: _TimeInfo(
                    icon: Icons.login,
                    label: 'Check In',
                    time: Utils.formatTimeToLocalWithAmPmFromDateTime(checkInDate),
                    color: const Color(0xFF34C759), // Green
                  ),
                ),
                const SizedBox(width: 12),
                // Check-out
                Expanded(
                  child: _TimeInfo(
                    icon: Icons.logout,
                    label: 'Check Out',
                    time: checkOutDate != null
                        ? Utils.formatTimeToLocalWithAmPmFromDateTime(checkOutDate)
                        : 'Not checked out',
                    color: checkOutDate != null ? const Color(0xFFFF9500) : ThemeColors.midGrey, // Orange or grey
                  ),
                ),
              ],
            ),
            // Working Hours
            if (workingHours != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeColors.themeBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: ThemeColors.themeBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Working Hours: ',
                      style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                    ),
                    Text(
                      attendance.formattedWorkingHours,
                      style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }
}

/// Time Info Widget
class _TimeInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  const _TimeInfo({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: ThemeFonts.text14Bold(textColor: color),
          ),
        ],
      ),
    );
  }
}

/// Empty attendance view
class _EmptyAttendanceView extends StatelessWidget {
  const _EmptyAttendanceView();

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
              child: Icon(Icons.calendar_today_outlined, size: 48, color: ThemeColors.midGrey),
            ),
            const SizedBox(height: 24),
            Text(
              'No Attendance Records',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your attendance history will appear here once you start checking in.',
              style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
          Text('Loading attendance records...', style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
        ],
      ),
    );
  }
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

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
              'Error Loading Attendance',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(error, style: ThemeFonts.text14(textColor: ThemeColors.midGrey), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ThemeButton(text: 'Try Again', onPressed: onRetry, leadingIcon: Icons.refresh),
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
              child: Icon(Icons.calendar_today_outlined, size: 48, color: ThemeColors.midGrey),
            ),
            const SizedBox(height: 24),
            Text(
              'No Data Available',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load attendance data at this time.',
              style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
