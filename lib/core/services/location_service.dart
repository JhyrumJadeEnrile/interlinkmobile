import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  final Logger _logger = Logger();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  static LocationService get instance => _instance;

  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      _logger.w('Location permissions are denied forever');
      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      if (!await checkLocationPermission()) {
        _logger.w('Location permission not granted');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      _logger.i('Current location: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      _logger.e('Error getting current location: $e');
      return null;
    }
  }

  Future<double> calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    try {
      return Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
    } catch (e) {
      _logger.e('Error calculating distance: $e');
      return 0;
    }
  }

  Future<bool> isWithinRadius({
    required double currentLat,
    required double currentLng,
    required double centerLat,
    required double centerLng,
    required double radiusInMeters,
  }) async {
    final distance = await calculateDistance(
      startLatitude: currentLat,
      startLongitude: currentLng,
      endLatitude: centerLat,
      endLongitude: centerLng,
    );

    return distance <= radiusInMeters;
  }
}
