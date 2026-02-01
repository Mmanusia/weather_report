// File: API_EXAMPLES.md

# BMKG API - Contoh Request & Response

## 1. API Endpoint

### Base URL

```
https://api.bmkg.go.id/publik/prakiraan-cuaca
```

### Request Example

```
GET https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001
```

---

## 2. ADM4 Codes - Mapping Lokasi

### Format: Provinsi.Kabupaten.Kecamatan.Desa

```
31.71.03.1001 → Jakarta Selatan, DKI Jakarta
32.73.01.1001 → Bandung, Jawa Barat
35.78.05.1001 → Surabaya, Jawa Timur
12.71.03.1001 → Medan, Sumatera Utara
34.55.02.1001 → Yogyakarta, DIY Yogyakarta
```

### Mapping GPS ke ADM4

```
Latitude        Longitude       ADM4 Code       Lokasi
-6.2            106.8           31.71.03.1001   Jakarta Selatan
-6.9            107.6           32.73.01.1001   Bandung
-7.2            112.7           35.78.05.1001   Surabaya
3.6             98.7            12.71.03.1001   Medan
-7.8            110.4           34.55.02.1001   Yogyakarta
```

---

## 3. Full Response Example

### Request

```bash
curl "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001"
```

### Response (Success 200)

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
        },
        {
          "datetime": "2024-02-01T02:00:00+00:00",
          "t": 25,
          "tmax": 27,
          "tmin": 23,
          "hu": 85,
          "wsws": "2.5",
          "wd": "210",
          "weather": "4",
          "weather_desc": "Hujan Ringan",
          "image": "image04s.jpg",
          "pp": 30
        },
        {
          "datetime": "2024-02-01T03:00:00+00:00",
          "t": 24,
          "tmax": 26,
          "tmin": 22,
          "hu": 88,
          "wsws": "2.2",
          "wd": "220",
          "weather": "5",
          "weather_desc": "Hujan Sedang",
          "image": "image05s.jpg",
          "pp": 60
        },
        {
          "datetime": "2024-02-01T04:00:00+00:00",
          "t": 23,
          "tmax": 25,
          "tmin": 21,
          "hu": 90,
          "wsws": "2.0",
          "wd": "230",
          "weather": "10",
          "weather_desc": "Hujan Lebat",
          "image": "image10s.jpg",
          "pp": 90
        }
      ]
    }
  ]
}
```

---

## 4. Field Documentation

### Top Level

| Field  | Type   | Deskripsi                        |
| ------ | ------ | -------------------------------- |
| status | string | Status response (success/failed) |
| data   | array  | Array of location forecast data  |

### Data Object

| Field      | Type   | Deskripsi                   |
| ---------- | ------ | --------------------------- |
| kotkab     | string | Nama kota/kabupaten         |
| provinsi   | string | Nama provinsi               |
| adm4       | string | Kode administrative level 4 |
| timeseries | array  | Array prakiraan per jam     |

### Timeseries Object

| Field        | Type    | Deskripsi                  | Contoh                      |
| ------------ | ------- | -------------------------- | --------------------------- |
| datetime     | string  | Waktu dalam ISO 8601       | "2024-02-01T00:00:00+00:00" |
| t            | integer | Suhu saat ini (°C)         | 28                          |
| tmax         | integer | Suhu maksimal (°C)         | 29                          |
| tmin         | integer | Suhu minimal (°C)          | 26                          |
| hu           | integer | Kelembapan relatif (%)     | 75                          |
| wsws         | string  | Kecepatan angin (m/s)      | "3.5"                       |
| wd           | string  | Arah angin (derajat 0-360) | "180"                       |
| weather      | string  | Kode cuaca                 | "1"                         |
| weather_desc | string  | Deskripsi cuaca            | "Cerah Berawan"             |
| image        | string  | URL gambar/icon            | "image01s.jpg"              |
| pp           | integer | Peluang curah hujan (%)    | 0-100                       |

---

## 5. Weather Codes Reference

### Kode Cuaca BMKG

```
0   → Cerah (Sunny)
1   → Cerah Berawan (Partly Cloudy)
2   → Berawan (Cloudy)
3   → Berawan Tebal (Overcast)
4   → Hujan Ringan (Light Rain)
5   → Hujan Sedang (Moderate Rain)
10  → Hujan Lebat (Heavy Rain)
45  → Hujan Lokal (Local Rain)
60  → Hujan es (Rain Snow)
61  → Hujan Es Ringan (Light Rain Snow)
63  → Hujan Es Sedang (Moderate Rain Snow)
80  → Hujan Ringan dan Hujan Es (Light Rain and Snow)
81  → Hujan Sedang dan Hujan Es (Moderate Rain and Snow)
```

### Emoji Mapping

```
0   → ☀️  Cerah
1   → 🌤️  Cerah Berawan
2   → ⛅  Berawan
3   → ☁️  Berawan Tebal
4   → 🌧️  Hujan Ringan
5   → 🌦️  Hujan Sedang
10  → ⛈️  Hujan Lebat
45  → 🌧️  Hujan Lokal
60  → 🧊  Hujan es
80  → 🌧️  Hujan + Es
```

---

## 6. Data Parsing Examples

### Extract Current Weather

```dart
// Ambil data terdekat dengan waktu sekarang
WeatherTimeseries closest = timeseries
  .reduce((a, b) {
    final diffA = a.datetime.difference(DateTime.now()).abs();
    final diffB = b.datetime.difference(DateTime.now()).abs();
    return diffA < diffB ? a : b;
  });

CurrentWeather current = CurrentWeather(
  temperature: closest.t?.toDouble() ?? 0.0,
  description: closest.weather_desc,
  humidity: closest.hu ?? 0,
  windSpeed: double.parse(closest.wsws ?? '0'),
  emoji: weatherEmoji[closest.weather] ?? '🌫️',
  lastUpdate: closest.datetime,
);
```

### Extract Hourly Forecasts (Next 12 Hours)

```dart
final now = DateTime.now();
final future12h = now.add(Duration(hours: 12));

List<WeatherTimeseries> hourlyForecasts = timeseries
  .where((ts) => ts.datetime.isAfter(now) && ts.datetime.isBefore(future12h))
  .toList();
```

### Extract Daily Forecasts

```dart
Map<String, DailyForecast> dailyMap = {};

for (final ts in timeseries) {
  final dateKey = '${ts.datetime.year}-${ts.datetime.month}-${ts.datetime.day}';

  if (!dailyMap.containsKey(dateKey)) {
    dailyMap[dateKey] = DailyForecast(
      date: DateTime(ts.datetime.year, ts.datetime.month, ts.datetime.day),
      tmax: ts.tmax,
      tmin: ts.tmin,
      condition: ts.weather_desc,
      rainChance: ts.pp,
      emoji: weatherEmoji[ts.weather] ?? '🌫️',
    );
  } else {
    // Update min/max
    var existing = dailyMap[dateKey]!;
    if (ts.tmax != null && ts.tmax! > (existing.tmax ?? 0)) {
      existing.tmax = ts.tmax;
    }
    if (ts.tmin != null && ts.tmin! < (existing.tmin ?? 999)) {
      existing.tmin = ts.tmin;
    }
  }
}

List<DailyForecast> forecasts = dailyMap.values.toList()..sort((a,b) => a.date.compareTo(b.date));
```

---

## 7. Error Handling

### Error Response (400)

```json
{
  "status": "error",
  "code": 400,
  "message": "Invalid parameter"
}
```

### Error Response (404)

```json
{
  "status": "error",
  "code": 404,
  "message": "Location not found"
}
```

### Network Timeout

```
Timeout: Connection timed out after 10 seconds
```

### Empty Data

```json
{
  "status": "success",
  "data": []
}
```

---

## 8. Wind Direction Reference

```
Derajat   Arah
0/360     Utara (N)
45        Timur Laut (NE)
90        Timur (E)
135       Tenggara (SE)
180       Selatan (S)
225       Barat Daya (SW)
270       Barat (W)
315       Barat Laut (NW)
```

---

## 9. Curl Examples for Testing

### Test API (Jakarta)

```bash
curl -X GET "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001"
```

### Test API (Bandung)

```bash
curl -X GET "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=32.73.01.1001"
```

### Pretty Print Response

```bash
curl -s "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001" | jq '.'
```

### Save Response to File

```bash
curl -s "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.71.03.1001" > weather_response.json
```

---

## 10. Response Headers

```
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 5832
Date: Wed, 01 Feb 2024 00:00:00 GMT
Server: Apache
Cache-Control: max-age=300
ETag: "abc123def456"
```

---

## Notes

- API Response cache validity: ~5 menit (300 detik)
- Timeseries typically updated setiap jam
- Prakiraan tersedia untuk ~10 hari ke depan
- Format datetime: ISO 8601 dengan timezone UTC (+00:00)
- Fields bisa null/kosong, selalu check before access

---

**Last Updated:** February 1, 2026
