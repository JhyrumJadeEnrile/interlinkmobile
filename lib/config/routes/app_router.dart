import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/attendance/presentation/pages/time_tracking_page.dart';
import '../../features/attendance/presentation/pages/selfie_verification_page.dart';
import '../../features/timesheets/presentation/pages/timesheets_page.dart';
import '../../features/supervisor/presentation/pages/approval_page.dart';
import '../../features/student/presentation/pages/student_dashboard_page.dart';
import '../../features/teacher/presentation/pages/teacher_dashboard_page.dart';
import '../../features/supervisor/presentation/pages/supervisor_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';

// Error page widget
class ErrorPage extends StatelessWidget {
  final String? error;

  const ErrorPage({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text(error ?? 'An error occurred'),
      ),
    );
  }
}

// App router class with static router property
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      // Main Home Route
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),

      // Role-Specific Dashboards
      GoRoute(
        path: '/student-dashboard',
        builder: (context, state) {
          final name = state.extra as String?;
          return StudentDashboardPage(userName: name);
        },
      ),
      GoRoute(
        path: '/teacher-dashboard',
        builder: (context, state) {
          final name = state.extra as String?;
          return TeacherDashboardPage(userName: name);
        },
      ),
      GoRoute(
        path: '/supervisor-dashboard',
        builder: (context, state) {
          final name = state.extra as String?;
          return SupervisorDashboardPage(userName: name);
        },
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) {
          final name = state.extra as String?;
          return AdminDashboardPage(userName: name);
        },
      ),

      // Profile Route
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // Attendance Routes
      GoRoute(
        path: '/time-tracking',
        builder: (context, state) => const TimeTrackingPage(),
      ),
      GoRoute(
        path: '/selfie-verification',
        builder: (context, state) => const SelfieVerificationPage(),
      ),

      // Timesheet Routes
      GoRoute(
        path: '/timesheets',
        builder: (context, state) => const TimesheetsPage(),
      ),

      // Approval Route
      GoRoute(
        path: '/approval',
        builder: (context, state) => const ApprovalPage(),
      ),

      // Additional Routes (Placeholder)
      GoRoute(
        path: '/manage-students',
        builder: (context, state) => const _PlaceholderPage(title: 'Manage Students'),
      ),
      GoRoute(
        path: '/attendance-report',
        builder: (context, state) => const _PlaceholderPage(title: 'Attendance Report'),
      ),
      GoRoute(
        path: '/teacher-approvals',
        builder: (context, state) => const _PlaceholderPage(title: 'Approvals'),
      ),
      GoRoute(
        path: '/teacher-reports',
        builder: (context, state) => const _PlaceholderPage(title: 'Reports'),
      ),
      GoRoute(
        path: '/teacher-feedback',
        builder: (context, state) => const _PlaceholderPage(title: 'Feedback'),
      ),
      GoRoute(
        path: '/teacher-monitor-students',
        builder: (context, state) => const _PlaceholderPage(title: 'Monitor Students'),
      ),
      GoRoute(
        path: '/approval-queue',
        builder: (context, state) => const _PlaceholderPage(title: 'Approval Queue'),
      ),
      GoRoute(
        path: '/supervisor-requests',
        builder: (context, state) => const _PlaceholderPage(title: 'Requests'),
      ),
      GoRoute(
        path: '/supervisor-exceptions',
        builder: (context, state) => const _PlaceholderPage(title: 'Exceptions'),
      ),
      GoRoute(
        path: '/supervisor-analytics',
        builder: (context, state) => const _PlaceholderPage(title: 'Analytics'),
      ),
      GoRoute(
        path: '/user-management',
        builder: (context, state) => const _PlaceholderPage(title: 'User Management'),
      ),
      GoRoute(
        path: '/supervisor-reports',
        builder: (context, state) => const _PlaceholderPage(title: 'Reports'),
      ),
      GoRoute(
        path: '/admin-users',
        builder: (context, state) => const _PlaceholderPage(title: 'User Management'),
      ),
      GoRoute(
        path: '/admin-settings',
        builder: (context, state) => const _PlaceholderPage(title: 'Settings'),
      ),
      GoRoute(
        path: '/admin-logs',
        builder: (context, state) => const _PlaceholderPage(title: 'System Logs'),
      ),
      GoRoute(
        path: '/admin-backup',
        builder: (context, state) => const _PlaceholderPage(title: 'Backup & Restore'),
      ),
      GoRoute(
        path: '/admin-security',
        builder: (context, state) => const _PlaceholderPage(title: 'Security'),
      ),
      GoRoute(
        path: '/admin-reports',
        builder: (context, state) => const _PlaceholderPage(title: 'Analytics'),
      ),
      GoRoute(
        path: '/admin-export',
        builder: (context, state) => const _PlaceholderPage(title: 'Export Data'),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
  );
}

// Placeholder page for routes under development
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This page is under development',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
