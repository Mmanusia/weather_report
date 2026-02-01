# 🏗️ Arsitektur & Design Patterns

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    FLUTTER APP LAYER                     │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────────────────────────────────────────┐    │
│  │         UI LAYER (Presentation)                 │    │
│  ├─────────────────────────────────────────────────┤    │
│  │ • DashboardPage (Main UI)                       │    │
│  │ • SplashScreenPage (Initialization)             │    │
│  │ • Widgets:                                      │    │
│  │   - CurrentWeatherCard                          │    │
│  │   - HourlyForecastCard                          │    │
│  │   - DailyForecastCard                           │    │
│  │   - ErrorStates (LocationDenied, etc)           │    │
│  │   - LoadingSkeleton (Shimmer)                   │    │
│  └─────────────────────────────────────────────────┘    │
│                       ↓ (Consume)                        │
│  ┌─────────────────────────────────────────────────┐    │
│  │   STATE MANAGEMENT LAYER (Provider Pattern)     │    │
│  ├─────────────────────────────────────────────────┤    │
│  │ WeatherProvider (ChangeNotifier)                │    │
│  │ • State: WeatherState enum                      │    │
│  │ • Data: weatherData, currentWeather, etc        │    │
│  │ • Methods: initialize(), refresh(), toggle()    │    │
│  │ • Notifies listeners on state change            │    │
│  └─────────────────────────────────────────────────┘    │
│                       ↓ (Use)                            │
│  ┌─────────────────────────────────────────────────┐    │
│  │     SERVICE LAYER (Business Logic)              │    │
│  ├──────────────────────┬──────────────────────────┤    │
│  │ WeatherService       │   LocationService        │    │
│  ├──────────────────────┼──────────────────────────┤    │
│  │ • API calls          │ • GPS location           │    │
│  │ • Data parsing       │ • Permission handling    │    │
│  │ • Error handling     │ • Location settings      │    │
│  │ • Location mapping   │                          │    │
│  └──────────────────────┴──────────────────────────┘    │
│                       ↓ (Call)                           │
│  ┌─────────────────────────────────────────────────┐    │
│  │      DATA MODEL LAYER                            │    │
│  ├─────────────────────────────────────────────────┤    │
│  │ • BmkgWeatherResponse                           │    │
│  │ • BmkgLocation                                  │    │
│  │ • WeatherTimeseries                             │    │
│  │ • CurrentWeather                                │    │
│  │ • DailyForecast                                 │    │
│  └─────────────────────────────────────────────────┘    │
│                                                           │
└─────────────────────────────────────────────────────────┘
         ↓ (External)            ↓ (External)
  ┌──────────────────┐     ┌──────────────────┐
  │  BMKG API Server │     │  Device GPS/Loc  │
  └──────────────────┘     └──────────────────┘
```

---

## 2. Data Flow Diagram

```
┌─────────────┐
│ App Start   │
└──────┬──────┘
       │
       ▼
┌──────────────────────┐
│  SplashScreenPage    │
│  - Initialize App    │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ WeatherProvider.initialize()     │
└──────┬───────────────────────────┘
       │
       ├─────────────────────────────────────────┐
       │                                         │
       ▼                                         ▼
┌──────────────────────┐          ┌──────────────────────┐
│ LocationService      │          │ Check Permission     │
│ • Get GPS            │          │ • Check Service      │
│ • Get Permission     │          │ • Request if needed  │
└──────┬───────────────┘          └──────┬───────────────┘
       │                                  │
       │  Denied? ──────────────────────────┐
       │                                    │
       │  Got Location? ─────┐             ├──► LocationDeniedWidget
       │                     │             │
       │                     ▼             │
       │            ┌──────────────────┐   │
       │            │ Map to ADM4 Code │   │
       │            │ (GPS → BMKG)     │   │
       │            └──────┬───────────┘   │
       │                   │               │
       │                   ▼               │
       │            ┌────────────────────────────┐
       │            │ WeatherService             │
       │            │ getWeatherForecast(adm4)   │
       │            │ API Call ─────────────────┐│
       │            └────────┬───────────────────┘│
       │                     │                    │
       │                     ├─ API: BMKG ────────┤
       │                     │  https://api...    │
       │                     │                    │
       │                     ▼                    │
       │            ┌──────────────────────────┐ │
       │            │ Parse Response:          │ │
       │            │ • BmkgWeatherResponse    │ │
       │            │ • Extract timeseries     │ │
       │            │ • Handle null fields     │ │
       │            └──────┬───────────────────┘ │
       │                   │                    ▼
       │                   │           ┌──────────────┐
       │                   │           │ Error? ──────► ErrorWidget
       │                   │           └──────────────┘
       │                   │
       │                   ▼
       │        ┌──────────────────────────────┐
       │        │ WeatherParser (Extract data) │
       │        ├──────────────────────────────┤
       │        │ • Current weather            │
       │        │ • Hourly forecasts (12h)     │
       │        │ • Daily forecasts (7d)       │
       │        └──────┬───────────────────────┘
       │              │
       ▼              ▼
    ┌──────────────────────────────────────┐
    │ WeatherProvider (Update State)        │
    │ • state = WeatherState.loaded         │
    │ • currentWeather = ...                │
    │ • hourlyForecasts = [...]             │
    │ • dailyForecasts = [...]              │
    │ • notifyListeners()                   │
    └──────┬───────────────────────────────┘
           │
           ▼
    ┌──────────────────────────────────────┐
    │ DashboardPage (Rebuild UI)           │
    │ • CurrentWeatherCard                 │
    │ • HourlyForecastCard                 │
    │ • DailyForecastCard                  │
    │ • RefreshIndicator (Pull-to-refresh) │
    │ • Auto refresh Timer (20 min)        │
    └──────────────────────────────────────┘
```

---

## 3. State Management Flow

```
┌─────────────────────────────────────────────┐
│  WeatherProvider (extends ChangeNotifier)   │
├─────────────────────────────────────────────┤
│                                              │
│  Enum: WeatherState                         │
│  ├─ initial                                 │
│  ├─ loading                                 │
│  ├─ loaded ✓                                │
│  ├─ error ✗                                 │
│  ├─ locationDenied ✗                        │
│  └─ locationDisabled ✗                      │
│                                              │
│  Private Variables:                         │
│  ├─ _state: WeatherState                    │
│  ├─ _weatherData: BmkgLocation?             │
│  ├─ _currentWeather: CurrentWeather?        │
│  ├─ _hourlyForecasts: List<>                │
│  ├─ _dailyForecasts: List<>                 │
│  ├─ _isDarkMode: bool                       │
│  ├─ _lastUpdate: DateTime?                  │
│  └─ _currentPosition: Position?             │
│                                              │
│  Public Methods:                            │
│  ├─ initialize() ───► Load initial data     │
│  ├─ fetchWeather() ──► Call API             │
│  ├─ refreshWeather() ► Manual refresh       │
│  ├─ toggleDarkMode() ► Switch theme         │
│  ├─ requestLocationPermission()             │
│  ├─ openLocationSettings()                  │
│  └─ openAppSettings()                       │
│                                              │
│  State Change:                              │
│  ├─ _state = WeatherState.xxx               │
│  ├─ Update private variables                │
│  └─ notifyListeners() ◄─── Trigger rebuild │
│                                              │
└─────────────────────────────────────────────┘
         ▲                             │
         │                             ▼
      Listen         ┌───────────────────────────────┐
         │           │ Consumer<WeatherProvider>     │
         └─────────┤ • Rebuild on state change      │
                   │ • Access provider data         │
                   │ • Call provider methods        │
                   └───────────────────────────────┘
```

---

## 4. Component Hierarchy

```
MyApp (MultiProvider)
│
├─ ChangeNotifierProvider(WeatherProvider)
│
└─ MaterialApp
   │
   └─ SplashScreenPage
      │
      ├─ ─[Timer]──► DashboardPage
      │   │
      │   └─ Scaffold
      │      │
      │      ├─ AppBar
      │      │  ├─ Title
      │      │  └─ Dark Mode Toggle
      │      │
      │      └─ SafeArea
      │         │
      │         └─ Consumer<WeatherProvider>
      │            │
      │            ├─ [LOADING STATE]
      │            │  └─ DashboardLoadingSkeleton
      │            │
      │            ├─ [LOADED STATE]
      │            │  └─ RefreshIndicator
      │            │     └─ ListView
      │            │        ├─ CurrentWeatherCard
      │            │        │  ├─ Header (Location, Time)
      │            │        │  ├─ Temperature + Emoji
      │            │        │  ├─ Description
      │            │        │  ├─ Details (Humidity, Wind)
      │            │        │  └─ Refresh Button
      │            │        │
      │            │        ├─ Hourly Forecasts
      │            │        │  └─ ListView (horizontal)
      │            │        │     └─ HourlyForecastCard
      │            │        │        ├─ Hour
      │            │        │        ├─ Emoji
      │            │        │        └─ Temp
      │            │        │
      │            │        └─ Daily Forecasts
      │            │           └─ ListView (vertical)
      │            │              └─ DailyForecastCard
      │            │                 ├─ Date
      │            │                 ├─ Emoji
      │            │                 ├─ Condition
      │            │                 ├─ Rain Chance
      │            │                 └─ Min/Max Temp
      │            │
      │            ├─ [LOCATION_DENIED STATE]
      │            │  └─ LocationDeniedWidget
      │            │     ├─ Icon
      │            │     ├─ Title
      │            │     ├─ Description
      │            │     └─ Buttons
      │            │
      │            ├─ [LOCATION_DISABLED STATE]
      │            │  └─ LocationDisabledWidget
      │            │     ├─ Icon
      │            │     ├─ Title
      │            │     ├─ Description
      │            │     └─ Button
      │            │
      │            └─ [ERROR STATE]
      │               └─ ErrorWidget
      │                  ├─ Icon
      │                  ├─ Title
      │                  ├─ Error Message
      │                  └─ Retry Button
      │
      └─ [Periodic Timer: 20 min]
         └─ refreshWeather()
```

---

## 5. Service Layer Design

### WeatherService
```dart
class WeatherService
├─ _dio: Dio (HTTP client)
├─ baseUrl: String (BMKG API)
│
└─ Methods:
   ├─ getWeatherForecast(adm4) → BmkgWeatherResponse?
   │  ├─ Check adm4 validity
   │  ├─ Make HTTP GET request
   │  ├─ Parse response to model
   │  ├─ Handle DioException
   │  └─ Handle ParseException
   │
   ├─ mapLocationToAdm4(lat, lon) → String
   │  ├─ Check latitude/longitude ranges
   │  ├─ Return matching adm4 code
   │  └─ Fallback to Jakarta (default)
   │
   └─ [Static Helpers]
      ├─ WeatherParser.extractDailyForecasts()
      ├─ WeatherParser.extractHourlyForecasts()
      └─ WeatherParser.getCurrentWeather()
```

### LocationService
```dart
class LocationService
├─ Static Methods:
│  ├─ isLocationServiceEnabled() → bool
│  ├─ checkLocationPermission() → LocationPermission
│  ├─ requestLocationPermission() → LocationPermission
│  ├─ getCurrentPosition() → Position?
│  ├─ openLocationSettings() → void
│  └─ openAppSettings() → void
│
└─ Flow:
   1. Check service enabled
   2. Check permission (Granted/Denied/DeniedForever)
   3. Request if needed
   4. Get current position
   5. Return Position(lat, lon, accuracy)
```

---

## 6. Error Handling Strategy

```
Try Block
│
├─ Location Error
│  └─ Show LocationDeniedWidget
│     └─ onRequestPermission() → Request Again
│
├─ API Error (DioException)
│  ├─ Timeout
│  │  └─ Show "Connection Timeout"
│  │
│  ├─ Connection Error
│  │  └─ Show "Network Error"
│  │
│  ├─ Server Error (5xx)
│  │  └─ Show "Server Error"
│  │
│  └─ Invalid Response
│     └─ Show "Invalid Data"
│
├─ Parsing Error (Null fields)
│  └─ Use defaults/fallbacks
│  │  ├─ weather_desc ← weather code
│  │  ├─ temperature ← 0
│  │  └─ humidity ← 0
│
└─ State: ERROR
   └─ Show ErrorWidget
      └─ onRetry() → initialize() again
```

---

## 7. Async Flow

```
Timeline:

T0: initState()
    └─ WeatherProvider.initialize()

T0+: Check Permission
     │
     ├─ Denied? → Show dialog
     │
     ├─ DeniedForever? → Show settings prompt
     │
     └─ Granted → Continue

T0++: Get GPS Location
      └─ Geolocator.getCurrentPosition()
         └─ Wait 10 seconds (timeout)

T0+++: Map to ADM4
       └─ mapLocationToAdm4(lat, lon)
          └─ Instant (local logic)

T0++++: Fetch from API
        └─ HTTP GET request
           └─ Wait ~1-5 seconds

T0+++++: Parse Response
         └─ Convert JSON to models
            └─ ~100ms

T0++++++: Update UI
          └─ notifyListeners()
             └─ Rebuild widgets

T0+++++++: Show Dashboard
           └─ DashboardPage displays data
              └─ auto refresh timer: 20 min
```

---

## 8. Data Transformation Pipeline

```
Raw JSON (BMKG API)
        │
        ▼
BmkgWeatherResponse.fromJson()
        │
        ├─► BmkgLocation
        │   └─► List<WeatherTimeseries>
        │       └─► WeatherTimeseries[0]
        │           ├─ datetime
        │           ├─ t (temp)
        │           ├─ weather (code)
        │           └─ pp (rain %)
        │
        ├─► WeatherParser.getCurrentWeather()
        │   └─► CurrentWeather
        │       ├─ temperature
        │       ├─ description
        │       ├─ humidity
        │       ├─ windSpeed
        │       ├─ emoji
        │       └─ lastUpdate
        │
        ├─► WeatherParser.extractHourlyForecasts()
        │   └─► List<WeatherTimeseries>
        │       └─ Filter: now < datetime < now+12h
        │
        └─► WeatherParser.extractDailyForecasts()
            └─► List<DailyForecast>
                ├─ date
                ├─ tmax
                ├─ tmin
                ├─ condition
                ├─ rainChance
                └─ emoji

        ↓
    Provider State
        ├─ _currentWeather
        ├─ _hourlyForecasts[]
        ├─ _dailyForecasts[]
        └─ notifyListeners()

        ↓
    UI Widgets
        ├─ CurrentWeatherCard
        ├─ HourlyForecastCard[]
        └─ DailyForecastCard[]
```

---

## 9. Performance Optimization

```
┌─ Lazy Loading
│  └─ Load data hanya saat needed
│
├─ Cache Response
│  └─ SharedPreferences untuk offline
│
├─ Efficient Rebuilds
│  └─ Consumer hanya rebuild affected widgets
│
├─ Memory Management
│  └─ Dispose timer dalam dispose()
│
├─ API Call Optimization
│  └─ 20 min interval (tidak terlalu sering)
│
└─ UI Optimization
   ├─ Shimmer loading (better UX)
   ├─ Lazy list (ListViewBuilder)
   └─ Image caching
```

---

## 10. Lifecycle Events

```
APP LIFECYCLE:

1. main() runs
   └─ runApp(MyApp())

2. MyApp builds
   └─ MultiProvider setup

3. SplashScreenPage shows
   └─ initState()
      ├─ WeatherProvider.initialize()
      └─ Timer(2 seconds) → Navigate

4. DashboardPage builds
   └─ Consumer<WeatherProvider>
      ├─ buildWhen: state changed
      └─ Rebuild child widgets

5. Auto refresh timer starts
   └─ Every 20 minutes
      └─ WeatherProvider.refreshWeather()
         └─ API call + notifyListeners()

6. User interactions
   ├─ Pull-to-refresh
   ├─ Toggle dark mode
   ├─ Click refresh button
   └─ Permission request

7. App paused/resumed
   └─ Timer continues in background

8. App destroyed
   └─ dispose()
      └─ _autoRefreshTimer.cancel()
```

---

**Architecture Version:** 1.0  
**Last Updated:** February 1, 2026  
**Status:** Production Ready
