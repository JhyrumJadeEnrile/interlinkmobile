import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink/config/theme/app_theme.dart';
import 'package:internlink/core/services/location_service.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class TimeTrackingPage extends StatefulWidget {
  final String? userName;
  final String? role;

  const TimeTrackingPage({
    super.key,
    this.userName,
    this.role,
  });

  @override
  State<TimeTrackingPage> createState() => _TimeTrackingPageState();
}

class _TimeTrackingPageState extends State<TimeTrackingPage> {
  final Logger _logger = Logger();
  DateTime? _timeIn;
  DateTime? _timeOut;
  late String displayName;

  @override
  void initState() {
    super.initState();
    displayName = widget.userName ?? _getDefaultNameByRole();
  }

  String _getDefaultNameByRole() {
    switch (widget.role) {
      case 'teacher':
        return 'Fernando Santos';
      case 'supervisor':
        return 'Maria Reyes';
      case 'admin':
        return 'Admin User';
      default:
        return 'Natnat Garcia';
    }
  }

  String? _currentLocation;
  bool _isLoading = false;
  bool _hasTimedIn = false;

  Future<void> _timeInWithVerification() async {
    // Navigate to selfie verification first
    final result = await context.push('/selfie-verification');
    
    if (result == true) {
      _performTimeIn();
    }
  }

  Future<void> _performTimeIn() async {
    setState(() => _isLoading = true);

    try {
      // Get current location
      final location = await LocationService.instance.getCurrentLocation();

      if (location == null) {
        _showErrorDialog('Unable to get your location. Please enable location services.');
        return;
      }

      setState(() {
        _timeIn = DateTime.now();
        _currentLocation =
            'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
        _hasTimedIn = true;
      });

      _showSuccessDialog(
        'Time In Recorded',
        'You timed in at ${DateFormat('hh:mm a').format(_timeIn!)}',
      );

      _logger.i('Time in recorded: $_timeIn');
      _logger.i('Location: $_currentLocation');
    } catch (e) {
      _logger.e('Error during time in: $e');
      _showErrorDialog('Failed to record time in. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performTimeOut() async {
    if (!_hasTimedIn) {
      _showErrorDialog('You must time in first');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final location = await LocationService.instance.getCurrentLocation();

      if (location == null) {
        _showErrorDialog('Unable to get your location. Please enable location services.');
        return;
      }

      setState(() {
        _timeOut = DateTime.now();
      });

      final duration = _timeOut!.difference(_timeIn!);
      final hours = duration.inMinutes / 60;

      _showSuccessDialog(
        'Time Out Recorded',
        'You timed out at ${DateFormat('hh:mm a').format(_timeOut!)}.\nTotal hours: ${hours.toStringAsFixed(2)}h',
      );

      _logger.i('Time out recorded: $_timeOut');
      _logger.i('Rendered hours: ${hours.toStringAsFixed(2)}');
    } catch (e) {
      _logger.e('Error during time out: $e');
      _showErrorDialog('Failed to record time out. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.successColor),
            SizedBox(width: 8.w),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: AppTheme.errorColor),
            SizedBox(width: 8.w),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracking'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Current Time
              Card(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('EEEE').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        DateFormat('hh:mm a').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        DateFormat('MMMM d, yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Time In / Time Out Cards
              Row(
                children: [
                  Expanded(
                    child: _TimeCard(
                      title: 'Time In',
                      time: _timeIn != null
                          ? DateFormat('hh:mm a').format(_timeIn!)
                          : '--:--',
                      isActive: _timeIn != null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _TimeCard(
                      title: 'Time Out',
                      time: _timeOut != null
                          ? DateFormat('hh:mm a').format(_timeOut!)
                          : '--:--',
                      isActive: _timeOut != null,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Location Info
              if (_currentLocation != null) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppTheme.secondaryColor,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Location',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _currentLocation!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // Action Buttons
              if (!_hasTimedIn)
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _timeInWithVerification,
                  icon: const Icon(Icons.login),
                  label: const Text('Time In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    minimumSize: Size(double.infinity, 50.h),
                  ),
                )
              else ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _performTimeOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Time Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    minimumSize: Size(double.infinity, 50.h),
                  ),
                ),
              ],

              SizedBox(height: 24.h),

              // Today's Summary
              if (_timeIn != null)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Summary",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _SummaryRow(
                          label: 'Time In',
                          value: DateFormat('hh:mm a').format(_timeIn!),
                        ),
                        SizedBox(height: 8.h),
                        if (_timeOut != null) ...[
                          _SummaryRow(
                            label: 'Time Out',
                            value: DateFormat('hh:mm a').format(_timeOut!),
                          ),
                          SizedBox(height: 8.h),
                          _SummaryRow(
                            label: 'Rendered Hours',
                            value:
                                '${(_timeOut!.difference(_timeIn!).inMinutes / 60).toStringAsFixed(2)}h',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 24.h),

              // Help Text
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '• Make sure you are within the company premises when clocking in/out\n• Your location will be recorded for verification\n• Take a clear selfie for identity verification\n• Time records are final once submitted',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue[800],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String title;
  final String time;
  final bool isActive;

  const _TimeCard({
    required this.title,
    required this.time,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor.withValues(alpha: 0.05) : Colors.white,
        border: Border.all(
          color: isActive ? AppTheme.primaryColor : Colors.grey[300]!,
          width: isActive ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              time,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: isActive ? AppTheme.primaryColor : Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            if (isActive)
              Icon(
                Icons.check_circle,
                color: AppTheme.secondaryColor,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
