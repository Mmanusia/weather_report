import 'package:dio/dio.dart';
import 'package:weather_report/models/weather_model.dart';

/// Service untuk API BMKG
class WeatherService {
  static const String baseUrl = 'https://api.bmkg.go.id/publik/prakiraan-cuaca';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  /// Fetch prakiraan cuaca dari BMKG
  /// [adm4] adalah kode administrative level 4 dari BMKG
  /// Default: '31.71.03.1001' (Jakarta)
  Future<BmkgWeatherResponse?> getWeatherForecast({
    String adm4 = '31.71.03.1001',
  }) async {
    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'adm4': adm4,
        },
      );

      if (response.statusCode == 200) {
        return BmkgWeatherResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch weather: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      throw Exception('Failed to fetch weather: ${e.message}');
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to parse weather data: $e');
    }
  }

  /// Mapping koordinat GPS ke adm4 BMKG
  /// Implementasi sederhana - bisa diperluas dengan database lokasi
  static String mapLocationToAdm4(double latitude, double longitude) {
    // Mapping sederhana berdasarkan koordinat umum di Indonesia
    // Format: latitude.longitude -> adm4

    // Jakarta (lat: -6.2, lon: 106.8)
    if (latitude > -6.5 && latitude < -5.5 && longitude > 106.5 && longitude < 107.0) {
      return '31.71.03.1001'; // Jakarta Selatan
    }

    // Bandung (lat: -6.9, lon: 107.6)
    if (latitude > -7.2 && latitude < -6.6 && longitude > 107.4 && longitude < 107.8) {
      return '32.73.01.1001'; // Bandung
    }

    // Surabaya (lat: -7.2, lon: 112.7)
    if (latitude > -7.5 && latitude < -6.9 && longitude > 112.5 && longitude < 112.9) {
      return '35.78.05.1001'; // Surabaya
    }

    // Medan (lat: 3.6, lon: 98.7)
    if (latitude > 3.4 && latitude < 3.8 && longitude > 98.5 && longitude < 98.9) {
      return '12.71.03.1001'; // Medan
    }

    // Yogyakarta (lat: -7.8, lon: 110.4)
    if (latitude > -8.0 && latitude < -7.6 && longitude > 110.2 && longitude < 110.6) {
      return '34.55.02.1001'; // Yogyakarta
    }

    // Default ke Jakarta
    return '31.71.03.1001';
  }
}

/// Parser helper untuk prakiraan harian
class WeatherParser {
  /// Extract prakiraan harian dari timeseries
  static List<DailyForecast> extractDailyForecasts(
    List<WeatherTimeseries> timeseries,
  ) {
    final Map<String, DailyForecast> dailyMap = {};

    for (final ts in timeseries) {
      final dateKey = '${ts.datetime.year}-${ts.datetime.month}-${ts.datetime.day}';

      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = DailyForecast(
          date: DateTime(ts.datetime.year, ts.datetime.month, ts.datetime.day),
          tmax: ts.tmax,
          tmin: ts.tmin,
          condition: ts.getWeatherDescription(),
          rainChance: ts.pp,
          emoji: ts.getWeatherEmoji(),
        );
      } else {
        // Update dengan nilai maksimal/minimal
        final existing = dailyMap[dateKey]!;
        if (ts.tmax != null && (existing.tmax == null || ts.tmax! > existing.tmax!)) {
          dailyMap[dateKey] = DailyForecast(
            date: existing.date,
            tmax: ts.tmax,
            tmin: existing.tmin,
            condition: existing.condition,
            rainChance: existing.rainChance,
            emoji: existing.emoji,
          );
        }
        if (ts.tmin != null && (existing.tmin == null || ts.tmin! < existing.tmin!)) {
          dailyMap[dateKey] = DailyForecast(
            date: existing.date,
            tmax: existing.tmax,
            tmin: ts.tmin,
            condition: existing.condition,
            rainChance: existing.rainChance,
            emoji: existing.emoji,
          );
        }
      }
    }

    // Sort by date dan ambil 7 hari
    final sorted = dailyMap.values.toList();
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted.take(7).toList();
  }

  /// Extract prakiraan per jam (6-12 jam ke depan)
  static List<WeatherTimeseries> extractHourlyForecasts(
    List<WeatherTimeseries> timeseries, {
    int hours = 12,
  }) {
    final now = DateTime.now();
    final futureTime = now.add(Duration(hours: hours));

    return timeseries
        .where((ts) => ts.datetime.isAfter(now) && ts.datetime.isBefore(futureTime))
        .toList();
  }

  /// Get current weather dari timeseries (data terdekat)
  static CurrentWeather? getCurrentWeather(
    List<WeatherTimeseries> timeseries,
    String cityName,
  ) {
    if (timeseries.isEmpty) return null;

    final now = DateTime.now();
    WeatherTimeseries? closest;
    Duration? minDifference;

    for (final ts in timeseries) {
      final difference = ts.datetime.difference(now).abs();
      if (minDifference == null || difference < minDifference) {
        minDifference = difference;
        closest = ts;
      }
    }

    if (closest == null) return null;

    return CurrentWeather(
      temperature: (closest.t?.toDouble() ?? 0.0),
      description: closest.getWeatherDescription(),
      humidity: closest.hu ?? 0,
      windSpeed: closest.getWindSpeed(),
      emoji: closest.getWeatherEmoji(),
      lastUpdate: closest.datetime,
    );
  }
}
