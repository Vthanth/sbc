import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/stores/attendance_page.store.dart';
import 'package:sbccapp/utils.dart';

class TodayAttendanceView extends StatefulWidget {
  const TodayAttendanceView({super.key});
  @override
  State<TodayAttendanceView> createState() => _TodayAttendanceViewState();
}

class _TodayAttendanceViewState extends State<TodayAttendanceView> {
  final _attendanceStore = locator<AttendancePageStore>();

  @override
  void initState() {
    _attendanceStore.loadAttendances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Observer(
      builder: (_) {
        final todayAttendance = _attendanceStore.todayAttendance;
        final isCheckedIn = todayAttendance != null && todayAttendance.checkOut == null;
        final isCheckingIn = _attendanceStore.isCheckingInLoading;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0,
          color: ThemeColors.themeBlue.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.formatDateToLocalFromDateTime(DateTime.now()),
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    if (todayAttendance != null && todayAttendance.checkIn != null) ...[
                      Text(
                        'Check-in: ${Utils.formatTimeToLocalWithAmPmFromDateTime(Utils.dateFromString(todayAttendance.checkIn!))}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                      ),
                      if (todayAttendance.checkOut != null)
                        Text(
                          'Check-out: ${Utils.formatTimeToLocalWithAmPmFromDateTime(Utils.dateFromString(todayAttendance.checkOut!))}',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                        ),
                    ] else
                      Text(
                        'Not checked in',
                        style: theme.textTheme.bodyMedium?.copyWith(color: ThemeColors.notificationRed),
                      ),
                  ],
                ),
                Row(
                  children: [
                    if (isCheckingIn)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Switch(
                      value: isCheckedIn,
                      onChanged: (value) {
                        if (value) {
                          _attendanceStore.checkIn(context: context);
                        } else {
                          _attendanceStore.checkOut(context: context);
                        }
                      },
                      activeColor: ThemeColors.themeBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
