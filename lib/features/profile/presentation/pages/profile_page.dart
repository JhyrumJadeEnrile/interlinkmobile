import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink/config/theme/app_theme.dart';
import 'package:internlink/core/services/storage_service.dart';

class ProfilePage extends StatefulWidget {
  final String? userName;
  final String? role;
  final String? email;
  final String? company;

  const ProfilePage({
    super.key,
    this.userName,
    this.role,
    this.email,
    this.company,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String displayName;
  late String userEmail;
  late String userCompany;
  late String userRole;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    // Test data mapping by role
    final roleTestData = {
      'student': {
        'name': 'Natnat Garcia',
        'email': 'natnat@example.com',
        'company': 'Tech Solutions Inc.',
        'role': 'OJT Student'
      },
      'teacher': {
        'name': 'Fernando Santos',
        'email': 'fernando@example.com',
        'company': 'Education Hub',
        'role': 'Teacher'
      },
      'supervisor': {
        'name': 'Maria Reyes',
        'email': 'maria@example.com',
        'company': 'Management Office',
        'role': 'Supervisor'
      },
      'admin': {
        'name': 'Admin User',
        'email': 'admin@example.com',
        'company': 'System Administration',
        'role': 'Administrator'
      },
    };

    final data = roleTestData[widget.role] ?? roleTestData['student']!;
    displayName = widget.userName ?? data['name']!;
    userEmail = widget.email ?? data['email']!;
    userCompany = widget.company ?? data['company']!;
    userRole = data['role']!;
  }
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: AppTheme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/placeholder_avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Natnat Abong',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'OJT Intern',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Personal Information
                  const _SectionTitle(title: 'Personal Information'),
                  SizedBox(height: 12.h),
                  const _InfoCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: 'jrebutar@ojt.com',
                  ),
                  SizedBox(height: 12.h),
                  const _InfoCard(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: '+63 917 123 4567',
                  ),
                  SizedBox(height: 12.h),
                  const _InfoCard(
                    icon: Icons.card_membership,
                    label: 'Student ID',
                    value: 'STU-2024-0456',
                  ),

                  SizedBox(height: 24.h),

                  // Internship Information
                  const _SectionTitle(title: 'Internship Information'),
                  SizedBox(height: 12.h),
                  const _InfoCard(
                    icon: Icons.business,
                    label: 'Company',
                    value: 'MedGrocer Inc.',
                  ),
                  SizedBox(height: 12.h),
                  const _InfoCard(
                    icon: Icons.location_on,
                    label: 'Location',
                    value: 'Centauria, WFH',
                  ),
                  SizedBox(height: 12.h),
                  const _InfoCard(
                    icon: Icons.person,
                    label: 'Supervisor',
                    value: 'Mr. John Supervisor',
                  ),
                  SizedBox(height: 12.h),
                  const _InfoCard(
                    icon: Icons.school,
                    label: 'OJT Coordinator',
                    value: 'Ms. Maria Coordinator',
                  ),

                  SizedBox(height: 24.h),

                  // Security Settings
                  const _SectionTitle(title: 'Security & Privacy'),
                  SizedBox(height: 12.h),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.fingerprint,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Biometric Authentication'),
                      subtitle: const Text('Fingerprint/Face ID'),
                      trailing: Switch(
                        value: _biometricEnabled,
                        onChanged: (value) {
                          setState(() => _biometricEnabled = value);
                          StorageService.instance.enableBiometric(value);
                        },
                        activeThumbColor: AppTheme.primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Settings
                  const _SectionTitle(title: 'Settings'),
                  SizedBox(height: 12.h),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.language,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Language'),
                      subtitle: const Text('English'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Notifications'),
                      subtitle: const Text('Manage notification preferences'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // About
                  const _SectionTitle(title: 'About'),
                  SizedBox(height: 12.h),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.info,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('About InternLink'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.description,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.description,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    'Version 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.instance.logout();
              if (mounted) {
                context.go('/login');
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
