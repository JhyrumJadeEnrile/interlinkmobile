import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink/config/theme/app_theme.dart';
import 'package:internlink/core/services/local_auth_service.dart';
import 'package:internlink/core/services/storage_service.dart';

class BiometricSetupPage extends StatefulWidget {
  const BiometricSetupPage({Key? key}) : super(key: key);

  @override
  State<BiometricSetupPage> createState() => _BiometricSetupPageState();
}

class _BiometricSetupPageState extends State<BiometricSetupPage> {
  bool _isSetupComplete = false;
  List<String> _setupSteps = [];

  @override
  void initState() {
    super.initState();
    _initializeSetup();
  }

  void _initializeSetup() async {
    final biometrics =
        await LocalAuthService.instance.getAvailableBiometrics();
    
    setState(() {
      _setupSteps = biometrics.map((b) => b.toString()).toList();
    });
  }

  void _enableBiometric() async {
    final authenticated =
        await LocalAuthService.instance.authenticateWithBiometrics();
    
    if (authenticated) {
      await StorageService.instance.enableBiometric(true);
      setState(() => _isSetupComplete = true);
      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) context.go('/home');
      });
    }
  }

  void _skipBiometric() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header
              Column(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fingerprint,
                      size: 50.sp,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Setup Biometric Authentication',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Secure your account with biometric authentication',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              // Benefits
              Column(
                children: [
                  _BenefitItem(
                    icon: Icons.security,
                    title: 'Enhanced Security',
                    description: 'Protect your account with fingerprint or face ID',
                  ),
                  SizedBox(height: 16.h),
                  _BenefitItem(
                    icon: Icons.speed,
                    title: 'Quick Access',
                    description: 'Login faster without typing credentials',
                  ),
                  SizedBox(height: 16.h),
                  _BenefitItem(
                    icon: Icons.check_circle,
                    title: 'Convenient',
                    description: 'One-tap authentication on every login',
                  ),
                ],
              ),
              
              // Buttons
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isSetupComplete ? null : _enableBiometric,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(
                      _isSetupComplete ? 'Setup Complete' : 'Enable Biometric',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSetupComplete
                          ? Colors.green
                          : AppTheme.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: _skipBiometric,
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
