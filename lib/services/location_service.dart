import 'package:geolocator/geolocator.dart';

/// Service untuk mendapatkan lokasi GPS
class LocationService {
  /// Check apakah location service diaktifkan
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Request location permission
  static Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Check current permission status
  static Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      // Check permission
      final permission = await checkLocationPermission();

      if (permission == LocationPermission.denied) {
        final newPermission = await requestLocationPermission();
        if (newPermission == LocationPermission.denied ||
            newPermission == LocationPermission.deniedForever) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Open app settings
        await Geolocator.openAppSettings();
        return null;
      }

      // Check location service
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Open location settings
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
