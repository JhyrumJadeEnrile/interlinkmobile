import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink/config/theme/app_theme.dart';

class AdminDashboardPage extends StatefulWidget {
  final String? userName;
  final String? email;

  const AdminDashboardPage({
    super.key,
    this.userName,
    this.email,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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

              // System Health
              Text(
                'System Health',
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
                  _buildHealthCard('124', 'Total Users', Colors.blue, '↑ 5%'),
                  _buildHealthCard('99.9%', 'Uptime', Colors.green, 'Healthy'),
                  _buildHealthCard('2.3 GB', 'Storage', Colors.orange, '68%'),
                  _buildHealthCard('12', 'Alerts', Colors.red, '3 Critical'),
                ],
              ),
              SizedBox(height: 24.h),

              // Management Tasks
              Text(
                'System Management',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              _buildManagementCard(
                title: 'User Management',
                description: 'Add, edit, manage users',
                icon: Icons.admin_panel_settings,
                color: Colors.blue,
                onTap: () => context.push('/admin-users'),
              ),
              SizedBox(height: 8.h),
              _buildManagementCard(
                title: 'System Settings',
                description: 'Configure system parameters',
                icon: Icons.settings,
                color: Colors.purple,
                onTap: () => context.push('/admin-settings'),
              ),
              SizedBox(height: 8.h),
              _buildManagementCard(
                title: 'System Logs',
                description: 'View application logs',
                icon: Icons.history,
                color: Colors.grey,
                onTap: () => context.push('/admin-logs'),
              ),
              SizedBox(height: 8.h),
              _buildManagementCard(
                title: 'Backup & Restore',
                description: 'Database backup management',
                icon: Icons.backup,
                color: Colors.teal,
                onTap: () => context.push('/admin-backup'),
              ),
              SizedBox(height: 8.h),
              _buildManagementCard(
                title: 'Security & Permissions',
                description: 'Role management & permissions',
                icon: Icons.security,
                color: Colors.red,
                onTap: () => context.push('/admin-security'),
              ),
              SizedBox(height: 24.h),

              // Reports
              Text(
                'Reports & Analytics',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: () => context.push('/admin-reports'),
                icon: const Icon(Icons.dashboard),
                label: const Text('View Analytics Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: () => context.push('/admin-export'),
                icon: const Icon(Icons.download),
                label: const Text('Export Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                ),
              ),
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
            colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
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
              widget.userName ?? 'Admin User',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Administrator • System Administration',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Status',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Operational',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Critical Alerts',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '3',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(String value, String label, Color color, String status) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: color.withOpacity(0.05),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              status,
              style: TextStyle(
                fontSize: 10.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard({
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
          backgroundColor: color.withOpacity(0.2),
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
}
