import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_report/providers/weather_provider.dart';
import 'package:weather_report/widgets/loading_skeleton.dart';
import 'package:weather_report/widgets/weather_cards.dart';
import 'package:weather_report/widgets/error_states.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Timer _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _setupAutoRefresh();
  }

  void _setupAutoRefresh() {
    // Auto refresh setiap 20 menit
    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 20),
      (_) {
        if (mounted) {
          context.read<WeatherProvider>().refreshWeather();
        }
      },
    );
  }

  @override
  void dispose() {
    _autoRefreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: _buildBody(context, weatherProvider),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor:
                weatherProvider.isDarkMode ? Colors.grey[900] : Colors.white,
            title: const Text('Cuaca Lokal'),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Tooltip(
                    message: weatherProvider.isDarkMode ? 'Mode Terang' : 'Mode Gelap',
                    child: IconButton(
                      icon: Icon(
                        weatherProvider.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      onPressed: () {
                        weatherProvider.toggleDarkMode();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider weatherProvider) {
    switch (weatherProvider.state) {
      case WeatherState.initial:
      case WeatherState.loading:
        return const DashboardLoadingSkeleton();

      case WeatherState.loaded:
        return _buildDashboard(context, weatherProvider);

      case WeatherState.locationDenied:
        return LocationDeniedWidget(
          isDarkMode: weatherProvider.isDarkMode,
          onRequestPermission: () {
            weatherProvider.requestLocationPermission();
          },
          onOpenSettings: () {
            weatherProvider.openAppSettings();
          },
        );

      case WeatherState.locationDisabled:
        return LocationDisabledWidget(
          isDarkMode: weatherProvider.isDarkMode,
          onEnableLocation: () {
            weatherProvider.openLocationSettings();
          },
        );

      case WeatherState.error:
        return ErrorWidget(
          isDarkMode: weatherProvider.isDarkMode,
          errorMessage: weatherProvider.errorMessage,
          onRetry: () {
            weatherProvider.initialize();
          },
        );
    }
  }

  Widget _buildDashboard(BuildContext context, WeatherProvider weatherProvider) {
    return RefreshIndicator(
      onRefresh: () => weatherProvider.refreshWeather(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Weather Card
          if (weatherProvider.currentWeather != null &&
              weatherProvider.lastUpdate != null)
            CurrentWeatherCard(
              weatherData: weatherProvider.currentWeather!,
              cityName: weatherProvider.cityName,
              lastUpdate: weatherProvider.lastUpdate!,
              onRefresh: () {
                weatherProvider.refreshWeather();
              },
              isDarkMode: weatherProvider.isDarkMode,
            ),
          const SizedBox(height: 24),

          // Prakiraan Per Jam
          if (weatherProvider.hourlyForecasts.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Prakiraan Berikutnya (12 Jam)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weatherProvider.hourlyForecasts.length,
                    itemBuilder: (context, index) {
                      final forecast = weatherProvider.hourlyForecasts[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: HourlyForecastCard(
                          forecast: forecast,
                          isDarkMode: weatherProvider.isDarkMode,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),

          // Prakiraan Harian
          if (weatherProvider.dailyForecasts.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Prakiraan 7 Hari',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: weatherProvider.dailyForecasts.length,
                  itemBuilder: (context, index) {
                    final forecast = weatherProvider.dailyForecasts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DailyForecastCard(
                        forecast: forecast,
                        isDarkMode: weatherProvider.isDarkMode,
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
