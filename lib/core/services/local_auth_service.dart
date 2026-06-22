import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

class LocalAuthService {
  static final LocalAuthService _instance = LocalAuthService._internal();
  final LocalAuthentication _auth = LocalAuthentication();
  final Logger _logger = Logger();

  factory LocalAuthService() {
    return _instance;
  }

  LocalAuthService._internal();

  static LocalAuthService get instance => _instance;

  bool _isBiometricAvailable = false;

  bool get isBiometricAvailable => _isBiometricAvailable;

  Future<void> init() async {
    try {
      _isBiometricAvailable = await _auth.canCheckBiometrics;
      _logger.i('Biometric available: $_isBiometricAvailable');
    } catch (e) {
      _logger.e('Error checking biometric availability: $e');
      _isBiometricAvailable = false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      if (!_isBiometricAvailable) {
        _logger.w('Biometrics not available');
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Authenticate to access InternLink',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      _logger.e('Biometric authentication error: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      _logger.e('Error getting available biometrics: $e');
      return [];
    }
  }

  Future<bool> deviceSupportsBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      _logger.e('Error checking device biometric support: $e');
      return false;
    }
  }
}
