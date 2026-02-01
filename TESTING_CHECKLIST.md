# ✅ Testing & Verification Checklist

## 🧪 Unit Testing

### Services Testing

**Test File:** `test/services/weather_service_test.dart`

```dart
// TODO: Implement these tests
void main() {
  group('WeatherService', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService();
    });

    test('mapLocationToAdm4 returns correct code for Jakarta', () {
      final adm4 = WeatherService.mapLocationToAdm4(-6.2, 106.8);
      expect(adm4, equals('31.71.03.1001'));
    });

    test('mapLocationToAdm4 returns correct code for Bandung', () {
      final adm4 = WeatherService.mapLocationToAdm4(-6.9, 107.6);
      expect(adm4, equals('32.73.01.1001'));
    });

    test('mapLocationToAdm4 returns default for unknown location', () {
      final adm4 = WeatherService.mapLocationToAdm4(0.0, 0.0);
      expect(adm4, isNotEmpty);
    });
  });
}
```

### Models Testing

**Test File:** `test/models/weather_model_test.dart`

```dart
void main() {
  group('WeatherTimeseries', () {
    test('getWeatherEmoji returns correct emoji', () {
      // Test with weather code 0 (Cerah)
      final ts = WeatherTimeseries(
        datetime: DateTime.now(),
        weather: '0',
      );
      expect(ts.getWeatherEmoji(), equals('☀️'));
    });

    test('getWeatherDescription returns correct description', () {
      final ts = WeatherTimeseries(
        datetime: DateTime.now(),
        weather: '1',
        weatherDesc: 'Cerah Berawan',
      );
      expect(ts.getWeatherDescription(), equals('Cerah Berawan'));
    });

    test('getWindSpeed returns parsed double', () {
      final ts = WeatherTimeseries(
        datetime: DateTime.now(),
        wsws: '3.5',
      );
      expect(ts.getWindSpeed(), equals(3.5));
    });
  });
}
```

---

## 📱 Manual Testing

### 1. Location Permission Flow

**Scenario 1: Permission Not Granted**

- [ ] App starts
- [ ] Shows "Lokasi diperlukan"
- [ ] Click "Aktifkan Lokasi"
- [ ] Permission dialog shows
- [ ] Grant permission
- [ ] Dashboard loads with weather

**Scenario 2: Permission Denied**

- [ ] App starts
- [ ] Shows "Lokasi diperlukan"
- [ ] Deny permission
- [ ] UI remains on permission screen
- [ ] Click "Buka Pengaturan"
- [ ] Settings app opens

**Scenario 3: Permission Forever Denied**

- [ ] Go to Settings
- [ ] Disable location permission
- [ ] App restart
- [ ] Shows "Lokasi diperlukan" + Settings button

### 2. GPS Detection

**Test with Emulator:**

```bash
# Android Emulator
adb emu geo fix -74.0 40.7

# iOS Simulator
# Settings > Location Services > Always
```

**Test with Real Device:**

- [ ] Turn on GPS
- [ ] Verify location captured
- [ ] Check ADM4 mapping correct
- [ ] Weather displays
- [ ] Turn off GPS
- [ ] Shows location disabled message

### 3. API Integration

**Endpoint Testing:**

```bash
# Test API directly
curl "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001"

# Should return JSON with weather data
# Check response has: kotkab, provinsi, timeseries[]
```

**Response Validation:**

- [ ] Status is "success"
- [ ] Data array not empty
- [ ] Contains kotkab & provinsi
- [ ] Timeseries has datetime objects
- [ ] Temperature values are reasonable (15-40°C)
- [ ] Humidity values 0-100%
- [ ] Weather codes are valid (0-10, 45, 60-81)

### 4. Current Weather Card

**Display Elements:**

- [ ] City name displays (e.g., "Jakarta Selatan, DKI Jakarta")
- [ ] Update time shows (e.g., "Update: 14:30")
- [ ] Temperature displays with emoji
- [ ] Weather description shows
- [ ] Humidity percentage visible
- [ ] Wind speed displays
- [ ] Date format correct (Bahasa Indonesia)

**Interaction:**

- [ ] Refresh button works
- [ ] Shows loading on refresh
- [ ] Updates data after refresh
- [ ] Gradient background displays correctly
- [ ] White text readable on gradient

### 5. Hourly Forecast

**Display:**

- [ ] Shows up to 12 hours of forecast
- [ ] Each card shows: hour, emoji, temperature
- [ ] Horizontal scroll works
- [ ] Times are future times from now
- [ ] Emoji matches weather code

**Responsiveness:**

- [ ] Works on phone (small screen)
- [ ] Works on tablet (large screen)
- [ ] Scroll smooth
- [ ] Cards properly spaced

### 6. Daily Forecast

**Display:**

- [ ] Shows 7 days of forecast
- [ ] Each row shows: date, emoji, condition, rain%, min/max temp
- [ ] Dates in correct format (e.g., "Rab, 01 Feb")
- [ ] Temperature colors: red for max, blue for min
- [ ] Rain chance shows percentage
- [ ] Vertical scroll works

**Data Accuracy:**

- [ ] Min temp < max temp
- [ ] Dates are sequential
- [ ] No duplicate dates
- [ ] Emoji changes based on condition

### 7. Auto Refresh

**Test:**

- [ ] App has been open > 20 minutes
- [ ] Data automatically refreshes
- [ ] Loading indicator briefly shows
- [ ] New data displays
- [ ] Timestamp updates

**Verify:**

```dart
// Check timer in debug mode
// Set interval to 1 minute for testing
const Duration(minutes: 1)
```

### 8. Pull-to-Refresh

**Test:**

- [ ] Swipe down on dashboard
- [ ] Refresh indicator shows
- [ ] Data reloads
- [ ] Indicator disappears
- [ ] New timestamp reflects

### 9. Dark Mode

**Toggle:**

- [ ] Click moon icon in AppBar
- [ ] Theme switches to dark
- [ ] All elements visible in dark
- [ ] Text contrast good
- [ ] Cards have dark background
- [ ] Click again to switch to light
- [ ] Toggle moon to sun icon

**Verify Dark Mode:**

- [ ] Background is dark grey/black
- [ ] Text is white/light grey
- [ ] Cards have dark grey background
- [ ] Buttons visible
- [ ] Icons visible

### 10. Error States

**API Timeout:**

- [ ] Disconnect internet
- [ ] Click refresh
- [ ] Shows error message
- [ ] "Coba Lagi" button works
- [ ] Reconnect internet
- [ ] Refresh success

**Invalid Location:**

- [ ] Force ADM4 to invalid code
- [ ] Shows error
- [ ] Retry button works
- [ ] Fallback to default location

**Network Error:**

- [ ] Airplane mode on
- [ ] Try to refresh
- [ ] Error displayed
- [ ] Airplane mode off
- [ ] Retry works

### 11. Responsive Design

**Phone Portrait (360x800):**

- [ ] All content visible
- [ ] No horizontal scroll
- [ ] Text readable
- [ ] Buttons clickable

**Tablet Landscape (1200x800):**

- [ ] Content uses full width
- [ ] Proper spacing
- [ ] Cards well proportioned
- [ ] Lists readable

**Desktop (1920x1080):**

- [ ] Proper scaling
- [ ] Max-width constraints (optional)
- [ ] Touch targets still usable

### 12. Weather Code Mapping

**Test Each Code:**

```
0   ☀️  Cerah
1   🌤️  Cerah Berawan
2   ⛅  Berawan
3   ☁️  Berawan Tebal
4   🌧️  Hujan Ringan
5   🌦️  Hujan Sedang
10  ⛈️  Hujan Lebat
```

- [ ] Check API returns each code
- [ ] Emoji displays correctly
- [ ] Description accurate
- [ ] Color scheme appropriate

---

## 🔍 Verification Checklist

### Code Quality

- [ ] No compilation errors
- [ ] No warnings
- [ ] Proper error handling
- [ ] Null safety checks
- [ ] No hardcoded values (except defaults)
- [ ] Comments on complex logic
- [ ] Consistent naming conventions

### Architecture

- [ ] Models properly defined
- [ ] Services separate from UI
- [ ] Provider pattern implemented
- [ ] State management clean
- [ ] No direct API calls in UI
- [ ] Proper dependency injection

### UI/UX

- [ ] UI matches design
- [ ] Proper spacing & alignment
- [ ] Readable fonts
- [ ] Proper colors
- [ ] Smooth animations
- [ ] No UI glitches
- [ ] Touch targets >= 48x48 dp

### Performance

- [ ] App loads < 3 seconds
- [ ] No jank on scroll
- [ ] API response < 2 seconds
- [ ] No memory leaks
- [ ] Efficient rebuilds
- [ ] Proper image sizing

### Accessibility

- [ ] Touch targets large enough
- [ ] Text contrast sufficient
- [ ] No reliance on color alone
- [ ] Proper button labels
- [ ] Error messages clear
- [ ] Dark mode tested

### Permissions

- [ ] Location request shown
- [ ] Permission denial handled
- [ ] Settings open correctly
- [ ] Works with permission denied
- [ ] Works with GPS disabled

### Localization

- [ ] Dates in Indonesian format
- [ ] Month names Indonesian
- [ ] Day names Indonesian
- [ ] Numbers formatted correctly
- [ ] All text strings localized

### Security

- [ ] No sensitive data hardcoded
- [ ] API calls over HTTPS
- [ ] No debug logs in release
- [ ] No credentials in code
- [ ] Proper error messages (no stack traces to user)

---

## 📊 Performance Benchmarks

### Target Metrics

| Metric         | Target    | Status  |
| -------------- | --------- | ------- |
| App startup    | < 3s      | ⏳ Test |
| Dashboard load | < 1s      | ⏳ Test |
| API response   | < 2s      | ⏳ Test |
| Scroll FPS     | >= 60     | ⏳ Test |
| Memory usage   | < 100MB   | ⏳ Test |
| Battery drain  | < 2%/hour | ⏳ Test |

### Debug Commands

```bash
# Profile app
flutter run --profile

# Capture timeline
flutter run --verbose > timeline.log

# Check memory
flutter run --debug --trace-startup
```

---

## 🐛 Known Issues & Workarounds

### Issue 1: Location always returns Jakarta

**Cause:** ADM4 mapping incomplete
**Workaround:** Add more location mappings in `mapLocationToAdm4()`

### Issue 2: Dark mode resets on restart

**Cause:** Not persisted
**Workaround:** Add SharedPreferences to save preference

### Issue 3: API slow on first load

**Cause:** Cold start + network latency
**Workaround:** Show loading skeleton

---

## ✨ Pre-Release Checklist

Before release to Play Store / App Store:

### Functionality

- [ ] All features working
- [ ] All UI screens display
- [ ] All buttons functional
- [ ] No crashes
- [ ] Proper error handling

### Testing

- [ ] Unit tests passing
- [ ] Manual testing complete
- [ ] Edge cases handled
- [ ] Offline mode tested
- [ ] Slow network tested

### Content

- [ ] App icon present
- [ ] Splash screen displays
- [ ] All text localized
- [ ] Privacy policy ready
- [ ] Terms ready

### Configuration

- [ ] Android manifest correct
- [ ] iOS Info.plist correct
- [ ] Version number correct
- [ ] Build number incremented
- [ ] Signing certificates valid

### Performance

- [ ] App size reasonable
- [ ] Memory usage acceptable
- [ ] Battery usage acceptable
- [ ] No ANRs (Android)
- [ ] No crashes on startup

### Security

- [ ] No hardcoded secrets
- [ ] HTTPS only
- [ ] Permissions justified
- [ ] Data privacy compliant
- [ ] No sensitive logging

---

## 📝 Test Report Template

```
=== TEST REPORT ===
Date: [DATE]
Tester: [NAME]
Device: [DEVICE_MODEL] [OS_VERSION]
Build: [VERSION] [BUILD_NUMBER]

FEATURES TESTED:
- [ ] Location detection
- [ ] API integration
- [ ] Current weather
- [ ] Hourly forecast
- [ ] Daily forecast
- [ ] Auto refresh
- [ ] Pull-to-refresh
- [ ] Dark mode

ISSUES FOUND:
1. [ISSUE TITLE]
   - Steps to reproduce
   - Expected result
   - Actual result
   - Severity: (Critical/High/Medium/Low)

2. [ANOTHER ISSUE]
   ...

OVERALL STATUS: PASS/FAIL

Notes:
[Additional notes]
```

---

**Testing Version:** 1.0  
**Last Updated:** February 1, 2026
