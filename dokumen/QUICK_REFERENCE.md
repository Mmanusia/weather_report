# ⚡ QUICK REFERENCE - Dashboard Cuaca Modern

## 📌 Start Here (90 detik)

### Install & Run

```bash
cd weather_report
flutter pub get
flutter run
```

### What You Get

✅ Real-time weather  
✅ 12-hour forecast  
✅ 7-day forecast  
✅ Dark mode  
✅ Auto refresh  
✅ GPS location

---

## 🎯 Key Files

| File                                  | Purpose      | Edit For                   |
| ------------------------------------- | ------------ | -------------------------- |
| `lib/main.dart`                       | App entry    | Theme, Provider setup      |
| `lib/providers/weather_provider.dart` | State        | Logic, refresh interval    |
| `lib/services/weather_service.dart`   | API          | Default location, mappings |
| `lib/ui/Dashboard_page.dart`          | Dashboard    | UI layout, colors          |
| `pubspec.yaml`                        | Dependencies | Add packages               |

---

## 📊 API Endpoint

```
https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001
```

**ADM4 Codes:**

- Jakarta: `31.71.03.1001`
- Bandung: `32.73.01.1001`
- Surabaya: `35.78.05.1001`
- Medan: `12.71.03.1001`
- Yogyakarta: `34.55.02.1001`

---

## 🔧 Common Changes

### Change Auto Refresh (20 min → 30 min)

```dart
// lib/ui/Dashboard_page.dart, line ~50
_autoRefreshTimer = Timer.periodic(
  const Duration(minutes: 30), // ← Change here
  (_) { ... }
);
```

### Change Default Location

```dart
// lib/services/weather_service.dart, line ~35
return '31.71.03.1001'; // ← Change ADM4 code here
```

### Change Timeout (10s → 20s)

```dart
// lib/services/weather_service.dart, line ~12
const Duration(seconds: 20), // ← Increase timeout
```

### Change Colors (Dark mode)

```dart
// lib/main.dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue, // ← Change seed color
  brightness: Brightness.dark,
),
```

---

## 📱 Responsive Breakpoints

```
Phone:  320-480px   (Single column)
Tablet: 600-1200px  (2 columns optional)
Desktop: >1200px    (Full width)
```

---

## 🌤️ Weather Codes

```
0:☀️ 1:🌤️ 2:⛅ 3:☁️ 4:🌧️ 5:🌦️ 10:⛈️
```

---

## 🔐 Permissions

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (Info.plist)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Lokasi diperlukan untuk prakiraan cuaca.</string>
```

---

## 📚 Docs Quick Links

```
README.md                 → Start here (5 min)
IMPLEMENTATION_SUMMARY.md → What's done (10 min)
API_EXAMPLES.md          → API reference (15 min)
ARCHITECTURE.md          → Design (20 min)
DOCUMENTATION.md         → Full guide (30 min)
SETUP_GUIDE.md          → Build/release (20 min)
TESTING_CHECKLIST.md    → QA (15 min)
INDEX.md                → Navigation (5 min)
```

---

## 🧪 Quick Test

```bash
# Run tests
flutter test

# Debug build
flutter run --verbose

# Profile build
flutter run --profile

# Release build
flutter build apk --release
```

---

## 🐛 Debug Tips

```dart
// Check permission
final perm = await Geolocator.checkPermission();
print('Permission: $perm');

// Check service
final enabled = await Geolocator.isLocationServiceEnabled();
print('Service enabled: $enabled');

// Get position
final pos = await Geolocator.getCurrentPosition();
print('Lat: ${pos.latitude}, Lon: ${pos.longitude}');

// Call API direct
final response = await WeatherService().getWeatherForecast();
print('Response: $response');
```

---

## ⚙️ Configuration

### Environment Variables (Optional)

```dart
// lib/config/environment.dart
class Environment {
  static const String apiUrl = 'https://api.bmkg.go.id/publik/prakiraan-cuaca';
  static const int apiTimeout = 10;
  static const int refreshMinutes = 20;
  static const String defaultAdm4 = '31.71.03.1001';
}
```

### SharedPreferences (For Persistence)

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('isDarkMode', true);
final isDarkMode = prefs.getBool('isDarkMode') ?? false;
```

---

## 🚀 Build & Release

### Android APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS IPA

```bash
flutter build ios --release
# Output: build/ios/iphoneos/Runner.app
```

### Web

```bash
flutter build web --release
# Output: build/web/
```

---

## 📦 Dependencies

```yaml
provider: ^6.1.0 # State management
geolocator: ^10.1.0 # Location
dio: ^5.3.1 # HTTP client
intl: ^0.19.0 # Localization
http: ^1.1.0 # HTTP
```

---

## 🎯 State Enum

```dart
enum WeatherState {
  initial,           // Loading
  loading,           // Getting data
  loaded,            // Success ✓
  error,             // Failed ✗
  locationDenied,    // Permission denied
  locationDisabled   // GPS off
}
```

---

## 🔄 Data Models

```dart
BmkgWeatherResponse
  └─ data: List<BmkgLocation>
      └─ BmkgLocation
          ├─ kotkab: String
          ├─ provinsi: String
          └─ timeseries: List<WeatherTimeseries>
              └─ WeatherTimeseries
                  ├─ t: int? (temp)
                  ├─ hu: int? (humidity)
                  ├─ weather: String (code)
                  └─ weather_desc: String

CurrentWeather
  ├─ temperature: double
  ├─ humidity: int
  ├─ windSpeed: double
  └─ emoji: String

DailyForecast
  ├─ date: DateTime
  ├─ tmax: int?
  ├─ tmin: int?
  └─ rainChance: int?
```

---

## 🎨 Color Scheme

### Light Mode

```
Primary: Colors.blue[400-600]
Background: Colors.white
Text: Colors.black
Card: Colors.grey[100]
```

### Dark Mode

```
Primary: Colors.blue[700-900]
Background: Colors.grey[900]
Text: Colors.white
Card: Colors.grey[800]
```

---

## 📈 Performance Targets

| Metric         | Target  |
| -------------- | ------- |
| Startup        | < 3s    |
| Dashboard load | < 1s    |
| API response   | < 2s    |
| Scroll FPS     | >= 60   |
| Memory         | < 100MB |

---

## ✅ Pre-Launch Checklist

```
Code:
- [ ] No errors/warnings
- [ ] All imports correct
- [ ] Null safety verified

Config:
- [ ] Manifest permissions OK
- [ ] iOS plist OK
- [ ] Version updated
- [ ] Build number incremented

Testing:
- [ ] Location working
- [ ] API returning data
- [ ] UI renders correctly
- [ ] Dark mode works
- [ ] Refresh working

Build:
- [ ] APK builds successfully
- [ ] IPA builds successfully
- [ ] No signing errors
- [ ] Output files exist
```

---

## 🆘 Quick Troubleshoot

| Issue             | Fix                              |
| ----------------- | -------------------------------- |
| Location null     | Check GPS + permission           |
| API timeout       | Increase timeout duration        |
| Pod errors        | `rm -rf ios/Pods && pod install` |
| Hot reload fail   | `flutter clean && flutter run`   |
| Dark mode missing | Check `main.dart` theme setup    |

---

## 🔗 Useful Links

- [BMKG API](https://api.bmkg.go.id)
- [Flutter Docs](https://flutter.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [Geolocator](https://pub.dev/packages/geolocator)

---

## 💡 Tips & Tricks

### Faster Development

```bash
flutter run -d all              # Run on all devices
flutter run --hot               # Hot reload
flutter run --verbose          # Debug output
```

### Optimize Build

```bash
flutter clean
flutter pub get
flutter run --release
```

### Test Specific Feature

```bash
flutter test test/services/weather_service_test.dart
```

### Profile Performance

```bash
flutter run --profile
# Open DevTools: http://localhost:8888
```

---

## 📋 File Checklist

```
lib/
├── ✅ main.dart
├── ✅ splashscreen_page.dart
├── ✅ models/weather_model.dart
├── ✅ services/weather_service.dart
├── ✅ services/location_service.dart
├── ✅ providers/weather_provider.dart
├── ✅ widgets/loading_skeleton.dart
├── ✅ widgets/weather_cards.dart
├── ✅ widgets/error_states.dart
└── ✅ ui/Dashboard_page.dart

pubspec.yaml ✅
AndroidManifest.xml ✅
Info.plist ✅
```

---

## 🎓 Learning Path

1. **Run** app locally → Explore UI
2. **Read** README.md → Understand basics
3. **Study** ARCHITECTURE.md → Learn design
4. **Modify** code → Add features
5. **Test** thoroughly → Verify working
6. **Build** & release → Deploy

---

## 📞 Support

Need help? Check:

1. DOCUMENTATION.md (Troubleshooting section)
2. API_EXAMPLES.md (API issues)
3. SETUP_GUIDE.md (Build issues)
4. TESTING_CHECKLIST.md (Test issues)

---

**Version**: 1.0.0  
**Status**: ✅ Production Ready  
**Last Update**: February 1, 2026

---

👉 **NEXT**: Open `README.md` for full quick start guide!
