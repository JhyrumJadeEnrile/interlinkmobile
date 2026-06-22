import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  final Logger _logger = Logger();

  late Box<String> _appBox;
  late Box<dynamic> _userBox;
  late Box<dynamic> _timesheetBox;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  static StorageService get instance => _instance;

  Future<void> init() async {
    try {
      _appBox = await Hive.openBox<String>('app_preferences');
      _userBox = await Hive.openBox('user_data');
      _timesheetBox = await Hive.openBox('timesheet_data');
      _logger.i('Storage service initialized');
    } catch (e) {
      _logger.e('Error initializing storage: $e');
      rethrow;
    }
  }

  // Auth related
  Future<void> saveToken(String token) async {
    await _appBox.put('auth_token', token);
  }

  String? getToken() {
    return _appBox.get('auth_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await _appBox.put('refresh_token', token);
  }

  String? getRefreshToken() {
    return _appBox.get('refresh_token');
  }

  Future<void> clearAuthTokens() async {
    await _appBox.delete('auth_token');
    await _appBox.delete('refresh_token');
  }

  // User data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _userBox.put('current_user', userData);
  }

  Map<String, dynamic>? getUserData() {
    return _userBox.get('current_user') as Map<String, dynamic>?;
  }

  Future<void> updateUserData(String key, dynamic value) async {
    await _userBox.put('user_$key', value);
  }

  dynamic getUserDataField(String key) {
    return _userBox.get('user_$key');
  }

  // Biometric preference
  Future<void> enableBiometric(bool enabled) async {
    await _appBox.put('biometric_enabled', enabled.toString());
  }

  bool isBiometricEnabled() {
    final value = _appBox.get('biometric_enabled');
    return value == 'true';
  }

  // Last login
  Future<void> saveLastLogin(String email) async {
    await _appBox.put('last_login_email', email);
  }

  String? getLastLoginEmail() {
    return _appBox.get('last_login_email');
  }

  // Timesheet data
  Future<void> saveTimesheet(String id, Map<String, dynamic> data) async {
    await _timesheetBox.put('timesheet_$id', data);
  }

  Map<String, dynamic>? getTimesheet(String id) {
    return _timesheetBox.get('timesheet_$id') as Map<String, dynamic>?;
  }

  Future<void> clearTimesheet(String id) async {
    await _timesheetBox.delete('timesheet_$id');
  }

  // Cache management
  Future<void> clearAll() async {
    await _appBox.clear();
    await _userBox.clear();
    await _timesheetBox.clear();
  }

  Future<void> logout() async {
    await clearAuthTokens();
    await _userBox.clear();
  }
}
