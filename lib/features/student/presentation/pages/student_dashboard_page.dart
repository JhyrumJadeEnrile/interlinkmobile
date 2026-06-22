import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink/config/theme/app_theme.dart';

class StudentDashboardPage extends StatefulWidget {
  final String? userName;
  final String? email;

  const StudentDashboardPage({
    super.key,
    this.userName,
    this.email,
  });

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              _buildWelcomeCard(),
              SizedBox(height: 24.h),

              // Current Tasks Section
              Text(
                'Your Tasks Today',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              _buildTaskCard(
                title: 'Record Time In',
                description: 'Start your shift',
                icon: Icons.login,
                color: Colors.green,
                onTap: () => context.push('/time-tracking'),
              ),
              SizedBox(height: 8.h),
              _buildTaskCard(
                title: 'Submit Selfie Verification',
                description: 'Face recognition required',
                icon: Icons.face,
                color: Colors.blue,
                onTap: () => context.push('/selfie-verification'),
              ),
              SizedBox(height: 8.h),
              _buildTaskCard(
                title: 'Record Time Out',
                description: 'End your shift',
                icon: Icons.logout,
                color: Colors.orange,
                onTap: () => context.push('/time-tracking'),
              ),
              SizedBox(height: 24.h),

              // Quick Stats
              Text(
                'This Week Statistics',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12.w,
                crossAxisSpacing: 12.w,
                children: [
                  _buildStatCard('32.5h', 'Hours Worked', Colors.blue),
                  _buildStatCard('5/5', 'Days Present', Colors.green),
                  _buildStatCard('2', 'Pending Reviews', Colors.orange),
                  _buildStatCard('1', 'Messages', Colors.purple),
                ],
              ),
              SizedBox(height: 24.h),

              // Recent Activities
              Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              _buildActivityLog(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userName ?? 'Natnat Garcia',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'OJT Student • Tech Solutions Inc.',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 12.h),
            LinearProgressIndicator(
              value: 0.502,
              minHeight: 6.h,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              '120.5 / 240 hours (50.2%)',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12.sp),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: color.withValues(alpha: 0.05),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLog() {
    final activities = [
      ('Time In', '08:00 AM', Icons.login, Colors.green),
      ('Selfie Verified', '08:15 AM', Icons.face, Colors.blue),
      ('Break', '12:00 PM', Icons.lunch_dining, Colors.orange),
      ('Resume Work', '01:00 PM', Icons.play_circle, Colors.green),
    ];

    return Column(
      children: activities.map((activity) {
        final (label, time, icon, color) = activity;
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.w,
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
