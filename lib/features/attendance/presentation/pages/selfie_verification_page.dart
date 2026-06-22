import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink/config/theme/app_theme.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class SelfieVerificationPage extends StatefulWidget {
  final String? userName;
  final String? role;

  const SelfieVerificationPage({
    Key? key,
    this.userName,
    this.role,
  }) : super(key: key);

  @override
  State<SelfieVerificationPage> createState() => _SelfieVerificationPageState();
}

class _SelfieVerificationPageState extends State<SelfieVerificationPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final Logger _logger = Logger();
  XFile? _capturedImage;
  bool _isVerifying = false;
  bool _isVerified = false;

  Future<void> _takeSelfie() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _capturedImage = image);
        _logger.i('Selfie captured: ${image.path}');
      }
    } catch (e) {
      _logger.e('Error taking selfie: $e');
      _showErrorDialog('Failed to capture image. Please try again.');
    }
  }

  Future<void> _verifySelfie() async {
    if (_capturedImage == null) {
      _showErrorDialog('Please take a selfie first');
      return;
    }

    setState(() => _isVerifying = true);

    try {
      // Simulate face verification API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock verification - in real app, send to ML service
      setState(() => _isVerified = true);

      _showSuccessDialog(
        'Identity Verified',
        'Your identity has been verified successfully.',
      );

      _logger.i('Selfie verified successfully');

      // Wait a moment then return to previous page
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate verification success
        }
      });
    } catch (e) {
      _logger.e('Verification error: $e');
      _showErrorDialog('Verification failed. Please try again.');
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  void _retakeSelfie() {
    setState(() {
      _capturedImage = null;
      _isVerified = false;
    });
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor),
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
            Icon(Icons.error, color: AppTheme.errorColor),
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
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation if not verified
        if (!_isVerified) {
          _showErrorDialog('Please complete the verification process');
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Identity Verification'),
          elevation: 0,
          leading: _isVerified
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                  tooltip: 'Back',
                )
              : null,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                
                // Instruction Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: AppTheme.primaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Identity Verification',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'To ensure security, we need to verify your identity by taking a selfie. This confirms that you are the registered OJT student.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Selfie Preview or Placeholder
                if (_capturedImage != null)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(
                            File(_capturedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (_isVerified)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppTheme.successColor,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.successColor,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Identity Verified',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 400.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No photo taken yet',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 32.h),

                // Guidelines
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'For best results:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[900],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '• Face the camera directly\n• Ensure good lighting\n• Remove sunglasses or hats\n• Make sure your face is clearly visible\n• Avoid shadows on your face',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.amber[800],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Action Buttons
                if (!_isVerified)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isVerifying ? null : _takeSelfie,
                        icon: const Icon(Icons.camera_alt),
                        label: Text(
                          _capturedImage != null
                              ? 'Retake Selfie'
                              : 'Take Selfie',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton.icon(
                        onPressed: (_capturedImage == null || _isVerifying)
                            ? null
                            : _verifySelfie,
                        icon: _isVerifying
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.verified),
                        label: Text(
                          _isVerifying ? 'Verifying...' : 'Verify Identity',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          backgroundColor: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Continue to Time In'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: AppTheme.successColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
