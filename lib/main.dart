import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_report/providers/weather_provider.dart';
import 'package:weather_report/splashscreen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cuaca Lokal',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                surfaceTintColor: Colors.transparent,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
              ),
              scaffoldBackgroundColor: Colors.grey[900],
            ),
            themeMode: weatherProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreenPage(),
            localizationsDelegates: const [],
          );
        },
      ),
    );
  }
}
