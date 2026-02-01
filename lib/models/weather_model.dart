/// Model untuk response BMKG
class BmkgWeatherResponse {
  final String status;
  final List<BmkgLocation> data;

  BmkgWeatherResponse({
    required this.status,
    required this.data,
  });

  factory BmkgWeatherResponse.fromJson(Map<String, dynamic> json) {
    return BmkgWeatherResponse(
      status: json['status'] as String? ?? 'unknown',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BmkgLocation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Model untuk lokasi di BMKG
class BmkgLocation {
  final String kotkab;
  final String provinsi;
  final String adm4;
  final List<WeatherTimeseries> timeseries;

  BmkgLocation({
    required this.kotkab,
    required this.provinsi,
    required this.adm4,
    required this.timeseries,
  });

  factory BmkgLocation.fromJson(Map<String, dynamic> json) {
    return BmkgLocation(
      kotkab: json['kotkab'] as String? ?? 'Unknown',
      provinsi: json['provinsi'] as String? ?? 'Unknown',
      adm4: json['adm4'] as String? ?? '',
      timeseries: (json['timeseries'] as List<dynamic>?)
              ?.map((e) => WeatherTimeseries.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Model untuk data cuaca per waktu/jam
class WeatherTimeseries {
  final DateTime datetime;
  final int? t; // Temperatur (°C)
  final int? tmax; // Suhu maksimal (°C)
  final int? tmin; // Suhu minimal (°C)
  final int? hu; // Kelembapan relatif (%)
  final String? wsws; // Kecepatan angin (m/s)
  final String? wd; // Arah angin (derajat: 0-360)
  final String? weather; // Kondisi cuaca (kode: 0=cerah, 1=cerah berawan, etc)
  final String? weatherDesc; // Deskripsi cuaca
  final String? image; // URL gambar (opsional)
  final int? pp; // Probabilitas curah hujan (%)

  WeatherTimeseries({
    required this.datetime,
    this.t,
    this.tmax,
    this.tmin,
    this.hu,
    this.wsws,
    this.wd,
    this.weather,
    this.weatherDesc,
    this.image,
    this.pp,
  });

  factory WeatherTimeseries.fromJson(Map<String, dynamic> json) {
    return WeatherTimeseries(
      datetime: DateTime.parse(json['datetime'] as String? ?? ''),
      t: json['t'] as int?,
      tmax: json['tmax'] as int?,
      tmin: json['tmin'] as int?,
      hu: json['hu'] as int?,
      wsws: json['wsws'] as String?,
      wd: json['wd'] as String?,
      weather: json['weather'] as String?,
      weatherDesc: json['weather_desc'] as String?,
      image: json['image'] as String?,
      pp: json['pp'] as int?,
    );
  }

  /// Mapping kode cuaca BMKG ke deskripsi dan emoji
  String getWeatherDescription() {
    if (weatherDesc != null && weatherDesc!.isNotEmpty) {
      return weatherDesc!;
    }

    final code = weather ?? '0';
    const weatherMap = {
      '0': 'Cerah',
      '1': 'Cerah Berawan',
      '2': 'Berawan',
      '3': 'Berawan Tebal',
      '4': 'Hujan Ringan',
      '5': 'Hujan Sedang',
      '10': 'Hujan Lebat',
      '45': 'Hujan Lokal',
      '60': 'Hujan es',
      '61': 'Hujan Es Ringan',
      '63': 'Hujan Es Sedang',
      '80': 'Hujan Ringan dan Hujan Es',
      '81': 'Hujan Sedang dan Hujan Es',
    };

    return weatherMap[code] ?? 'Unknown';
  }

  /// Get emoji berdasarkan kondisi cuaca
  String getWeatherEmoji() {
    final code = weather ?? '0';
    const emojiMap = {
      '0': '☀️',
      '1': '🌤️',
      '2': '⛅',
      '3': '☁️',
      '4': '🌧️',
      '5': '🌦️',
      '10': '⛈️',
      '45': '🌧️',
      '60': '🧊',
      '61': '🧊',
      '63': '🧊',
      '80': '🌧️',
      '81': '⛈️',
    };

    return emojiMap[code] ?? '🌫️';
  }

  /// Get wind speed as double
  double getWindSpeed() {
    if (wsws == null) return 0.0;
    return double.tryParse(wsws!) ?? 0.0;
  }
}

/// Model untuk prakiraan harian
class DailyForecast {
  final DateTime date;
  final int? tmax;
  final int? tmin;
  final String? condition;
  final int? rainChance;
  final String emoji;

  DailyForecast({
    required this.date,
    this.tmax,
    this.tmin,
    this.condition,
    this.rainChance,
    required this.emoji,
  });
}

/// Model untuk state saat ini
class CurrentWeather {
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String emoji;
  final DateTime lastUpdate;

  CurrentWeather({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.emoji,
    required this.lastUpdate,
  });
}
