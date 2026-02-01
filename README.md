# 🌤️ Dashboard Cuaca Modern - Flutter

Aplikasi cuaca modern berbasis Flutter yang menampilkan prakiraan cuaca real-time menggunakan data dari **API BMKG (Badan Meteorologi, Klimatologi dan Geofisika)**.

## ✨ Fitur Utama

- 📍 **Deteksi Lokasi GPS** - Otomatis mendeteksi lokasi pengguna
- 🌡️ **Cuaca Real-time** - Suhu, kelembapan, kecepatan angin
- ⏰ **Prakiraan Per Jam** - Detail cuaca 12 jam ke depan
- 📅 **Prakiraan 7 Hari** - Prakiraan harian dengan min/max suhu
- 🔄 **Auto Refresh** - Update otomatis setiap 20 menit
- 👆 **Pull-to-Refresh** - Manual refresh dengan gesture
- 🌙 **Mode Gelap/Terang** - Toggle dark mode
- ⚡ **Loading Skeleton** - Shimmer animation saat loading
- ❌ **Error Handling** - Tampilan yang user-friendly untuk error
- 📱 **Responsive Design** - Optimal untuk mobile & tablet

## 🚀 Quick Start

### Prerequisites

- Flutter 3.4.4 atau lebih tinggi
- Dart 3.4.4 atau lebih tinggi
- Android SDK / iOS SDK

### Installation

1. **Clone Repository**

```bash
cd /Users/dewangga/Documents/dio/weather_report
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Configure Android Permissions**

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

4. **Configure iOS Permissions**

Edit `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi membutuhkan akses lokasi untuk menampilkan prakiraan cuaca.</string>
```

5. **Run App**

```bash
flutter run
```

## 📁 Struktur Project

```
lib/
├── main.dart                    # Entry point
├── splashscreen_page.dart       # Splash screen
├── models/
│   └── weather_model.dart       # Data models
├── services/
│   ├── weather_service.dart     # BMKG API service
│   └── location_service.dart    # GPS service
├── providers/
│   └── weather_provider.dart    # State management
├── widgets/
│   ├── loading_skeleton.dart    # Loading UI
│   ├── weather_cards.dart       # Weather components
│   └── error_states.dart        # Error UI
└── ui/
    └── Dashboard_page.dart      # Main dashboard
```

## 🔧 API Integration

### BMKG API Endpoint

```
GET https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001
```

**Response Structure:**

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
          "pp": 0
        }
      ]
    }
  ]
}
```

## 📊 Data Flow

```
GPS Location
    ↓
Map to ADM4 (BMKG Code)
    ↓
Fetch from BMKG API
    ↓
Parse Response
    ↓
Extract Current Weather
    ↓
Extract Hourly Forecasts (12h)
    ↓
Extract Daily Forecasts (7d)
    ↓
Display on Dashboard
```

## 🎨 UI Components

### 1. CurrentWeatherCard

Menampilkan cuaca saat ini dengan detail lengkap

### 2. HourlyForecastCard

Prakiraan per jam dalam horizontal scroll

### 3. DailyForecastCard

Prakiraan harian dalam vertical list

### 4. Error States

- LocationDeniedWidget
- LocationDisabledWidget
- ErrorWidget

## 🌡️ Weather Codes Mapping

| Kode | Deskripsi     | Emoji |
| ---- | ------------- | ----- |
| 0    | Cerah         | ☀️    |
| 1    | Cerah Berawan | 🌤️    |
| 2    | Berawan       | ⛅    |
| 3    | Berawan Tebal | ☁️    |
| 4    | Hujan Ringan  | 🌧️    |
| 5    | Hujan Sedang  | 🌦️    |
| 10   | Hujan Lebat   | ⛈️    |

## 🔐 Permissions

### Android

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Description</string>
```

## 📱 Responsiveness

Aplikasi dioptimalkan untuk:

- Phone (320px - 480px)
- Tablet (600px - 1200px)
- Desktop (1200px+)

## ⚙️ State Management

Menggunakan **Provider** untuk state management yang simple namun powerful.

```dart
Consumer<WeatherProvider>(
  builder: (context, weatherProvider, _) {
    // Build UI based on state
  }
)
```

## 🔄 Auto Refresh

- **Interval:** 20 menit
- **Trigger:** Automatic setiap 20 menit
- **Manual:** Pull-to-refresh, tombol refresh

## 🌙 Dark Mode

Toggle dengan button di AppBar. Tema berubah berdasarkan:

- Current system theme
- User preference

## 🐛 Troubleshooting

### Location Permission Error

```
Solusi: Check Android/iOS manifest, request permission explicitly
```

### API Connection Error

```
Solusi: Check internet connection, verify API endpoint
```

### Date Localization

```
Solusi: Gunakan intl package dengan locale 'id_ID'
```

## 📦 Dependencies

```yaml
- flutter (SDK)
- http: ^1.1.0
- geolocator: ^10.1.0
- provider: ^6.1.0
- intl: ^0.19.0
- dio: ^5.3.1
```

## 📝 Development

### Run Development

```bash
flutter run
```

### Build Release (Android)

```bash
flutter build apk --release
```

### Build Release (iOS)

```bash
flutter build ios --release
```

## 📚 Documentation

Lihat [DOCUMENTATION.md](DOCUMENTATION.md) untuk dokumentasi lengkap, termasuk:

- Detailed API specification
- Model data struktur
- State management detail
- Component documentation
- Troubleshooting guide

## 🎯 Next Steps

- [ ] Add notifications untuk cuaca ekstrem
- [ ] Multi-location support
- [ ] Weather alerts
- [ ] Historical data
- [ ] UV index
- [ ] Air quality
- [ ] Sunrise/sunset time

## 📄 License

MIT License - Lihat LICENSE file

## 👨‍💻 Author

Created with ❤️ for weather enthusiasts

---

**Versi:** 1.0.0  
**Last Updated:** February 1, 2026  
**Status:** Production Ready ✅
