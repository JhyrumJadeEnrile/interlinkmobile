# InternLink Flutter Mobile App - Complete Setup Guide

## Project Structure

```
internlink_flutter/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── config/
│   │   ├── routes/
│   │   │   └── app_router.dart           # Navigation/routing
│   │   └── theme/
│   │       └── app_theme.dart            # Theme configuration
│   ├── core/
│   │   ├── api/
│   │   │   └── api_service.dart          # API integration (Retrofit)
│   │   ├── models/
│   │   │   ├── user_model.dart           # User data model
│   │   │   └── attendance_model.dart     # Attendance data model
│   │   └── services/
│   │       ├── local_auth_service.dart   # Biometric authentication
│   │       ├── location_service.dart     # GPS/Location services
│   │       └── storage_service.dart      # Local data persistence (Hive)
│   └── features/
│       ├── auth/
│       │   └── presentation/pages/
│       │       ├── login_page.dart       # Login with email/password & biometric
│       │       └── biometric_setup_page.dart # Biometric setup
│       ├── home/
│       │   └── presentation/pages/
│       │       └── home_page.dart        # Dashboard with progress
│       ├── attendance/
│       │   └── presentation/pages/
│       │       ├── time_tracking_page.dart  # Time in/out with GPS
│       │       └── selfie_verification_page.dart # Identity verification
│       ├── timesheets/
│       │   └── presentation/pages/
│       │       └── timesheets_page.dart  # View timesheets
│       ├── supervisor/
│       │   └── presentation/pages/
│       │       └── approval_page.dart    # DTR approval with signature
│       └── profile/
│           └── presentation/pages/
│               └── profile_page.dart     # User profile
├── assets/
│   ├── images/
│   ├── icons/
│   └── animations/
├── pubspec.yaml                           # Dependencies
├── BACKEND_API_DOCS.md                   # API documentation
└── README.md                              # Project documentation
```

## Prerequisites

- Flutter SDK >= 3.10.0
- Dart >= 3.0.0
- Android SDK (for Android development)
- Xcode (for iOS development)
- Git
- Android/iOS device or emulator

## Installation

### 1. Setup Flutter

```bash
# Install Flutter from https://flutter.dev/docs/get-started/install

# Verify installation
flutter doctor

# Upgrade Flutter
flutter upgrade
```

### 2. Clone or Create Project

```bash
# Create new Flutter project
flutter create internlink_flutter

# Or clone existing repository
git clone <repository_url>
cd internlink_flutter
```

### 3. Install Dependencies

```bash
# Get all pub packages
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Run code generator for models and retrofit
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Configure Environment

Create `.env` file in project root:
```
API_BASE_URL=https://api.internlink.local/v1
API_TIMEOUT=30000
LOG_LEVEL=DEBUG
```

## Running the App

### Android

```bash
# Run on connected device
flutter run

# Run on specific device
flutter run -d <device_id>

# Release build
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Run on connected device
flutter run

# Release build
flutter build ios --release
```

## Key Features Implementation

### 1. Biometric Authentication
- Fingerprint/Face ID login
- Biometric setup during first login
- Biometric toggle in settings

**Files**: `local_auth_service.dart`, `login_page.dart`, `biometric_setup_page.dart`

### 2. GPS Location Tracking
- Automatic location capture during time in/out
- Location verification (within company premises)
- GPS data encryption and secure storage

**Files**: `location_service.dart`, `time_tracking_page.dart`

### 3. Selfie Verification
- Camera-based identity verification
- Selfie capture before time in
- ML-based face verification (via API)

**Files**: `selfie_verification_page.dart`

### 4. Digital Signature
- Supervisor signature capture for DTR approval
- Signature storage and export
- PDF generation with signature

**Files**: `approval_page.dart`, signature package integration

### 5. Time Tracking
- Time in/out with automatic calculations
- DTR photo attachment option
- Rendered hours calculation

**Files**: `time_tracking_page.dart`, `attendance_model.dart`

### 6. DTR Management
- Monthly DTR generation
- Digital signature for approval
- PDF export functionality

**Files**: `approval_page.dart`, BACKEND_API_DOCS.md

## Configuration Files

### pubspec.yaml

All dependencies are listed. Key packages:
- `flutter_screenutil`: Responsive UI
- `go_router`: Navigation
- `dio`: HTTP client
- `retrofit`: API client generation
- `local_auth`: Biometrics
- `geolocator`: GPS
- `image_picker`: Camera/gallery access
- `signature`: Digital signatures
- `hive`: Local storage

### AndroidManifest.xml

Permissions configured for:
- Camera (selfie)
- Fine/Coarse location (GPS)
- Internet access
- File storage
- Biometrics
- Notifications

### iOS Configuration (Info.plist)

Add these keys to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access for identity verification</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>We need location access to verify you're at the workplace</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need location access for background location tracking</string>

<key>NSLocalAuthenticationUsageDescription</key>
<string>We use biometric authentication for secure login</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos for document upload</string>
```

## API Integration

### Base URL Configuration

Edit API base URL in service initialization:

```dart
// In main.dart or api configuration
final dio = Dio()
  ..options.baseUrl = 'https://api.internlink.local/v1'
  ..options.connectTimeout = const Duration(seconds: 30)
  ..options.receiveTimeout = const Duration(seconds: 30);

final apiService = ApiService(dio);
```

### Authentication Flow

1. User logs in with email/password
2. Backend returns JWT token + refresh token
3. Token stored in local storage (Hive)
4. All subsequent requests include token in header
5. Token auto-refreshed when expired

### Error Handling

All API errors are caught and displayed to user with appropriate messages.

## Building for Production

### Android Release

```bash
# Generate signed APK
flutter build apk --release --obfuscate --split-debug-info=build/app/profile

# Generate App Bundle
flutter build appbundle --release
```

### iOS Release

```bash
# Build for App Store
flutter build ios --release

# Archive and submit to App Store
open ios/Runner.xcworkspace
# Then use Xcode to archive and submit
```

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Test with coverage
flutter test --coverage
```

## Troubleshooting

### Common Issues

1. **Permissions not working on Android 12+**
   - Update `targetSdkVersion` to 33+ in build.gradle
   - Request runtime permissions properly

2. **Location services not working**
   - Enable location services on device
   - Check location permissions in settings
   - Use foreground location access

3. **Camera not opening**
   - Check camera permission
   - Verify camera hardware availability
   - On iOS, check camera entitlements

4. **Biometrics not available**
   - Device must have fingerprint/face sensor
   - Setup biometric on device first
   - Check `local_auth` package compatibility

5. **Build issues**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Run `flutter pub run build_runner build --delete-conflicting-outputs`

## Performance Optimization

1. **Code Obfuscation**: Enabled in release builds
2. **Tree Shaking**: Removes unused code
3. **Image Optimization**: Compress images before deployment
4. **Lazy Loading**: Routes loaded on demand
5. **Caching**: API responses cached locally
6. **Database Indexing**: Hive indexes for faster queries

## Security Best Practices

1. **Store sensitive data** in encrypted local storage (Hive)
2. **Never log** API tokens or passwords
3. **Use HTTPS** for all API calls
4. **Validate input** on client and server
5. **Implement rate limiting** for auth endpoints
6. **Sign APK/IPA** before distribution
7. **Use ProGuard** for Android obfuscation
8. **Implement SSL pinning** for API security

## Deployment Checklist

- [ ] All tests passing
- [ ] No console errors or warnings
- [ ] API endpoints configured correctly
- [ ] Release builds generated
- [ ] App signed and ready
- [ ] Privacy policy reviewed
- [ ] Terms of service reviewed
- [ ] Permissions justified
- [ ] Crash reporting configured (Firebase Crashlytics)
- [ ] Analytics integrated
- [ ] Beta testing completed
- [ ] Store descriptions and screenshots ready

## Support & Documentation

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Package Documentation: https://pub.dev
- GitHub Issues: Report issues and feature requests

## Backend Requirements

Ensure backend API implements all endpoints documented in `BACKEND_API_DOCS.md`:
- Authentication (login, register, refresh token)
- Attendance management (time in, time out, get records)
- DTR operations (get, sign, export)
- User profile (get, update)
- Communications (messages, announcements)
- Journal submissions
- File uploads/downloads

## Future Enhancements

1. Offline mode with data sync
2. Push notifications for approvals
3. Attendance analytics dashboard
4. Performance metrics and reports
5. Integration with learning management system
6. QR code check-in
7. Attendance auto-sync with HR systems
8. Advanced reporting and export options
9. Multi-language support
10. Dark mode theme

## License

This project is proprietary to Technological University of the Philippines - Taguig.
All rights reserved.

## Contact & Support

For technical support, please contact the InternLink development team.
Email: internlink@tup.edu.ph
