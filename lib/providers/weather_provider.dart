import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_report/models/weather_model.dart';
import 'package:weather_report/services/location_service.dart';
import 'package:weather_report/services/weather_service.dart';

enum WeatherState { initial, loading, loaded, error, locationDenied, locationDisabled }

class WeatherProvider extends ChangeNotifier {
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  BmkgLocation? _weatherData;
  CurrentWeather? _currentWeather;
  List<WeatherTimeseries> _hourlyForecasts = [];
  List<DailyForecast> _dailyForecasts = [];
  String _cityName = 'Unknown';
  bool _isDarkMode = false;
  DateTime? _lastUpdate;
  Position? _currentPosition;
  
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  // Getters
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  BmkgLocation? get weatherData => _weatherData;
  CurrentWeather? get currentWeather => _currentWeather;
  List<WeatherTimeseries> get hourlyForecasts => _hourlyForecasts;
  List<DailyForecast> get dailyForecasts => _dailyForecasts;
  String get cityName => _cityName;
  bool get isDarkMode => _isDarkMode;
  DateTime? get lastUpdate => _lastUpdate;
  Position? get currentPosition => _currentPosition;

  /// Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  /// Initialize dan load weather data
  Future<void> initialize() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      // Get location permission
      final permission = await _locationService.checkLocationPermission();

      if (permission == LocationPermission.denied) {
        _state = WeatherState.locationDenied;
        _errorMessage = 'Lokasi diperlukan untuk menampilkan prakiraan cuaca';
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _state = WeatherState.locationDenied;
        _errorMessage = 'Izin lokasi ditolak permanen. Buka pengaturan aplikasi.';
        notifyListeners();
        return;
      }

      // Check location service
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _state = WeatherState.locationDisabled;
        _errorMessage = 'Aktifkan layanan lokasi di pengaturan perangkat';
        notifyListeners();
        return;
      }

      // Get position
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        _state = WeatherState.locationDenied;
        _errorMessage = 'Gagal mendapatkan lokasi Anda';
        notifyListeners();
        return;
      }

      _currentPosition = position;

      // Map location to adm4
      final adm4 = WeatherService.mapLocationToAdm4(
        position.latitude,
        position.longitude,
      );

      // Fetch weather data
      await fetchWeather(adm4);
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = 'Error: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Fetch weather data dari BMKG
  Future<void> fetchWeather(String adm4) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final response = await _weatherService.getWeatherForecast(adm4: adm4);

      if (response != null && response.data.isNotEmpty) {
        _weatherData = response.data.first;
        _cityName = '${_weatherData!.kotkab}, ${_weatherData!.provinsi}';
        _lastUpdate = DateTime.now();

        // Parse data
        _currentWeather = WeatherParser.getCurrentWeather(
          _weatherData!.timeseries,
          _cityName,
        );
        _hourlyForecasts = WeatherParser.extractHourlyForecasts(
          _weatherData!.timeseries,
          hours: 12,
        );
        _dailyForecasts = WeatherParser.extractDailyForecasts(
          _weatherData!.timeseries,
        );

        _state = WeatherState.loaded;
      } else {
        throw Exception('No weather data received');
      }
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = 'Gagal mengambil data cuaca: ${e.toString()}';
    }

    notifyListeners();
  }

  /// Request location permission
  Future<void> requestLocationPermission() async {
    await _locationService.requestLocationPermission();
    await initialize();
  }

  /// Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentPosition != null) {
      final adm4 = WeatherService.mapLocationToAdm4(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      await fetchWeather(adm4);
    } else {
      await initialize();
    }
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await LocationService.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await LocationService.openAppSettings();
  }
}
