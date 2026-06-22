import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  final Map<String, Map<String, String>> testUsers = {
    'student': {
      'email': 'natnat@example.com',
      'password': 'password',
      'name': 'Natnat Garcia',
    },
    'teacher': {
      'email': 'fernando@example.com',
      'password': 'password',
      'name': 'Fernando Santos',
    },
    'supervisor': {
      'email': 'maria@example.com',
      'password': 'password',
      'name': 'Maria Reyes',
    },
    'admin': {
      'email': 'admin@example.com',
      'password': 'password',
      'name': 'Admin User',
    },
  };

  void _setTestUser(String role) {
    final userData = testUsers[role];
    if (userData != null) {
      setState(() {
        _emailController.text = userData['email']!;
        _passwordController.text = userData['password']!;
      });
    }
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate login delay
      await Future.delayed(const Duration(seconds: 1));

      // Determine role and user name based on email
      String role = 'student';
      String userName = 'User';
      for (var entry in testUsers.entries) {
        if (entry.value['email'] == _emailController.text) {
          role = entry.key;
          userName = entry.value['name'] ?? 'User';
          break;
        }
      }

      if (mounted) {
        // Navigate to role-specific dashboard
        switch (role) {
          case 'student':
            context.go('/student-dashboard', extra: userName);
            break;
          case 'teacher':
            context.go('/teacher-dashboard', extra: userName);
            break;
          case 'supervisor':
            context.go('/supervisor-dashboard', extra: userName);
            break;
          case 'admin':
            context.go('/admin-dashboard', extra: userName);
            break;
          default:
            context.go('/student-dashboard', extra: userName);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),

                // Header
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 40.h),

                // Email Field
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Password Field
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Demo Test Users Section
                Text(
                  'Demo Test Users',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    // Student Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _setTestUser('student'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '👤',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Text(
                              'Student',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Natnat',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Teacher Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _setTestUser('teacher'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '👨‍🏫',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Text(
                              'Teacher',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Fernando',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Supervisor Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _setTestUser('supervisor'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '👨‍💼',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Text(
                              'Supervisor',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Maria',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Admin Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _setTestUser('admin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '⚙️',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Demo Credentials Info
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Credentials',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'All roles use password: "password"',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
