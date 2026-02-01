# ⚙️ Setup & Configuration Guide

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Android Configuration](#android-configuration)
3. [iOS Configuration](#ios-configuration)
4. [Environment Setup](#environment-setup)
5. [Testing & Debugging](#testing--debugging)
6. [Build & Release](#build--release)
7. [Troubleshooting](#troubleshooting)

---

## Initial Setup

### Step 1: Clone/Setup Project

```bash
# Navigate to project directory
cd /Users/dewangga/Documents/dio/weather_report

# Check Flutter version
flutter --version

# Check doctor
flutter doctor
```

### Step 2: Get Dependencies

```bash
# Get all packages
flutter pub get

# (Optional) Upgrade packages
flutter pub upgrade

# (Optional) Upgrade major versions
flutter pub upgrade --major-versions
```

### Step 3: Verify Installation

```bash
# Check if all packages installed
flutter pub get

# List all dependencies
flutter pub deps

# Check for any issues
flutter analyze
```

---

## Android Configuration

### Step 1: Update AndroidManifest.xml

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Location Permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <!-- Internet -->
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:label="Cuaca Lokal"
        android:icon="@mipmap/ic_launcher">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### Step 2: Update build.gradle

**File:** `android/app/build.gradle`

```gradle
android {
    namespace "com.example.weather_report"
    compileSdk 34

    defaultConfig {
        applicationId "com.example.weather_report"
        minSdk 21              // Minimum SDK version
        targetSdk 34           // Target SDK version
        versionCode 1
        versionName "1.0.0"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
}
```

### Step 3: Test on Android Device

```bash
# List connected devices
flutter devices

# Run on device
flutter run

# Run with specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

---

## iOS Configuration

### Step 1: Update Info.plist

**File:** `ios/Runner/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- ... existing keys ... -->

    <!-- Location Usage Descriptions -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Aplikasi membutuhkan akses ke lokasi Anda saat menggunakan aplikasi untuk menampilkan prakiraan cuaca yang akurat.</string>

    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Aplikasi membutuhkan akses ke lokasi Anda untuk menampilkan prakiraan cuaca yang akurat.</string>

    <!-- App Transport Security -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <false/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>api.bmkg.go.id</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
                <true/>
            </dict>
        </dict>
    </key>

</dict>
</plist>
```

### Step 2: Update Podfile (if needed)

**File:** `ios/Podfile`

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

### Step 3: Test on iOS Device

```bash
# List connected iOS devices
flutter devices

# Run on iOS simulator
flutter run -d "iPhone 14"

# Run on iOS device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

---

## Environment Setup

### Using Different Environments

Create environment-specific configuration files:

**File:** `lib/config/environment.dart`

```dart
class Environment {
  static const String apiBaseUrl = 'https://api.bmkg.go.id/publik/prakiraan-cuaca';
  static const int apiTimeout = 10; // seconds
  static const int autoRefreshInterval = 20; // minutes
  static const String defaultAdm4 = '31.71.03.1001'; // Jakarta
}
```

### Using Environment Variables (Optional)

```bash
# Set environment variable
export WEATHER_APP_ENV=production

# Run with env var
flutter run --dart-define=WEATHER_APP_ENV=production
```

### Using .env File (Optional)

Install `flutter_dotenv`:

```yaml
dev_dependencies:
  flutter_dotenv: ^5.1.0
```

**File:** `.env`

```
BMKG_API_URL=https://api.bmkg.go.id/publik/prakiraan-cuaca
API_TIMEOUT=10
AUTO_REFRESH_MINUTES=20
```

---

## Testing & Debugging

### 1. Run Tests

```bash
# Run unit tests
flutter test

# Run specific test
flutter test test/services/weather_service_test.dart

# Run with coverage
flutter test --coverage
```

### 2. Debug Mode

```bash
# Run with debug logs
flutter run --verbose

# Run with debug symbols
flutter run --dart-define=FLAVOR=debug
```

### 3. Performance Monitoring

```bash
# Run with DevTools
flutter run --observatory-port=8888

# Open DevTools
open http://localhost:8888
```

### 4. Device Logs

```bash
# Show device logs
flutter logs

# Filter logs by level
flutter logs --grep "ERROR|WARNING"

# Save logs to file
flutter logs > app_logs.txt
```

### 5. Network Debugging

Use Charles Proxy or Fiddler:

```bash
# Enable proxy
flutter run --proxy=127.0.0.1:8888
```

---

## Build & Release

### Android Release

#### Step 1: Create Keystore

```bash
# Generate keystore
keytool -genkey -v -keystore ~/key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias weather_key

# Or use existing keystore
# Place key.jks in android/ directory
```

#### Step 2: Configure signing

**File:** `android/app/build.gradle`

```gradle
signingConfigs {
    release {
        keyAlias System.getenv("KEYSTORE_ALIAS") ?: "weather_key"
        keyPassword System.getenv("KEYSTORE_PASSWORD")?.toCharArray()
        storeFile file(System.getenv("KEYSTORE_PATH") ?: "key.jks")
        storePassword System.getenv("KEYSTORE_STORE_PASSWORD")?.toCharArray()
    }
}
```

#### Step 3: Build APK

```bash
# Build APK release
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release

# Output location
# APK: build/app/outputs/flutter-apk/app-release.apk
# Bundle: build/app/outputs/bundle/release/app-release.aab
```

### iOS Release

#### Step 1: Update Version

**File:** `ios/Runner.xcodeproj/project.pbxproj`

Or use Xcode:

```
Project > Runner > Build Settings > Versioning
```

#### Step 2: Build IPA

```bash
# Build iOS release
flutter build ios --release

# Output location
# build/ios/iphoneos/Runner.app

# Create IPA manually using Xcode
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner -configuration Release \
  -derivedDataPath build/ios_release \
  -arch arm64 build

# Or use xcrun
cd ios
xcodebuild archive -workspace Runner.xcworkspace \
  -scheme Runner \
  -archivePath ../build/Runner.xcarchive
xcrun xcodebuild -exportArchive \
  -archivePath ../build/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ../build/ipa
```

#### Step 3: Upload to TestFlight/App Store

```bash
# Validate before upload
xcrun altool --validate-app -f build/ipa/Runner.ipa \
  -t ios -u apple_id -p app_password

# Upload to TestFlight
xcrun altool --upload-app -f build/ipa/Runner.ipa \
  -t ios -u apple_id -p app_password
```

### Web Release (Optional)

```bash
# Build web
flutter build web --release

# Output location
# build/web/

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

---

## Troubleshooting

### Issue: "SDK not found"

```bash
# Solution 1: Run flutter doctor
flutter doctor

# Solution 2: Install missing components
flutter pub get

# Solution 3: Check Flutter path
echo $PATH
```

### Issue: "Permission denied" (Android)

```bash
# Check manifest
cat android/app/src/main/AndroidManifest.xml

# Grant permissions via adb
adb shell pm grant com.example.weather_report \
  android.permission.ACCESS_FINE_LOCATION

adb shell pm grant com.example.weather_report \
  android.permission.INTERNET
```

### Issue: "API connection timeout"

```dart
// Increase timeout in WeatherService
final Dio _dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
  ),
);
```

### Issue: "Location always returns null"

```dart
// Debug location
final position = await Geolocator.getCurrentPosition();
print('Lat: ${position.latitude}, Lon: ${position.longitude}');

// Check permission
final permission = await Geolocator.checkPermission();
print('Permission: $permission');

// Check service
final serviceEnabled = await Geolocator.isLocationServiceEnabled();
print('Service enabled: $serviceEnabled');
```

### Issue: "Dark mode not persisting"

```dart
// Add SharedPreferences to persist dark mode
import 'package:shared_preferences/shared_preferences.dart';

// In WeatherProvider
void toggleDarkMode() async {
  _isDarkMode = !_isDarkMode;

  // Persist to SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', _isDarkMode);

  notifyListeners();
}

// Load on init
Future<void> loadDarkMode() async {
  final prefs = await SharedPreferences.getInstance();
  _isDarkMode = prefs.getBool('isDarkMode') ?? false;
  notifyListeners();
}
```

### Issue: "Hot reload not working"

```bash
# Full restart instead
flutter clean

flutter pub get

flutter run
```

### Issue: "Pod install fails" (iOS)

```bash
# Navigate to iOS directory
cd ios

# Remove pods
rm -rf Pods
rm Podfile.lock

# Reinstall
pod install --repo-update

# Go back to root
cd ..

# Run app
flutter run
```

---

## Performance Optimization

### 1. Code Optimization

```dart
// Use const constructors
const Widget(...) instead of Widget(...)

// Lazy load widgets
ListView.builder() instead of ListView()

// Use proper keys
Key key = ValueKey(id)
```

### 2. Build Optimization

```bash
# Remove debug symbols in release
flutter build apk --release --split-debug-info=build/symbols

# Optimize assets
# Compress images before adding to assets/
```

### 3. Runtime Optimization

```dart
// Dispose resources properly
@override
void dispose() {
  _timer.cancel();
  super.dispose();
}

// Use Provider selectors to avoid rebuilds
Selector<WeatherProvider, String>(
  selector: (_, provider) => provider.cityName,
  builder: (_, cityName, __) => Text(cityName),
)
```

---

## CI/CD Setup (Optional)

### GitHub Actions Example

**File:** `.github/workflows/flutter.yml`

```yaml
name: Flutter Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.4.4"

      - name: Get dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## Checklist Before Release

- [ ] All dependencies updated
- [ ] No compilation errors
- [ ] All tests passing
- [ ] Permissions configured (Android & iOS)
- [ ] App icon configured
- [ ] Version number updated
- [ ] Build number incremented
- [ ] Release notes prepared
- [ ] Privacy policy prepared
- [ ] Terms of service prepared
- [ ] App signing configured
- [ ] Beta testing completed
- [ ] Performance tested
- [ ] Battery usage checked
- [ ] Network usage checked
- [ ] Offline mode tested
- [ ] Dark mode tested
- [ ] All screen sizes tested
- [ ] All permissions tested
- [ ] Location permission flow tested

---

**Setup Version:** 1.0  
**Last Updated:** February 1, 2026
