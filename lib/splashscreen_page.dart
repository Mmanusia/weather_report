import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_report/providers/weather_provider.dart';
import 'package:weather_report/ui/Dashboard_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  void _initializeWeather() async {
    // Initialize weather provider
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.initialize();

    // Navigate to dashboard setelah loading selesai
    if (mounted) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[900]!, Colors.blue[900]!]
                : [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weather icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.cloud,
                  size: 60,
                  color: isDarkMode ? Colors.blue[300] : Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App title
            Text(
              'Cuaca Lokal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Prakiraan cuaca real-time',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode ? Colors.blue[300]! : Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Loading text
            Text(
              'Memuat data cuaca...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}