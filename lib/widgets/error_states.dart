import 'package:flutter/material.dart';

/// Widget untuk menampilkan state ketika lokasi ditolak
class LocationDeniedWidget extends StatelessWidget {
  final VoidCallback onRequestPermission;
  final VoidCallback? onOpenSettings;
  final bool isDarkMode;

  const LocationDeniedWidget({
    Key? key,
    required this.onRequestPermission,
    this.onOpenSettings,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon besar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.red[900] : Colors.red[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  Icons.location_off,
                  size: 50,
                  color: isDarkMode ? Colors.red[300] : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Judul
            Text(
              'Lokasi Diperlukan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Deskripsi
            Text(
              'Aplikasi cuaca membutuhkan akses ke lokasi Anda untuk menampilkan prakiraan cuaca yang akurat berdasarkan posisi GPS Anda.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Tombol aktifkan lokasi
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onRequestPermission,
                icon: const Icon(Icons.location_on),
                label: const Text('Aktifkan Lokasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol buka pengaturan (optional)
            if (onOpenSettings != null)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('Buka Pengaturan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDarkMode ? Colors.blue[300] : Colors.blue,
                    side: BorderSide(
                      color: isDarkMode ? Colors.blue[300]! : Colors.blue,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk state lokasi disabled
class LocationDisabledWidget extends StatelessWidget {
  final VoidCallback onEnableLocation;
  final bool isDarkMode;

  const LocationDisabledWidget({
    Key? key,
    required this.onEnableLocation,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon besar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.orange[900] : Colors.orange[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  Icons.gps_off,
                  size: 50,
                  color: isDarkMode ? Colors.orange[300] : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Judul
            Text(
              'Aktifkan GPS',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Deskripsi
            Text(
              'Layanan lokasi (GPS) di perangkat Anda tidak aktif. Silakan aktifkan di pengaturan untuk melanjutkan.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Tombol buka pengaturan
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onEnableLocation,
                icon: const Icon(Icons.settings_location),
                label: const Text('Buka Pengaturan Lokasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.orange[700] : Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk state error
class ErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final bool isDarkMode;

  const ErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon error
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.red[900] : Colors.red[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  size: 50,
                  color: isDarkMode ? Colors.red[300] : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Judul
            Text(
              'Terjadi Kesalahan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDarkMode ? Colors.red[900]! : Colors.red[200]!,
                ),
              ),
              child: Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Tombol retry
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
