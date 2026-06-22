import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink/config/theme/app_theme.dart';

enum UserRole { student, teacher, supervisor, admin }

class HomePage extends StatefulWidget {
  final String? userName;
  final String? email;
  final UserRole userRole;

  const HomePage({
    super.key,
    this.userName,
    this.email,
    this.userRole = UserRole.student,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String displayName;
  late String userEmail;
  late String company;
  late double attendancePercentage;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final roleData = {
      UserRole.student: {
        'name': 'Natnat Garcia',
        'email': 'natnat@example.com',
        'company': 'Tech Solutions Inc.',
        'attendance': 92.5,
      },
      UserRole.teacher: {
        'name': 'Fernando Santos',
        'email': 'fernando@example.com',
        'company': 'Education Hub',
        'attendance': 95.0,
      },
      UserRole.supervisor: {
        'name': 'Maria Reyes',
        'email': 'maria@example.com',
        'company': 'Management Office',
        'attendance': 98.0,
      },
      UserRole.admin: {
        'name': 'Admin User',
        'email': 'admin@example.com',
        'company': 'System Administration',
        'attendance': 100.0,
      },
    };

    final data = roleData[widget.userRole]!;
    displayName = widget.userName ?? data['name'] as String;
    userEmail = widget.email ?? data['email'] as String;
    company = data['company'] as String;
    attendancePercentage = data['attendance'] as double;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go('/login');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/login'),
            tooltip: 'Logout',
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Center(
                child: GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: CircleAvatar(
                    radius: 20.w,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      displayName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              SizedBox(height: 20.h),
              // Role-specific content
              _buildRoleSpecificContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            displayName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            company,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white60,
            ),
          ),
          SizedBox(height: 16.h),
          // Role badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              widget.userRole.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificContent() {
    switch (widget.userRole) {
      case UserRole.student:
        return _buildStudentContent();
      case UserRole.teacher:
        return _buildTeacherContent();
      case UserRole.supervisor:
        return _buildSupervisorContent();
      case UserRole.admin:
        return _buildAdminContent();
    }
  }

  Widget _buildStudentContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // OJT Progress Card
          _buildProgressCard('120.5', '240', '50.2%'),
          SizedBox(height: 20.h),
          // Stats
          _buildStatsGrid(),
          SizedBox(height: 24.h),
          // Student-only buttons
          _buildActionButtons([
            ('Time Tracking', Icons.access_time, AppTheme.primaryColor, '/time-tracking'),
            ('My Timesheets', Icons.description, AppTheme.secondaryColor, '/timesheets'),
            ('Verification', Icons.verified_user, Colors.green, '/selfie-verification'),
          ]),
        ],
      ),
    );
  }

  Widget _buildTeacherContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildStatsGrid(),
          SizedBox(height: 24.h),
          // Teacher-only buttons
          _buildActionButtons([
            ('Manage Students', Icons.groups, AppTheme.primaryColor, '/manage-students'),
            ('View Attendance', Icons.assessment, AppTheme.secondaryColor, '/attendance-report'),
            ('Generate Reports', Icons.file_present, Colors.blue, '/teacher-reports'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSupervisorContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildStatsGrid(),
          SizedBox(height: 24.h),
          // Supervisor-only buttons
          _buildActionButtons([
            ('Approve Timesheets', Icons.check_circle, Colors.green, '/approval-queue'),
            ('View Analytics', Icons.analytics, AppTheme.primaryColor, '/supervisor-analytics'),
            ('Manage Users', Icons.people, AppTheme.secondaryColor, '/user-management'),
          ]),
        ],
      ),
    );
  }

  Widget _buildAdminContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildStatsGrid(),
          SizedBox(height: 24.h),
          // Admin-only buttons
          _buildActionButtons([
            ('User Management', Icons.admin_panel_settings, AppTheme.primaryColor, '/admin-users'),
            ('System Settings', Icons.settings, AppTheme.secondaryColor, '/admin-settings'),
            ('System Logs', Icons.history, Colors.red, '/admin-logs'),
            ('Reports & Analytics', Icons.dashboard, Colors.purple, '/admin-reports'),
          ]),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String current, String required, String percentage) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'OJT Progress',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: double.parse(percentage.replaceAll('%', '')) / 100,
                minHeight: 8.h,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hours: $current / $required',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.w,
      crossAxisSpacing: 12.w,
      children: [
        _buildStatTile('92.5%', 'Attendance', Icons.calendar_today, Colors.blue),
        _buildStatTile('On Track', 'Status', Icons.check_circle, Colors.green),
        _buildStatTile('3', 'Pending', Icons.pending_actions, Colors.orange),
        _buildStatTile('45', 'Days Left', Icons.schedule, Colors.purple),
      ],
    );
  }

  Widget _buildStatTile(String value, String label, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32.sp, color: color),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(List<(String, IconData, Color, String)> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons.asMap().entries.map((entry) {
        final (label, icon, color, route) = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ElevatedButton.icon(
            onPressed: () => context.push(route),
            icon: Icon(icon),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
