import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_report/models/weather_model.dart';

/// Card untuk cuaca saat ini
class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather weatherData;
  final String cityName;
  final DateTime lastUpdate;
  final VoidCallback onRefresh;
  final bool isDarkMode;

  const CurrentWeatherCard({
    Key? key,
    required this.weatherData,
    required this.cityName,
    required this.lastUpdate,
    required this.onRefresh,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.blue[900]!, Colors.blue[700]!]
              : [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header dengan location dan update time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Update: ${timeFormat.format(lastUpdate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onRefresh,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Cuaca emoji dan suhu
          Text(
            weatherData.emoji,
            style: const TextStyle(fontSize: 60),
          ),
          const SizedBox(height: 12),
          Text(
            '${weatherData.temperature.toStringAsFixed(0)}°C',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weatherData.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Weather details (humidity, wind speed)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherDetailItem(
                  icon: Icons.opacity,
                  label: 'Kelembapan',
                  value: '${weatherData.humidity}%',
                ),
                _WeatherDetailItem(
                  icon: Icons.air,
                  label: 'Angin',
                  value: '${weatherData.windSpeed.toStringAsFixed(1)} m/s',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            dateFormat.format(lastUpdate),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item detail cuaca
class _WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Card untuk prakiraan per jam
class HourlyForecastCard extends StatelessWidget {
  final WeatherTimeseries forecast;
  final bool isDarkMode;

  const HourlyForecastCard({
    Key? key,
    required this.forecast,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hourFormat = DateFormat('HH:mm');

    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            hourFormat.format(forecast.datetime),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Text(
            forecast.getWeatherEmoji(),
            style: const TextStyle(fontSize: 28),
          ),
          Text(
            '${forecast.t}°C',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card untuk prakiraan harian
class DailyForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final bool isDarkMode;

  const DailyForecastCard({
    Key? key,
    required this.forecast,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM', 'id_ID');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          // Tanggal
          Expanded(
            flex: 2,
            child: Text(
              dateFormat.format(forecast.date),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Emoji
          Text(
            forecast.emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 8),

          // Kondisi
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forecast.condition ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (forecast.rainChance != null)
                  Text(
                    'Hujan: ${forecast.rainChance}%',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? Colors.cyan : Colors.blue,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Suhu min/max
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${forecast.tmax}°C',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.red[300] : Colors.red,
                  ),
                ),
                Text(
                  '${forecast.tmin}°C',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.blue[300] : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
