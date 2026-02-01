# 📱 Dashboard Cuaca Modern - Dokumentasi Lengkap

## 📋 Daftar Isi
1. [Overview](#overview)
2. [Struktur Project](#struktur-project)
3. [Konfigurasi & Setup](#konfigurasi--setup)
4. [Alur Aplikasi](#alur-aplikasi)
5. [API Endpoints](#api-endpoints)
6. [Model Data](#model-data)
7. [State Management](#state-management)
8. [Komponen UI](#komponen-ui)
9. [Fitur Utama](#fitur-utama)
10. [Troubleshooting](#troubleshooting)

---

## Overview

Dashboard Cuaca Modern adalah aplikasi Flutter yang menampilkan prakiraan cuaca real-time berdasarkan lokasi GPS pengguna menggunakan API BMKG (Badan Meteorologi, Klimatologi dan Geofisika Indonesia).

### Fitur Utama:
- ✅ Deteksi lokasi GPS otomatis
- ✅ Cuaca real-time dengan detail lengkap
- ✅ Prakiraan per jam (12 jam ke depan)
- ✅ Prakiraan harian (7 hari)
- ✅ Auto refresh setiap 20 menit
- ✅ Pull-to-refresh manual
- ✅ Mode gelap/terang
- ✅ Loading skeleton shimmer
- ✅ Error handling yang baik
- ✅ Permission management

---

## Struktur Project

```
lib/
├── main.dart                          # Entry point dengan Provider setup
├── splashscreen_page.dart             # Splash screen dengan init
├── models/
│   └── weather_model.dart             # Model data BMKG
├── services/
│   ├── weather_service.dart           # API BMKG service & parser
│   └── location_service.dart          # GPS location service
├── providers/
│   └── weather_provider.dart          # State management (Provider)
├── widgets/
│   ├── loading_skeleton.dart          # Shimmer loading UI
│   ├── weather_cards.dart             # Komponen weather cards
│   └── error_states.dart              # Error & permission UI
└── ui/
    └── Dashboard_page.dart            # Main dashboard page
```

---

## Konfigurasi & Setup

### 1. Instalasi Dependencies

```bash
flutter pub get
```

Dependencies yang dibutuhkan:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  http: ^1.1.0                  # HTTP client
  geolocator: ^10.1.0           # GPS location
  provider: ^6.1.0              # State management
  intl: ^0.19.0                 # Lokalisasi tanggal
  dio: ^5.3.1                   # HTTP client (advanced)
```

### 2. Konfigurasi Permission (Android)

**File: `android/app/src/main/AndroidManifest.xml`**

```xml
<!-- Lokasi permission -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- Internet permission -->
<uses-permission android:name="android.permission.INTERNET" />
```

### 3. Konfigurasi Permission (iOS)

**File: `ios/Runner/Info.plist`**

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi ini membutuhkan akses lokasi untuk menampilkan prakiraan cuaca yang akurat.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Aplikasi ini membutuhkan akses lokasi untuk menampilkan prakiraan cuaca yang akurat.</string>
```

---

## Alur Aplikasi

### Pseudocode Alur Utama:

```
1. APP START
   └─> main.dart: Run MyApp dengan Provider setup
       └─> MultiProvider: WeatherProvider instance
           └─> Consumer<WeatherProvider>: Build dengan dark mode theme
               └─> SplashScreenPage

2. SPLASH SCREEN
   └─> initState()
       └─> WeatherProvider.initialize()
           ├─> [1] Request Location Permission
           │   └─> Check: Denied? → Show LocationDeniedWidget
           │   └─> Check: DeniedForever? → Show LocationDeniedWidget + Open Settings
           │   └─> Check: Disabled? → Show LocationDisabledWidget
           │
           ├─> [2] Get GPS Location
           │   └─> Geolocator.getCurrentPosition()
           │   └─> Result: Position(latitude, longitude)
           │
           ├─> [3] Map Location to ADM4
           │   └─> WeatherService.mapLocationToAdm4(lat, lon)
           │   └─> Result: String (e.g., "31.71.03.1001")
           │   └─> Fallback: "31.71.03.1001" (Jakarta)
           │
           ├─> [4] Fetch Weather Data
           │   └─> WeatherService.getWeatherForecast(adm4)
           │   └─> API Call: https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=...
           │   └─> Parse Response: BmkgWeatherResponse
           │
           ├─> [5] Parse & Process Data
           │   ├─> Get Current Weather
           │   ├─> Extract Hourly Forecasts (12 jam)
           │   └─> Extract Daily Forecasts (7 hari)
           │
           └─> [6] Update State
               └─> notifyListeners()
                   └─> state = WeatherState.loaded

3. DASHBOARD DISPLAY
   └─> _buildBody() berdasarkan WeatherState
       ├─> LOADING: Tampilkan DashboardLoadingSkeleton
       ├─> LOADED: Tampilkan Dashboard Utama
       │   ├─> CurrentWeatherCard
       │   ├─> HourlyForecastCard (horizontal list)
       │   └─> DailyForecastCard (vertical list)
       │
       ├─> LOCATION_DENIED: Tampilkan LocationDeniedWidget
       ├─> LOCATION_DISABLED: Tampilkan LocationDisabledWidget
       └─> ERROR: Tampilkan ErrorWidget

4. USER INTERACTIONS
   ├─> Refresh Button → refreshWeather()
   ├─> Pull-to-Refresh → refreshWeather()
   ├─> Dark Mode Toggle → toggleDarkMode()
   ├─> Enable Location → requestLocationPermission()
   ├─> Open Settings → openLocationSettings() / openAppSettings()
   └─> Auto Refresh: Timer 20 menit → refreshWeather()
```

---

## API Endpoints

### BMKG API

**Base URL:** `https://api.bmkg.go.id/publik/prakiraan-cuaca`

### Request

```
GET https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001
```

### Query Parameters

| Parameter | Type   | Required | Contoh           | Keterangan                        |
|-----------|--------|----------|------------------|----------------------------------|
| adm4      | string | Yes      | 31.71.03.1001    | Kode administrative level 4 BMKG |

### Response Sukses (200)

```json
{
  "status": "success",
  "data": [
    {
      "kotkab": "Jakarta Selatan",
      "provinsi": "DKI Jakarta",
      "adm4": "31.71.03.1001",
      "timeseries": [
        {
          "datetime": "2024-02-01T00:00:00+00:00",
          "t": 28,
          "tmax": 29,
          "tmin": 26,
          "hu": 75,
          "wsws": "3.5",
          "wd": "180",
          "weather": "1",
          "weather_desc": "Cerah Berawan",
          "image": "image01s.jpg",
          "pp": 0
        },
        {
          "datetime": "2024-02-01T01:00:00+00:00",
          "t": 26,
          "tmax": 28,
          "tmin": 24,
          "hu": 80,
          "wsws": "2.8",
          "wd": "200",
          "weather": "3",
          "weather_desc": "Berawan Tebal",
          "image": "image03s.jpg",
          "pp": 10
        }
        // ... more data
      ]
    }
  ]
}
```

---

## Model Data

### 1. BmkgWeatherResponse

```dart
class BmkgWeatherResponse {
  final String status;
  final List<BmkgLocation> data;
  
  // Parsing dari JSON
  factory BmkgWeatherResponse.fromJson(Map<String, dynamic> json)
}
```

### 2. BmkgLocation

```dart
class BmkgLocation {
  final String kotkab;          // Nama kota/kabupaten
  final String provinsi;        // Nama provinsi
  final String adm4;            // Kode administrative level 4
  final List<WeatherTimeseries> timeseries;
}
```

### 3. WeatherTimeseries

```dart
class WeatherTimeseries {
  final DateTime datetime;      // Waktu data
  final int? t;                 // Temperatur (°C)
  final int? tmax;              // Suhu maksimal (°C)
  final int? tmin;              // Suhu minimal (°C)
  final int? hu;                // Kelembapan (%)
  final String? wsws;           // Kecepatan angin (m/s)
  final String? wd;             // Arah angin (derajat)
  final String? weather;        // Kode cuaca
  final String? weatherDesc;    // Deskripsi cuaca
  final String? image;          // URL image
  final int? pp;                // Peluang hujan (%)
  
  // Helper methods
  String getWeatherDescription()
  String getWeatherEmoji()
  double getWindSpeed()
}
```

### 4. CurrentWeather

```dart
class CurrentWeather {
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String emoji;
  final DateTime lastUpdate;
}
```

### 5. DailyForecast

```dart
class DailyForecast {
  final DateTime date;
  final int? tmax;              // Suhu maksimal harian
  final int? tmin;              // Suhu minimal harian
  final String? condition;      // Kondisi cuaca
  final int? rainChance;        // Peluang hujan (%)
  final String emoji;
}
```

---

## State Management

### WeatherProvider (Provider Pattern)

**File:** `lib/providers/weather_provider.dart`

#### States

```dart
enum WeatherState {
  initial,           // Initial state
  loading,           // Loading data
  loaded,            // Data loaded successfully
  error,             // Error occurred
  locationDenied,    // Location permission denied
  locationDisabled   // Location service disabled
}
```

#### Key Methods

```dart
// Initialize dan load weather
Future<void> initialize()

// Fetch weather dari BMKG
Future<void> fetchWeather(String adm4)

// Refresh weather data
Future<void> refreshWeather()

// Toggle dark mode
void toggleDarkMode()

// Request location permission
Future<void> requestLocationPermission()

// Open location settings
Future<void> openLocationSettings()

// Open app settings
Future<void> openAppSettings()
```

#### Getters

```dart
WeatherState get state
String get errorMessage
BmkgLocation? get weatherData
CurrentWeather? get currentWeather
List<WeatherTimeseries> get hourlyForecasts
List<DailyForecast> get dailyForecasts
String get cityName
bool get isDarkMode
DateTime? get lastUpdate
Position? get currentPosition
```

---

## Komponen UI

### 1. DashboardLoadingSkeleton

Loading placeholder dengan shimmer animation.

```dart
DashboardLoadingSkeleton()
```

### 2. CurrentWeatherCard

Card utama untuk cuaca saat ini.

```dart
CurrentWeatherCard(
  weatherData: currentWeather,
  cityName: 'Jakarta Selatan, DKI Jakarta',
  lastUpdate: DateTime.now(),
  onRefresh: () => provider.refreshWeather(),
  isDarkMode: false,
)
```

### 3. HourlyForecastCard

Card individual untuk prakiraan per jam.

```dart
HourlyForecastCard(
  forecast: weatherTimeseries,
  isDarkMode: false,
)
```

### 4. DailyForecastCard

Card individual untuk prakiraan harian.

```dart
DailyForecastCard(
  forecast: dailyForecast,
  isDarkMode: false,
)
```

### 5. LocationDeniedWidget

UI ketika izin lokasi ditolak.

```dart
LocationDeniedWidget(
  isDarkMode: false,
  onRequestPermission: () { /* handle */ },
  onOpenSettings: () { /* handle */ },
)
```

### 6. LocationDisabledWidget

UI ketika GPS disabled.

```dart
LocationDisabledWidget(
  isDarkMode: false,
  onEnableLocation: () { /* handle */ },
)
```

### 7. ErrorWidget

UI ketika terjadi error.

```dart
ErrorWidget(
  isDarkMode: false,
  errorMessage: 'Gagal mengambil data cuaca',
  onRetry: () { /* handle */ },
)
```

---

## Fitur Utama

### 1. Auto Refresh

**Interval:** 20 menit

```dart
_autoRefreshTimer = Timer.periodic(
  const Duration(minutes: 20),
  (_) {
    context.read<WeatherProvider>().refreshWeather();
  },
);
```

### 2. Pull-to-Refresh

```dart
RefreshIndicator(
  onRefresh: () => weatherProvider.refreshWeather(),
  child: ListView(...)
)
```

### 3. Dark Mode

```dart
// Toggle
weatherProvider.toggleDarkMode()

// Use in UI
ThemeData(
  brightness: Brightness.light,
  // ...
)
```

### 4. Location Mapping

Mapping koordinat GPS ke ADM4 BMKG:

```dart
static String mapLocationToAdm4(double latitude, double longitude) {
  // Jakarta (-6.2, 106.8)
  if (latitude > -6.5 && latitude < -5.5 && 
      longitude > 106.5 && longitude < 107.0) {
    return '31.71.03.1001';
  }
  
  // Default
  return '31.71.03.1001';
}
```

### 5. Weather Code Mapping

```dart
const weatherMap = {
  '0': 'Cerah',
  '1': 'Cerah Berawan',
  '2': 'Berawan',
  '3': 'Berawan Tebal',
  '4': 'Hujan Ringan',
  '5': 'Hujan Sedang',
  '10': 'Hujan Lebat',
  // ... more
};

const emojiMap = {
  '0': '☀️',
  '1': '🌤️',
  '2': '⛅',
  '3': '☁️',
  '4': '🌧️',
  // ... more
};
```

---

## Troubleshooting

### Issue: "Failed to get location"

**Penyebab:**
- Permission belum diberikan
- GPS disabled di perangkat
- Timeout koneksi

**Solusi:**
```dart
// Pastikan permission sudah granted
final permission = await Geolocator.checkPermission();
if (permission == LocationPermission.granted) {
  // Get location
}

// Buka location settings
await Geolocator.openLocationSettings();
```

### Issue: "API returns empty data"

**Penyebab:**
- ADM4 code tidak valid
- API sedang maintenance
- Network error

**Solusi:**
```dart
// Check response data
if (response.data.isEmpty) {
  // Handle empty data
}

// Use fallback adm4
final adm4 = '31.71.03.1001'; // Jakarta default
```

### Issue: "Date tidak ter-lokalisasi (masih Inggris)"

**Solusi:**

Tambahkan localization package:

```yaml
dependencies:
  intl: ^0.19.0
```

Gunakan:
```dart
final dateFormat = DateFormat('EEE, d MMMM yyyy', 'id_ID');
```

### Issue: "Dark mode tidak berubah setelah restart"

**Solusi:** Implementasikan SharedPreferences untuk persist state:

```dart
import 'package:shared_preferences/shared_preferences.dart';

void toggleDarkMode() {
  _isDarkMode = !_isDarkMode;
  
  // Save preference
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', _isDarkMode);
  
  notifyListeners();
}
```

---

## Development Tips

### 1. Testing API Response

Gunakan Postman atau curl:

```bash
curl "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001"
```

### 2. Mock Location untuk Testing

Gunakan Flutter DevTools atau emulator:

```bash
flutter run --dart-define=LOCATION_LAT=-6.2 --dart-define=LOCATION_LON=106.8
```

### 3. Debug Permission Issues

```dart
final permission = await Geolocator.checkPermission();
print('Permission: $permission');

final serviceEnabled = await Geolocator.isLocationServiceEnabled();
print('Service Enabled: $serviceEnabled');
```

### 4. Log API Responses

```dart
Future<BmkgWeatherResponse?> getWeatherForecast({
  String adm4 = '31.71.03.1001',
}) async {
  try {
    final response = await _dio.get(
      baseUrl,
      queryParameters: {'adm4': adm4},
    );
    
    print('Response: ${response.data}');
    // ... rest of code
  }
}
```

---

## Performance Optimization

1. **Lazy Load Data**: Load hourly & daily forecasts hanya saat diperlukan
2. **Cache Response**: Simpan data dalam SharedPreferences
3. **Optimize Images**: Gunakan cached network image
4. **Reduce API Calls**: Auto refresh setiap 20 menit, bukan lebih sering
5. **Memory Management**: Dispose timer saat widget dispose

---

## Next Steps untuk Enhancement

- [ ] Add Notification untuk cuaca ekstrem
- [ ] Multi-location support
- [ ] Weather alerts & warnings
- [ ] Historical weather data
- [ ] Rainfall prediction graph
- [ ] UV index display
- [ ] Air quality index
- [ ] Sunset/sunrise time
- [ ] Share weather status

---

**Dibuat:** 2024
**Last Updated:** February 1, 2026
**License:** MIT
