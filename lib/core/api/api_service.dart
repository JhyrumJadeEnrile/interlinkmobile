import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;
  final Logger _logger = Logger();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.internlink.local/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));
  }

  static ApiService get instance => _instance;

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      _logger.i('Login successful');
      return response.data;
    } catch (e) {
      _logger.e('Login error: $e');
      rethrow;
    }
  }

  Future<dynamic> getProfile() async {
    try {
      final response = await _dio.get('/users/profile');
      return response.data;
    } catch (e) {
      _logger.e('Get profile error: $e');
      rethrow;
    }
  }

  Future<dynamic> timeIn({
    required double latitude,
    required double longitude,
    required String selfieImagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'latitude': latitude,
        'longitude': longitude,
        'selfie': await MultipartFile.fromFile(selfieImagePath),
      });
      final response = await _dio.post(
        '/attendance/time-in',
        data: formData,
      );
      _logger.i('Time in successful');
      return response.data;
    } catch (e) {
      _logger.e('Time in error: $e');
      rethrow;
    }
  }

  Future<dynamic> timeOut({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.post(
        '/attendance/time-out',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      _logger.i('Time out successful');
      return response.data;
    } catch (e) {
      _logger.e('Time out error: $e');
      rethrow;
    }
  }

  Future<dynamic> getAttendanceRecords({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/attendance/records',
        queryParameters: {
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );
      return response.data;
    } catch (e) {
      _logger.e('Get attendance records error: $e');
      rethrow;
    }
  }

  Future<dynamic> submitJournal({
    required String content,
    required String date,
  }) async {
    try {
      final response = await _dio.post(
        '/journals',
        data: {
          'content': content,
          'date': date,
        },
      );
      _logger.i('Journal submitted successfully');
      return response.data;
    } catch (e) {
      _logger.e('Submit journal error: $e');
      rethrow;
    }
  }

  Future<dynamic> getJournals() async {
    try {
      final response = await _dio.get('/journals');
      return response.data;
    } catch (e) {
      _logger.e('Get journals error: $e');
      rethrow;
    }
  }
}
